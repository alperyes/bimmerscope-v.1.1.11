//! Process-wide ownership for vehicle I/O. This gate does not validate ECU
//! support. Programming must fail busy until all diagnostic workers exit.
use std::sync::{Arc, Mutex, OnceLock};

#[derive(Default)]
struct State {
    diagnostics: usize,
    programming: bool,
}

#[derive(Clone, Default)]
pub(crate) struct VehicleAccess(Arc<Mutex<State>>);

pub(crate) struct Lease {
    access: VehicleAccess,
    exclusive: bool,
}

impl VehicleAccess {
    pub(crate) fn diagnostic(&self) -> Result<Lease, String> {
        let mut state = self.0.lock().map_err(|_| "Vehicle access lock poisoned")?;
        if state.programming {
            return Err("Vehicle is reserved for programming".into());
        }
        state.diagnostics += 1;
        Ok(Lease {
            access: self.clone(),
            exclusive: false,
        })
    }

    // Reserved for the future ECU-specific Rust programming owner.
    #[allow(dead_code)]
    pub(crate) fn programming(&self) -> Result<Lease, String> {
        let mut state = self.0.lock().map_err(|_| "Vehicle access lock poisoned")?;
        if state.programming || state.diagnostics != 0 {
            return Err("Vehicle access is busy; wait for existing operations to finish".into());
        }
        state.programming = true;
        Ok(Lease {
            access: self.clone(),
            exclusive: true,
        })
    }
}

impl Drop for Lease {
    fn drop(&mut self) {
        if let Ok(mut state) = self.access.0.lock() {
            if self.exclusive {
                state.programming = false;
            } else {
                state.diagnostics -= 1;
            }
        }
    }
}

pub(crate) fn vehicle_access() -> &'static VehicleAccess {
    static ACCESS: OnceLock<VehicleAccess> = OnceLock::new();
    ACCESS.get_or_init(VehicleAccess::default)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn programming_waits_for_every_diagnostic_lease() {
        let access = VehicleAccess::default();
        let first = access.diagnostic().unwrap();
        let second = access.diagnostic().unwrap();
        assert!(access.programming().is_err());
        drop(first);
        assert!(access.programming().is_err());
        drop(second);
        let programming = access.programming().unwrap();
        assert!(access.diagnostic().is_err());
        assert!(access.programming().is_err());
        drop(programming);
        assert!(access.diagnostic().is_ok());
    }

    #[test]
    fn real_service_entry_points_reject_programming_ownership_before_io() {
        use crate::api::vehicle;
        let _owner = vehicle_access().programming().unwrap();
        let expected = "Vehicle is reserved for programming";
        assert_eq!(vehicle::read_ista_s55_calibration().unwrap_err(), expected);
        assert_eq!(vehicle::scan_engine_diagnostics().unwrap_err(), expected);
        assert_eq!(vehicle::clear_engine_diagnostics().unwrap_err(), expected);
        assert_eq!(
            vehicle::experimental_exhaust_flap_service_test().unwrap_err(),
            expected
        );
        assert_eq!(
            vehicle::experimental_exhaust_flap_set_position("open".into()).unwrap_err(),
            expected
        );
    }

    #[test]
    fn worker_owns_lease_until_it_exits() {
        let access = VehicleAccess::default();
        let lease = access.diagnostic().unwrap();
        let (release, wait) = std::sync::mpsc::channel();
        let worker = std::thread::spawn(move || {
            let _lease = lease;
            wait.recv().unwrap();
        });
        assert!(access.programming().is_err());
        release.send(()).unwrap();
        worker.join().unwrap();
        assert!(access.programming().is_ok());
    }
}

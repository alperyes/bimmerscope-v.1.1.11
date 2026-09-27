//! Process-wide ownership for vehicle I/O. Exactly one live session or
//! standalone diagnostic service may own the transport at a time.
use std::sync::{Arc, Condvar, Mutex, OnceLock};
use std::time::{Duration, Instant};

#[derive(Default)]
struct State {
    diagnostic: bool,
    programming: bool,
}

#[derive(Default)]
struct Inner {
    state: Mutex<State>,
    released: Condvar,
}

#[derive(Clone, Default)]
pub(crate) struct VehicleAccess(Arc<Inner>);

pub(crate) struct Lease {
    access: VehicleAccess,
    programming: bool,
}

impl VehicleAccess {
    pub(crate) fn diagnostic(&self) -> Result<Lease, String> {
        let mut state = self
            .0
            .state
            .lock()
            .map_err(|_| "Vehicle access lock poisoned")?;
        if state.programming {
            return Err("Vehicle is reserved for programming".into());
        }
        if state.diagnostic {
            return Err("Vehicle access is busy; stop the live session or wait for the current diagnostic operation".into());
        }
        state.diagnostic = true;
        Ok(Lease {
            access: self.clone(),
            programming: false,
        })
    }

    pub(crate) fn diagnostic_active(&self) -> bool {
        self.0
            .state
            .lock()
            .map(|state| state.diagnostic)
            .unwrap_or(false)
    }

    pub(crate) fn wait_for_diagnostic_release(&self, timeout: Duration) -> Result<(), String> {
        let deadline = Instant::now() + timeout;
        let mut state = self
            .0
            .state
            .lock()
            .map_err(|_| "Vehicle access lock poisoned")?;
        while state.diagnostic {
            let remaining = deadline.saturating_duration_since(Instant::now());
            if remaining.is_zero() {
                return Err("Timed out waiting for the live vehicle session to stop".into());
            }
            let (next, result) = self
                .0
                .released
                .wait_timeout(state, remaining)
                .map_err(|_| "Vehicle access lock poisoned")?;
            state = next;
            if result.timed_out() && state.diagnostic {
                return Err("Timed out waiting for the live vehicle session to stop".into());
            }
        }
        Ok(())
    }

    // Reserved for the future ECU-specific Rust programming owner.
    #[allow(dead_code)]
    pub(crate) fn programming(&self) -> Result<Lease, String> {
        let mut state = self
            .0
            .state
            .lock()
            .map_err(|_| "Vehicle access lock poisoned")?;
        if state.programming || state.diagnostic {
            return Err("Vehicle access is busy; wait for existing operations to finish".into());
        }
        state.programming = true;
        Ok(Lease {
            access: self.clone(),
            programming: true,
        })
    }
}

impl Drop for Lease {
    fn drop(&mut self) {
        if let Ok(mut state) = self.access.0.state.lock() {
            if self.programming {
                state.programming = false;
            } else {
                state.diagnostic = false;
            }
            self.access.0.released.notify_all();
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
    fn diagnostic_and_programming_owners_are_exclusive() {
        let access = VehicleAccess::default();
        let first = access.diagnostic().unwrap();
        assert!(access.diagnostic().is_err());
        assert!(access.programming().is_err());
        drop(first);
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
    }

    #[test]
    fn wait_observes_worker_releasing_diagnostic_owner() {
        let access = VehicleAccess::default();
        let lease = access.diagnostic().unwrap();
        let worker = std::thread::spawn(move || {
            let _lease = lease;
            std::thread::sleep(Duration::from_millis(20));
        });
        assert!(access
            .wait_for_diagnostic_release(Duration::from_secs(1))
            .is_ok());
        worker.join().unwrap();
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

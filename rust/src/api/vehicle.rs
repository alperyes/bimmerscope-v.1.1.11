use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use if_addrs::{get_if_addrs, IfAddr};
use serde_json::{json, Value};
use std::cell::RefCell;
use std::collections::{BTreeSet, VecDeque};
use std::fs::OpenOptions;
use std::io::{ErrorKind, Read, Write};
use std::net::{IpAddr, Shutdown, TcpStream, ToSocketAddrs, UdpSocket};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{mpsc, Arc, Mutex, OnceLock};
use std::thread;
use std::time::{Duration, Instant, SystemTime, UNIX_EPOCH};

const TESTER: u8 = 0xF4;
// The confirmed F82/S55 engine ECU is addressed at 0x12. Address 0x10 is the
// gateway and must not be used as DME identity evidence.
const ENGINE_ECU_ADDRESS: u8 = 0x12;
const BROADCAST_ECU_ADDRESS: u8 = 0xDF;
const DYNAMIC_DID_HIGH: u8 = 0xF3;
const DYNAMIC_DID_LOW: u8 = 0x00;
const LIVE_POLL_STARTUP_SETTLE: Duration = Duration::from_millis(400);
// Leave a small idle window between dynamic-DID transactions. This avoids
// saturating older ENET gateways while keeping the monitor responsive.
const LIVE_POLL_INTER_TRANSACTION_SETTLE: Duration = Duration::from_millis(20);
const LIVE_POLL_TIMEOUT: Duration = Duration::from_millis(1200);
// A momentary ENET interruption can occur while driving, but a session must
// not keep reporting itself as live indefinitely after the adapter network has
// gone away (for example when the ignition is switched off).
const MAX_SESSION_RECOVERY_ATTEMPTS: u8 = 5;
const MAX_NETWORK_CONFIGURATION_RETRIES: u8 = 8;
const BROADCAST_CLEAR_TIMEOUT: Duration = Duration::from_secs(5);
const BROADCAST_CLEAR_QUIET_WINDOW: Duration = Duration::from_millis(600);
const BROADCAST_RESET_TIMEOUT: Duration = Duration::from_secs(5);
const TRANSPORT_DIAGNOSTICS_MAX_BYTES: u64 = 8 * 1024 * 1024;
// ISTA capture-derived read parameters. These are protocol primitives only;
// a live read still requires a software-specific, validated region plan.
const ISTA_MEMORY_ADDRESS_LENGTH_FORMAT: u8 = 0x24;
const ISTA_MEMORY_READ_CHUNK: u32 = 0x100;
const ISTA_S55_READ_SOFTWARE: &str = "6MC9ED0B";
const ISTA_S55_READ_START: u32 = 0x8018_0000;
const ISTA_S55_READ_LENGTH: u32 = 0x80_000;
// The BM3 capture shows 0x23 reads covering [0x80180000, 0x801FFC00),
// using 0x0FFC-byte blocks (and a 0x0DFC-byte final block).
const BM3_S55_READ_START: u32 = 0x8018_0000;
const BM3_S55_READ_LENGTH: u32 = 0x7_FC00;
const BM3_S55_READ_CHUNK: u32 = 0x0_FFC;
// A 0xFFC-byte response can span several TCP segments. The N20 bench capture
// showed a later segment arriving just after the former three-second deadline.
const BM3_MEMORY_RESPONSE_TIMEOUT: Duration = Duration::from_secs(10);
const BM3_S55_READ_VIN: &str = "WBS3R92010K340307";
const BM3_S55_READ_SOFTWARE: &str = "00001C9F029150001";
const N20_BENCH_VIN: &str = "WBA3A52010F360747";
const N20_BENCH_F101: &str = "010100052302078F04D20100001000000001000019A601130306000019010131020800001C9F1D96010800001CDB1D96030500000B0A007803";
const N20_BENCH_F103: &str = "010100041504018D006E0100000007000001000019A601130306000019010131010800001C9F1D6E020800001CDB1D6E09";
const N20_BENCH_F102: &str = "010100040810138B00080000000000000001000019A601130306000019010131010800001C9F1D6E020800001CA11D6E00";
static ISTA_READ_CANCEL: OnceLock<Arc<AtomicBool>> = OnceLock::new();
static BM3_READ_CANCEL: OnceLock<Arc<AtomicBool>> = OnceLock::new();

#[frb(ignore)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
enum TransportDiagnosticsLevel {
    Normal = 0,
    Detailed = 1,
    Trace = 2,
}

impl TransportDiagnosticsLevel {
    fn parse(value: &str) -> Self {
        match value {
            "trace" => Self::Trace,
            "detailed" => Self::Detailed,
            _ => Self::Normal,
        }
    }
}

#[frb(ignore)]
struct TransportDiagnosticsConfig {
    level: TransportDiagnosticsLevel,
    session_id: String,
    bytes_written: u64,
    truncated: bool,
}

impl Default for TransportDiagnosticsConfig {
    fn default() -> Self {
        Self {
            level: TransportDiagnosticsLevel::Normal,
            session_id: String::new(),
            bytes_written: 0,
            truncated: false,
        }
    }
}

#[frb(ignore)]
#[derive(Clone)]
struct PendingTransportRequest {
    id: u64,
    destination: u8,
    service: u8,
    identifier: Option<u16>,
    started: Instant,
}

#[frb(ignore)]
#[derive(Default)]
struct TransportRequestContext {
    pending: VecDeque<PendingTransportRequest>,
    completed: VecDeque<(u8, Option<u16>)>,
}

static TRANSPORT_DIAGNOSTICS: OnceLock<Mutex<TransportDiagnosticsConfig>> = OnceLock::new();
static NEXT_TRANSPORT_REQUEST_ID: AtomicU64 = AtomicU64::new(1);
static NEXT_LIVE_POLL_ID: AtomicU64 = AtomicU64::new(1);

thread_local! {
    static TRANSPORT_REQUESTS: RefCell<TransportRequestContext> = RefCell::new(TransportRequestContext::default());
}

/// Configure Rust transport capture for the next vehicle session. The app calls
/// this once before opening a session, so a level change never alters a capture
/// already in progress.
#[frb(sync)]
pub fn configure_transport_diagnostics(level: String, session_id: String) {
    let level = TransportDiagnosticsLevel::parse(&level);
    let path = std::env::temp_dir().join("BimmerScope_Raw_HSFZ.log");
    let _ = OpenOptions::new()
        .create(true)
        .write(true)
        .truncate(true)
        .open(path);
    if let Ok(mut config) = TRANSPORT_DIAGNOSTICS
        .get_or_init(|| Mutex::new(TransportDiagnosticsConfig::default()))
        .lock()
    {
        *config = TransportDiagnosticsConfig {
            level,
            session_id,
            bytes_written: 0,
            truncated: false,
        };
    }
    TRANSPORT_REQUESTS.with(|requests| *requests.borrow_mut() = TransportRequestContext::default());
    transport_diagnostic(
        TransportDiagnosticsLevel::Normal,
        json!({"type": "transport_session_start", "captureLevel": format!("{level:?}").to_lowercase()}),
    );
}

#[derive(Clone, Debug, PartialEq)]
pub struct VehicleProfile {
    pub id: String,
    pub make: String,
    pub chassis: String,
    pub engine: String,
    pub gateway_address: String,
    pub diagnostic_port: u16,
    pub engine_ecu: u8,
    pub clear_dtc_ecu: u8,
}

#[derive(Clone, Debug, PartialEq)]
pub struct DecodedHsfzFrame {
    pub message_type: u16,
    pub source: u8,
    pub destination: u8,
    pub uds_hex: String,
    pub application_response: bool,
}

/// Decode a concatenated raw HSFZ capture for offline ISTA/BimmerScope
/// comparison. This intentionally accepts HSFZ payloads, not PCAP files.
#[frb(sync)]
pub fn decode_raw_hsfz_capture(bytes: Vec<u8>) -> Result<Vec<DecodedHsfzFrame>, String> {
    let mut buffer = bytes;
    drain_hsfz(&mut buffer)?
        .into_iter()
        .map(|frame| {
            Ok(DecodedHsfzFrame {
                message_type: frame.message_type,
                source: frame.source,
                destination: frame.destination,
                uds_hex: frame
                    .uds
                    .iter()
                    .map(|byte| format!("{byte:02X}"))
                    .collect::<Vec<_>>()
                    .join(" "),
                application_response: is_application_response(&frame),
            })
        })
        .collect()
}

#[frb(sync)]
pub fn confirmed_vehicle_profiles() -> Vec<VehicleProfile> {
    vec![VehicleProfile {
        id: "bmw_f82_s55".into(),
        make: "BMW".into(),
        chassis: "F82".into(),
        engine: "S55".into(),
        gateway_address: "169.254.12.64".into(),
        diagnostic_port: 6801,
        engine_ecu: 0x12,
        clear_dtc_ecu: BROADCAST_ECU_ADDRESS,
    }]
}

fn confirmed_f82_s55_profile() -> VehicleProfile {
    confirmed_vehicle_profiles()
        .into_iter()
        .next()
        .expect("confirmed vehicle profile is missing")
}

/// A small, Rust-native description of a diagnostic service.  This is the
/// beginning of the ODX-inspired layer: transport code remains responsible
/// for HSFZ/TCP, while service metadata describes the UDS operation.
#[derive(Clone, Debug, PartialEq)]
pub struct DiagnosticServiceDefinition {
    pub id: String,
    pub name: String,
    pub request_sid: u8,
    pub positive_response_sid: u8,
    pub safety: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct DiagnosticDataIdentifierDefinition {
    pub id: String,
    pub name: String,
    pub did: u16,
    pub response_sid: u8,
    pub encoding: String,
    pub exact_length: Option<u8>,
}

#[derive(Clone, Debug, PartialEq)]
pub struct EcuIdentification {
    pub raw_data: Vec<u8>,
    pub display_value: String,
}

/// Identity record used by capability preflight. Optional fields remain empty
/// until the corresponding ECU-specific read is validated on hardware.
#[derive(Clone, Debug, PartialEq)]
pub struct EcuFingerprint {
    pub vin: Option<String>,
    pub hardware_number: Option<String>,
    pub software_number: Option<String>,
    pub bootloader_id: Option<String>,
    pub calibration_id: Option<String>,
    pub verified: bool,
}

#[derive(Clone, Debug, PartialEq)]
pub struct DmeCapabilityPreflight {
    pub status: String,
    pub detail: String,
    pub read_only: bool,
}

/// Comparison with the N20 bench state for which MHD reported no unlock needed.
/// A match is evidence, not a validated general unlock-state classifier.
#[derive(Clone, Debug, PartialEq)]
pub struct N20UnlockReferenceCheck {
    pub status: String,
    pub detail: String,
    pub vin: String,
    pub read_only: bool,
}

pub fn check_n20_bench_unlock_reference(
    expected_vin: String,
) -> Result<N20UnlockReferenceCheck, String> {
    if expected_vin != N20_BENCH_VIN {
        return Err("N20 unlock reference is limited to the documented F30 bench VIN".into());
    }
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let host =
        last_vehicle_host().ok_or_else(|| "No active vehicle endpoint to check".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    send_uds(&mut stream, ENGINE_ECU_ADDRESS, &[0x3E, 0x00])?;
    read_matching_uds_response(
        &mut stream,
        ENGINE_ECU_ADDRESS,
        &[0x7E, 0x00],
        &[0x3E],
        Duration::from_secs(2),
    )?;
    let f150 = read_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "ecu_identification")?;
    let vin = read_ascii_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "vehicle_vin")?;
    if vin != expected_vin {
        return Err("DME VIN changed during unlock reference check".into());
    }
    let f101 = read_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "s55_dme_identity_bundle")?;
    if f150 != [0x0F, 0x18, 0x10] || hex_payload(&f101) != N20_BENCH_F101 {
        return Ok(N20UnlockReferenceCheck {
            status: "unsupported_identity".into(),
            detail: "DME identity differs from the captured MEVD17.2.9 bench software".into(),
            vin,
            read_only: true,
        });
    }
    let short = read_n20_reference_memory(&mut stream, 0x801F_FA40, 16)?;
    let header = read_n20_reference_memory(&mut stream, 0xD000_0000, 64)?;
    let full = read_n20_reference_memory(&mut stream, 0x801F_FA00, 64)?;
    Ok(classify_n20_reference(&vin, &short, &header, &full))
}

fn read_n20_reference_memory(
    stream: &mut TcpStream,
    address: u32,
    length: u16,
) -> Result<Vec<u8>, String> {
    let request = build_ista_memory_read_request(address, length)?;
    send_uds(stream, ENGINE_ECU_ADDRESS, &request)?;
    let response = read_matching_uds_response(
        stream,
        ENGINE_ECU_ADDRESS,
        &[0x63],
        &[0x23],
        Duration::from_secs(2),
    )?;
    Ok(parse_ista_memory_read_response(&response, length as usize)?.to_vec())
}

fn classify_n20_reference(
    vin: &str,
    short: &[u8],
    header: &[u8],
    full: &[u8],
) -> N20UnlockReferenceCheck {
    const HEADER_PREFIX: [u8; 25] = [
        0x41, 0x80, 0x8A, 0x05, 0x16, 0x40, 0xA5, 0x98, 0x74, 0x08, 0x00, 0x10, 0x11, 0x14, 0xFD,
        0x00, 0x5D, 0x55, 0xFD, 0x98, 0xD9, 0x08, 0xF5, 0x05, 0x50,
    ];
    let matched = short == [0xC3; 16]
        && full == [0xC3; 64]
        && header.len() == 64
        && header.starts_with(&HEADER_PREFIX)
        && header[HEADER_PREFIX.len()..].iter().all(|byte| *byte == 0);
    N20UnlockReferenceCheck {
        status: if matched { "reference_match" } else { "unable_to_verify" }.into(),
        detail: if matched {
            "Matches the captured N20 bench state where no unlock was required. This does not establish BimmerScope flash compatibility or general DME unlock state"
        } else {
            "Read-only DME values differ from the captured N20 bench reference"
        }.into(),
        vin: vin.into(),
        read_only: true,
    }
}

/// A capture-derived, read-only memory region. Profiles are intentionally
/// explicit so a new software level cannot inherit another level's range.
#[derive(Clone, Debug, PartialEq)]
pub struct IstaDmeReadProfile {
    pub dme_address: u8,
    pub software_token: String,
    pub start_address: u32,
    pub length: u32,
    pub chunk_size: u16,
    pub response_sid: u8,
}

#[frb(sync)]
pub fn ista_s55_read_profile() -> IstaDmeReadProfile {
    IstaDmeReadProfile {
        dme_address: ENGINE_ECU_ADDRESS,
        software_token: ISTA_S55_READ_SOFTWARE.into(),
        start_address: ISTA_S55_READ_START,
        length: ISTA_S55_READ_LENGTH,
        chunk_size: ISTA_MEMORY_READ_CHUNK as u16,
        response_sid: 0x63,
    }
}

/// Request cancellation of the active read-only ISTA calibration transaction.
#[frb(sync)]
pub fn cancel_ista_s55_calibration() {
    if let Some(flag) = ISTA_READ_CANCEL.get() {
        flag.store(true, Ordering::Relaxed);
    }
}

#[frb(sync)]
pub fn dme_capability_preflight(fingerprint: EcuFingerprint) -> DmeCapabilityPreflight {
    let complete = fingerprint.vin.is_some()
        && fingerprint.hardware_number.is_some()
        && fingerprint.software_number.is_some()
        && fingerprint.bootloader_id.is_some()
        && fingerprint.calibration_id.is_some()
        && fingerprint.verified;
    if !complete {
        return DmeCapabilityPreflight {
            status: "Unable to verify".into(),
            detail: "A validated VIN and complete ECU fingerprint are required".into(),
            read_only: true,
        };
    }
    DmeCapabilityPreflight {
        status: "Unsupported software".into(),
        detail: "Software support has not been validated for this DME profile".into(),
        read_only: true,
    }
}

#[frb(sync)]
pub fn empty_ecu_fingerprint() -> EcuFingerprint {
    EcuFingerprint {
        vin: None,
        hardware_number: None,
        software_number: None,
        bootloader_id: None,
        calibration_id: None,
        verified: false,
    }
}

#[derive(Clone, Debug, PartialEq)]
pub struct DtcResponseDefinition {
    pub id: String,
    pub request_sid: u8,
    pub subfunction: u8,
    pub response_sid: u8,
    pub record_length: u8,
    pub code_length: u8,
    pub status_mask: u8,
}

#[derive(Clone, Debug, PartialEq)]
pub struct DtcStatusDefinition {
    pub mask: u8,
    pub label: String,
}

#[frb(sync)]
pub fn default_dtc_status_definitions() -> Vec<DtcStatusDefinition> {
    vec![
        dtc_status(0x08, "Confirmed"),
        dtc_status(0x04, "Pending"),
        dtc_status(0x02, "Failed this operation cycle"),
        dtc_status(0x01, "Currently failed"),
        dtc_status(0x20, "Failed since clear"),
        dtc_status(0x80, "Warning requested"),
    ]
}

fn dtc_status(mask: u8, label: &str) -> DtcStatusDefinition {
    DtcStatusDefinition {
        mask,
        label: label.into(),
    }
}

#[frb(sync)]
pub fn default_dtc_response_definition() -> DtcResponseDefinition {
    DtcResponseDefinition {
        id: "read_dtc_by_status_mask".into(),
        request_sid: 0x19,
        subfunction: 0x02,
        response_sid: 0x59,
        record_length: 4,
        code_length: 3,
        status_mask: 0x0C,
    }
}

fn build_dtc_read_request() -> [u8; 3] {
    let definition = default_dtc_response_definition();
    [
        definition.request_sid,
        definition.subfunction,
        definition.status_mask,
    ]
}

/// Build one bounded ReadMemoryByAddress request. The caller must provide a
/// validated region; this function does not select DME addresses.
fn build_ista_memory_read_request(address: u32, length: u16) -> Result<[u8; 8], String> {
    if length == 0 {
        return Err("DME memory-read chunks must not be empty".into());
    }
    Ok([
        0x23,
        ISTA_MEMORY_ADDRESS_LENGTH_FORMAT,
        (address >> 24) as u8,
        (address >> 16) as u8,
        (address >> 8) as u8,
        address as u8,
        (length >> 8) as u8,
        length as u8,
    ])
}

/// Validate one positive ReadMemoryByAddress response. The response payload
/// is returned without the 0x63 service byte.
fn parse_ista_memory_read_response(uds: &[u8], expected_length: usize) -> Result<&[u8], String> {
    if uds.first() != Some(&0x63) {
        return Err("Unexpected DME memory-read response".into());
    }
    let payload = &uds[1..];
    if payload.len() != expected_length {
        return Err(format!(
            "DME memory-read length mismatch: expected {expected_length}, received {}",
            payload.len()
        ));
    }
    Ok(payload)
}

/// Read one user-selected DME address without changing diagnostic session or
/// issuing any programming service. The active vehicle identity is rechecked
/// on the new diagnostic socket before the memory request is sent.
pub fn read_dme_memory(address: u32, length: u16, expected_vin: String) -> Result<Vec<u8>, String> {
    if length == 0 || length > 256 {
        return Err("Read length must be between 1 and 256 bytes".into());
    }
    if address.checked_add(u32::from(length) - 1).is_none() {
        return Err("Read range exceeds the 32-bit address space".into());
    }
    if expected_vin.len() != 17 || !expected_vin.chars().all(|c| c.is_ascii_alphanumeric()) {
        return Err("A valid connected vehicle VIN is required".into());
    }
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let host =
        last_vehicle_host().ok_or_else(|| "No active vehicle endpoint to read".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    let vin = read_ascii_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "vehicle_vin")?;
    if vin != expected_vin {
        return Err("DME VIN does not match the connected vehicle".into());
    }
    let f150 = read_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "ecu_identification")?;
    if f150.is_empty() {
        return Err("DME identity is unavailable".into());
    }
    let request = build_ista_memory_read_request(address, length)?;
    send_uds(&mut stream, ENGINE_ECU_ADDRESS, &request)?;
    let response = read_matching_uds_response(
        &mut stream,
        ENGINE_ECU_ADDRESS,
        &[0x63],
        &[0x23],
        Duration::from_secs(3),
    )?;
    Ok(parse_ista_memory_read_response(&response, length as usize)?.to_vec())
}

/// Send one physical UDS request. The caller supplies UDS bytes only; ENET
/// framing and the tester address are added here. Return the ECU's raw UDS
/// payload, including a final 7F negative response.
pub fn send_manual_diagnostic_message(
    target: u8,
    request: Vec<u8>,
    expected_vin: String,
) -> Result<Vec<u8>, String> {
    if target == BROADCAST_ECU_ADDRESS || target == TESTER {
        return Err("Choose a physical ECU address, not broadcast or tester".into());
    }
    if request.is_empty() || request.len() > 4096 {
        return Err("UDS request must contain 1–4096 bytes".into());
    }
    if expected_vin.len() != 17 || !expected_vin.chars().all(|c| c.is_ascii_alphanumeric()) {
        return Err("A valid connected vehicle VIN is required".into());
    }
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let host = last_vehicle_host().ok_or_else(|| "No active vehicle endpoint".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    let vin = read_ascii_data_identifier(&mut stream, ENGINE_ECU_ADDRESS, "vehicle_vin")?;
    if vin != expected_vin {
        return Err("DME VIN does not match the connected vehicle".into());
    }
    send_uds(&mut stream, target, &request)?;
    read_manual_uds_response(&mut stream, target, request[0], Duration::from_secs(5))
}

fn read_manual_uds_response(
    stream: &mut TcpStream,
    source: u8,
    service: u8,
    timeout: Duration,
) -> Result<Vec<u8>, String> {
    let deadline = Instant::now() + timeout;
    let mut buffer = Vec::with_capacity(4096);
    let mut scratch = [0u8; 4096];
    while Instant::now() < deadline {
        match stream.read(&mut scratch) {
            Ok(0) => return Err("Vehicle closed the diagnostic connection".into()),
            Ok(count) => buffer.extend_from_slice(&scratch[..count]),
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {
                continue
            }
            Err(error) => return Err(error.to_string()),
        }
        for frame in drain_hsfz(&mut buffer)? {
            if !is_application_response(&frame) || frame.source != source {
                continue;
            }
            if frame.uds.first() == Some(&service.wrapping_add(0x40)) {
                return Ok(frame.uds);
            }
            if frame.uds.starts_with(&[0x7F, service]) {
                if frame.uds.get(2) == Some(&0x78) {
                    continue;
                }
                return Ok(frame.uds);
            }
        }
    }
    Err("ECU response timeout".into())
}

/// Read the capture-derived S55 calibration region using ISTA's conservative
/// 256-byte transaction pattern. This is read-only and deliberately limited
/// to the exact software token observed in the ISTA capture.
pub fn read_ista_s55_calibration() -> Result<Vec<u8>, String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let cancelled = ISTA_READ_CANCEL
        .get_or_init(|| Arc::new(AtomicBool::new(false)))
        .clone();
    cancelled.store(false, Ordering::Relaxed);
    let host = last_vehicle_host()
        .or_else(|| discover_vehicle(&cancelled))
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    let (vin, identity, fingerprint, _, _) = identify_engine(&mut stream)?;
    validate_vehicle_identity(vin, stable_dme_identity(&fingerprint, &identity)?)?;
    let software = fingerprint.software;
    if software.is_empty() {
        return Err("DME software identifier is unavailable".into());
    }
    if !software.contains(ISTA_S55_READ_SOFTWARE) {
        return Err(format!(
            "ISTA read profile is not validated for DME software {software}"
        ));
    }
    let mut output = Vec::with_capacity(ISTA_S55_READ_LENGTH as usize);
    let mut address = ISTA_S55_READ_START;
    while address < ISTA_S55_READ_START + ISTA_S55_READ_LENGTH {
        if cancelled.load(Ordering::Relaxed) {
            return Err("ISTA DME read cancelled".into());
        }
        let request = build_ista_memory_read_request(address, ISTA_MEMORY_READ_CHUNK as u16)?;
        send_uds(&mut stream, ENGINE_ECU_ADDRESS, &request)?;
        let response = read_matching_uds_response(
            &mut stream,
            ENGINE_ECU_ADDRESS,
            &[0x63],
            &[0x23],
            Duration::from_secs(3),
        )?;
        output.extend_from_slice(parse_ista_memory_read_response(
            &response,
            ISTA_MEMORY_READ_CHUNK as usize,
        )?);
        address += ISTA_MEMORY_READ_CHUNK;
    }
    Ok(output)
}

/// Read the capture-derived BM3 memory region with the larger 0x23 blocks
/// observed on the F82 and the beginning of the N20 bench read. This prototype deliberately does
/// not invoke the unexplained 0x31 routine sent to ECU 0x40 in the F82 capture.
pub fn read_bm3_s55_calibration() -> Result<Vec<u8>, String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let cancelled = BM3_READ_CANCEL
        .get_or_init(|| Arc::new(AtomicBool::new(false)))
        .clone();
    cancelled.store(false, Ordering::Relaxed);
    let host = last_vehicle_host()
        .or_else(|| discover_vehicle(&cancelled))
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    let is_n20_bench = validate_bm3_read_vehicle(&mut stream)?;

    let mut output = Vec::with_capacity(BM3_S55_READ_LENGTH as usize);
    let mut address = BM3_S55_READ_START;
    let end_address = BM3_S55_READ_START + BM3_S55_READ_LENGTH;
    let mut recovered_once = false;
    while address < end_address {
        if cancelled.load(Ordering::Relaxed) {
            return Err("BM3-pattern DME read cancelled".into());
        }
        let length = (end_address - address).min(BM3_S55_READ_CHUNK) as u16;
        let block = match read_bm3_memory_block(&mut stream, address, length) {
            Ok(block) => block,
            Err(error) if is_n20_bench && error == "ECU response timeout" && !recovered_once => {
                recovered_once = true;
                if cancelled.load(Ordering::Relaxed) {
                    return Err("BM3-pattern DME read cancelled".into());
                }
                let mut resumed = fresh_diagnostic_stream(&host)?;
                if !validate_bm3_read_vehicle(&mut resumed)? {
                    return Err("DME changed during the N20 read".into());
                }
                if address > BM3_S55_READ_START {
                    let previous_address = address - BM3_S55_READ_CHUNK;
                    let previous_offset = (previous_address - BM3_S55_READ_START) as usize;
                    let previous = read_bm3_memory_block(
                        &mut resumed,
                        previous_address,
                        BM3_S55_READ_CHUNK as u16,
                    )
                    .map_err(|error| {
                        format!(
                            "DME read stopped at 0x{address:08X}: recovery check failed: {error}"
                        )
                    })?;
                    if previous != output[previous_offset..] {
                        return Err(format!(
                            "DME read stopped at 0x{address:08X}: previous block changed after reconnect"
                        ));
                    }
                }
                let block =
                    read_bm3_memory_block(&mut resumed, address, length).map_err(|error| {
                        format!("DME read stopped at 0x{address:08X}: retry failed: {error}")
                    })?;
                stream = resumed;
                block
            }
            Err(error) => {
                return Err(format!(
                    "DME read stopped at 0x{address:08X} after {} bytes: {error}",
                    output.len()
                ));
            }
        };
        output.extend_from_slice(&block);
        address += u32::from(length);
    }
    Ok(output)
}

fn validate_bm3_read_vehicle(stream: &mut TcpStream) -> Result<bool, String> {
    let (vin, identity, fingerprint, _, _) = identify_engine(stream)?;
    if vin == N20_BENCH_VIN {
        validate_vehicle_identity(vin.clone(), stable_dme_identity(&fingerprint, &identity)?)?;
        let f150 = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "ecu_identification")?;
        let f101 = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "s55_dme_identity_bundle")?;
        if f150 != [0x0F, 0x18, 0x10] || hex_payload(&f101) != N20_BENCH_F101 {
            return Err("N20 DME identity does not match the captured bench probe profile".into());
        }
        Ok(true)
    } else if vin != BM3_S55_READ_VIN {
        Err(format!(
            "Read DME 2 is limited to the captured S55 or documented N20 bench profile; found VIN {vin}"
        ))
    } else {
        validate_vehicle_identity(vin, stable_dme_identity(&fingerprint, &identity)?)?;
        let software = fingerprint.software;
        if software != BM3_S55_READ_SOFTWARE {
            return Err(format!(
                "BM3-pattern read profile is limited to captured DME software {BM3_S55_READ_SOFTWARE}; found {software}"
            ));
        }
        Ok(false)
    }
}

fn read_bm3_memory_block(
    stream: &mut TcpStream,
    address: u32,
    length: u16,
) -> Result<Vec<u8>, String> {
    let request = build_ista_memory_read_request(address, length)?;
    send_uds(stream, ENGINE_ECU_ADDRESS, &request)?;
    let response = read_matching_uds_response(
        stream,
        ENGINE_ECU_ADDRESS,
        &[0x63],
        &[0x23],
        BM3_MEMORY_RESPONSE_TIMEOUT,
    )?;
    Ok(parse_ista_memory_read_response(&response, length as usize)?.to_vec())
}

/// Request cancellation of the active BM3-pattern read-only transaction.
#[frb(sync)]
pub fn cancel_bm3_s55_calibration() {
    if let Some(flag) = BM3_READ_CANCEL.get() {
        flag.store(true, Ordering::Relaxed);
    }
}

#[frb(sync)]
pub fn default_diagnostic_data_identifiers() -> Vec<DiagnosticDataIdentifierDefinition> {
    vec![
        data_identifier(
            "ecu_identification",
            "Diagnostic ECU ID",
            0xF150,
            0x62,
            "ascii",
            None,
        ),
        data_identifier(
            "vehicle_vin",
            "Vehicle identification number",
            0xF190,
            0x62,
            "ascii",
            Some(17),
        ),
        data_identifier(
            "ecu_serial_number",
            "ECU serial number",
            0xF18C,
            0x62,
            "ascii",
            None,
        ),
        data_identifier(
            "s55_dme_identity_bundle",
            "S55 DME identity bundle",
            0xF101,
            0x62,
            "binary",
            None,
        ),
        data_identifier(
            "dme_factory_identity_bundle",
            "DME factory identity bundle",
            0xF103,
            0x62,
            "binary",
            Some(49),
        ),
        data_identifier(
            "dme_supplier_identity_bundle",
            "DME system supplier identity bundle",
            0xF102,
            0x62,
            "binary",
            Some(49),
        ),
        data_identifier(
            "dme_flash_counter",
            "DME flash counter",
            0x2502,
            0x62,
            "unsigned_u32_be",
            Some(4),
        ),
        data_identifier(
            "vehicle_dme_battery_voltage",
            "DME battery voltage",
            0x586A,
            0x62,
            "unsigned_u16_be",
            Some(2),
        ),
        data_identifier(
            "s55_ecu_manufacturing_date",
            "S55 ECU manufacturing date",
            0xF18B,
            0x62,
            "binary_bcd_yy_mm_dd",
            Some(3),
        ),
        data_identifier(
            "s55_dme_diagnostic_session",
            "S55 DME diagnostic session record",
            0xF186,
            0x62,
            "binary_session_record",
            Some(2),
        ),
    ]
}

fn data_identifier(
    id: &str,
    name: &str,
    did: u16,
    response_sid: u8,
    encoding: &str,
    exact_length: Option<u8>,
) -> DiagnosticDataIdentifierDefinition {
    DiagnosticDataIdentifierDefinition {
        id: id.into(),
        name: name.into(),
        did,
        response_sid,
        encoding: encoding.into(),
        exact_length,
    }
}

fn data_identifier_definition(id: &str) -> DiagnosticDataIdentifierDefinition {
    default_diagnostic_data_identifiers()
        .into_iter()
        .find(|definition| definition.id == id)
        .expect("built-in diagnostic data identifier is missing")
}

#[frb(sync)]
pub fn decode_ecu_identification(raw_data: Vec<u8>) -> EcuIdentification {
    let is_text = raw_data
        .iter()
        .all(|byte| *byte == 0 || (0x20..=0x7e).contains(byte));
    let display_value = if is_text {
        String::from_utf8_lossy(&raw_data).trim().to_string()
    } else {
        raw_data
            .iter()
            .map(|byte| format!("{byte:02X}"))
            .collect::<Vec<_>>()
            .join(" ")
    };
    EcuIdentification {
        display_value,
        raw_data,
    }
}

#[frb(sync)]
pub fn default_diagnostic_services() -> Vec<DiagnosticServiceDefinition> {
    vec![
        diagnostic_service(
            "read_ecu_identification",
            "Read diagnostic ECU ID (F150)",
            0x22,
            0x62,
            "read_only",
        ),
        diagnostic_service(
            "read_vin",
            "Read vehicle identification number (F190)",
            0x22,
            0x62,
            "read_only",
        ),
        diagnostic_service(
            "read_dtc_information",
            "Read diagnostic trouble information",
            0x19,
            0x59,
            "read_only",
        ),
        diagnostic_service(
            "clear_diagnostic_information",
            "Clear diagnostic information",
            0x14,
            0x54,
            "confirmed_ecu_specific_write",
        ),
    ]
}

fn diagnostic_service(
    id: &str,
    name: &str,
    request_sid: u8,
    positive_response_sid: u8,
    safety: &str,
) -> DiagnosticServiceDefinition {
    DiagnosticServiceDefinition {
        id: id.into(),
        name: name.into(),
        request_sid,
        positive_response_sid,
        safety: safety.into(),
    }
}
// Additional powertrain and gateway DTC endpoints observed in the ISTA F82
// capture. iDrive and gear-selector endpoints are deliberately excluded.
const ADDITIONAL_DTC_ECUS: [u8; 3] = [0x10, 0x17, 0x18];
const DTC_QUERY_TIMEOUT: Duration = Duration::from_millis(1500);
const OPTIONAL_ECU_SESSION_TIMEOUT: Duration = Duration::from_millis(750);
const MAX_LIVE_SENSORS: usize = 6;

fn ecu_display_name(address: u8) -> String {
    match address {
        0x12 => "DME (engine control unit)".into(),
        0x40 => "FEM body module".into(),
        0x10 => "Vehicle control module".into(),
        _ => "Vehicle control module".into(),
    }
}

static ACTIVE_SESSION: OnceLock<Mutex<Option<Arc<AtomicBool>>>> = OnceLock::new();
static MONITORING_ENABLED: OnceLock<AtomicBool> = OnceLock::new();
static LAST_VEHICLE_HOST: OnceLock<Mutex<Option<String>>> = OnceLock::new();
static LAST_VALIDATED_VEHICLE: OnceLock<Mutex<Option<ValidatedVehicleIdentity>>> = OnceLock::new();
static LIVE_SENSOR_IDS: OnceLock<Mutex<Vec<String>>> = OnceLock::new();
static ACTIVE_FLAP_MODE: OnceLock<Mutex<Option<String>>> = OnceLock::new();
enum FlapCommand {
    Set {
        mode: String,
        reply: mpsc::Sender<Result<(), String>>,
    },
}

#[frb(ignore)]
#[derive(Default)]
struct PendingFlapReply(Option<mpsc::Sender<Result<(), String>>>);

impl PendingFlapReply {
    fn complete(&mut self, result: Result<(), String>) {
        if let Some(reply) = self.0.take() {
            let _ = reply.send(result);
        }
    }
}

static FLAP_COMMAND_SENDER: OnceLock<Mutex<Option<mpsc::Sender<FlapCommand>>>> = OnceLock::new();

#[frb(ignore)]
#[derive(Clone, Debug, PartialEq, Eq)]
struct ValidatedVehicleIdentity {
    vin: String,
    dme_identity: String,
}

fn monitoring_enabled() -> &'static AtomicBool {
    MONITORING_ENABLED.get_or_init(|| AtomicBool::new(false))
}

/// Begin the optional live-data loop for the active vehicle session.
/// Identification and other diagnostic actions remain available while stopped.
#[frb(sync)]
pub fn start_monitoring() {
    monitoring_enabled().store(true, Ordering::Release);
}

/// Pause live telemetry and release its temporary dynamic identifier.
#[frb(sync)]
pub fn stop_monitoring() {
    monitoring_enabled().store(false, Ordering::Release);
}

fn last_vehicle_host() -> Option<String> {
    LAST_VEHICLE_HOST
        .get_or_init(|| Mutex::new(None))
        .lock()
        .ok()
        .and_then(|host| host.clone())
}

fn remember_vehicle_host(host: &str) {
    if let Ok(mut slot) = LAST_VEHICLE_HOST.get_or_init(|| Mutex::new(None)).lock() {
        *slot = Some(host.to_string());
    }
}

fn clear_validated_vehicle_identity() {
    if let Ok(mut binding) = LAST_VALIDATED_VEHICLE
        .get_or_init(|| Mutex::new(None))
        .lock()
    {
        *binding = None;
    }
}

fn forget_vehicle_host() {
    if let Ok(mut slot) = LAST_VEHICLE_HOST.get_or_init(|| Mutex::new(None)).lock() {
        *slot = None;
    }
}

fn fresh_diagnostic_stream(host: &str) -> Result<TcpStream, String> {
    let address = format!("{host}:6801")
        .to_socket_addrs()
        .map_err(|error| error.to_string())?
        .next()
        .ok_or_else(|| "Invalid vehicle address".to_string())?;
    let stream = TcpStream::connect_timeout(&address, Duration::from_secs(5))
        .map_err(|error| error.to_string())?;
    stream
        .set_read_timeout(Some(Duration::from_millis(250)))
        .map_err(|error| error.to_string())?;
    stream
        .set_write_timeout(Some(Duration::from_secs(1)))
        .map_err(|error| error.to_string())?;
    Ok(stream)
}

#[derive(Clone, Debug)]
pub struct SensorDefinition {
    pub id: String,
    pub label: String,
    pub did: u16,
    pub ecu: u8,
    pub size: u8,
    pub unit: String,
    pub minimum: f64,
    pub maximum: f64,
    pub warning: f64,
    pub danger: f64,
    pub decimals: u8,
    pub scale: f64,
    pub offset: f64,
}

#[derive(Clone, Debug)]
pub struct VehicleEvent {
    pub kind: String,
    pub message: String,
    pub sensor_id: String,
    pub value: f64,
    pub raw_value: u32,
    pub vin: String,
    // These fields are part of the v24 Flutter/Rust bridge contract.  Empty
    // values mean that a read-only identifier was not available; they are not
    // evidence that an ECU is absent or that a value is valid on this vehicle.
    pub ecu_address: u8,
    pub ecu_identity: String,
    pub ecu_hardware: String,
    pub ecu_software: String,
    pub ecu_bootloader: String,
    pub ecu_calibration: String,
    pub ecu_application_software: String,
    pub ecu_software_version: String,
    pub ecu_supplier_hardware: String,
    pub ecu_supplier_software: String,
    pub ecu_bootloader_fingerprint: String,
    pub ecu_software_fingerprint: String,
    pub ecu_calibration_fingerprint: String,
    pub ecu_sgbd_index: String,
    pub ecu_serial_number: String,
    pub ecu_manufacturing_date: String,
    pub ecu_flash_counter: String,
    pub ecu_diagnostic_session: String,
    pub ecu_coding_id: String,
    pub ecu_cvn: String,
    pub ecu_bmw_routine_0205_raw: String,
    pub ecu_bmw_routine_0205_software: String,
    pub ecu_bmw_controller_family: String,
    pub ecu_bmw_variant: String,
    pub ecu_bmw_transmission: String,
    pub ecu_bmw_emissions: String,
    pub ecu_bmw_internal_token: String,
    pub transport_request_id: u64,
    pub transport_request_operation: String,
    pub transport_request_age_ms: u64,
    pub transport_retry_count: u8,
    pub transport_socket_state: String,
    pub transport_recovery_action: String,
    pub transport_recovery_result: String,
}

#[derive(Default)]
pub struct EcuFingerprintValues {
    pub hardware: String,
    pub software: String,
    pub bootloader: String,
    pub calibration: String,
    pub application_software: String,
    pub software_version: String,
    pub supplier_hardware: String,
    pub supplier_software: String,
    pub bootloader_fingerprint: String,
    pub software_fingerprint: String,
    pub calibration_fingerprint: String,
    pub sgbd_index: String,
    pub serial_number: String,
    pub manufacturing_date: String,
    pub flash_counter: String,
    pub diagnostic_session: String,
    pub coding_id: String,
    pub cvn: String,
    pub bmw_routine_0205_raw: String,
    pub bmw_routine_0205_software: String,
    pub bmw_controller_family: String,
    pub bmw_variant: String,
    pub bmw_transmission: String,
    pub bmw_emissions: String,
    pub bmw_internal_token: String,
}

#[derive(Clone, Debug)]
pub struct DiagnosticTroubleCode {
    pub code: String,
    pub raw_code: u32,
    pub status: u8,
    pub status_text: String,
    pub ecu: String,
}

impl VehicleEvent {
    fn status(kind: &str, message: impl Into<String>) -> Self {
        Self {
            kind: kind.into(),
            message: message.into(),
            sensor_id: String::new(),
            value: 0.0,
            raw_value: 0,
            vin: String::new(),
            ecu_address: 0,
            ecu_identity: String::new(),
            ecu_hardware: String::new(),
            ecu_software: String::new(),
            ecu_bootloader: String::new(),
            ecu_calibration: String::new(),
            ecu_application_software: String::new(),
            ecu_software_version: String::new(),
            ecu_supplier_hardware: String::new(),
            ecu_supplier_software: String::new(),
            ecu_bootloader_fingerprint: String::new(),
            ecu_software_fingerprint: String::new(),
            ecu_calibration_fingerprint: String::new(),
            ecu_sgbd_index: String::new(),
            ecu_serial_number: String::new(),
            ecu_manufacturing_date: String::new(),
            ecu_flash_counter: String::new(),
            ecu_diagnostic_session: String::new(),
            ecu_coding_id: String::new(),
            ecu_cvn: String::new(),
            ecu_bmw_routine_0205_raw: String::new(),
            ecu_bmw_routine_0205_software: String::new(),
            ecu_bmw_controller_family: String::new(),
            ecu_bmw_variant: String::new(),
            ecu_bmw_transmission: String::new(),
            ecu_bmw_emissions: String::new(),
            ecu_bmw_internal_token: String::new(),
            transport_request_id: 0,
            transport_request_operation: String::new(),
            transport_request_age_ms: 0,
            transport_retry_count: 0,
            transport_socket_state: String::new(),
            transport_recovery_action: String::new(),
            transport_recovery_result: String::new(),
        }
    }

    fn sensor(sensor: &SensorDefinition, raw_value: u32) -> Self {
        Self {
            kind: "sensor".into(),
            message: sensor.label.clone(),
            sensor_id: sensor.id.clone(),
            value: raw_value as f64 * sensor.scale + sensor.offset,
            raw_value,
            vin: String::new(),
            ecu_address: 0,
            ecu_identity: String::new(),
            ecu_hardware: String::new(),
            ecu_software: String::new(),
            ecu_bootloader: String::new(),
            ecu_calibration: String::new(),
            ecu_application_software: String::new(),
            ecu_software_version: String::new(),
            ecu_supplier_hardware: String::new(),
            ecu_supplier_software: String::new(),
            ecu_bootloader_fingerprint: String::new(),
            ecu_software_fingerprint: String::new(),
            ecu_calibration_fingerprint: String::new(),
            ecu_sgbd_index: String::new(),
            ecu_serial_number: String::new(),
            ecu_manufacturing_date: String::new(),
            ecu_flash_counter: String::new(),
            ecu_diagnostic_session: String::new(),
            ecu_coding_id: String::new(),
            ecu_cvn: String::new(),
            ecu_bmw_routine_0205_raw: String::new(),
            ecu_bmw_routine_0205_software: String::new(),
            ecu_bmw_controller_family: String::new(),
            ecu_bmw_variant: String::new(),
            ecu_bmw_transmission: String::new(),
            ecu_bmw_emissions: String::new(),
            ecu_bmw_internal_token: String::new(),
            transport_request_id: 0,
            transport_request_operation: String::new(),
            transport_request_age_ms: 0,
            transport_retry_count: 0,
            transport_socket_state: String::new(),
            transport_recovery_action: String::new(),
            transport_recovery_result: String::new(),
        }
    }

    fn vehicle_voltage(raw_value: u16) -> Self {
        let mut event = Self::status("vehicle_voltage", "DME battery voltage (0x586A)");
        event.ecu_address = ENGINE_ECU_ADDRESS;
        event.raw_value = u32::from(raw_value);
        event.value = f64::from(raw_value) * 0.00025 + 6.0;
        event
    }

    fn sensor_with_transport(
        sensor: &SensorDefinition,
        raw_value: u32,
        request_id: u64,
        request_age: Duration,
        retry_count: u8,
    ) -> Self {
        let mut event = Self::sensor(sensor, raw_value);
        event.transport_request_id = request_id;
        event.transport_request_operation = format!(
            "{}:{DYNAMIC_DID_HIGH:02X}{DYNAMIC_DID_LOW:02X}",
            LivePollStage::Read.label()
        );
        event.transport_request_age_ms = request_age.as_millis() as u64;
        event.transport_retry_count = retry_count;
        event.transport_socket_state = "connected".into();
        if retry_count > 0 {
            event.transport_recovery_action = "tcp_reconnect_and_reidentify".into();
            event.transport_recovery_result = "telemetry_resumed".into();
        } else {
            event.transport_recovery_action = "none".into();
            event.transport_recovery_result = "not_required".into();
        }
        event
    }

    fn vin(vin: String) -> Self {
        Self {
            kind: "vin".into(),
            message: "Vehicle identified".into(),
            sensor_id: String::new(),
            value: 0.0,
            raw_value: 0,
            vin,
            ecu_address: 0,
            ecu_identity: String::new(),
            ecu_hardware: String::new(),
            ecu_software: String::new(),
            ecu_bootloader: String::new(),
            ecu_calibration: String::new(),
            ecu_application_software: String::new(),
            ecu_software_version: String::new(),
            ecu_supplier_hardware: String::new(),
            ecu_supplier_software: String::new(),
            ecu_bootloader_fingerprint: String::new(),
            ecu_software_fingerprint: String::new(),
            ecu_calibration_fingerprint: String::new(),
            ecu_sgbd_index: String::new(),
            ecu_serial_number: String::new(),
            ecu_manufacturing_date: String::new(),
            ecu_flash_counter: String::new(),
            ecu_diagnostic_session: String::new(),
            ecu_coding_id: String::new(),
            ecu_cvn: String::new(),
            ecu_bmw_routine_0205_raw: String::new(),
            ecu_bmw_routine_0205_software: String::new(),
            ecu_bmw_controller_family: String::new(),
            ecu_bmw_variant: String::new(),
            ecu_bmw_transmission: String::new(),
            ecu_bmw_emissions: String::new(),
            ecu_bmw_internal_token: String::new(),
            transport_request_id: 0,
            transport_request_operation: String::new(),
            transport_request_age_ms: 0,
            transport_retry_count: 0,
            transport_socket_state: String::new(),
            transport_recovery_action: String::new(),
            transport_recovery_result: String::new(),
        }
    }

    fn ecu_identity(address: u8, identity: String) -> Self {
        let mut event = Self::status("ecu_identity", "Read-only ECU identity collected");
        event.ecu_address = address;
        event.ecu_identity = identity;
        event
    }

    fn ecu_fingerprint(address: u8, values: EcuFingerprintValues) -> Self {
        Self {
            kind: "ecu_fingerprint".into(),
            message: "Read-only ECU fingerprint collected".into(),
            sensor_id: String::new(),
            value: 0.0,
            raw_value: 0,
            vin: String::new(),
            ecu_address: address,
            ecu_identity: String::new(),
            ecu_hardware: values.hardware,
            ecu_software: values.software,
            ecu_bootloader: values.bootloader,
            ecu_calibration: values.calibration,
            ecu_application_software: values.application_software,
            ecu_software_version: values.software_version,
            ecu_supplier_hardware: values.supplier_hardware,
            ecu_supplier_software: values.supplier_software,
            ecu_bootloader_fingerprint: values.bootloader_fingerprint,
            ecu_software_fingerprint: values.software_fingerprint,
            ecu_calibration_fingerprint: values.calibration_fingerprint,
            ecu_sgbd_index: values.sgbd_index,
            ecu_serial_number: values.serial_number,
            ecu_manufacturing_date: values.manufacturing_date,
            ecu_flash_counter: values.flash_counter,
            ecu_diagnostic_session: values.diagnostic_session,
            ecu_coding_id: values.coding_id,
            ecu_cvn: values.cvn,
            ecu_bmw_routine_0205_raw: values.bmw_routine_0205_raw,
            ecu_bmw_routine_0205_software: values.bmw_routine_0205_software,
            ecu_bmw_controller_family: values.bmw_controller_family,
            ecu_bmw_variant: values.bmw_variant,
            ecu_bmw_transmission: values.bmw_transmission,
            ecu_bmw_emissions: values.bmw_emissions,
            ecu_bmw_internal_token: values.bmw_internal_token,
            transport_request_id: 0,
            transport_request_operation: String::new(),
            transport_request_age_ms: 0,
            transport_retry_count: 0,
            transport_socket_state: String::new(),
            transport_recovery_action: String::new(),
            transport_recovery_result: String::new(),
        }
    }

    fn ecu_factory_identity(address: u8, values: EcuFingerprintValues) -> Self {
        let mut event = Self::status(
            "ecu_factory_identity",
            "Factory DME identity collected (F103)",
        );
        event.ecu_address = address;
        event.ecu_hardware = values.hardware;
        event.ecu_bootloader = values.bootloader;
        event.ecu_software = values.software;
        event.ecu_calibration = values.calibration;
        event
    }

    fn ecu_supplier_identity(address: u8, values: EcuFingerprintValues) -> Self {
        let mut event = Self::status(
            "ecu_supplier_identity",
            "System supplier DME identity collected (F102)",
        );
        event.ecu_address = address;
        event.ecu_hardware = values.hardware;
        event.ecu_bootloader = values.bootloader;
        event.ecu_software = values.software;
        event.ecu_calibration = values.calibration;
        event
    }

    fn ecu_last_flash_date(address: u8, date: String) -> Self {
        let mut event = Self::status("ecu_last_flash_date", date);
        event.ecu_address = address;
        event
    }
}

#[frb(sync)]
pub fn default_sensors() -> Vec<SensorDefinition> {
    vec![
        sensor(
            "engine_rpm",
            "Engine RPM",
            18439,
            2,
            "RPM",
            0.0,
            8000.0,
            5500.0,
            7000.0,
            0,
            0.25,
            0.0,
        ),
        sensor(
            "battery_voltage",
            "Battery Voltage",
            22549,
            1,
            "V",
            9.0,
            16.0,
            14.8,
            11.0,
            2,
            0.1,
            0.0,
        ),
        sensor(
            "lp_fuel_pressure",
            "LP Fuel Pressure",
            22771,
            2,
            "PSI",
            0.0,
            145.0,
            116.0,
            130.0,
            1,
            0.0145038,
            0.0,
        ),
        sensor(
            "hp_rail_pressure",
            "HP Rail Pressure",
            22768,
            2,
            "PSI",
            0.0,
            2900.0,
            2610.0,
            2830.0,
            1,
            0.0725,
            0.0,
        ),
        sensor(
            "coolant_temp",
            "Coolant Temp",
            17152,
            1,
            "°C",
            0.0,
            130.0,
            100.0,
            115.0,
            1,
            0.5,
            -3.5,
        ),
        sensor(
            "oil_pressure",
            "Oil Pressure",
            22639,
            2,
            "PSI",
            0.0,
            90.0,
            75.0,
            85.0,
            1,
            0.0145675,
            0.0,
        ),
        sensor(
            "engine_oil_temp",
            "Engine Oil Temp",
            17410,
            2,
            "°C",
            0.0,
            150.0,
            120.0,
            135.0,
            1,
            0.5127551,
            0.0,
        ),
        sensor(
            "boost_pressure",
            "Boost Pressure",
            22749,
            2,
            "PSI",
            0.0,
            30.0,
            25.0,
            28.0,
            2,
            0.0011331,
            0.0,
        ),
        sensor(
            "throttle_angle",
            "Throttle Angle",
            17920,
            2,
            "%",
            0.0,
            100.0,
            90.0,
            95.0,
            1,
            0.024375,
            0.0,
        ),
        sensor(
            "intake_pressure",
            "Intake Pressure",
            22539,
            2,
            "PSI",
            0.0,
            15.0,
            13.0,
            14.0,
            2,
            0.00056536,
            0.0,
        ),
        sensor(
            "valvetronic_angle",
            "Valvetronic Angle",
            22690,
            2,
            "deg",
            0.0,
            60.0,
            50.0,
            55.0,
            1,
            0.1,
            0.0,
        ),
    ]
}

fn configured_live_sensor_ids() -> Vec<String> {
    LIVE_SENSOR_IDS
        .get_or_init(|| Mutex::new(Vec::new()))
        .lock()
        .map(|ids| ids.clone())
        .unwrap_or_default()
}

fn selected_sensors(all_sensors: &[SensorDefinition]) -> Vec<SensorDefinition> {
    let configured = configured_live_sensor_ids();
    let mut selected = all_sensors
        .iter()
        .filter(|sensor| configured.iter().any(|id| id == &sensor.id))
        .take(MAX_LIVE_SENSORS)
        .cloned()
        .collect::<Vec<_>>();
    if selected.is_empty() {
        selected.extend(all_sensors.iter().take(MAX_LIVE_SENSORS).cloned());
    }
    selected
}

/// Sets the live telemetry channels. The transport deliberately caps this at
/// six channels; sensor polling still serializes with actuator traffic.
#[frb(sync)]
pub fn set_live_sensor_ids(sensor_ids: Vec<String>) {
    let mut sanitized = Vec::new();
    for id in sensor_ids {
        if !sanitized.contains(&id) {
            sanitized.push(id);
        }
        if sanitized.len() == MAX_LIVE_SENSORS {
            break;
        }
    }
    if let Ok(mut configured) = LIVE_SENSOR_IDS
        .get_or_init(|| Mutex::new(Vec::new()))
        .lock()
    {
        *configured = sanitized;
    }
}

#[allow(clippy::too_many_arguments)]
fn sensor(
    id: &str,
    label: &str,
    did: u16,
    size: u8,
    unit: &str,
    minimum: f64,
    maximum: f64,
    warning: f64,
    danger: f64,
    decimals: u8,
    scale: f64,
    offset: f64,
) -> SensorDefinition {
    SensorDefinition {
        id: id.into(),
        label: label.into(),
        did,
        ecu: 0x12,
        size,
        unit: unit.into(),
        minimum,
        maximum,
        warning,
        danger,
        decimals,
        scale,
        offset,
    }
}

pub fn start_vehicle_session(
    host: String,
    port: u16,
    sink: StreamSink<VehicleEvent>,
) -> Result<(), String> {
    let access = crate::vehicle_access::vehicle_access().diagnostic()?;
    begin_session(move |stop| {
        let _access = access;
        run_vehicle_session(host, port, sink, stop)
    })
}

pub fn start_auto_vehicle_session(sink: StreamSink<VehicleEvent>) -> Result<(), String> {
    let access = crate::vehicle_access::vehicle_access().diagnostic()?;
    begin_session(move |stop| {
        let _access = access;
        const DISCOVERY_ATTEMPTS: u8 = 4;
        const DISCOVERY_RETRY_DELAY: Duration = Duration::from_millis(350);

        let mut discovered_host = None;
        for attempt in 1..=DISCOVERY_ATTEMPTS {
            if stop.load(Ordering::Acquire) {
                break;
            }
            let _ = sink.add(VehicleEvent::status(
                "discovering",
                format!("Searching for vehicle ({attempt}/{DISCOVERY_ATTEMPTS})"),
            ));
            let cached_host = last_vehicle_host();
            let host = cached_host
                .clone()
                .filter(|host| probe_enet(host, Duration::from_millis(350)))
                .or_else(|| {
                    if cached_host.is_some() {
                        forget_vehicle_host();
                    }
                    discover_vehicle(&stop)
                });
            if let Some(host) = host {
                discovered_host = Some(host);
                break;
            }
            if attempt < DISCOVERY_ATTEMPTS {
                let retry_at = Instant::now() + DISCOVERY_RETRY_DELAY;
                while Instant::now() < retry_at && !stop.load(Ordering::Acquire) {
                    thread::sleep(Duration::from_millis(50));
                }
            }
        }

        if let Some(host) = discovered_host {
            remember_vehicle_host(&host);
            run_vehicle_session(host, 6801, sink.clone(), stop.clone());
        } else if !stop.load(Ordering::Acquire) {
            let _ = sink.add(VehicleEvent::status(
                "warning",
                "No vehicle found after 4 searches. Check the cable and ignition, then tap Retry.",
            ));
        }
        if stop.load(Ordering::Acquire) {
            let _ = sink.add(VehicleEvent::status("disconnected", "Session stopped"));
        }
    })
}

pub fn start_demo_session(sink: StreamSink<VehicleEvent>) -> Result<(), String> {
    begin_session(move |stop| run_demo_session(sink, stop))
}

#[frb(sync)]
pub fn stop_session() {
    stop_monitoring();
    stop_exhaust_flap_session();
    if let Some(stop) = session_slot().lock().expect("session lock poisoned").take() {
        stop.store(true, Ordering::Release);
    }
}

/// Stop the live owner and wait until its worker has closed the socket and
/// released process-wide vehicle access. Standalone services use this handoff
/// instead of guessing with a fixed delay.
pub fn stop_session_and_wait(timeout_ms: u64) -> Result<(), String> {
    stop_session();
    crate::vehicle_access::vehicle_access()
        .wait_for_diagnostic_release(Duration::from_millis(timeout_ms))
}

pub fn scan_engine_diagnostics() -> Result<Vec<DiagnosticTroubleCode>, String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    // Reuse the diagnostic socket so a later guarded clear can remain in the
    // same initialized ENET session.
    let cancelled = AtomicBool::new(false);
    let host = last_vehicle_host()
        .or_else(|| discover_vehicle(&cancelled))
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    remember_vehicle_host(&host);
    let mut stream = fresh_diagnostic_stream(&host)?;

    let profile = confirmed_f82_s55_profile();
    let vin = validate_service_vehicle(&mut stream)?;
    let mut faults = query_dtc_for_ecu_with_retry(
        &mut stream,
        profile.engine_ecu,
        &ecu_display_name(profile.engine_ecu),
    )?;
    // ISTA's F82 scan also queries the FEM at HSFZ address 0x40. This is
    // read-only; Clear-DTC remains restricted to the separately guarded DME path.
    let optional_ecus = if vin == N20_BENCH_VIN {
        vec![0x40, 0x10]
    } else {
        std::iter::once(0x40).chain(ADDITIONAL_DTC_ECUS).collect()
    };
    for ecu in optional_ecus {
        match query_dtc_for_ecu(
            &mut stream,
            ecu,
            &ecu_display_name(ecu),
            OPTIONAL_ECU_SESSION_TIMEOUT,
        ) {
            Ok(ecu_faults) => faults.extend(ecu_faults),
            Err(error) => transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({"type": "optional_dtc_ecu_skipped", "ecu": format!("{ecu:02X}"), "reason": error}),
            ),
        }
    }
    Ok(faults)
}

fn query_dtc_for_ecu(
    stream: &mut TcpStream,
    ecu: u8,
    ecu_name: &str,
    session_timeout: Duration,
) -> Result<Vec<DiagnosticTroubleCode>, String> {
    // BM3's captured F82/S55 DME read sends 19 02 0C directly after the
    // identification exchange. Other ECUs require session setup, but optional
    // addresses are probed once so an absent module cannot stall the scan.
    if ecu != confirmed_f82_s55_profile().engine_ecu {
        enter_extended_session_with_timeout(stream, ecu, session_timeout)?;
    }
    send_uds(stream, ecu, &build_dtc_read_request())?;
    let deadline = Instant::now() + DTC_QUERY_TIMEOUT;
    let mut buffer = Vec::with_capacity(4096);
    let mut scratch = [0u8; 4096];
    while Instant::now() < deadline {
        match stream.read(&mut scratch) {
            Ok(0) => return Err("Vehicle closed the diagnostic connection".into()),
            Ok(count) => buffer.extend_from_slice(&scratch[..count]),
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {}
            Err(error) => return Err(error.to_string()),
        }
        for frame in drain_hsfz(&mut buffer)? {
            if !is_application_response(&frame) || frame.source != ecu {
                transport_diagnostic(
                    TransportDiagnosticsLevel::Detailed,
                    json!({
                        "type": "response_ignored",
                        "reason": "dtc_route_mismatch",
                        "expectedSource": format!("{ecu:02X}"),
                        "expectedDestination": format!("{TESTER:02X}"),
                        "actualMessageType": format!("{:04X}", frame.message_type),
                        "actualSource": format!("{:02X}", frame.source),
                        "actualDestination": format!("{:02X}", frame.destination),
                    }),
                );
                continue;
            }
            if frame.uds.starts_with(&[0x59, 0x02]) {
                return parse_dtc_response_for_ecu(&frame.uds, ecu_name);
            }
            if frame.uds.starts_with(&[0x7F, 0x19, 0x78]) {
                continue;
            }
            if frame.uds.starts_with(&[0x7F, 0x19]) {
                return Err(format!(
                    "{ecu_name} rejected the DTC request (NRC 0x{:02X})",
                    frame.uds.get(2).copied().unwrap_or_default()
                ));
            }
        }
    }
    Err(format!("{ecu_name} did not answer the diagnostic request"))
}

fn query_dtc_for_ecu_with_retry(
    stream: &mut TcpStream,
    ecu: u8,
    ecu_name: &str,
) -> Result<Vec<DiagnosticTroubleCode>, String> {
    let mut last_error = String::new();
    for attempt in 0..3 {
        match query_dtc_for_ecu(stream, ecu, ecu_name, Duration::from_secs(3)) {
            Ok(faults) => return Ok(faults),
            Err(error) => {
                last_error = error;
                if attempt < 2 {
                    // A timeout is commonly transient on ENET while another ECU
                    // is responding. Re-enter the session and retry the same ECU.
                    let _ = enter_extended_session(stream, ecu);
                }
            }
        }
    }
    Err(last_error)
}

/// Clears diagnostic information with the captured BM3 broadcast transaction.
/// This is intentionally a separate, explicit API: scanning never clears.
pub fn clear_engine_diagnostics() -> Result<Vec<DiagnosticTroubleCode>, String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    // The guarded write uses its own socket and leaves live telemetry state
    // under the caller's control.
    let cancelled = AtomicBool::new(false);
    let host = last_vehicle_host()
        .or_else(|| discover_vehicle(&cancelled))
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    remember_vehicle_host(&host);
    let mut stream = fresh_diagnostic_stream(&host)?;
    let profile = confirmed_f82_s55_profile();
    // Validate the S55 DME directly. 0xDF is an HSFZ broadcast address, not
    // an ECU identity endpoint, so it must never be used for this check.
    validate_service_vehicle(&mut stream)?;
    // BM3 clears with a broadcast 14 FF FF FF and no preceding broadcast
    // session-control request. The gateway fans the command out to the ECUs.
    send_uds(
        &mut stream,
        profile.clear_dtc_ecu,
        &build_clear_dtc_request([0xFF, 0xFF, 0xFF]),
    )?;
    wait_for_broadcast_clear_dtc_responses(
        &mut stream,
        profile.engine_ecu,
        BROADCAST_CLEAR_TIMEOUT,
    )?;
    // Verify the S55 DME directly. A broadcast verification can consume a
    // response from any ECU and cannot prove the engine fault state.
    send_uds(&mut stream, profile.engine_ecu, &build_dtc_read_request())?;
    let dtc_response = read_matching_uds_response(
        &mut stream,
        profile.engine_ecu,
        &[0x59, 0x02],
        &[0x19],
        Duration::from_secs(3),
    )?;
    if !dtc_response.starts_with(&[0x59, 0x02]) {
        return Err("Clear succeeded, but post-clear verification was malformed".into());
    }
    parse_dtc_response(&dtc_response)
}

/// Sends the captured BMW broadcast DME reset after confirming that the live
/// DME VIN matches the vehicle selected in the app. Address 0xDF can reach
/// multiple ECUs, so the UI requires explicit confirmation before calling.
pub fn reset_engine_dme(expected_vin: String) -> Result<(), String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let expected_vin = expected_vin.trim().to_ascii_uppercase();
    validate_selected_reset_vin(&expected_vin)?;
    let cancelled = AtomicBool::new(false);
    let host = last_vehicle_host()
        .or_else(|| discover_vehicle(&cancelled))
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    remember_vehicle_host(&host);
    let mut stream = fresh_diagnostic_stream(&host)?;
    let live_vin = validate_service_vehicle(&mut stream)?;
    validate_matching_reset_vin(&expected_vin, &live_vin)?;

    send_uds(
        &mut stream,
        BROADCAST_ECU_ADDRESS,
        &build_dme_reset_request(),
    )?;
    let response = read_matching_uds_response(
        &mut stream,
        ENGINE_ECU_ADDRESS,
        &[0x51, 0x01],
        &[0x11],
        BROADCAST_RESET_TIMEOUT,
    )?;
    parse_dme_reset_acknowledgement(&response)
}

/// Executes the captured ISTA exhaust-flap cyclic service test.
/// This is experimental and intentionally not a permanent open/close control.
pub fn experimental_exhaust_flap_service_test() -> Result<(), String> {
    let _access = crate::vehicle_access::vehicle_access().diagnostic()?;
    let cancelled = AtomicBool::new(false);
    let host = discover_vehicle(&cancelled)
        .ok_or_else(|| "No vehicle found. Check the cable and ignition.".to_string())?;
    let mut stream = fresh_diagnostic_stream(&host)?;
    validate_service_vehicle(&mut stream)?;
    enter_extended_session(&mut stream, EXHAUST_FLAP_DME)?;
    for control in [[0x19, 0x99], [0xE6, 0x66]].into_iter().cycle().take(8) {
        send_uds(
            &mut stream,
            EXHAUST_FLAP_DME,
            &build_exhaust_flap_cycle_request(control),
        )?;
        let response = read_matching_uds_response(
            &mut stream,
            EXHAUST_FLAP_DME,
            &[0x6F, 0x60, 0xFD],
            &[0x2F],
            Duration::from_secs(3),
        )?;
        parse_exhaust_flap_io_response(&response, control)?;
        thread::sleep(Duration::from_secs(1));
    }
    send_uds(
        &mut stream,
        EXHAUST_FLAP_DME,
        &build_exhaust_flap_reset_request(),
    )?;
    let response = read_matching_uds_response(
        &mut stream,
        EXHAUST_FLAP_DME,
        &[0x6F, 0x60, 0xFD, 0x00],
        &[0x2F],
        Duration::from_secs(3),
    )?;
    if response == [0x6F, 0x60, 0xFD, 0x00] {
        Ok(())
    } else {
        Err("DME did not acknowledge exhaust flap service-test reset".into())
    }
}

/// Sends one experimental exhaust-flap position command. The DME may require
/// periodic refresh messages; this one-shot API intentionally does not claim
/// to provide a persistent override.
pub fn experimental_exhaust_flap_set_position(mode: String) -> Result<(), String> {
    if !matches!(
        mode.as_str(),
        "open" | "open_legacy" | "open_periodic" | "open_bm3" | "closed" | "auto"
    ) {
        return Err("Unsupported exhaust flap mode".into());
    }
    if !crate::vehicle_access::vehicle_access().diagnostic_active() {
        return Err("No active vehicle session for flap control".into());
    }
    if LAST_VALIDATED_VEHICLE
        .get_or_init(|| Mutex::new(None))
        .lock()
        .map_err(|_| "Vehicle identity lock poisoned".to_string())?
        .is_none()
    {
        return Err("Active DME identity has not been validated".into());
    }
    validate_flap_control_vehicle()?;
    let sender = FLAP_COMMAND_SENDER
        .get_or_init(|| Mutex::new(None))
        .lock()
        .map_err(|_| "Flap command lock poisoned".to_string())?
        .clone()
        .ok_or_else(|| "No active vehicle session for flap control".to_string())?;
    if let Ok(mut active_mode) = ACTIVE_FLAP_MODE.get_or_init(|| Mutex::new(None)).lock() {
        *active_mode = (!matches!(mode.as_str(), "auto" | "open_bm3")).then_some(mode.clone());
    }
    let (reply_tx, reply_rx) = mpsc::channel();
    sender
        .send(FlapCommand::Set {
            mode,
            reply: reply_tx,
        })
        .map_err(|_| "Live vehicle session is unavailable".to_string())?;
    reply_rx
        .recv_timeout(Duration::from_secs(5))
        .map_err(|_| "Timed out waiting for the live vehicle session".to_string())?
}

fn validate_flap_control_vehicle() -> Result<(), String> {
    let binding = LAST_VALIDATED_VEHICLE
        .get_or_init(|| Mutex::new(None))
        .lock()
        .map_err(|_| "Vehicle identity lock poisoned".to_string())?;
    let Some(vehicle) = binding.as_ref() else {
        return Err("Active DME identity has not been validated".into());
    };
    // The N20 command path is enabled only for the identified bench DME. Keep
    // the existing F82/S55 support and reject other vehicles at the Rust API
    // boundary as well as in the Flutter capability gate.
    if vehicle.vin == N20_BENCH_VIN
        || vehicle.vin.starts_with("WBS3R92")
        || is_f30_n20_328i_vin(&vehicle.vin)
    {
        Ok(())
    } else {
        Err("Exhaust flap control is not enabled for this vehicle profile".into())
    }
}

fn is_f30_n20_328i_vin(vin: &str) -> bool {
    const F30_N20_328I_TYPE_KEYS: &[&str] = &[
        "3A50", "3A53", "3A57", "3A58", "3A59", "3B33", "3B37", "3B54", "3F35", "3F39", "3F55",
        "3F59", "8E54", "8E70", "8E71", "8E73", "8E74", "8E77", "8M70", "8N50",
    ];
    vin.get(3..7)
        .is_some_and(|type_key| F30_N20_328I_TYPE_KEYS.contains(&type_key))
}

#[frb(sync)]
pub fn stop_exhaust_flap_session() {
    if let Ok(mut active_mode) = ACTIVE_FLAP_MODE.get_or_init(|| Mutex::new(None)).lock() {
        *active_mode = None;
    }
    if let Some(sender) = FLAP_COMMAND_SENDER
        .get()
        .and_then(|slot| slot.lock().ok())
        .and_then(|guard| guard.clone())
    {
        let (reply_tx, _) = mpsc::channel();
        let _ = sender.send(FlapCommand::Set {
            mode: "auto".into(),
            reply: reply_tx,
        });
    }
}

fn configured_flap_control() -> Option<[u8; 8]> {
    ACTIVE_FLAP_MODE
        .get_or_init(|| Mutex::new(None))
        .lock()
        .ok()
        .and_then(|mode| match mode.as_deref() {
            Some("open" | "open_periodic") => flap_request_for_mode("open_periodic"),
            Some("open_legacy") => flap_request_for_mode("open_legacy"),
            Some("closed") => flap_request_for_mode("closed"),
            _ => None,
        })
}

fn apply_flap_command(stream: &mut TcpStream, mode: &str) -> Result<(), String> {
    if mode == "auto" {
        send_uds(
            stream,
            EXHAUST_FLAP_DME,
            &build_exhaust_flap_reset_request(),
        )?;
        return Ok(());
    }
    let request =
        flap_request_for_mode(mode).ok_or_else(|| "Unsupported exhaust flap mode".to_string())?;
    send_uds(stream, EXHAUST_FLAP_DME, &request)?;
    // Do not synchronously read here: this socket is also carrying the live
    // sensor poller, and a nested read can consume a sensor response before
    // the poll loop sees it. The shared loop owns all incoming frames.
    Ok(())
}

fn flap_request_for_mode(mode: &str) -> Option<[u8; 8]> {
    match mode {
        "open_legacy" => Some(build_exhaust_flap_cycle_request([0x14, 0x7A])),
        "open" | "open_periodic" | "open_bm3" => {
            Some(build_live_exhaust_flap_request([0x14, 0x7A]))
        }
        "closed" => Some(build_live_exhaust_flap_request([0xEB, 0x85])),
        _ => None,
    }
}

fn periodic_flap_request(mode: &str) -> Option<[u8; 8]> {
    (mode != "open_bm3")
        .then(|| flap_request_for_mode(mode))
        .flatten()
}

fn identify_engine(
    stream: &mut TcpStream,
) -> Result<
    (
        String,
        String,
        EcuFingerprintValues,
        Option<EcuFingerprintValues>,
        Option<String>,
    ),
    String,
> {
    let f150 = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "ecu_identification")
        .or_else(|_| read_data_identifier(stream, 0x10, "ecu_identification"))?;
    let identity = decode_ecu_identification(f150);
    debug_transport("ECU identity", ENGINE_ECU_ADDRESS, &identity.raw_data);
    let vin = read_ascii_data_identifier(stream, ENGINE_ECU_ADDRESS, "vehicle_vin")
        .or_else(|_| read_ascii_data_identifier(stream, 0x10, "vehicle_vin"))?;

    // The captured F101 response carries HWEL as its first versioned record;
    // the F82/S55 layout then carries bootloader, software, calibration, and
    // coding in the remaining bundle. Prefer these captured records over
    // unverified individual DIDs, and retain the legacy reads as a fallback
    // when a DME does not implement this layout.
    let mut last_flash_date = None;
    let mut values =
        match read_data_identifier(stream, ENGINE_ECU_ADDRESS, "s55_dme_identity_bundle") {
            Ok(payload) => match decode_s55_dme_identity_bundle(&payload) {
                Ok(values) => {
                    last_flash_date = decode_f101_last_flash_date(&payload);
                    values
                }
                Err(_) => read_legacy_optional_fingerprint(stream, ENGINE_ECU_ADDRESS),
            },
            Err(_) => read_legacy_optional_fingerprint(stream, ENGINE_ECU_ADDRESS),
        };
    let factory = read_factory_identity(stream);
    values.serial_number = read_optional_identifier(stream, ENGINE_ECU_ADDRESS, 0xF18C);
    values.manufacturing_date =
        read_s55_ecu_manufacturing_date(stream, ENGINE_ECU_ADDRESS).unwrap_or_default();
    values.diagnostic_session =
        read_s55_dme_diagnostic_session(stream, ENGINE_ECU_ADDRESS).unwrap_or_default();
    values.flash_counter = read_dme_flash_counter(stream, ENGINE_ECU_ADDRESS).unwrap_or_default();
    if let Ok(routine) = read_bmw_routine_0205(
        stream,
        ENGINE_ECU_ADDRESS,
        &values.calibration,
        &values.bootloader,
    ) {
        values.bmw_routine_0205_raw = routine.raw_hex;
        values.bmw_routine_0205_software = routine.software;
        values.bmw_controller_family = routine.controller_family;
        values.bmw_variant = routine.variant;
        values.bmw_transmission = routine.transmission;
        values.bmw_emissions = routine.emissions;
        values.bmw_internal_token = routine.internal_token;
    }
    Ok((
        vin,
        identity.display_value,
        values,
        factory,
        last_flash_date,
    ))
}

#[derive(Default)]
pub struct BmwRoutine0205Values {
    pub raw_hex: String,
    pub software: String,
    pub controller_family: String,
    pub variant: String,
    pub transmission: String,
    pub emissions: String,
    pub internal_token: String,
}

/// Read BMW's 0x0205 identity routine using the live calibration and
/// bootloader identifiers. Both request forms were captured during the MHD
/// N20 identification exchange; each remains optional for other software.
fn read_bmw_routine_0205(
    stream: &mut TcpStream,
    ecu: u8,
    calibration: &str,
    bootloader: &str,
) -> Result<BmwRoutine0205Values, String> {
    let calibration_result = read_bmw_routine_0205_identifier(stream, ecu, calibration, 0x08);
    let bootloader_result = read_bmw_routine_0205_identifier(stream, ecu, bootloader, 0x06);
    match (calibration_result, bootloader_result) {
        (Err(calibration_error), Err(bootloader_error)) => Err(format!(
            "BMW 0x0205 calibration and bootloader reads failed: {calibration_error}; {bootloader_error}"
        )),
        (calibration, bootloader) => Ok(merge_bmw_routine_0205_values(
            calibration.ok(),
            bootloader.ok(),
        )),
    }
}

fn read_bmw_routine_0205_identifier(
    stream: &mut TcpStream,
    ecu: u8,
    identifier: &str,
    record_type: u8,
) -> Result<BmwRoutine0205Values, String> {
    let request = build_bmw_routine_0205_request(identifier, record_type)?;
    send_uds(stream, ecu, &request)?;
    let response = read_matching_uds_response(
        stream,
        ecu,
        &[0x71, 0x01, 0x02, 0x05],
        &[0x31],
        Duration::from_secs(3),
    )?;
    decode_bmw_routine_0205(&response)
}

fn build_bmw_routine_0205_request(identifier: &str, record_type: u8) -> Result<Vec<u8>, String> {
    if !matches!(record_type, 0x06 | 0x08) {
        return Err("BMW 0x0205 identifier type is unsupported".into());
    }
    let identifier = identifier.trim();
    if identifier.len() != 17 || !identifier.is_ascii() {
        return Err("BMW identifier has an unsupported format".into());
    }
    let part_number = u32::from_str_radix(&identifier[..8], 16)
        .map_err(|_| "BMW identifier has an invalid part number".to_string())?;
    let mut request = vec![0x31, 0x01, 0x02, 0x05, record_type];
    request.extend(part_number.to_be_bytes());
    for version in [&identifier[8..11], &identifier[11..14], &identifier[14..17]] {
        request.push(
            version
                .parse::<u8>()
                .map_err(|_| "BMW identifier has an invalid version".to_string())?,
        );
    }
    Ok(request)
}

fn format_bmw_software_identifier(record: &[u8]) -> String {
    if record.len() != 7 {
        return String::new();
    }
    format!(
        "{:02X}{:02X}{:02X}{:02X}{:03}{:03}{:03}",
        record[0], record[1], record[2], record[3], record[4], record[5], record[6]
    )
}

fn merge_bmw_routine_0205_values(
    calibration: Option<BmwRoutine0205Values>,
    bootloader: Option<BmwRoutine0205Values>,
) -> BmwRoutine0205Values {
    let calibration = calibration.unwrap_or_default();
    let bootloader = bootloader.unwrap_or_default();
    let variant = match (
        calibration.variant.is_empty(),
        bootloader.variant.is_empty(),
    ) {
        (false, false) => format!(
            "Software: {}; bootloader: {}",
            calibration.variant, bootloader.variant
        ),
        (false, true) => calibration.variant.clone(),
        (true, false) => bootloader.variant.clone(),
        (true, true) => String::new(),
    };
    let raw_hex = [
        (!calibration.raw_hex.is_empty()).then(|| format!("CAL {}", calibration.raw_hex)),
        (!bootloader.raw_hex.is_empty()).then(|| format!("BTLD {}", bootloader.raw_hex)),
    ]
    .into_iter()
    .flatten()
    .collect::<Vec<_>>()
    .join(" | ");
    BmwRoutine0205Values {
        raw_hex,
        software: if calibration.software.is_empty() {
            bootloader.software
        } else {
            calibration.software
        },
        controller_family: if calibration.controller_family.is_empty() {
            bootloader.controller_family
        } else {
            calibration.controller_family
        },
        variant,
        transmission: if calibration.transmission.is_empty() {
            bootloader.transmission
        } else {
            calibration.transmission
        },
        emissions: if calibration.emissions.is_empty() {
            bootloader.emissions
        } else {
            calibration.emissions
        },
        internal_token: if calibration.internal_token.is_empty() {
            bootloader.internal_token
        } else {
            calibration.internal_token
        },
    }
}

fn decode_bmw_routine_0205(payload: &[u8]) -> Result<BmwRoutine0205Values, String> {
    if payload.len() < 5 || !payload.starts_with(&[0x71, 0x01, 0x02, 0x05]) {
        return Err("BMW 0x0205 response has an unsupported layout".into());
    }
    let ascii_runs = payload[4..]
        .split(|byte| !byte.is_ascii_alphanumeric() && !matches!(*byte, b'.' | b'-' | b'_'))
        .filter(|run| run.len() >= 3)
        .map(|run| String::from_utf8_lossy(run).into_owned())
        .collect::<Vec<_>>();
    let find_run = |prefix: &str| {
        ascii_runs
            .iter()
            .find(|value| value.starts_with(prefix))
            .cloned()
            .unwrap_or_default()
    };
    let contains_token = |token: &str| {
        ascii_runs
            .iter()
            .find(|value| value.contains(token))
            .map(|_| token.to_string())
            .unwrap_or_default()
    };
    let software = payload[4..]
        .windows(10)
        .find(|record| record[..3] == [0xFF, 0x01, 0x08])
        .map(|record| format_bmw_software_identifier(&record[3..10]))
        .filter(|value| !value.is_empty())
        .or_else(|| {
            payload[4..]
                .windows(7)
                .find(|record| record[0..4] == [0x00, 0x00, 0x1A, 0x84])
                .map(format_bmw_software_identifier)
        })
        .unwrap_or_default();
    let controller_family = ascii_runs
        .iter()
        .find(|value| value.starts_with("DME-MEVD") && value.ends_with('_'))
        .and_then(|value| value.strip_prefix("DME-"))
        .map(str::to_string)
        .or_else(|| {
            ascii_runs
                .iter()
                .find(|value| value.starts_with("MEVD"))
                .cloned()
        })
        .or_else(|| {
            ascii_runs
                .iter()
                .find(|value| value.starts_with("DME-MEVD"))
                .and_then(|value| value.strip_prefix("DME-"))
                .map(str::to_string)
        })
        .map(|value| value.trim_end_matches('_').to_string())
        .unwrap_or_default();
    let variant = ascii_runs
        .iter()
        .find(|value| {
            value.starts_with("DME-MEVD")
                && value
                    .strip_prefix("DME-")
                    .is_some_and(|family| family.trim_end_matches('_') != controller_family)
        })
        .map(|value| value.clone())
        .or_else(|| {
            ascii_runs
                .iter()
                .find(|value| {
                    value.starts_with("MEVD") && value.trim_end_matches('_') != controller_family
                })
                .cloned()
        })
        .unwrap_or_default();
    Ok(BmwRoutine0205Values {
        raw_hex: payload[4..]
            .iter()
            .map(|byte| format!("{byte:02X}"))
            .collect::<String>(),
        software,
        controller_family,
        variant,
        transmission: contains_token("DKG"),
        emissions: contains_token("EU6"),
        internal_token: find_run("6MC"),
    })
}

fn read_s55_ecu_manufacturing_date(stream: &mut TcpStream, ecu: u8) -> Result<String, String> {
    let payload = read_data_identifier(stream, ecu, "s55_ecu_manufacturing_date")?;
    decode_s55_ecu_manufacturing_date(&payload)
}

fn read_s55_dme_diagnostic_session(stream: &mut TcpStream, ecu: u8) -> Result<String, String> {
    let payload = read_data_identifier(stream, ecu, "s55_dme_diagnostic_session")?;
    decode_s55_dme_diagnostic_session(&payload)
}

fn decode_s55_dme_diagnostic_session(payload: &[u8]) -> Result<String, String> {
    if payload.len() != 2 {
        return Err("S55 F186 diagnostic-session response has an unsupported layout".into());
    }
    Ok(payload
        .iter()
        .map(|byte| format!("{byte:02X}"))
        .collect::<Vec<_>>()
        .join(" "))
}

fn decode_s55_ecu_manufacturing_date(payload: &[u8]) -> Result<String, String> {
    if payload.len() != 3 {
        return Err("S55 F18B ECU date returned an invalid length".into());
    }
    let decode_bcd = |value: u8| -> Option<u8> {
        let high = value >> 4;
        let low = value & 0x0F;
        (high <= 9 && low <= 9).then_some(high * 10 + low)
    };
    let year = decode_bcd(payload[0])
        .map(|year| 2000 + year as u16)
        .ok_or_else(|| "S55 F18B ECU date has an invalid BCD year".to_string())?;
    let month = decode_bcd(payload[1])
        .filter(|month| (1..=12).contains(month))
        .ok_or_else(|| "S55 F18B ECU date has an invalid BCD month".to_string())?;
    let day = decode_bcd(payload[2])
        .filter(|day| (1..=31).contains(day))
        .ok_or_else(|| "S55 F18B ECU date has an invalid BCD day".to_string())?;
    Ok(format!("{day:02}/{month:02}/{year:04}"))
}

fn decode_s55_dme_identity_bundle(payload: &[u8]) -> Result<EcuFingerprintValues, String> {
    const RECORD_SIZE: usize = 7;
    const FIRST_RECORD_OFFSET: usize = 26;
    const SUBSEQUENT_RECORD_STRIDE: usize = RECORD_SIZE + 1;
    const RECORD_OFFSETS: [usize; 4] = [
        FIRST_RECORD_OFFSET,
        FIRST_RECORD_OFFSET + RECORD_SIZE + 1,
        FIRST_RECORD_OFFSET + RECORD_SIZE + 1 + SUBSEQUENT_RECORD_STRIDE,
        FIRST_RECORD_OFFSET + RECORD_SIZE + 1 + SUBSEQUENT_RECORD_STRIDE * 2,
    ];

    // After HWEL at offset 18, the S55 F101 layout has a DME-specific prefix
    // through offset 25. Its bootloader record is seven bytes; each following
    // record has a one-byte marker before its seven-byte ID/version value.
    // Reject another layout and use the legacy read-only fallback rather than
    // assigning incorrect identifiers.
    if payload.len() < RECORD_OFFSETS[3] + RECORD_SIZE {
        return Err("S55 F101 identity response has an unsupported layout".into());
    }
    let format_record = |record: &[u8]| {
        let id = u32::from_be_bytes(record[0..4].try_into().expect("record ID length"));
        format!("{id:08X}{:03}{:03}{:03}", record[4], record[5], record[6])
    };

    Ok(EcuFingerprintValues {
        hardware: decode_mhd_hwel_from_f101(payload).unwrap_or_default(),
        bootloader: format_record(&payload[RECORD_OFFSETS[0]..RECORD_OFFSETS[0] + RECORD_SIZE]),
        software: format_record(&payload[RECORD_OFFSETS[1]..RECORD_OFFSETS[1] + RECORD_SIZE]),
        calibration: format_record(&payload[RECORD_OFFSETS[2]..RECORD_OFFSETS[2] + RECORD_SIZE]),
        coding_id: format_record(&payload[RECORD_OFFSETS[3]..RECORD_OFFSETS[3] + RECORD_SIZE]),
        ..Default::default()
    })
}

fn decode_mhd_hwel_from_f101(payload: &[u8]) -> Option<String> {
    // MHD reads the HWEL as the first seven-byte versioned record in the
    // captured F101 family. Later records are separated by marker bytes and
    // include BTLD/SWFL/CAFD; using the second record would mislabel BTLD or
    // software as hardware. Require the observed response prefix and HWEL
    // record marker before interpreting this fixed position.
    const HWEL_OFFSET: usize = 18;
    const RECORD_SIZE: usize = 7;
    if payload.len() <= HWEL_OFFSET + RECORD_SIZE
        || payload.get(..3) != Some(&[0x01, 0x01, 0x00])
        || payload.get(HWEL_OFFSET + RECORD_SIZE) != Some(&0x06)
    {
        return None;
    }
    let record = &payload[HWEL_OFFSET..HWEL_OFFSET + RECORD_SIZE];
    let id = u32::from_be_bytes(record[..4].try_into().ok()?);
    if id == 0 || record[4..].iter().all(|byte| *byte == 0) {
        return None;
    }
    Some(format!(
        "{id:08X}{:03}{:03}{:03}",
        record[4], record[5], record[6]
    ))
}

fn decode_dme_flash_counter(payload: &[u8]) -> Option<u32> {
    let bytes: [u8; 4] = payload.try_into().ok()?;
    Some(u32::from_be_bytes(bytes))
}

fn read_dme_flash_counter(stream: &mut TcpStream, ecu: u8) -> Option<String> {
    let raw = read_optional_identifier_hex(stream, ecu, 0x2502);
    if raw.len() != 8 {
        return None;
    }
    let bytes = (0..raw.len())
        .step_by(2)
        .map(|index| u8::from_str_radix(&raw[index..index + 2], 16).ok())
        .collect::<Option<Vec<_>>>()?;
    decode_dme_flash_counter(&bytes).map(|counter| counter.to_string())
}

fn read_legacy_optional_fingerprint(stream: &mut TcpStream, ecu: u8) -> EcuFingerprintValues {
    // A negative response or timeout is represented as an empty field and does
    // not prevent VIN identification or live telemetry.
    EcuFingerprintValues {
        hardware: read_optional_identifier(stream, ecu, 0xF191),
        software: read_optional_identifier(stream, ecu, 0xF188),
        bootloader: read_optional_identifier(stream, ecu, 0xF180),
        calibration: read_optional_identifier(stream, ecu, 0xF182),
        application_software: read_optional_identifier(stream, ecu, 0xF181),
        software_version: read_optional_identifier(stream, ecu, 0xF189),
        supplier_hardware: read_optional_identifier(stream, ecu, 0xF192),
        supplier_software: read_optional_identifier(stream, ecu, 0xF194),
        bootloader_fingerprint: read_optional_identifier_hex(stream, ecu, 0xF183),
        software_fingerprint: read_optional_identifier_hex(stream, ecu, 0xF184),
        calibration_fingerprint: read_optional_identifier_hex(stream, ecu, 0xF185),
        ..Default::default()
    }
}

fn read_optional_identifier(stream: &mut TcpStream, ecu: u8, did: u16) -> String {
    let request = [0x22, (did >> 8) as u8, did as u8];
    if send_uds(stream, ecu, &request).is_err() {
        return String::new();
    }
    let expected = [0x62, (did >> 8) as u8, did as u8];
    let response = match read_matching_uds_response(
        stream,
        ecu,
        &expected,
        &[0x22],
        Duration::from_millis(700),
    ) {
        Ok(response) => response,
        Err(_) => return String::new(),
    };
    String::from_utf8_lossy(&response[expected.len()..])
        .trim()
        .to_string()
}

fn read_optional_identifier_hex(stream: &mut TcpStream, ecu: u8, did: u16) -> String {
    let request = [0x22, (did >> 8) as u8, did as u8];
    if send_uds(stream, ecu, &request).is_err() {
        return String::new();
    }
    let expected = [0x62, (did >> 8) as u8, did as u8];
    let response = match read_matching_uds_response(
        stream,
        ecu,
        &expected,
        &[0x22],
        Duration::from_millis(700),
    ) {
        Ok(response) => response,
        Err(_) => return String::new(),
    };
    response[expected.len()..]
        .iter()
        .map(|byte| format!("{byte:02X}"))
        .collect::<String>()
}

fn stable_dme_identity(
    fingerprint: &EcuFingerprintValues,
    raw_identity: &str,
) -> Result<String, String> {
    // F150 is not consistently printable on the target F82/S55 DME. Prefer
    // its versioned fingerprint, which is designed to identify the software
    // running in the DME and remains stable across ENET reconnects.
    if !fingerprint.software.is_empty()
        && !fingerprint.bootloader.is_empty()
        && !fingerprint.calibration.is_empty()
    {
        return Ok(format!(
            "SW={} / BL={} / CAL={}",
            fingerprint.software, fingerprint.bootloader, fingerprint.calibration
        ));
    }

    // Retain compatibility with older ECUs only when F150 is genuinely
    // readable text. Never bind the safety check to lossy/control characters.
    let printable = raw_identity.trim();
    if printable.chars().count() >= 4
        && printable
            .chars()
            .all(|character| character.is_ascii_graphic() || character == ' ')
    {
        return Ok(printable.to_string());
    }

    Err("Refusing service operation: stable DME fingerprint is unavailable".into())
}

fn validate_vehicle_identity(vin: String, dme_identity: String) -> Result<(), String> {
    if vin.len() != 17 || !vin.chars().all(|c| c.is_ascii_alphanumeric()) {
        return Err("Refusing service operation: ECU VIN identity is invalid".into());
    }
    if dme_identity.trim().is_empty() {
        return Err("Refusing service operation: DME identity is unavailable".into());
    }
    let candidate = ValidatedVehicleIdentity { vin, dme_identity };
    let mut binding = LAST_VALIDATED_VEHICLE
        .get_or_init(|| Mutex::new(None))
        .lock()
        .map_err(|_| "Vehicle identity lock poisoned")?;
    if let Some(expected) = binding.as_ref() {
        if expected != &candidate {
            return Err(format!(
                "Refusing service operation: active vehicle changed (expected VIN {} / DME {}, found VIN {} / DME {})",
                expected.vin, expected.dme_identity, candidate.vin, candidate.dme_identity
            ));
        }
    } else {
        *binding = Some(candidate);
    }
    Ok(())
}

fn validate_service_vehicle(stream: &mut TcpStream) -> Result<String, String> {
    let (vin, raw_identity, fingerprint, _, _) = identify_engine(stream)?;
    validate_vehicle_identity(
        vin.clone(),
        stable_dme_identity(&fingerprint, &raw_identity)?,
    )?;
    Ok(vin)
}

fn read_ascii_data_identifier(
    stream: &mut TcpStream,
    ecu: u8,
    definition_id: &str,
) -> Result<String, String> {
    let value = read_data_identifier(stream, ecu, definition_id)?;
    Ok(String::from_utf8_lossy(&value).trim().to_string())
}

fn read_data_identifier(
    stream: &mut TcpStream,
    ecu: u8,
    definition_id: &str,
) -> Result<Vec<u8>, String> {
    let definition = data_identifier_definition(definition_id);
    let did = definition.did.to_be_bytes();
    send_uds(stream, ecu, &[0x22, did[0], did[1]])?;
    let expected = [definition.response_sid, did[0], did[1]];
    let response =
        read_matching_uds_response(stream, ecu, &expected, &[0x22], Duration::from_secs(2))?;
    let value = &response[expected.len()..];
    if definition
        .exact_length
        .is_some_and(|length| value.len() != length as usize)
    {
        return Err(format!("{} returned an invalid length", definition.name));
    }
    Ok(value.to_vec())
}

fn read_vehicle_dme_voltage(stream: &mut TcpStream) -> Result<u16, String> {
    let value = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "vehicle_dme_battery_voltage")?;
    let raw = u16::from_be_bytes([value[0], value[1]]);
    let voltage = f64::from(raw) * 0.00025 + 6.0;
    if !(6.0..=22.0).contains(&voltage) {
        return Err(format!("DME voltage out of range: {voltage:.2} V"));
    }
    Ok(raw)
}

fn enter_extended_session(stream: &mut TcpStream, ecu: u8) -> Result<(), String> {
    enter_extended_session_with_timeout(stream, ecu, Duration::from_secs(3))
}

fn enter_extended_session_with_timeout(
    stream: &mut TcpStream,
    ecu: u8,
    timeout: Duration,
) -> Result<(), String> {
    send_uds(stream, ecu, &[0x10, 0x03])?;
    // The live adapter session can interleave unrelated UDS responses on the
    // same ENET path (for example 6C 03 F3 00). Keep the TCP buffer alive while
    // draining all frames, so a matching 50 03 that follows an unrelated frame
    // in the same read is not discarded.
    let response = read_matching_uds_response(stream, ecu, &[0x50, 0x03], &[0x10], timeout)?;
    debug_transport("RX", ecu, &response);
    Ok(())
}

fn read_matching_uds_response(
    stream: &mut TcpStream,
    source: u8,
    expected: &[u8],
    request_services: &[u8],
    timeout: Duration,
) -> Result<Vec<u8>, String> {
    let deadline = Instant::now() + timeout;
    let mut buffer = Vec::with_capacity(4096);
    let mut scratch = [0u8; 4096];
    while Instant::now() < deadline {
        match stream.read(&mut scratch) {
            Ok(0) => return Err("Vehicle closed the diagnostic connection".into()),
            Ok(count) => buffer.extend_from_slice(&scratch[..count]),
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {
                continue
            }
            Err(error) => return Err(error.to_string()),
        }
        for frame in drain_hsfz(&mut buffer)? {
            if !is_application_response(&frame) || frame.source != source {
                transport_diagnostic(
                    TransportDiagnosticsLevel::Detailed,
                    json!({
                        "type": "response_ignored",
                        "reason": "diagnostic_route_mismatch",
                        "expectedSource": format!("{source:02X}"),
                        "expectedDestination": format!("{TESTER:02X}"),
                        "actualMessageType": format!("{:04X}", frame.message_type),
                        "actualSource": format!("{:02X}", frame.source),
                        "actualDestination": format!("{:02X}", frame.destination),
                    }),
                );
                continue;
            }
            if frame.uds.starts_with(expected) {
                return Ok(frame.uds);
            }
            if frame.uds.starts_with(&[0x7F])
                && frame
                    .uds
                    .get(1)
                    .is_some_and(|service| request_services.contains(service))
                && frame.uds.get(2) != Some(&0x78)
            {
                return Err(format!(
                    "ECU rejected request (NRC 0x{:02X})",
                    frame.uds.get(2).copied().unwrap_or_default()
                ));
            }
            transport_diagnostic(
                TransportDiagnosticsLevel::Detailed,
                json!({
                    "type": "response_ignored",
                    "reason": "diagnostic_payload_mismatch",
                    "expectedPrefix": hex_payload(expected),
                    "actualService": frame.uds.first().map(|value| format!("{value:02X}")),
                    "actualIdentifier": transport_identifier(&frame.uds).map(|value| format!("{value:04X}")),
                    "actualPayloadLength": frame.uds.len(),
                }),
            );
        }
    }
    Err("ECU response timeout".into())
}

#[frb(sync)]
pub fn demo_diagnostics() -> Vec<DiagnosticTroubleCode> {
    vec![
        diagnostic_code(0x123456, 0x2C, "Engine control unit"),
        diagnostic_code(0x1A2002, 0x08, "Engine control unit"),
    ]
}

fn parse_dtc_response(uds: &[u8]) -> Result<Vec<DiagnosticTroubleCode>, String> {
    parse_dtc_response_for_ecu(uds, "Engine control unit")
}

fn parse_dtc_response_for_ecu(
    uds: &[u8],
    ecu_name: &str,
) -> Result<Vec<DiagnosticTroubleCode>, String> {
    let definition = default_dtc_response_definition();
    if uds.len() < 3 || uds[0] != definition.response_sid || uds[1] != definition.subfunction {
        return Err("Malformed DTC response".into());
    }
    let records = &uds[3..];
    if records.len() % definition.record_length as usize != 0 {
        return Err("Unexpected DTC response length".into());
    }
    Ok(records
        .chunks_exact(definition.record_length as usize)
        .map(|record| {
            let raw = record[..definition.code_length as usize]
                .iter()
                .fold(0u32, |value, byte| (value << 8) | *byte as u32);
            diagnostic_code(raw, record[3], ecu_name)
        })
        .collect())
}

fn diagnostic_code(raw_code: u32, status: u8, ecu: &str) -> DiagnosticTroubleCode {
    let states = default_dtc_status_definitions()
        .into_iter()
        .filter(|definition| status & definition.mask != 0)
        .map(|definition| definition.label)
        .collect::<Vec<_>>();
    DiagnosticTroubleCode {
        code: format!("{raw_code:06X}"),
        raw_code,
        status,
        status_text: if states.is_empty() {
            "Stored".into()
        } else {
            states.join(" · ")
        },
        ecu: ecu.into(),
    }
}

fn begin_session<F>(runner: F) -> Result<(), String>
where
    F: FnOnce(Arc<AtomicBool>) + Send + 'static,
{
    stop_session();
    // Identity binding protects reconnects within one user-started session.
    // A new session may intentionally connect to another vehicle (for example
    // switching between the F82 and the N20 bench), so discard the old binding.
    clear_validated_vehicle_identity();
    // A new connection identifies the vehicle first. Live traffic starts only
    // after the user explicitly starts monitoring.
    stop_monitoring();
    let stop = Arc::new(AtomicBool::new(false));
    *session_slot().lock().map_err(|_| "Session lock poisoned")? = Some(stop.clone());
    thread::Builder::new()
        .name("bmw-enet-session".into())
        .spawn(move || runner(stop))
        .map(|_| ())
        .map_err(|error| error.to_string())
}

fn session_slot() -> &'static Mutex<Option<Arc<AtomicBool>>> {
    ACTIVE_SESSION.get_or_init(|| Mutex::new(None))
}

fn discover_vehicle(stop: &AtomicBool) -> Option<String> {
    // Use the ZGW's standard UDP discovery before falling back to bounded
    // address probing. Candidates are still validated with TCP/HSFZ below.
    if let Some(host) = discover_zgw_udp(stop) {
        return Some(host);
    }

    const QUICK_CANDIDATES: [&str; 1] = [
        // Confirmed ISTA gateway address for the user's ENET setup.
        "169.254.12.64",
    ];
    for host in QUICK_CANDIDATES {
        if stop.load(Ordering::Acquire) {
            return None;
        }
        if probe_enet(host, Duration::from_millis(180)) {
            return Some(host.to_string());
        }
    }

    // Ethernet-only discovery: restrict automatic subnet probing to the
    // link-local range used by direct BMW ENET connections. Wi-Fi adapter
    // networks are intentionally deferred until a later transport milestone.
    let mut local_subnets = discovery_subnets();
    // Keep distinct interface addresses; Windows may need to route probes
    // through its ENET adapter even when other link-local adapters exist.
    local_subnets.sort_unstable();
    local_subnets.dedup();
    if local_subnets.is_empty() {
        return None;
    }
    let (sender, receiver) = mpsc::channel();
    let found = AtomicBool::new(false);
    let mut discovered = None;
    thread::scope(|scope| {
        for worker in 0..64u32 {
            let sender = sender.clone();
            let subnets = local_subnets.clone();
            let found = &found;
            scope.spawn(move || {
                for (network, mask, local_ip) in subnets {
                    let broadcast = network | !mask;
                    for value in (network + worker + 1..broadcast).step_by(64) {
                        if stop.load(Ordering::Acquire) || found.load(Ordering::Acquire) {
                            return;
                        }
                        if value == local_ip {
                            continue;
                        }
                        let host = IpAddr::V4(value.into()).to_string();
                        if probe_enet(&host, Duration::from_millis(150)) {
                            let _ = sender.send(host);
                            found.store(true, Ordering::Release);
                            return;
                        }
                    }
                }
            });
        }
        drop(sender);
        while !stop.load(Ordering::Acquire) {
            match receiver.recv_timeout(Duration::from_millis(50)) {
                Ok(host) => {
                    discovered = Some(host);
                    found.store(true, Ordering::Release);
                    break;
                }
                Err(mpsc::RecvTimeoutError::Timeout) => continue,
                Err(mpsc::RecvTimeoutError::Disconnected) => break,
            }
        }
    });
    discovered
}

fn discovery_subnets() -> Vec<(u32, u32, u32)> {
    #[cfg(windows)]
    {
        return windows_link_local_subnets();
    }

    #[cfg(not(windows))]
    {
        get_if_addrs()
            .ok()
            .into_iter()
            .flatten()
            .filter_map(|interface| match interface.addr {
                IfAddr::V4(address) if address.ip.is_link_local() => {
                    let mask = u32::from(address.netmask);
                    (mask.count_ones() >= 16).then_some((
                        u32::from(address.ip) & mask,
                        mask,
                        u32::from(address.ip),
                    ))
                }
                _ => None,
            })
            .collect()
    }
}

#[cfg(windows)]
fn windows_link_local_subnets() -> Vec<(u32, u32, u32)> {
    use std::mem::size_of;
    use std::net::Ipv4Addr;
    use std::ptr::{null, null_mut};
    use windows_sys::Win32::Foundation::{ERROR_BUFFER_OVERFLOW, ERROR_SUCCESS};
    use windows_sys::Win32::NetworkManagement::IpHelper::{
        GetAdaptersAddresses, IP_ADAPTER_ADDRESSES_LH, GAA_FLAG_INCLUDE_PREFIX,
        GAA_FLAG_SKIP_ANYCAST, GAA_FLAG_SKIP_DNS_SERVER, GAA_FLAG_SKIP_MULTICAST,
    };
    use windows_sys::Win32::Networking::WinSock::{
        AF_INET, IpDadStatePreferred, SOCKADDR_IN,
    };

    let flags = GAA_FLAG_SKIP_ANYCAST
        | GAA_FLAG_SKIP_MULTICAST
        | GAA_FLAG_SKIP_DNS_SERVER
        | GAA_FLAG_INCLUDE_PREFIX;
    let mut required_size = 0u32;
    // SAFETY: The initial call supplies a null buffer as required to retrieve
    // the allocation size. No pointers are retained by Windows.
    let status = unsafe {
        GetAdaptersAddresses(
            AF_INET as u32,
            flags,
            null(),
            null_mut(),
            &mut required_size,
        )
    };
    if status != ERROR_BUFFER_OVERFLOW || required_size == 0 {
        return Vec::new();
    }

    let mut storage = vec![0u64; (required_size as usize).div_ceil(size_of::<u64>())];
    loop {
        let mut buffer_size = (storage.len() * size_of::<u64>()) as u32;
        // SAFETY: `storage` is aligned, sized using the API's required-size
        // result, and remains alive while the linked adapter records are read.
        let status = unsafe {
            GetAdaptersAddresses(
                AF_INET as u32,
                flags,
                null(),
                storage.as_mut_ptr().cast(),
                &mut buffer_size,
            )
        };
        if status == ERROR_BUFFER_OVERFLOW {
            storage.resize((buffer_size as usize).div_ceil(size_of::<u64>()), 0);
            continue;
        }
        if status != ERROR_SUCCESS {
            return Vec::new();
        }
        break;
    }

    let mut subnets = Vec::new();
    let mut adapter = storage.as_mut_ptr().cast::<IP_ADAPTER_ADDRESSES_LH>();
    // SAFETY: The API returned a valid linked list inside `storage`; each
    // pointer is checked before it is dereferenced.
    unsafe {
        while !adapter.is_null() {
            let mut unicast = (*adapter).FirstUnicastAddress;
            while !unicast.is_null() {
                let address = &*unicast;
                if address.DadState == IpDadStatePreferred && address.OnLinkPrefixLength >= 16 {
                    let socket_address = address.Address.lpSockaddr.cast::<SOCKADDR_IN>();
                    if !socket_address.is_null() && (*socket_address).sin_family == AF_INET {
                        let ip = Ipv4Addr::from(
                            (*socket_address).sin_addr.S_un.S_addr.to_ne_bytes(),
                        );
                        let prefix = address.OnLinkPrefixLength;
                        if ip.is_link_local() && prefix <= 30 {
                            let mask = u32::MAX << (32 - u32::from(prefix));
                            let ip_value = u32::from(ip);
                            subnets.push((ip_value & mask, mask, ip_value));
                        }
                    }
                }
                unicast = (*unicast).Next;
            }
            adapter = (*adapter).Next;
        }
    }
    subnets.sort_unstable();
    subnets.dedup();
    subnets
}

fn is_private_ipv4(ip: std::net::Ipv4Addr) -> bool {
    let octets = ip.octets();
    octets[0] == 10
        || (octets[0] == 172 && (16..=31).contains(&octets[1]))
        || (octets[0] == 192 && octets[1] == 168)
}

fn local_interface_summary() -> String {
    let mut addresses = get_if_addrs()
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|interface| match interface.addr {
            IfAddr::V4(address) if !address.ip.is_loopback() => Some(format!(
                "{}{}",
                address.ip,
                if address.ip.is_link_local() {
                    " (link-local)"
                } else {
                    ""
                }
            )),
            _ => None,
        })
        .collect::<Vec<_>>();
    addresses.sort();
    addresses.dedup();
    if addresses.is_empty() {
        "no IPv4 interface".into()
    } else {
        addresses.join(", ")
    }
}

fn discover_zgw_udp(stop: &AtomicBool) -> Option<String> {
    const DISCOVERY_PORT: u16 = 6811;
    const HELLO: [u8; 6] = [0, 0, 0, 0, 0, 0x11];
    // On Windows, if-addrs can omit the direct ENET adapter while it is
    // configured with a 169.254/16 address. Use the same native adapter
    // enumeration as the TCP fallback so the ZGW broadcast reaches Ethernet.
    let broadcasts = discovery_subnets()
        .into_iter()
        .map(|(network, mask, _)| IpAddr::V4((network | !mask).into()))
        .collect::<Vec<_>>();
    if broadcasts.is_empty() {
        return None;
    }
    let socket = UdpSocket::bind("0.0.0.0:0").ok()?;
    socket.set_broadcast(true).ok()?;
    socket
        .set_read_timeout(Some(Duration::from_millis(150)))
        .ok()?;
    for broadcast in broadcasts {
        if stop.load(Ordering::Acquire) {
            return None;
        }
        let _ = socket.send_to(&HELLO, (broadcast, DISCOVERY_PORT));
    }
    let deadline = Instant::now() + Duration::from_secs(2);
    let mut buffer = [0u8; 512];
    while Instant::now() < deadline && !stop.load(Ordering::Acquire) {
        match socket.recv_from(&mut buffer) {
            Ok((length, remote)) => {
                let reply = String::from_utf8_lossy(&buffer[..length]);
                if parse_zgw_vin(&reply).is_some() {
                    let host = remote.ip().to_string();
                    if probe_enet(&host, Duration::from_millis(350)) {
                        return Some(host);
                    }
                }
            }
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {
                continue
            }
            Err(_) => return None,
        }
    }
    None
}

fn parse_zgw_vin(reply: &str) -> Option<String> {
    let start = reply.find("BMWVIN")? + "BMWVIN".len();
    let value = reply[start..].trim_matches(|c: char| c.is_whitespace() || c == ':' || c == '=');
    let vin = value
        .split_whitespace()
        .next()?
        .trim_matches(|c: char| !c.is_ascii_alphanumeric());
    (vin.len() == 17 && vin.chars().all(|c| c.is_ascii_alphanumeric())).then(|| vin.to_string())
}

fn probe_enet(host: &str, timeout: Duration) -> bool {
    format!("{host}:6801")
        .parse()
        .ok()
        .and_then(|address| TcpStream::connect_timeout(&address, timeout).ok())
        .map(|mut stream| {
            let _ = stream.set_read_timeout(Some(timeout));
            // The bootmod3 F82 capture confirms an F101 response from the DME.
            // Some supported DME software does not expose the generic F150
            // identifier consistently, so do not reject a live gateway for it.
            let _ = stream.write_all(&build_hsfz(TESTER, ENGINE_ECU_ADDRESS, &[0x22, 0xF1, 0x01]));
            let deadline = Instant::now() + timeout.max(Duration::from_secs(2));
            let mut buffer = Vec::with_capacity(256);
            let mut scratch = [0u8; 128];
            while Instant::now() < deadline {
                match stream.read(&mut scratch) {
                    Ok(0) => return false,
                    Ok(count) => buffer.extend_from_slice(&scratch[..count]),
                    Err(error)
                        if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) =>
                    {
                        continue
                    }
                    Err(_) => return false,
                }
                match drain_hsfz(&mut buffer) {
                    Ok(frames) if frames.iter().any(is_engine_probe_reply) => return true,
                    Ok(_) => continue, // transport ACKs are not validation responses
                    Err(_) => return false,
                }
            }
            false
        })
        .unwrap_or(false)
}

fn decode_dme_factory_identity_bundle(payload: &[u8]) -> Result<EcuFingerprintValues, String> {
    if payload.len() != 49 || payload[25] != 0x06 || payload[33] != 0x08 || payload[41] != 0x08 {
        return Err("F103 factory identity response has an unsupported layout".into());
    }
    let format_record = |record: &[u8]| {
        let id = u32::from_be_bytes(record[0..4].try_into().expect("record ID length"));
        format!("{id:08X}{:03}{:03}{:03}", record[4], record[5], record[6])
    };
    Ok(EcuFingerprintValues {
        hardware: format_record(&payload[18..25]),
        bootloader: format_record(&payload[26..33]),
        software: format_record(&payload[34..41]),
        calibration: format_record(&payload[42..49]),
        ..Default::default()
    })
}

fn decode_dme_supplier_identity_bundle(payload: &[u8]) -> Result<EcuFingerprintValues, String> {
    if payload.len() != 49
        || payload.get(..4) != Some(&[0x01, 0x01, 0x00, 0x04])
        || payload[25] != 0x06
        || payload[33] != 0x08
        || payload[41] != 0x08
    {
        return Err("F102 supplier identity response has an unsupported layout".into());
    }
    let format_record = |record: &[u8]| {
        let id = u32::from_be_bytes(record[0..4].try_into().expect("record ID length"));
        format!("{id:08X}{:03}{:03}{:03}", record[4], record[5], record[6])
    };
    Ok(EcuFingerprintValues {
        hardware: format_record(&payload[18..25]),
        bootloader: format_record(&payload[26..33]),
        software: format_record(&payload[34..41]),
        calibration: format_record(&payload[42..49]),
        ..Default::default()
    })
}

fn read_supplier_identity(stream: &mut TcpStream) -> Option<EcuFingerprintValues> {
    let result = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "dme_supplier_identity_bundle")
        .and_then(|payload| decode_dme_supplier_identity_bundle(&payload));
    match result {
        Ok(values) => Some(values),
        Err(error) => {
            transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({"type": "supplier_identity_read_failed", "did": "F102", "error": error}),
            );
            None
        }
    }
}

fn read_factory_identity(stream: &mut TcpStream) -> Option<EcuFingerprintValues> {
    let result = read_data_identifier(stream, ENGINE_ECU_ADDRESS, "dme_factory_identity_bundle")
        .and_then(|payload| decode_dme_factory_identity_bundle(&payload));
    match result {
        Ok(values) => Some(values),
        Err(error) => {
            transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({"type": "factory_identity_read_failed", "did": "F103", "error": error}),
            );
            None
        }
    }
}

fn decode_f101_last_flash_date(payload: &[u8]) -> Option<String> {
    // MHD labels bytes 4..7 of this captured F101 layout as the last flash
    // date. Keep the extraction tied to the observed bundle structure.
    if payload.len() < 57
        || payload.get(..4) != Some(&[0x01, 0x01, 0x00, 0x05])
        || payload.get(25) != Some(&0x06)
    {
        return None;
    }
    let bcd = |value: u8| -> Option<u8> {
        let high = value >> 4;
        let low = value & 0x0F;
        (high <= 9 && low <= 9).then_some(high * 10 + low)
    };
    let year = 2000 + u16::from(bcd(payload[4])?);
    let month = bcd(payload[5])?;
    let day = bcd(payload[6])?;
    if !(1..=12).contains(&month) || !(1..=31).contains(&day) {
        return None;
    }
    Some(format!("{year:04}.{month:02}.{day:02}"))
}

fn is_engine_probe_reply(frame: &HsfzFrame) -> bool {
    frame.message_type == 0x0001
        && frame.source == ENGINE_ECU_ADDRESS
        && frame.destination == TESTER
        && (frame.uds.starts_with(&[0x62, 0xF1, 0x01])
            || frame.uds.starts_with(&[0x62, 0xF1, 0x50]))
}

fn run_vehicle_session(
    mut host: String,
    port: u16,
    sink: StreamSink<VehicleEvent>,
    stop: Arc<AtomicBool>,
) {
    transport_diagnostic(
        TransportDiagnosticsLevel::Normal,
        json!({"type": "session_worker_started", "host": host, "port": port}),
    );
    let mut first_attempt = true;
    let mut recovery_attempts = 0u8;
    let mut reconnect_delay = Duration::from_millis(350);
    let (flap_sender, flap_receiver) = mpsc::channel();
    if let Ok(mut slot) = FLAP_COMMAND_SENDER.get_or_init(|| Mutex::new(None)).lock() {
        *slot = Some(flap_sender);
    }
    while !stop.load(Ordering::Acquire) {
        let phase = if first_attempt {
            "connecting"
        } else {
            "reconnecting"
        };
        transport_diagnostic(
            TransportDiagnosticsLevel::Normal,
            json!({
                "type": "socket_connect_attempt",
                "host": host,
                "port": port,
                "phase": phase,
                "retry": recovery_attempts,
            }),
        );
        if sink
            .add(VehicleEvent::status(phase, format!("{host}:{port}")))
            .is_err()
        {
            return;
        }
        first_attempt = false;
        let address = match format!("{host}:{port}")
            .to_socket_addrs()
            .ok()
            .and_then(|mut addresses| addresses.next())
        {
            Some(address) => address,
            None => {
                let _ = sink.add(VehicleEvent::status(
                    "disconnected",
                    "Invalid vehicle address",
                ));
                return;
            }
        };
        match TcpStream::connect_timeout(&address, Duration::from_secs(5)) {
            Ok(mut stream) => {
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({"type": "socket_connected", "peer": address.to_string()}),
                );
                let _ = stream.set_nodelay(true);
                let _ = stream.set_read_timeout(Some(Duration::from_millis(100)));
                let _ = stream.set_write_timeout(Some(Duration::from_secs(1)));
                let _ = sink.add(VehicleEvent::status(
                    "identifying",
                    "Reading vehicle and ECU identities",
                ));
                let session_result =
                    poll_connection(&mut stream, &sink, &stop, &flap_receiver, recovery_attempts);
                let _ = stream.shutdown(Shutdown::Both);
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({
                        "type": "socket_closed",
                        "reason": session_result.as_ref().err(),
                    }),
                );
                match session_result {
                    Ok(()) => {
                        reconnect_delay = Duration::from_millis(350);
                        recovery_attempts = 0;
                    }
                    Err(error) => {
                        // A live ENET socket can be interrupted by a gateway
                        // reset, transient link loss, or a delayed ECU
                        // response. Keep the user session alive and let the
                        // outer loop establish a fresh socket. Emitting
                        // `reconnecting` also preserves the vehicle identity
                        // in the UI while recovery is in progress.
                        if is_terminal_transport_error(&error)
                            && !is_transient_network_configuration_error(&error)
                        {
                            clear_flap_command_sender();
                            let _ = sink.add(VehicleEvent::status(
                                "disconnected",
                                format!("Vehicle network unavailable: {error}"),
                            ));
                            return;
                        }
                        recovery_attempts += 1;
                        let maximum_attempts = recovery_attempt_limit(&error);
                        transport_diagnostic(
                            TransportDiagnosticsLevel::Normal,
                            json!({
                                "type": "transport_retry",
                                "reason": error,
                                "attempt": recovery_attempts,
                                "maximumAttempts": maximum_attempts,
                            }),
                        );
                        if recovery_attempts >= maximum_attempts {
                            clear_flap_command_sender();
                            let _ = sink.add(VehicleEvent::status(
                                "disconnected",
                                format!(
                                    "Vehicle session did not recover after {recovery_attempts} attempts: {error}"
                                ),
                            ));
                            return;
                        }
                        let _ = sink.add(VehicleEvent::status(
                            "reconnecting",
                            format!(
                                "{error}; retrying vehicle session ({recovery_attempts}/{maximum_attempts})"
                            ),
                        ));
                        if is_transient_network_configuration_error(&error) {
                            refresh_vehicle_host_after_route_loss(&mut host, &stop);
                        }
                    }
                }
            }
            Err(error) => {
                let error = error.to_string();
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({
                        "type": "socket_connect_error",
                        "peer": address.to_string(),
                        "error": error,
                    }),
                );
                // Android's Ethernet route can disappear briefly while the
                // adapter renegotiates. Treat that narrow condition like a
                // peer reset and use the existing bounded backoff rather than
                // ending an otherwise healthy session immediately.
                if is_terminal_transport_error(&error)
                    && !is_transient_network_configuration_error(&error)
                {
                    clear_flap_command_sender();
                    let _ = sink.add(VehicleEvent::status(
                        "disconnected",
                        format!("Vehicle network unavailable: {error}"),
                    ));
                    return;
                }
                recovery_attempts += 1;
                let maximum_attempts = recovery_attempt_limit(&error);
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({
                        "type": "transport_retry",
                        "reason": error,
                        "attempt": recovery_attempts,
                        "maximumAttempts": maximum_attempts,
                    }),
                );
                if recovery_attempts >= maximum_attempts {
                    clear_flap_command_sender();
                    let _ = sink.add(VehicleEvent::status(
                        "disconnected",
                        format!(
                        "Vehicle network did not recover after {recovery_attempts} attempts: {error}"
                        ),
                    ));
                    return;
                }
                let _ = sink.add(VehicleEvent::status(
                    "reconnecting",
                    format!(
                        "{error}; waiting for the vehicle network ({recovery_attempts}/{maximum_attempts})"
                    ),
                ));
                if is_transient_network_configuration_error(&error) {
                    refresh_vehicle_host_after_route_loss(&mut host, &stop);
                }
            }
        }
        if !stop.load(Ordering::Acquire) {
            thread::sleep(reconnect_delay);
            reconnect_delay = (reconnect_delay * 2).min(Duration::from_secs(3));
        }
    }
    clear_flap_command_sender();
    transport_diagnostic(
        TransportDiagnosticsLevel::Normal,
        json!({"type": "session_worker_stopped"}),
    );
    let _ = sink.add(VehicleEvent::status("disconnected", "Session stopped"));
}

fn clear_flap_command_sender() {
    if let Ok(mut slot) = FLAP_COMMAND_SENDER.get_or_init(|| Mutex::new(None)).lock() {
        *slot = None;
    }
}

fn refresh_vehicle_host_after_route_loss(host: &mut String, stop: &AtomicBool) {
    match discover_vehicle(stop) {
        Some(discovered) => {
            remember_vehicle_host(&discovered);
            *host = discovered;
        }
        None => forget_vehicle_host(),
    }
}

fn is_terminal_transport_error(error: &str) -> bool {
    let error = error.to_ascii_lowercase();
    [
        "network is unreachable",
        "network unreachable",
        "host is unreachable",
        "host unreachable",
        "no route to host",
        "address not available",
    ]
    .iter()
    .any(|needle| error.contains(needle))
}

fn recovery_attempt_limit(error: &str) -> u8 {
    if is_transient_network_configuration_error(error) {
        MAX_NETWORK_CONFIGURATION_RETRIES
    } else {
        MAX_SESSION_RECOVERY_ATTEMPTS
    }
}

/// A route can be reinstalled shortly after an Android USB/Ethernet adapter
/// renegotiates. This is recoverable within the session's bounded retry window.
fn is_transient_network_configuration_error(error: &str) -> bool {
    let error = error.to_ascii_lowercase();
    [
        "network is unreachable",
        "network unreachable",
        "no route to host",
        "host is unreachable",
        "host unreachable",
    ]
    .iter()
    .any(|needle| error.contains(needle))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum LivePollStage {
    Define,
    Read,
    Clear,
}

impl LivePollStage {
    fn request_sid(self) -> u8 {
        match self {
            Self::Define | Self::Clear => 0x2C,
            Self::Read => 0x22,
        }
    }

    fn label(self) -> &'static str {
        match self {
            Self::Define => "define_dynamic_did",
            Self::Read => "read_dynamic_did",
            Self::Clear => "clear_dynamic_did",
        }
    }
}

struct PendingLivePoll {
    id: u64,
    sensor: SensorDefinition,
    stage: LivePollStage,
    started: Instant,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum LivePollResponse {
    Positive,
    Pending,
    Negative(u8),
}

fn match_live_poll_response(
    frame: &HsfzFrame,
    pending: &PendingLivePoll,
) -> Option<LivePollResponse> {
    if frame.message_type != 0x0001
        || frame.source != pending.sensor.ecu
        || frame.destination != TESTER
    {
        return None;
    }
    let positive = match pending.stage {
        LivePollStage::Define => [0x6C, 0x01, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
        LivePollStage::Read => [0x62, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW, 0x00],
        LivePollStage::Clear => [0x6C, 0x03, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
    };
    let positive_length = if pending.stage == LivePollStage::Read {
        3
    } else {
        4
    };
    if frame.uds.starts_with(&positive[..positive_length]) {
        return Some(LivePollResponse::Positive);
    }
    match frame.uds.as_slice() {
        [0x7F, request_sid, 0x78] if *request_sid == pending.stage.request_sid() => {
            Some(LivePollResponse::Pending)
        }
        [0x7F, request_sid, nrc] if *request_sid == pending.stage.request_sid() => {
            Some(LivePollResponse::Negative(*nrc))
        }
        _ => None,
    }
}

fn log_ignored_live_response(frame: &HsfzFrame, pending: &PendingLivePoll) {
    transport_diagnostic(
        TransportDiagnosticsLevel::Detailed,
        json!({
            "type": "response_ignored",
            "reason": "live_poll_mismatch",
            "expectedSource": format!("{:02X}", pending.sensor.ecu),
            "expectedDestination": format!("{TESTER:02X}"),
            "expectedService": format!("{:02X}", pending.stage.request_sid()),
            "expectedIdentifier": format!("{DYNAMIC_DID_HIGH:02X}{DYNAMIC_DID_LOW:02X}"),
            "expectedOperation": pending.stage.label(),
            "actualMessageType": format!("{:04X}", frame.message_type),
            "actualSource": format!("{:02X}", frame.source),
            "actualDestination": format!("{:02X}", frame.destination),
            "actualService": frame.uds.first().map(|value| format!("{value:02X}")),
            "actualIdentifier": transport_identifier(&frame.uds).map(|value| format!("{value:04X}")),
            "actualPayloadLength": frame.uds.len(),
        }),
    );
}

fn poll_connection(
    stream: &mut TcpStream,
    sink: &StreamSink<VehicleEvent>,
    stop: &AtomicBool,
    flap_receiver: &mpsc::Receiver<FlapCommand>,
    recovery_attempts: u8,
) -> Result<(), String> {
    let all_sensors = default_sensors();
    let mut configured_sensor_ids = configured_live_sensor_ids();
    let mut sensors = selected_sensors(&all_sensors);
    let mut buffer = Vec::with_capacity(4096);
    let mut scratch = [0u8; 4096];
    let mut index = 0usize;
    let mut pending = None::<PendingLivePoll>;
    let mut flap_commands = VecDeque::new();
    // Only periodic modes are restored after a transient TCP reconnect.
    let mut flap_control = configured_flap_control();
    let mut flap_ack_deadline = None::<Instant>;
    // Keep the command's reply open until the DME confirms the IO-control.
    // A successful socket write alone is not a successful flap command.
    let mut pending_flap_reply = PendingFlapReply::default();
    let mut next_flap_refresh = if flap_control.is_some() {
        Instant::now()
    } else {
        Instant::now() + Duration::from_secs(5)
    };
    let mut was_monitoring = false;
    let (vin, ecu_identity, fingerprint, factory, last_flash_date) = identify_engine(stream)?;
    validate_vehicle_identity(
        vin.clone(),
        stable_dme_identity(&fingerprint, &ecu_identity)?,
    )?;
    let _ = sink.add(VehicleEvent::ecu_identity(ENGINE_ECU_ADDRESS, ecu_identity));
    let _ = sink.add(VehicleEvent::ecu_fingerprint(
        ENGINE_ECU_ADDRESS,
        fingerprint,
    ));
    let factory_read = factory.is_some();
    if let Some(factory) = factory {
        let _ = sink.add(VehicleEvent::ecu_factory_identity(
            ENGINE_ECU_ADDRESS,
            factory,
        ));
    }
    let supplier = read_supplier_identity(stream);
    let supplier_read = supplier.is_some();
    if let Some(supplier) = supplier {
        let _ = sink.add(VehicleEvent::ecu_supplier_identity(
            ENGINE_ECU_ADDRESS,
            supplier,
        ));
    }
    if let Some(date) = last_flash_date {
        let _ = sink.add(VehicleEvent::ecu_last_flash_date(ENGINE_ECU_ADDRESS, date));
    }
    enter_extended_session(stream, ENGINE_ECU_ADDRESS)?;
    if !factory_read {
        // A transient F103 timeout during initial identification must not
        // leave the factory card empty for the rest of a connected session.
        if let Some(values) = read_factory_identity(stream) {
            let _ = sink.add(VehicleEvent::ecu_factory_identity(
                ENGINE_ECU_ADDRESS,
                values,
            ));
        }
    }
    if !supplier_read {
        if let Some(values) = read_supplier_identity(stream) {
            let _ = sink.add(VehicleEvent::ecu_supplier_identity(
                ENGINE_ECU_ADDRESS,
                values,
            ));
        }
    }
    // Do not perform the 26-ECU inventory sweep here. On the user's ENET
    // gateway, that burst competes with the first live poll and has been
    // observed immediately before socket resets. The connected DME is already
    // proven by the identity and live-sensor reads; a full inventory belongs
    // to an explicit diagnostics scan.
    let _ = sink.add(VehicleEvent::status(
        "ecu_inventory",
        format!(
            "Live DME responding at 0x{ENGINE_ECU_ADDRESS:02X}; full ECU inventory deferred to an explicit diagnostics scan"
        ),
    ));
    let _ = sink.add(VehicleEvent::vin(vin));
    let _ = sink.add(VehicleEvent::status(
        "connected",
        "Diagnostic session active; live monitoring is paused",
    ));
    let _ = sink.add(VehicleEvent::status("identified", "Vehicle identified"));
    let mut next_vehicle_voltage_read = Instant::now();
    while !stop.load(Ordering::Acquire) {
        let monitoring = monitoring_enabled().load(Ordering::Acquire);
        if monitoring != was_monitoring {
            if monitoring {
                // Leave a settling window after the identity reads before the
                // first dynamic-DID request.
                thread::sleep(LIVE_POLL_STARTUP_SETTLE);
                if pending.is_none() && flap_ack_deadline.is_none() {
                    start_poll(stream, &sensors[index], &mut pending)?;
                }
                let _ = sink.add(VehicleEvent::status(
                    "monitoring_started",
                    "Live monitoring started",
                ));
            } else {
                // A pending definition/read can be abandoned safely; clearing
                // F300 prevents a stopped monitor leaving a temporary DID in
                // the DME.
                if pending.take().is_some() {
                    send_uds(
                        stream,
                        ENGINE_ECU_ADDRESS,
                        &[0x2C, 0x03, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
                    )?;
                    next_vehicle_voltage_read = Instant::now() + Duration::from_secs(1);
                }
                let _ = sink.add(VehicleEvent::status(
                    "monitoring_stopped",
                    "Live monitoring paused",
                ));
            }
            was_monitoring = monitoring;
        }
        while let Ok(command) = flap_receiver.try_recv() {
            flap_commands.push_back(command);
        }
        // Flap control remains available when telemetry is paused. Unlike live
        // monitoring, it is an explicit user action and must not require a
        // background F300 polling cycle to dispatch.
        if !monitoring && pending.is_none() && flap_ack_deadline.is_none() {
            if let Some(FlapCommand::Set { mode, reply }) = flap_commands.pop_front() {
                let result = apply_flap_command(stream, &mode);
                if result.is_ok() {
                    flap_control = periodic_flap_request(&mode);
                    next_flap_refresh = Instant::now() + Duration::from_secs(5);
                    flap_ack_deadline = Some(Instant::now() + Duration::from_secs(3));
                    pending_flap_reply.0 = Some(reply);
                } else {
                    let _ = reply.send(result.clone());
                }
            }
            if let Some(request) = flap_control {
                if Instant::now() >= next_flap_refresh {
                    send_uds(stream, EXHAUST_FLAP_DME, &request)?;
                    next_flap_refresh = Instant::now() + Duration::from_secs(5);
                    flap_ack_deadline = Some(Instant::now() + Duration::from_secs(3));
                }
            }
        }
        if pending.is_none() {
            let latest_sensor_ids = configured_live_sensor_ids();
            if latest_sensor_ids != configured_sensor_ids {
                configured_sensor_ids = latest_sensor_ids;
                sensors = selected_sensors(&all_sensors);
                index %= sensors.len();
            }
        }
        // A separate read for the Vehicle page. Keep it on this socket and
        // outside the F300 polling transaction so replies cannot be mixed.
        if !monitoring
            && pending.is_none()
            && flap_ack_deadline.is_none()
            && Instant::now() >= next_vehicle_voltage_read
        {
            match read_vehicle_dme_voltage(stream) {
                Ok(raw) => {
                    let _ = sink.add(VehicleEvent::vehicle_voltage(raw));
                }
                Err(error) => {
                    let _ = sink.add(VehicleEvent::status("vehicle_voltage_unavailable", error));
                }
            }
            next_vehicle_voltage_read = Instant::now() + Duration::from_secs(10);
        }
        match stream.read(&mut scratch) {
            Ok(0) => {
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({"type": "socket_peer_closed", "operation": "read"}),
                );
                return Err("Vehicle closed the connection".into());
            }
            Ok(count) => buffer.extend_from_slice(&scratch[..count]),
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {}
            Err(error) => {
                transport_diagnostic(
                    TransportDiagnosticsLevel::Normal,
                    json!({"type": "socket_error", "operation": "read", "error": error.to_string()}),
                );
                return Err(error.to_string());
            }
        }
        for frame in drain_hsfz(&mut buffer)? {
            if frame.message_type == 0x0043 {
                return Err("Gateway reset detected".into());
            }
            if flap_ack_deadline.is_some()
                && frame.message_type == 0x0001
                && frame.source == EXHAUST_FLAP_DME
                && frame.destination == TESTER
                && frame.uds.starts_with(&[0x6F, 0x60, 0xFD])
            {
                // Never overlap a flap IO-control request with the next
                // dynamic sensor request. The DME can otherwise accept the
                // command but lose the override shortly afterward.
                if flap_ack_deadline.take().is_some() && pending.is_none() {
                    pending_flap_reply.complete(Ok(()));
                    if monitoring {
                        index = (index + 1) % sensors.len();
                        start_poll(stream, &sensors[index], &mut pending)?;
                    }
                }
                continue;
            }
            if flap_ack_deadline.is_some()
                && frame.message_type == 0x0001
                && frame.source == EXHAUST_FLAP_DME
                && frame.destination == TESTER
                && matches!(frame.uds.as_slice(), [0x7F, 0x2F, _])
            {
                let nrc = frame.uds[2];
                let error =
                    format!("DME rejected exhaust flap command (NRC 0x{nrc:02X}); reconnecting");
                pending_flap_reply.complete(Err(error.clone()));
                return Err(error);
            }

            let Some(response) = pending
                .as_ref()
                .and_then(|request| match_live_poll_response(&frame, request))
            else {
                if let Some(request) = pending.as_ref() {
                    log_ignored_live_response(&frame, request);
                }
                continue;
            };

            match response {
                LivePollResponse::Pending => continue,
                LivePollResponse::Negative(nrc) => {
                    let stage = pending.as_ref().expect("matched pending poll").stage;
                    transport_diagnostic(
                        TransportDiagnosticsLevel::Detailed,
                        json!({
                            "type": "matched_negative_response",
                            "operation": stage.label(),
                            "nrc": format!("{nrc:02X}"),
                        }),
                    );
                    if stage == LivePollStage::Read {
                        let request = pending.as_mut().expect("matched pending poll");
                        send_uds(
                            stream,
                            request.sensor.ecu,
                            &[0x2C, 0x03, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
                        )?;
                        request.stage = LivePollStage::Clear;
                        request.started = Instant::now();
                    } else {
                        pending = None;
                        if monitoring {
                            index = (index + 1) % sensors.len();
                            start_poll(stream, &sensors[index], &mut pending)?;
                        }
                    }
                }
                LivePollResponse::Positive => {
                    let stage = pending.as_ref().expect("matched pending poll").stage;
                    match stage {
                        LivePollStage::Define => {
                            let request = pending.as_mut().expect("matched pending poll");
                            send_uds(
                                stream,
                                request.sensor.ecu,
                                &[0x22, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
                            )?;
                            request.stage = LivePollStage::Read;
                            request.started = Instant::now();
                        }
                        LivePollStage::Read => {
                            let request = pending.as_mut().expect("matched pending poll");
                            let raw =
                                decode_unsigned(&frame.uds[3..], request.sensor.size as usize)?;
                            let _ = sink.add(VehicleEvent::sensor_with_transport(
                                &request.sensor,
                                raw,
                                request.id,
                                request.started.elapsed(),
                                recovery_attempts,
                            ));
                            send_uds(
                                stream,
                                request.sensor.ecu,
                                &[0x2C, 0x03, DYNAMIC_DID_HIGH, DYNAMIC_DID_LOW],
                            )?;
                            request.stage = LivePollStage::Clear;
                            request.started = Instant::now();
                        }
                        LivePollStage::Clear => {
                            pending = None;
                            if let Some(FlapCommand::Set { mode, reply }) =
                                flap_commands.pop_front()
                            {
                                let result = apply_flap_command(stream, &mode);
                                if result.is_ok() {
                                    flap_control = periodic_flap_request(&mode);
                                    next_flap_refresh = Instant::now() + Duration::from_secs(5);
                                    flap_ack_deadline =
                                        Some(Instant::now() + Duration::from_secs(3));
                                    pending_flap_reply.0 = Some(reply);
                                } else {
                                    let _ = reply.send(result.clone());
                                }
                            }
                            if let Some(request) = flap_control {
                                if Instant::now() >= next_flap_refresh {
                                    send_uds(stream, EXHAUST_FLAP_DME, &request)?;
                                    next_flap_refresh = Instant::now() + Duration::from_secs(5);
                                    flap_ack_deadline =
                                        Some(Instant::now() + Duration::from_secs(3));
                                }
                            }
                            if monitoring && flap_ack_deadline.is_none() {
                                thread::sleep(LIVE_POLL_INTER_TRANSACTION_SETTLE);
                                index = (index + 1) % sensors.len();
                                start_poll(stream, &sensors[index], &mut pending)?;
                            }
                        }
                    }
                }
            }
        }
        if monitoring
            && pending
                .as_ref()
                .is_some_and(|request| request.started.elapsed() > LIVE_POLL_TIMEOUT)
        {
            let (sensor_id, age_ms) = pending
                .as_ref()
                .map(|request| {
                    (
                        request.sensor.id.clone(),
                        request.started.elapsed().as_millis() as u64,
                    )
                })
                .unwrap_or_else(|| (String::new(), 0));
            transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({
                    "type": "request_timeout",
                    "operation": "live_poll",
                    "sensorId": sensor_id,
                    "ageMs": age_ms,
                    "timeoutMs": LIVE_POLL_TIMEOUT.as_millis() as u64,
                }),
            );
            return Err("ECU polling timeout; reconnecting".into());
        }
        if flap_ack_deadline.is_some_and(|deadline| Instant::now() > deadline) {
            transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({"type": "request_timeout", "operation": "exhaust_flap_ack"}),
            );
            let error = "Exhaust flap command acknowledgement timeout; reconnecting".to_string();
            pending_flap_reply.complete(Err(error.clone()));
            return Err(error);
        }
    }
    Ok(())
}

fn start_poll(
    stream: &mut TcpStream,
    sensor: &SensorDefinition,
    pending: &mut Option<PendingLivePoll>,
) -> Result<(), String> {
    let did_high = (sensor.did >> 8) as u8;
    let did_low = sensor.did as u8;
    send_uds(
        stream,
        sensor.ecu,
        &[
            0x2C,
            0x01,
            DYNAMIC_DID_HIGH,
            DYNAMIC_DID_LOW,
            did_high,
            did_low,
            0x01,
            sensor.size,
        ],
    )?;
    *pending = Some(PendingLivePoll {
        id: NEXT_LIVE_POLL_ID.fetch_add(1, Ordering::Relaxed),
        sensor: sensor.clone(),
        stage: LivePollStage::Define,
        started: Instant::now(),
    });
    Ok(())
}

fn send_uds(stream: &mut TcpStream, destination: u8, uds: &[u8]) -> Result<(), String> {
    debug_transport("TX", destination, uds);
    raw_transport_log("TX", 0x0001, TESTER, destination, uds);
    stream
        .write_all(&build_hsfz(TESTER, destination, uds))
        .map_err(|error| {
            transport_diagnostic(
                TransportDiagnosticsLevel::Normal,
                json!({
                    "type": "socket_error",
                    "operation": "write",
                    "destination": format!("{destination:02X}"),
                    "error": error.to_string(),
                }),
            );
            error.to_string()
        })
}

fn debug_transport(direction: &str, ecu: u8, uds: &[u8]) {
    #[cfg(debug_assertions)]
    eprintln!(
        "[bimmerscope] {direction} ecu=0x{ecu:02X} service=0x{:02X} length={}",
        uds.first().copied().unwrap_or_default(),
        uds.len()
    );
}

fn transport_identifier(uds: &[u8]) -> Option<u16> {
    match uds {
        [0x22 | 0x2C | 0x2F | 0x62 | 0x6C | 0x6F, high, low, ..] => {
            Some(u16::from_be_bytes([*high, *low]))
        }
        _ => None,
    }
}

fn response_request_service(uds: &[u8]) -> Option<u8> {
    match uds {
        [0x7F, request, ..] => Some(*request),
        [response, ..] if *response >= 0x40 => Some(response - 0x40),
        _ => None,
    }
}

fn hex_payload(bytes: &[u8]) -> String {
    bytes
        .iter()
        .map(|byte| format!("{byte:02X}"))
        .collect::<Vec<_>>()
        .join("")
}

fn transport_diagnostic(required: TransportDiagnosticsLevel, mut record: Value) {
    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|duration| duration.as_millis())
        .unwrap_or_default();
    let mut config = match TRANSPORT_DIAGNOSTICS
        .get_or_init(|| Mutex::new(TransportDiagnosticsConfig::default()))
        .lock()
    {
        Ok(config) => config,
        Err(_) => return,
    };
    if config.level < required || config.truncated {
        return;
    }
    if let Some(object) = record.as_object_mut() {
        object.insert("timestampMs".into(), json!(timestamp));
        object.insert("sessionId".into(), json!(config.session_id));
    }
    let mut line = match serde_json::to_string(&record) {
        Ok(line) => line,
        Err(_) => return,
    };
    line.push('\n');
    if config.bytes_written + line.len() as u64 > TRANSPORT_DIAGNOSTICS_MAX_BYTES {
        let truncated = format!(
            "{{\"type\":\"transport_capture_truncated\",\"timestampMs\":{timestamp},\"sessionId\":{},\"limitBytes\":{TRANSPORT_DIAGNOSTICS_MAX_BYTES}}}\n",
            serde_json::to_string(&config.session_id).unwrap_or_else(|_| "\"\"".into())
        );
        let path = std::env::temp_dir().join("BimmerScope_Raw_HSFZ.log");
        if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(path) {
            let _ = file.write_all(truncated.as_bytes());
        }
        config.truncated = true;
        return;
    }
    let path = std::env::temp_dir().join("BimmerScope_Raw_HSFZ.log");
    if let Ok(mut file) = OpenOptions::new().create(true).append(true).open(path) {
        if file.write_all(line.as_bytes()).is_ok() {
            config.bytes_written += line.len() as u64;
        }
    }
}

fn raw_transport_log(direction: &str, message_type: u16, source: u8, destination: u8, uds: &[u8]) {
    let service = uds.first().copied().unwrap_or_default();
    let identifier = transport_identifier(uds);
    let mut request_id = None;
    let mut correlation = "not_applicable";
    let mut duration_ms = None;
    let mut queue_depth = 0usize;
    let mut current_operation = None::<String>;

    TRANSPORT_REQUESTS.with(|requests| {
        let mut context = requests.borrow_mut();
        if direction == "TX" && message_type == 0x0001 {
            let id = NEXT_TRANSPORT_REQUEST_ID.fetch_add(1, Ordering::Relaxed);
            context.pending.push_back(PendingTransportRequest {
                id,
                destination,
                service,
                identifier,
                started: Instant::now(),
            });
            request_id = Some(id);
            correlation = "pending";
        } else if direction == "RX" && message_type == 0x0001 {
            if let Some(request_service) = response_request_service(uds) {
                let response_identifier = transport_identifier(uds);
                let matched = context.pending.iter().position(|pending| {
                    pending.service == request_service
                        && (pending.destination == source || pending.destination == 0xDF)
                        && (response_identifier.is_none()
                            || pending.identifier.is_none()
                            || pending.identifier == response_identifier)
                });
                if let Some(index) = matched {
                    let response_pending = uds == [0x7F, request_service, 0x78];
                    if response_pending {
                        let pending = &context.pending[index];
                        request_id = Some(pending.id);
                        duration_ms = Some(pending.started.elapsed().as_millis() as u64);
                        correlation = "response_pending";
                    } else if let Some(pending) = context.pending.remove(index) {
                        request_id = Some(pending.id);
                        duration_ms = Some(pending.started.elapsed().as_millis() as u64);
                        correlation = "matched";
                        context
                            .completed
                            .push_back((pending.service, pending.identifier));
                        while context.completed.len() > 32 {
                            context.completed.pop_front();
                        }
                    }
                } else if context
                    .completed
                    .iter()
                    .any(|item| item.0 == request_service && item.1 == response_identifier)
                {
                    correlation = "late";
                } else {
                    correlation = "unmatched";
                }
            } else {
                correlation = "unmatched";
            }
        }
        queue_depth = context.pending.len();
        current_operation = context.pending.front().map(|pending| {
            pending.identifier.map_or_else(
                || format!("service_{:02X}", pending.service),
                |identifier| format!("service_{:02X}:{identifier:04X}", pending.service),
            )
        });
    });

    let mut record = json!({
        "type": "hsfz_frame",
        "direction": direction,
        "messageType": format!("{message_type:04X}"),
        "source": format!("{source:02X}"),
        "destination": format!("{destination:02X}"),
        "service": format!("{service:02X}"),
        "identifier": identifier.map(|value| format!("{value:04X}")),
        "requestId": request_id,
        "correlation": correlation,
        "durationMs": duration_ms,
        "queueDepth": queue_depth,
        "currentOperation": current_operation,
        "payloadLength": uds.len(),
    });
    let trace_enabled = TRANSPORT_DIAGNOSTICS
        .get_or_init(|| Mutex::new(TransportDiagnosticsConfig::default()))
        .lock()
        .map(|config| config.level == TransportDiagnosticsLevel::Trace)
        .unwrap_or(false);
    if trace_enabled {
        if let Some(object) = record.as_object_mut() {
            object.insert("payloadHex".into(), json!(hex_payload(uds)));
        }
    }
    transport_diagnostic(TransportDiagnosticsLevel::Detailed, record);
}

// Prototype only: this builds and validates the UDS ClearDiagnosticInformation
// payload, but is intentionally not connected to the ENET transport yet.
fn build_clear_dtc_request(group: [u8; 3]) -> [u8; 4] {
    let service = default_diagnostic_services()
        .into_iter()
        .find(|service| service.id == "clear_diagnostic_information")
        .expect("built-in clear-DTC service is missing");
    [service.request_sid, group[0], group[1], group[2]]
}

fn build_dme_reset_request() -> [u8; 2] {
    [0x11, 0x01]
}

fn validate_selected_reset_vin(vin: &str) -> Result<(), String> {
    if vin.len() != 17 || !vin.is_ascii() || !vin.chars().all(|c| c.is_ascii_alphanumeric()) {
        return Err("Refusing DME reset: selected vehicle VIN is invalid".into());
    }
    Ok(())
}

fn validate_matching_reset_vin(selected: &str, live: &str) -> Result<(), String> {
    validate_selected_reset_vin(selected)?;
    if !live.eq_ignore_ascii_case(selected) {
        return Err(format!(
            "Refusing DME reset: selected VIN {selected} does not match live DME VIN {live}"
        ));
    }
    Ok(())
}

fn parse_dme_reset_acknowledgement(response: &[u8]) -> Result<(), String> {
    if response == [0x51, 0x01] {
        Ok(())
    } else {
        Err("DME returned an unsupported reset acknowledgement".into())
    }
}

// Experimental ISTA service-test request captured from an F82/S55 vehicle.
// This is deliberately not connected to the live transport: the request is
// for "teach-in exhaust flap / move to installation position", not a proven
// open/close command, and may change DME adaptation state.
const EXHAUST_FLAP_DME: u8 = 0x12;
const EXHAUST_FLAP_IO_CONTROL_ID: [u8; 2] = [0x60, 0xFD];

fn build_exhaust_flap_cycle_request(control: [u8; 2]) -> [u8; 8] {
    [
        0x2F,
        EXHAUST_FLAP_IO_CONTROL_ID[0],
        EXHAUST_FLAP_IO_CONTROL_ID[1],
        0x03,
        control[0],
        control[1],
        0x0A,
        0xFF,
    ]
}

fn build_live_exhaust_flap_request(control: [u8; 2]) -> [u8; 8] {
    if control == [0x14, 0x7A] {
        // The BM3-observed Open variant remains a distinct user-selectable
        // mode. The BimmerScope cycle variant keeps its original 0A FF bytes.
        [0x2F, 0x60, 0xFD, 0x03, 0x14, 0x7A, 0xFA, 0xFF]
    } else {
        build_exhaust_flap_cycle_request(control)
    }
}

fn build_exhaust_flap_reset_request() -> [u8; 4] {
    [0x2F, 0x60, 0xFD, 0x00]
}

fn parse_exhaust_flap_io_response(uds: &[u8], control: [u8; 2]) -> Result<(), String> {
    match uds {
        [0x6F, 0x60, 0xFD, 0x03, value] if *value == control[0] => Ok(()),
        // Some DME software versions acknowledge the actuator request
        // without echoing the requested position byte.
        [0x6F, 0x60, 0xFD, 0x03] => Ok(()),
        [0x7F, 0x2F, nrc] => Err(format!(
            "DME rejected exhaust flap service test (NRC 0x{nrc:02X})"
        )),
        _ => Err("Unexpected exhaust flap service-test response".into()),
    }
}

fn parse_clear_dtc_response(uds: &[u8]) -> Result<(), String> {
    let service = default_diagnostic_services()
        .into_iter()
        .find(|service| service.id == "clear_diagnostic_information")
        .expect("built-in clear-DTC service is missing");
    match uds {
        [response_sid] if *response_sid == service.positive_response_sid => Ok(()),
        [0x7F, request_sid, 0x78] if *request_sid == service.request_sid => {
            Err("Engine ECU is processing the clear request".into())
        }
        [0x7F, request_sid, nrc] if *request_sid == service.request_sid => Err(format!(
            "Engine ECU rejected the clear request (NRC 0x{nrc:02X})"
        )),
        _ => Err("Malformed clear-DTC response".into()),
    }
}

fn wait_for_broadcast_clear_dtc_responses(
    stream: &mut TcpStream,
    required_ecu: u8,
    timeout: Duration,
) -> Result<(), String> {
    let service = default_diagnostic_services()
        .into_iter()
        .find(|service| service.id == "clear_diagnostic_information")
        .expect("built-in clear-DTC service is missing");
    let deadline = Instant::now() + timeout;
    let mut last_clear_response = None::<Instant>;
    let mut successful_ecus = BTreeSet::new();
    let mut pending_ecus = BTreeSet::new();
    let mut buffer = Vec::with_capacity(4096);
    let mut scratch = [0u8; 4096];
    while Instant::now() < deadline {
        match stream.read(&mut scratch) {
            Ok(0) => return Err("Vehicle closed the diagnostic connection".into()),
            Ok(count) => buffer.extend_from_slice(&scratch[..count]),
            Err(error) if matches!(error.kind(), ErrorKind::WouldBlock | ErrorKind::TimedOut) => {
                continue
            }
            Err(error) => return Err(error.to_string()),
        }
        for frame in drain_hsfz(&mut buffer)? {
            if !is_application_response(&frame) {
                continue;
            }
            match frame.uds.as_slice() {
                [0x7F, request_sid, 0x78] if *request_sid == service.request_sid => {
                    pending_ecus.insert(frame.source);
                    last_clear_response = Some(Instant::now());
                }
                [0x7F, request_sid, nrc] if *request_sid == service.request_sid => {
                    if frame.source == required_ecu {
                        return Err(format!(
                            "S55 DME rejected the clear request (NRC 0x{nrc:02X})"
                        ));
                    }
                    last_clear_response = Some(Instant::now());
                }
                _ if is_expected_response(&frame, &[service.positive_response_sid]) => {
                    successful_ecus.insert(frame.source);
                    pending_ecus.remove(&frame.source);
                    last_clear_response = Some(Instant::now());
                }
                _ => {}
            }
        }
        // BM3 receives acknowledgements from several ECUs. Drain a short quiet
        // window after the DME confirms, rather than declaring success on the
        // first 54 response from an unrelated ECU.
        if successful_ecus.contains(&required_ecu)
            && last_clear_response
                .is_some_and(|received| received.elapsed() >= BROADCAST_CLEAR_QUIET_WINDOW)
        {
            return Ok(());
        }
    }
    if successful_ecus.contains(&required_ecu) {
        return Ok(());
    }
    if pending_ecus.contains(&required_ecu) {
        return Err("S55 DME did not finish the clear request before timeout".into());
    }
    Err("S55 DME did not acknowledge the broadcast clear request".into())
}

#[derive(Debug, PartialEq)]
struct HsfzFrame {
    message_type: u16,
    source: u8,
    destination: u8,
    uds: Vec<u8>,
}

/// Incoming application frames are addressed back to the tester. The ECU-side
/// source is dynamic in ISTA captures, so response matching must not require a
/// fixed source address. Gateway echoes (0x0002) and reset/event frames are
/// deliberately excluded from UDS response handling.
fn is_application_response(frame: &HsfzFrame) -> bool {
    frame.message_type == 0x0001 && frame.destination == TESTER
}

fn is_expected_response(frame: &HsfzFrame, expected: &[u8]) -> bool {
    is_application_response(frame) && frame.uds.starts_with(expected)
}

/// Socket adapter for the download runner. Construction remains test-only until
/// an approved procedure can bind identity, route and exclusive ownership.
#[allow(dead_code)]
#[frb(ignore)]
struct DownloadHsfzTransport {
    stream: TcpStream,
    tester: u8,
    response_source: u8,
    target: u8,
    buffer: Vec<u8>,
    frames: VecDeque<HsfzFrame>,
    sid: Option<u8>,
}

impl crate::uds_download::DownloadTransport for DownloadHsfzTransport {
    fn send(&mut self, bytes: &[u8], deadline: Instant) -> Result<(), String> {
        if self.sid.is_some() || !self.frames.is_empty() || !self.buffer.is_empty() {
            return Err("Previous exchange has unresolved data".into());
        }
        let sid = *bytes.first().ok_or("Empty download request")?;
        if !matches!(sid, 0x34 | 0x36 | 0x37) {
            return Err("Unsupported download service".into());
        }
        self.sid = Some(sid);
        let packet = build_hsfz(self.tester, self.target, bytes);
        let mut remaining = packet.as_slice();
        while !remaining.is_empty() {
            let timeout = deadline
                .checked_duration_since(Instant::now())
                .filter(|d| !d.is_zero())
                .ok_or("Send deadline expired")?;
            self.stream
                .set_write_timeout(Some(timeout))
                .map_err(|e| e.to_string())?;
            let count = self.stream.write(remaining).map_err(|e| e.to_string())?;
            if count == 0 {
                return Err("Socket closed during write".into());
            }
            remaining = &remaining[count..];
        }
        Ok(())
    }

    fn receive(&mut self, deadline: Instant) -> Result<Vec<u8>, String> {
        let sid = self.sid.ok_or("No outstanding download request")?;
        loop {
            let timeout = deadline
                .checked_duration_since(Instant::now())
                .filter(|d| !d.is_zero())
                .ok_or("Receive deadline expired")?;
            if let Some(frame) = self.frames.pop_front() {
                if frame.message_type == 2 {
                    continue;
                }
                if frame.message_type != 1 {
                    return Err("Unexpected gateway control frame".into());
                }
                if frame.source != self.response_source || frame.destination != self.tester {
                    continue;
                }
                let correlated = frame.uds.first() == Some(&(sid + 0x40))
                    || (frame.uds.first() == Some(&0x7f) && frame.uds.get(1) == Some(&sid));
                if !correlated {
                    return Err("Unexpected ECU application response".into());
                }
                if frame.uds != [0x7f, sid, 0x78] {
                    self.sid = None;
                }
                return Ok(frame.uds);
            }
            self.stream
                .set_read_timeout(Some(timeout))
                .map_err(|e| e.to_string())?;
            let mut bytes = [0u8; 4096];
            let count = self.stream.read(&mut bytes).map_err(|e| e.to_string())?;
            if count == 0 {
                return Err("Socket closed before acknowledgement".into());
            }
            self.buffer.extend_from_slice(&bytes[..count]);
            self.frames.extend(drain_hsfz(&mut self.buffer)?);
        }
    }
}

fn build_hsfz(source: u8, destination: u8, uds: &[u8]) -> Vec<u8> {
    let body_length = (uds.len() + 2) as u32;
    let mut packet = Vec::with_capacity(uds.len() + 8);
    packet.extend_from_slice(&body_length.to_be_bytes());
    packet.extend_from_slice(&1u16.to_be_bytes());
    packet.push(source);
    packet.push(destination);
    packet.extend_from_slice(uds);
    packet
}

fn drain_hsfz(buffer: &mut Vec<u8>) -> Result<Vec<HsfzFrame>, String> {
    let mut frames = Vec::new();
    loop {
        if buffer.len() < 6 {
            break;
        }
        let length = u32::from_be_bytes(buffer[0..4].try_into().unwrap()) as usize;
        // Some ENET gateways emit an empty HSFZ envelope while recovering
        // from a transient link interruption. It is not an application
        // response, so consume the six-byte envelope and keep the session
        // alive instead of forcing an unnecessary reconnect.
        if length == 0 {
            buffer.drain(..6);
            continue;
        }
        if !(2..=1_048_576).contains(&length) {
            return Err(format!("Invalid HSFZ body length: {length}"));
        }
        let total = 6 + length;
        if buffer.len() < total {
            break;
        }
        let frame = HsfzFrame {
            message_type: u16::from_be_bytes([buffer[4], buffer[5]]),
            source: buffer[6],
            destination: buffer[7],
            uds: buffer[8..total].to_vec(),
        };
        raw_transport_log(
            "RX",
            frame.message_type,
            frame.source,
            frame.destination,
            &frame.uds,
        );
        frames.push(frame);
        buffer.drain(..total);
    }
    Ok(frames)
}

fn decode_unsigned(bytes: &[u8], size: usize) -> Result<u32, String> {
    if size == 0 || size > 4 || bytes.len() < size {
        return Err("Invalid sensor payload length".into());
    }
    Ok(bytes[..size]
        .iter()
        .fold(0u32, |value, byte| (value << 8) | *byte as u32))
}

fn run_demo_session(sink: StreamSink<VehicleEvent>, stop: Arc<AtomicBool>) {
    let all_sensors = default_sensors();
    let sensors = selected_sensors(&all_sensors);
    let _ = sink.add(VehicleEvent::status("connected", "Demo vehicle"));
    let _ = sink.add(VehicleEvent::vin("DEMOF82S55MOBILE".into()));
    let started = Instant::now();
    while !stop.load(Ordering::Acquire) {
        let t = started.elapsed().as_secs_f64();
        for (index, sensor) in sensors.iter().enumerate() {
            let center = (sensor.minimum + sensor.maximum) / 2.0;
            let amplitude = (sensor.maximum - sensor.minimum) * 0.32;
            let value = (center + amplitude * (t * 0.7 + index as f64 * 0.8).sin())
                .clamp(sensor.minimum, sensor.maximum);
            let raw = ((value - sensor.offset) / sensor.scale).max(0.0) as u32;
            if sink.add(VehicleEvent::sensor(sensor, raw)).is_err() {
                return;
            }
        }
        thread::sleep(Duration::from_millis(120));
    }
    let _ = sink.add(VehicleEvent::status("disconnected", "Demo stopped"));
}

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn flap_command_reply_waits_for_dme_acknowledgement() {
        let (reply, result) = mpsc::channel();
        let mut pending = PendingFlapReply(Some(reply));

        assert!(matches!(result.try_recv(), Err(mpsc::TryRecvError::Empty)));
        pending.complete(Ok(()));
        assert_eq!(result.recv().unwrap(), Ok(()));

        let (reply, result) = mpsc::channel();
        let mut pending = PendingFlapReply(Some(reply));
        pending.complete(Err("ack timeout".into()));
        assert_eq!(result.recv().unwrap(), Err("ack timeout".into()));
    }

    #[test]
    fn builds_desktop_compatible_hsfz_packet() {
        assert_eq!(
            build_hsfz(0xF4, 0x10, &[0x22, 0xF1, 0x90]),
            vec![0, 0, 0, 5, 0, 1, 0xF4, 0x10, 0x22, 0xF1, 0x90]
        );
    }

    #[test]
    fn discovery_probe_accepts_f82_dme_reply_not_gateway_echo_or_other_ecu() {
        let mut buffer = build_hsfz(ENGINE_ECU_ADDRESS, TESTER, &[0x62, 0xF1, 0x50, 0x0F]);
        let reply = drain_hsfz(&mut buffer).unwrap();
        assert!(is_engine_probe_reply(&reply[0]));

        let mut buffer = build_hsfz(0x10, TESTER, &[0x62, 0xF1, 0x50, 0x0F]);
        let other_ecu = drain_hsfz(&mut buffer).unwrap();
        assert!(!is_engine_probe_reply(&other_ecu[0]));

        let mut buffer = vec![
            0,
            0,
            0,
            5,
            0,
            2,
            TESTER,
            ENGINE_ECU_ADDRESS,
            0x22,
            0xF1,
            0x50,
        ];
        let echo = drain_hsfz(&mut buffer).unwrap();
        assert!(!is_engine_probe_reply(&echo[0]));
    }

    #[test]
    fn buffers_partial_and_multiple_frames() {
        let first = build_hsfz(0x10, 0xF4, &[0x62, 0xF1, 0x90, b'A']);
        let second = build_hsfz(0x12, 0xF4, &[0x6C, 1, 0xF3, 0]);
        let mut buffer = first[..5].to_vec();
        assert!(drain_hsfz(&mut buffer).unwrap().is_empty());
        buffer.extend_from_slice(&first[5..]);
        buffer.extend_from_slice(&second);
        let frames = drain_hsfz(&mut buffer).unwrap();
        assert_eq!(frames.len(), 2);
        assert!(buffer.is_empty());
        assert_eq!(frames[0].uds, vec![0x62, 0xF1, 0x90, b'A']);
    }

    #[test]
    fn decodes_big_endian_values() {
        assert_eq!(decode_unsigned(&[0x0D, 0x2E], 2).unwrap(), 3374);
    }

    #[test]
    fn parses_uds_dtc_records() {
        let faults = parse_dtc_response(&[0x59, 0x02, 0xFF, 0x12, 0x34, 0x56, 0x0C])
            .expect("valid DTC response");
        assert_eq!(faults.len(), 1);
        assert_eq!(faults[0].code, "123456");
        assert_eq!(faults[0].status, 0x0C);
        assert!(faults[0].status_text.contains("Confirmed"));
        assert!(faults[0].status_text.contains("Pending"));
    }

    #[test]
    fn n20_unlock_reference_requires_all_three_captured_read_results() {
        assert_eq!(
            build_ista_memory_read_request(0x801F_FA40, 16).unwrap(),
            [0x23, 0x24, 0x80, 0x1F, 0xFA, 0x40, 0x00, 0x10]
        );
        assert_eq!(
            build_ista_memory_read_request(0x801F_FA00, 64).unwrap(),
            [0x23, 0x24, 0x80, 0x1F, 0xFA, 0x00, 0x00, 0x40]
        );
        let mut header = vec![0u8; 64];
        header[..25].copy_from_slice(&[
            0x41, 0x80, 0x8A, 0x05, 0x16, 0x40, 0xA5, 0x98, 0x74, 0x08, 0x00, 0x10, 0x11, 0x14,
            0xFD, 0x00, 0x5D, 0x55, 0xFD, 0x98, 0xD9, 0x08, 0xF5, 0x05, 0x50,
        ]);
        assert_eq!(
            classify_n20_reference(N20_BENCH_VIN, &[0xC3; 16], &header, &[0xC3; 64]).status,
            "reference_match"
        );
        header[25] = 1;
        assert_eq!(
            classify_n20_reference(N20_BENCH_VIN, &[0xC3; 16], &header, &[0xC3; 64]).status,
            "unable_to_verify"
        );
        assert_eq!(
            classify_n20_reference(N20_BENCH_VIN, &[0xC3; 15], &header, &[0xC3; 64]).status,
            "unable_to_verify"
        );
    }

    #[test]
    fn absent_optional_ecu_times_out_once_and_leaves_socket_usable() {
        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let mut client = TcpStream::connect(listener.local_addr().unwrap()).unwrap();
        client
            .set_read_timeout(Some(Duration::from_millis(100)))
            .unwrap();
        let worker = thread::spawn(move || {
            let (mut server, _) = listener.accept().unwrap();
            server
                .set_read_timeout(Some(Duration::from_secs(2)))
                .unwrap();
            let mut header = [0u8; 6];
            server.read_exact(&mut header).unwrap();
            let mut body = vec![0; u32::from_be_bytes(header[..4].try_into().unwrap()) as usize];
            server.read_exact(&mut body).unwrap();
            assert_eq!(body, [TESTER, 0x17, 0x10, 0x03]);
            let mut ack = build_hsfz(TESTER, 0x17, &[0x10, 0x03]);
            ack[5] = 2;
            server.write_all(&ack).unwrap();

            server.read_exact(&mut header).unwrap();
            let mut body = vec![0; u32::from_be_bytes(header[..4].try_into().unwrap()) as usize];
            server.read_exact(&mut body).unwrap();
            assert_eq!(body, [TESTER, 0x12, 0x22, 0xF1, 0x90]);
            server
                .write_all(&build_hsfz(0x12, TESTER, &[0x62, 0xF1, 0x90, b'W']))
                .unwrap();
        });
        let started = Instant::now();
        assert!(query_dtc_for_ecu(
            &mut client,
            0x17,
            "Optional ECU",
            OPTIONAL_ECU_SESSION_TIMEOUT,
        )
        .is_err());
        assert!(started.elapsed() < Duration::from_secs(2));
        send_uds(&mut client, 0x12, &[0x22, 0xF1, 0x90]).unwrap();
        let response = read_matching_uds_response(
            &mut client,
            0x12,
            &[0x62, 0xF1, 0x90],
            &[0x22],
            Duration::from_secs(1),
        )
        .unwrap();
        assert_eq!(response, [0x62, 0xF1, 0x90, b'W']);
        worker.join().unwrap();
    }

    #[test]
    fn builds_clear_all_dtcs_request_without_transport() {
        assert_eq!(
            build_clear_dtc_request([0xFF, 0xFF, 0xFF]),
            [0x14, 0xFF, 0xFF, 0xFF]
        );
    }

    #[test]
    fn builds_captured_exhaust_flap_cycle_requests_without_transport() {
        assert_eq!(EXHAUST_FLAP_DME, 0x12);
        assert_eq!(
            build_exhaust_flap_cycle_request([0x19, 0x99]),
            [0x2F, 0x60, 0xFD, 0x03, 0x19, 0x99, 0x0A, 0xFF]
        );
        assert_eq!(
            parse_exhaust_flap_io_response(&[0x6F, 0x60, 0xFD, 0x03, 0x19], [0x19, 0x99]),
            Ok(())
        );
        assert_eq!(build_exhaust_flap_reset_request(), [0x2F, 0x60, 0xFD, 0x00]);
    }

    #[test]
    fn builds_bm3_observed_flap_position_requests_without_transport() {
        assert_eq!(
            periodic_flap_request("open_legacy"),
            Some([0x2F, 0x60, 0xFD, 0x03, 0x14, 0x7A, 0x0A, 0xFF])
        );
        assert_eq!(
            periodic_flap_request("open_periodic"),
            Some([0x2F, 0x60, 0xFD, 0x03, 0x14, 0x7A, 0xFA, 0xFF])
        );
        assert_eq!(periodic_flap_request("open_bm3"), None);
        assert_eq!(
            flap_request_for_mode("open_bm3"),
            Some([0x2F, 0x60, 0xFD, 0x03, 0x14, 0x7A, 0xFA, 0xFF])
        );
        assert_eq!(
            build_live_exhaust_flap_request([0x14, 0x7A]),
            [0x2F, 0x60, 0xFD, 0x03, 0x14, 0x7A, 0xFA, 0xFF]
        );
        assert_eq!(
            build_live_exhaust_flap_request([0xEB, 0x85]),
            [0x2F, 0x60, 0xFD, 0x03, 0xEB, 0x85, 0x0A, 0xFF]
        );
        assert_eq!(
            parse_exhaust_flap_io_response(&[0x6F, 0x60, 0xFD, 0x03], [0x14, 0x7A]),
            Ok(())
        );
    }

    #[test]
    fn flap_vin_allowlist_matches_f30_328i_and_excludes_320i() {
        assert!(is_f30_n20_328i_vin("WBA3A53010F360747"));
        assert!(is_f30_n20_328i_vin("WBA8E71010F360747"));
        assert!(!is_f30_n20_328i_vin("WBA3B10010F360747"));
    }

    #[test]
    fn builds_and_validates_ista_memory_read_chunks() {
        assert_eq!(
            build_ista_memory_read_request(0x80180000, 0x100).unwrap(),
            [0x23, 0x24, 0x80, 0x18, 0x00, 0x00, 0x01, 0x00]
        );
        assert_eq!(
            build_ista_memory_read_request(0x80180100, 0x100).unwrap(),
            [0x23, 0x24, 0x80, 0x18, 0x01, 0x00, 0x01, 0x00]
        );
        assert_eq!(BM3_S55_READ_LENGTH / BM3_S55_READ_CHUNK, 127);
        assert_eq!(BM3_S55_READ_LENGTH % BM3_S55_READ_CHUNK, 0xDFC);
        assert_eq!(
            build_ista_memory_read_request(0x801F_EE04, 0xDFC).unwrap(),
            [0x23, 0x24, 0x80, 0x1F, 0xEE, 0x04, 0x0D, 0xFC]
        );
        assert_eq!(
            build_ista_memory_read_request(0x8018, 0x101).unwrap(),
            [0x23, 0x24, 0x00, 0x00, 0x80, 0x18, 0x01, 0x01]
        );
        let data = [0xA5; 0x100];
        let mut response = vec![0x63];
        response.extend_from_slice(&data);
        assert_eq!(
            parse_ista_memory_read_response(&response, 0x100).unwrap(),
            data
        );
        assert!(parse_ista_memory_read_response(&response, 0xFF).is_err());
    }

    #[test]
    fn parses_clear_dtc_positive_and_negative_responses() {
        assert_eq!(parse_clear_dtc_response(&[0x54]), Ok(()));
        assert!(parse_clear_dtc_response(&[0x7F, 0x14, 0x31])
            .unwrap_err()
            .contains("NRC 0x31"));
        assert!(parse_clear_dtc_response(&[0x7F, 0x14, 0x78])
            .unwrap_err()
            .contains("processing"));
    }

    #[test]
    fn builds_and_validates_broadcast_dme_reset() {
        assert_eq!(BROADCAST_ECU_ADDRESS, 0xDF);
        assert_eq!(build_dme_reset_request(), [0x11, 0x01]);
        assert_eq!(
            build_hsfz(TESTER, BROADCAST_ECU_ADDRESS, &build_dme_reset_request()),
            [0, 0, 0, 4, 0, 1, 0xF4, 0xDF, 0x11, 0x01]
        );
        let positive = HsfzFrame {
            message_type: 1,
            source: ENGINE_ECU_ADDRESS,
            destination: TESTER,
            uds: vec![0x51, 0x01],
        };
        let unrelated_ecu = HsfzFrame {
            source: 0x40,
            ..positive
        };
        assert!(is_application_response(&unrelated_ecu));
        assert_ne!(unrelated_ecu.source, ENGINE_ECU_ADDRESS);
        assert_eq!(parse_dme_reset_acknowledgement(&[0x51, 0x01]), Ok(()));
        assert!(parse_dme_reset_acknowledgement(&[0x51]).is_err());
    }

    #[test]
    fn dme_reset_requires_matching_selected_and_live_vins() {
        assert!(validate_selected_reset_vin("WBA3A52010F360747").is_ok());
        assert!(validate_selected_reset_vin("DEMOF82S55MOBILE").is_err());
        assert!(validate_selected_reset_vin("WBA3A52010F36074").is_err());
        assert!(validate_matching_reset_vin("WBA3A52010F360747", "wba3a52010f360747").is_ok());
        assert!(validate_matching_reset_vin("WBA3A52010F360747", "WBA3A52010F360748").is_err());
    }

    #[test]
    fn replays_ista_clear_sequence_with_echo_pending_and_dynamic_source() {
        let echo = HsfzFrame {
            message_type: 0x0002,
            source: 0xF4,
            destination: 0xDF,
            uds: vec![0x14, 0xFF, 0xFF, 0xFF],
        };
        let pending = HsfzFrame {
            message_type: 0x0001,
            source: 0x35,
            destination: TESTER,
            uds: vec![0x7F, 0x14, 0x78],
        };
        let positive = HsfzFrame {
            message_type: 0x0001,
            source: 0x18,
            destination: TESTER,
            uds: vec![0x54],
        };
        assert!(!is_expected_response(&echo, &[0x54]));
        assert!(is_application_response(&pending));
        assert!(!is_expected_response(&pending, &[0x54]));
        assert!(is_expected_response(&positive, &[0x54]));
    }

    #[test]
    fn parses_standard_zgw_discovery_vin() {
        assert_eq!(
            parse_zgw_vin("DIAGADR01BMWMAC001122BMWVINWBA00000000000000"),
            Some("WBA00000000000000".into())
        );
        assert!(parse_zgw_vin("BMWVINSHORT").is_none());
    }

    #[test]
    fn exposes_safe_diagnostic_service_inventory() {
        let services = default_diagnostic_services();
        let vin = services
            .iter()
            .find(|service| service.id == "read_vin")
            .unwrap();
        assert_eq!(vin.request_sid, 0x22);
        assert_eq!(vin.positive_response_sid, 0x62);
        assert_eq!(vin.safety, "read_only");

        let clear = services
            .iter()
            .find(|service| service.id == "clear_diagnostic_information")
            .unwrap();
        assert_eq!(clear.safety, "confirmed_ecu_specific_write");
    }

    #[test]
    fn exposes_vin_and_ecu_data_identifier_definitions() {
        let identifiers = default_diagnostic_data_identifiers();
        let vin = identifiers
            .iter()
            .find(|item| item.id == "vehicle_vin")
            .unwrap();
        assert_eq!(vin.did, 0xF190);
        assert_eq!(vin.response_sid, 0x62);
        assert_eq!(vin.encoding, "ascii");
        assert_eq!(vin.exact_length, Some(17));

        let ecu = identifiers
            .iter()
            .find(|item| item.id == "ecu_identification")
            .unwrap();
        assert_eq!(ecu.did, 0xF150);
        assert_eq!(ecu.exact_length, None);

        let serial = identifiers
            .iter()
            .find(|item| item.id == "ecu_serial_number")
            .unwrap();
        assert_eq!(serial.did, 0xF18C);
        assert_eq!(serial.encoding, "ascii");

        let s55_bundle = identifiers
            .iter()
            .find(|item| item.id == "s55_dme_identity_bundle")
            .unwrap();
        assert_eq!(s55_bundle.did, 0xF101);
        assert_eq!(s55_bundle.response_sid, 0x62);
        assert_eq!(s55_bundle.encoding, "binary");
        let factory = identifiers
            .iter()
            .find(|item| item.id == "dme_factory_identity_bundle")
            .unwrap();
        assert_eq!(factory.did, 0xF103);
        assert_eq!(factory.exact_length, Some(49));

        let flash_counter = identifiers
            .iter()
            .find(|item| item.id == "dme_flash_counter")
            .unwrap();
        assert_eq!(flash_counter.did, 0x2502);
        assert_eq!(flash_counter.response_sid, 0x62);
        assert_eq!(flash_counter.encoding, "unsigned_u32_be");
        assert_eq!(flash_counter.exact_length, Some(4));

        let ecu_date = identifiers
            .iter()
            .find(|item| item.id == "s55_ecu_manufacturing_date")
            .unwrap();
        assert_eq!(ecu_date.did, 0xF18B);
        assert_eq!(ecu_date.exact_length, Some(3));

        let session = identifiers
            .iter()
            .find(|item| item.id == "s55_dme_diagnostic_session")
            .unwrap();
        assert_eq!(session.did, 0xF186);
        assert_eq!(session.response_sid, 0x62);
        assert_eq!(session.exact_length, Some(2));
    }

    #[test]
    fn decodes_captured_s55_f101_identity_bundle() {
        let payload = [
            0x01, 0x01, 0x00, 0x05, 0x19, 0x06, 0x03, 0x8A, 0x04, 0xD2, 0x01, 0x00, 0x00, 0x10,
            0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x19, 0xDE, 0x0A, 0x13, 0x01, 0x06, 0x00, 0x00,
            0x1A, 0x83, 0x0A, 0x3B, 0x02, 0x08, 0x00, 0x00, 0x1A, 0x84, 0x1D, 0x28, 0x01, 0x08,
            0x00, 0x00, 0x26, 0x0B, 0x1D, 0x28, 0xFE, 0x05, 0x00, 0x00, 0x0B, 0x0A, 0x00, 0x73,
            0x02,
        ];

        let values = decode_s55_dme_identity_bundle(&payload).unwrap();
        assert_eq!(values.hardware, "000019DE010019001");
        assert_eq!(values.bootloader, "00001A83010059002");
        assert_eq!(values.software, "00001A84029040001");
        assert_eq!(values.calibration, "0000260B029040254");
        assert_eq!(values.coding_id, "00000B0A000115002");
    }

    #[test]
    fn extracts_hwel_from_the_first_mhd_f101_record() {
        let captured = N20_BENCH_F101;
        let payload = (0..captured.len())
            .step_by(2)
            .map(|index| u8::from_str_radix(&captured[index..index + 2], 16).unwrap())
            .collect::<Vec<_>>();
        assert_eq!(
            decode_mhd_hwel_from_f101(&payload),
            Some("000019A6001019003".into())
        );
        let mut changed = payload;
        changed[25] ^= 1;
        assert_eq!(decode_mhd_hwel_from_f101(&changed), None);
    }

    #[test]
    fn decodes_captured_n20_factory_and_current_identity() {
        let decode_hex = |hex: &str| {
            (0..hex.len())
                .step_by(2)
                .map(|index| u8::from_str_radix(&hex[index..index + 2], 16).unwrap())
                .collect::<Vec<_>>()
        };
        let current = decode_s55_dme_identity_bundle(&decode_hex(N20_BENCH_F101)).unwrap();
        let mut current_payload = decode_hex(N20_BENCH_F101);
        assert_eq!(
            decode_f101_last_flash_date(&current_payload),
            Some("2023.02.07".into())
        );
        current_payload[5] = 0x13;
        assert_eq!(decode_f101_last_flash_date(&current_payload), None);
        let factory = decode_dme_factory_identity_bundle(&decode_hex(N20_BENCH_F103)).unwrap();
        let supplier = decode_dme_supplier_identity_bundle(&decode_hex(N20_BENCH_F102)).unwrap();
        assert_eq!(current.hardware, factory.hardware);
        assert_eq!(supplier.hardware, factory.hardware);
        assert_eq!(supplier.bootloader, factory.bootloader);
        assert_eq!(supplier.software, factory.software);
        assert_eq!(supplier.calibration, "00001CA1029110000");
        assert_eq!(current.software, "00001C9F029150001");
        assert_eq!(factory.bootloader, "00001901001049001");
        assert_eq!(factory.software, "00001C9F029110002");
        assert_eq!(factory.calibration, "00001CDB029110009");
        assert!(decode_dme_factory_identity_bundle(&decode_hex(N20_BENCH_F103)[..48]).is_err());
        assert!(decode_dme_supplier_identity_bundle(&decode_hex(N20_BENCH_F102)[..48]).is_err());
    }

    #[test]
    fn decodes_mhd_dme_flash_counter_as_big_endian_u32() {
        assert_eq!(decode_dme_flash_counter(&[0x00, 0x00, 0x00, 0x05]), Some(5));
        assert_eq!(decode_dme_flash_counter(&[0x00, 0x01]), None);
        assert_eq!(
            decode_dme_flash_counter(&[0x00, 0x00, 0x00, 0x00, 0x05]),
            None
        );
    }

    #[test]
    fn decodes_captured_s55_f18b_ecu_date() {
        assert_eq!(
            decode_s55_ecu_manufacturing_date(&[0x14, 0x08, 0x07]),
            Ok("07/08/2014".into())
        );
        assert!(decode_s55_ecu_manufacturing_date(&[0x14, 0x19, 0x07]).is_err());
    }

    #[test]
    fn decodes_captured_s55_f186_diagnostic_session() {
        assert_eq!(
            decode_s55_dme_diagnostic_session(&[0x01, 0x81]),
            Ok("01 81".into())
        );
        assert!(decode_s55_dme_diagnostic_session(&[0x01]).is_err());
    }

    #[test]
    fn decodes_captured_s55_bmw_0205_identity_record() {
        let payload = [
            0x71, 0x01, 0x02, 0x05, 0x00, 0x00, 0x1A, 0x84, 0x1D, 0x28, 0x01, 0x23, b'M', b'E',
            b'V', b'D', b'1', b'7', b'.', b'2', b'.', b'G', 0x00, b'D', b'M', b'E', b'-', b'M',
            b'E', b'V', b'D', b'1', b'7', b'.', b'2', b'.', b'G', b'-', b'S', b'5', b'5', b'-',
            b'B', b'G', b'2', b'-', b'B', b'3', b'0', b'-', b'F', b'0', b'8', b'0', b'-', b'D',
            b'K', b'G', b'-', b'E', b'U', b'6', 0x00, b'6', b'M', b'C', b'9', b'E', b'D',
        ];
        let values = decode_bmw_routine_0205(&payload).unwrap();
        assert_eq!(values.software, "00001A84029040001");
        assert_eq!(values.controller_family, "MEVD17.2.G");
        assert_eq!(values.variant, "DME-MEVD17.2.G-S55-BG2-B30-F080-DKG-EU6");
        assert_eq!(values.transmission, "DKG");
        assert_eq!(values.emissions, "EU6");
        assert_eq!(values.internal_token, "6MC9ED");
    }

    #[test]
    fn builds_captured_mhd_0205_requests_from_current_bootloader_and_calibration_ids() {
        assert_eq!(
            build_bmw_routine_0205_request("00001CDB029150003", 0x08).unwrap(),
            [0x31, 0x01, 0x02, 0x05, 0x08, 0x00, 0x00, 0x1C, 0xDB, 0x1D, 0x96, 0x03]
        );
        assert_eq!(
            build_bmw_routine_0205_request("00001901001049002", 0x06).unwrap(),
            [0x31, 0x01, 0x02, 0x05, 0x06, 0x00, 0x00, 0x19, 0x01, 0x01, 0x31, 0x02]
        );
        assert!(build_bmw_routine_0205_request("00001901001049002", 0x07).is_err());
    }

    #[test]
    fn decodes_captured_mhd_n20_0205_calibration_response() {
        let mut payload = vec![
            0x71, 0x01, 0x02, 0x05, 0xFF, 0x01, 0x08, 0x00, 0x00, 0x1C, 0x9F, 0x1D, 0x96, 0x01,
            b'#',
        ];
        payload.extend_from_slice(b"MEVD17.2.9________#C1#DST#MEVD17.2.P-N20-Mo-B20-O0-F030-EU6-HGAG_-LL-RL____________________#9VT9G40B#9G4LAHX2");
        let values = decode_bmw_routine_0205(&payload).unwrap();
        assert_eq!(values.software, "00001C9F029150001");
        assert_eq!(values.controller_family, "MEVD17.2.9");
        assert!(values
            .variant
            .starts_with("MEVD17.2.P-N20-Mo-B20-O0-F030-EU6"));
        assert_eq!(values.emissions, "EU6");
    }

    #[test]
    fn decodes_captured_mhd_n20_0205_bootloader_response() {
        let mut payload = vec![
            0x71, 0x01, 0x02, 0x05, 0x50, 0x02, 0x01, 0x00, 0x00, 0x19, 0xA6, 0x01, 0x13, 0x03,
            0x01, 0x00, 0x00, 0x13, 0xE4, 0x01, 0x0C, 0x02, b'#',
        ];
        payload.extend_from_slice(b"DME-MEVD17.2.9_____#C1#BTL##MEVD17.2.9-CB_L6C-D6.2.0_G.5.18.1");
        let values = decode_bmw_routine_0205(&payload).unwrap();
        assert_eq!(values.controller_family, "MEVD17.2.9");
        assert_eq!(values.variant, "MEVD17.2.9-CB_L6C-D6.2.0_G.5.18.1");
    }

    #[test]
    fn merges_bmw_0205_results_from_calibration_and_bootloader_reads() {
        let mut calibration = BmwRoutine0205Values::default();
        calibration.raw_hex = "cal-raw".into();
        calibration.software = "software-id".into();
        calibration.controller_family = "MEVD17.2.9".into();
        calibration.variant = "MEVD17.2.P-N20".into();
        calibration.emissions = "EU6".into();
        let mut bootloader = BmwRoutine0205Values::default();
        bootloader.raw_hex = "boot-raw".into();
        bootloader.controller_family = "MEVD17.2.9".into();
        bootloader.variant = "MEVD17.2.9-CB".into();
        let values = merge_bmw_routine_0205_values(Some(calibration), Some(bootloader));
        assert_eq!(values.software, "software-id");
        assert_eq!(
            values.variant,
            "Software: MEVD17.2.P-N20; bootloader: MEVD17.2.9-CB"
        );
        assert_eq!(values.raw_hex, "CAL cal-raw | BTLD boot-raw");
        assert_eq!(values.emissions, "EU6");
    }

    #[test]
    fn describes_dtc_response_record_layout() {
        let definition = default_dtc_response_definition();
        assert_eq!(definition.request_sid, 0x19);
        assert_eq!(definition.subfunction, 0x02);
        assert_eq!(definition.response_sid, 0x59);
        assert_eq!(definition.record_length, 4);
        assert_eq!(definition.code_length, 3);
        assert_eq!(definition.status_mask, 0x0C);
        assert_eq!(build_dtc_read_request(), [0x19, 0x02, 0x0C]);
        assert!(parse_dtc_response(&[0x62, 0x02, 0, 0, 0, 0]).is_err());
    }

    #[test]
    fn preserves_raw_ecu_identification_data() {
        let identity = decode_ecu_identification(b"MEVD17.2.9\0".to_vec());
        assert_eq!(identity.display_value, "MEVD17.2.9\0");
        assert_eq!(identity.raw_data, b"MEVD17.2.9\0");
    }

    #[test]
    fn renders_binary_ecu_identification_as_hex() {
        let identity = decode_ecu_identification(vec![0x0F, 0x18, 0x10]);
        assert_eq!(identity.display_value, "0F 18 10");
        assert_eq!(identity.raw_data, [0x0F, 0x18, 0x10]);
    }

    #[test]
    fn defines_dtc_status_bits() {
        let definitions = default_dtc_status_definitions();
        assert_eq!(definitions.len(), 6);
        assert!(definitions
            .iter()
            .any(|item| item.mask == 0x08 && item.label == "Confirmed"));
    }

    #[test]
    fn exposes_only_the_confirmed_f82_s55_profile() {
        let profiles = confirmed_vehicle_profiles();
        assert_eq!(profiles.len(), 1);
        assert_eq!(profiles[0].id, "bmw_f82_s55");
        assert_eq!(profiles[0].gateway_address, "169.254.12.64");
        assert_eq!(profiles[0].diagnostic_port, 6801);
        assert_eq!(profiles[0].engine_ecu, 0x12);
        assert_eq!(profiles[0].clear_dtc_ecu, 0xDF);
    }

    #[test]
    fn decodes_raw_hsfz_capture_frames_for_offline_analysis() {
        let mut capture = build_hsfz(0x12, TESTER, &[0x62, 0xF1, 0x90, b'W']);
        capture.extend_from_slice(&build_hsfz(TESTER, 0xDF, &[0x14, 0xFF, 0xFF, 0xFF]));
        let frames = decode_raw_hsfz_capture(capture).unwrap();
        assert_eq!(frames.len(), 2);
        assert_eq!(frames[0].uds_hex, "62 F1 90 57");
        assert!(frames[0].application_response);
        assert!(!frames[1].application_response);
    }

    #[test]
    fn downloads_over_loopback_hsfz_with_fragmentation_echo_and_pending() {
        use crate::uds_download::{run_download, ExchangeJournal, ExchangeRecord};
        struct Log(Vec<ExchangeRecord>);
        impl ExchangeJournal for Log {
            fn append(&mut self, record: ExchangeRecord) -> Result<(), String> {
                self.0.push(record);
                Ok(())
            }
        }
        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let client = TcpStream::connect(listener.local_addr().unwrap()).unwrap();
        let worker = thread::spawn(move || {
            let (mut server, _) = listener.accept().unwrap();
            server
                .set_read_timeout(Some(Duration::from_secs(3)))
                .unwrap();
            for (expected, reply) in [
                (
                    vec![0x34, 0, 0x44, 0, 0, 0x10, 0, 0, 0, 0, 3],
                    vec![0x74, 0x10, 4],
                ),
                (vec![0x36, 1, 1, 2], vec![0x76, 1]),
                (vec![0x36, 2, 3], vec![0x76, 2]),
                (vec![0x37], vec![0x77]),
            ] {
                let mut header = [0u8; 6];
                server.read_exact(&mut header).unwrap();
                let len = u32::from_be_bytes(header[..4].try_into().unwrap()) as usize;
                assert!(len < 1024);
                let mut body = vec![0; len];
                server.read_exact(&mut body).unwrap();
                assert_eq!(&body[..2], &[TESTER, 0x12]);
                assert_eq!(&body[2..], expected);
                let mut echo = build_hsfz(0x12, TESTER, &expected);
                echo[5] = 2;
                server.write_all(&echo).unwrap();
                // A different ECU must not satisfy the request.
                server.write_all(&build_hsfz(0x20, TESTER, &reply)).unwrap();
                server
                    .write_all(&build_hsfz(0x12, TESTER, &[0x7f, expected[0], 0x78]))
                    .unwrap();
                let frame = build_hsfz(0x12, TESTER, &reply);
                for part in frame.chunks(3) {
                    server.write_all(part).unwrap();
                }
            }
        });
        let mut transport = DownloadHsfzTransport {
            stream: client,
            tester: TESTER,
            response_source: 0x12,
            target: 0x12,
            buffer: vec![],
            frames: VecDeque::new(),
            sid: None,
        };
        let mut log = Log(vec![]);
        let result = run_download(
            &mut transport,
            &mut log,
            0x1000,
            vec![1, 2, 3],
            64,
            Duration::from_secs(3),
        );
        worker.join().unwrap();
        result.unwrap();
        assert_eq!(log.0.last(), Some(&ExchangeRecord::TransferExited));
    }

    #[test]
    fn treats_lost_vehicle_network_as_terminal() {
        assert!(is_terminal_transport_error(
            "Network is unreachable (os error 101)"
        ));
        assert!(is_terminal_transport_error(
            "No route to host (os error 113)"
        ));
        assert!(!is_terminal_transport_error(
            "Software caused connection abort (os error 103)"
        ));
    }

    #[test]
    fn treats_a_brief_enet_route_loss_as_recoverable() {
        assert!(is_transient_network_configuration_error(
            "Network is unreachable (os error 101)"
        ));
        assert!(!is_transient_network_configuration_error(
            "Connection refused (os error 111)"
        ));
    }

    #[test]
    fn transport_capture_levels_and_correlation_are_structured() {
        let trace_session = format!(
            "transport-test-{}",
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_nanos()
        );
        configure_transport_diagnostics("trace".into(), trace_session.clone());
        raw_transport_log("TX", 0x0001, TESTER, 0x12, &[0x22, 0xF1, 0x90]);
        raw_transport_log("RX", 0x0001, 0x12, TESTER, &[0x7F, 0x22, 0x78]);
        raw_transport_log("RX", 0x0001, 0x12, TESTER, &[0x62, 0xF1, 0x90, 0x57]);

        let path = std::env::temp_dir().join("BimmerScope_Raw_HSFZ.log");
        let records = std::fs::read_to_string(&path)
            .unwrap()
            .lines()
            .filter_map(|line| serde_json::from_str::<Value>(line).ok())
            .filter(|record| record["sessionId"] == trace_session)
            .collect::<Vec<_>>();
        let frames = records
            .iter()
            .filter(|record| {
                record["type"] == "hsfz_frame"
                    && matches!(
                        record["payloadHex"].as_str(),
                        Some("22F190") | Some("62F19057")
                    )
            })
            .collect::<Vec<_>>();
        let matched = frames
            .iter()
            .find(|record| record["payloadHex"] == "62F19057" && record["correlation"] == "matched")
            .expect("correlated response record");
        let request_id = &matched["requestId"];
        let response_pending = records
            .iter()
            .find(|record| record["correlation"] == "response_pending")
            .expect("response-pending record");
        assert_eq!(&response_pending["requestId"], request_id);
        let pending = frames
            .iter()
            .find(|record| {
                record["payloadHex"] == "22F190"
                    && record["correlation"] == "pending"
                    && &record["requestId"] == request_id
            })
            .expect("matching request record");
        assert_eq!(pending["identifier"], "F190");

        let normal_session = format!("{trace_session}-normal");
        configure_transport_diagnostics("normal".into(), normal_session.clone());
        raw_transport_log("TX", 0x0001, TESTER, 0x12, &[0x22, 0xF1, 0x90]);
        let normal_records = std::fs::read_to_string(path).unwrap();
        assert!(normal_records.contains(&normal_session));
        assert!(!normal_records.lines().any(|line| {
            line.contains(&normal_session) && line.contains("\"type\":\"hsfz_frame\"")
        }));
    }

    #[test]
    fn live_poll_matching_requires_route_service_identifier_and_stage() {
        let sensor = default_sensors().remove(0);
        let pending = PendingLivePoll {
            id: 1,
            sensor: sensor.clone(),
            stage: LivePollStage::Define,
            started: Instant::now(),
        };
        let frame = |message_type, source, destination, uds: &[u8]| HsfzFrame {
            message_type,
            source,
            destination,
            uds: uds.to_vec(),
        };

        assert_eq!(
            match_live_poll_response(
                &frame(0x0001, sensor.ecu, TESTER, &[0x6C, 0x01, 0xF3, 0x00]),
                &pending,
            ),
            Some(LivePollResponse::Positive)
        );
        for unrelated in [
            frame(0x0002, sensor.ecu, TESTER, &[0x6C, 0x01, 0xF3, 0x00]),
            frame(0x0001, 0x20, TESTER, &[0x6C, 0x01, 0xF3, 0x00]),
            frame(0x0001, sensor.ecu, 0x00, &[0x6C, 0x01, 0xF3, 0x00]),
            frame(0x0001, sensor.ecu, TESTER, &[0x6C, 0x01, 0xF3, 0x01]),
            frame(0x0001, sensor.ecu, TESTER, &[0x62, 0xF3, 0x00, 0x12]),
            frame(0x0001, sensor.ecu, TESTER, &[0x7F, 0x22, 0x31]),
        ] {
            assert_eq!(match_live_poll_response(&unrelated, &pending), None);
        }

        let read_pending = PendingLivePoll {
            id: 2,
            sensor: sensor.clone(),
            stage: LivePollStage::Read,
            started: Instant::now(),
        };
        assert_eq!(
            match_live_poll_response(
                &frame(0x0001, sensor.ecu, TESTER, &[0x62, 0xF3, 0x00, 0x12]),
                &read_pending,
            ),
            Some(LivePollResponse::Positive)
        );
        assert_eq!(
            match_live_poll_response(
                &frame(0x0001, sensor.ecu, TESTER, &[0x7F, 0x22, 0x78]),
                &read_pending,
            ),
            Some(LivePollResponse::Pending)
        );
        assert_eq!(
            match_live_poll_response(
                &frame(0x0001, sensor.ecu, TESTER, &[0x7F, 0x22, 0x31]),
                &read_pending,
            ),
            Some(LivePollResponse::Negative(0x31))
        );

        let clear_pending = PendingLivePoll {
            id: 3,
            sensor,
            stage: LivePollStage::Clear,
            started: Instant::now(),
        };
        assert_eq!(
            match_live_poll_response(
                &frame(
                    0x0001,
                    clear_pending.sensor.ecu,
                    TESTER,
                    &[0x6C, 0x03, 0xF3, 0x00]
                ),
                &clear_pending,
            ),
            Some(LivePollResponse::Positive)
        );
        assert_eq!(
            match_live_poll_response(
                &frame(
                    0x0001,
                    clear_pending.sensor.ecu,
                    TESTER,
                    &[0x6C, 0x01, 0xF3, 0x00]
                ),
                &clear_pending,
            ),
            None
        );
    }

    #[test]
    fn diagnostic_reader_ignores_matching_payload_from_wrong_ecu() {
        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let mut client = TcpStream::connect(listener.local_addr().unwrap()).unwrap();
        client
            .set_read_timeout(Some(Duration::from_millis(100)))
            .unwrap();
        let worker = thread::spawn(move || {
            let (mut server, _) = listener.accept().unwrap();
            server
                .write_all(&build_hsfz(0x20, TESTER, &[0x62, 0xF1, 0x90, b'X']))
                .unwrap();
            server
                .write_all(&build_hsfz(0x12, TESTER, &[0x62, 0xF1, 0x90, b'W']))
                .unwrap();
        });
        let response = read_matching_uds_response(
            &mut client,
            0x12,
            &[0x62, 0xF1, 0x90],
            &[0x22],
            Duration::from_secs(1),
        )
        .unwrap();
        worker.join().unwrap();
        assert_eq!(response, [0x62, 0xF1, 0x90, b'W']);
    }

    #[test]
    fn sensor_event_carries_request_and_recovery_evidence() {
        let sensor = default_sensors().remove(0);
        let event =
            VehicleEvent::sensor_with_transport(&sensor, 123, 42, Duration::from_millis(3119), 1);
        assert_eq!(event.transport_request_id, 42);
        assert_eq!(event.transport_request_operation, "read_dynamic_did:F300");
        assert_eq!(event.transport_request_age_ms, 3119);
        assert_eq!(event.transport_retry_count, 1);
        assert_eq!(event.transport_socket_state, "connected");
        assert_eq!(
            event.transport_recovery_action,
            "tcp_reconnect_and_reidentify"
        );
        assert_eq!(event.transport_recovery_result, "telemetry_resumed");
    }
}

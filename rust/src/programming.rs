//! Offline development runner. No network transport or production ECU profile.
//! The synthetic procedure is not an S55 programming sequence.
#![allow(dead_code)]
use crate::vehicle_access::VehicleAccess;
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{self, Write};
use std::path::Path;

/// An operation owns a new journal; existing evidence cannot be overwritten.
pub(crate) struct Journal {
    file: File,
    sequence: usize,
    started: bool,
    failed: bool,
    #[cfg(test)]
    fail_at: Option<usize>,
}

impl Journal {
    pub(crate) fn create(path: &Path) -> io::Result<Self> {
        let file = OpenOptions::new().write(true).create_new(true).open(path)?;
        let mut journal = Self {
            file,
            sequence: 0,
            started: false,
            failed: false,
            #[cfg(test)]
            fail_at: None,
        };
        journal.record("synthetic-operation-v1")?;
        Ok(journal)
    }

    fn record(&mut self, event: &str) -> io::Result<()> {
        if self.failed {
            return Err(io::Error::other("Operation journal previously failed"));
        }
        #[cfg(test)]
        if self.fail_at == Some(self.sequence) {
            self.failed = true;
            return Err(io::Error::other("Injected journal storage failure"));
        }
        let result =
            writeln!(self.file, "{} {}", self.sequence, event).and_then(|_| self.file.sync_all());
        if let Err(error) = result {
            self.failed = true;
            return Err(error);
        }
        self.sequence += 1;
        Ok(())
    }
}

#[derive(Clone)]
pub(crate) struct ExactIdentity<'a> {
    pub vin: &'a str,
    pub family: &'a str,
    pub bosch_hardware: &'a str,
    pub bmw_hardware: &'a str,
    pub software: &'a str,
    pub calibration: &'a str,
    pub bootloader: &'a str,
}

pub(crate) struct SupportProfile<'a> {
    backend_id: &'a str,
    evidence_id: &'a str,
    recovery_id: &'a str,
    identity: ExactIdentity<'a>,
    region_size: usize,
    chunk_size: usize,
}

struct SupportDefinition {
    backend_id: &'static str,
    evidence_id: &'static str,
    recovery_id: &'static str,
    vin: &'static str,
    family: &'static str,
    bosch_hardware: &'static str,
    bmw_hardware: &'static str,
    software: &'static str,
    calibration: &'static str,
    bootloader: &'static str,
    region_size: usize,
    chunk_size: usize,
}

/// Production entries require a reviewed bench evidence bundle and recovery
/// procedure. No S55 combination has met those conditions yet.
const APPROVED_SUPPORT_PROFILES: &[SupportDefinition] = &[];

pub(crate) fn lookup_approved_support(
    identity: &ExactIdentity<'_>,
) -> Option<SupportProfile<'static>> {
    APPROVED_SUPPORT_PROFILES.iter().find_map(|definition| {
        let candidate = ExactIdentity {
            vin: definition.vin,
            family: definition.family,
            bosch_hardware: definition.bosch_hardware,
            bmw_hardware: definition.bmw_hardware,
            software: definition.software,
            calibration: definition.calibration,
            bootloader: definition.bootloader,
        };
        same_identity(identity, &candidate).then_some(SupportProfile {
            backend_id: definition.backend_id,
            evidence_id: definition.evidence_id,
            recovery_id: definition.recovery_id,
            identity: candidate,
            region_size: definition.region_size,
            chunk_size: definition.chunk_size,
        })
    })
}

#[cfg(test)]
impl<'a> SupportProfile<'a> {
    fn synthetic(identity: ExactIdentity<'a>, region_size: usize, chunk_size: usize) -> Self {
        Self {
            backend_id: "synthetic-backend-v1",
            evidence_id: "synthetic-evidence",
            recovery_id: "synthetic-recovery",
            identity,
            region_size,
            chunk_size,
        }
    }
}

pub(crate) struct OperationRequest<'a> {
    pub operation_id: &'a str,
    pub identity: ExactIdentity<'a>,
    pub payload_sha256: &'a str,
    pub backup_sha256: &'a str,
}

fn sha256_hex(bytes: &[u8]) -> String {
    Sha256::digest(bytes)
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect()
}

fn safe_token(value: &str) -> bool {
    !value.is_empty()
        && value
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || b"._:-".contains(&byte))
}

fn valid_sha256(value: &str) -> bool {
    value.len() == 64 && value.bytes().all(|byte| byte.is_ascii_hexdigit())
}

fn valid_operation_event(event: &str) -> bool {
    let fields = event.split_whitespace().collect::<Vec<_>>();
    fields.len() == 14
        && fields[0] == "operation"
        && fields[1..12].iter().all(|value| safe_token(value))
        && valid_sha256(fields[12])
        && valid_sha256(fields[13])
}

fn same_identity(left: &ExactIdentity<'_>, right: &ExactIdentity<'_>) -> bool {
    left.vin.eq_ignore_ascii_case(right.vin)
        && left.family == right.family
        && left.bosch_hardware == right.bosch_hardware
        && left.bmw_hardware == right.bmw_hardware
        && left.software == right.software
        && left.calibration == right.calibration
        && left.bootloader == right.bootloader
}

#[derive(Debug)]
struct TargetIdentity {
    vin: String,
    family: String,
    bosch_hardware: String,
    bmw_hardware: String,
    software: String,
    calibration: String,
    bootloader: String,
}

fn target_identity_matches(target: &TargetIdentity, expected: &ExactIdentity<'_>) -> bool {
    target.vin.eq_ignore_ascii_case(expected.vin)
        && target.family == expected.family
        && target.bosch_hardware == expected.bosch_hardware
        && target.bmw_hardware == expected.bmw_hardware
        && target.software == expected.software
        && target.calibration == expected.calibration
        && target.bootloader == expected.bootloader
}

fn validate_binding(
    request: &OperationRequest<'_>,
    support: &SupportProfile<'_>,
    payload: &[u8],
    backup: &[u8],
) -> Result<(), String> {
    let tokens = [
        request.operation_id,
        support.backend_id,
        support.evidence_id,
        support.recovery_id,
        request.identity.vin,
        request.identity.family,
        request.identity.bosch_hardware,
        request.identity.bmw_hardware,
        request.identity.software,
        request.identity.calibration,
        request.identity.bootloader,
    ];
    if !tokens.into_iter().all(safe_token) {
        return Err("Operation identity contains an invalid token".into());
    }
    if !same_identity(&request.identity, &support.identity) {
        return Err("Operation identity is not supported by this backend profile".into());
    }
    if payload.len() != support.region_size
        || backup.len() != support.region_size
        || support.chunk_size == 0
        || sha256_hex(payload) != request.payload_sha256.to_ascii_lowercase()
        || sha256_hex(backup) != request.backup_sha256.to_ascii_lowercase()
    {
        return Err("Artifact bytes do not match the supported operation request".into());
    }
    Ok(())
}

fn operation_event(request: &OperationRequest<'_>, support: &SupportProfile<'_>) -> String {
    format!(
        "operation {} {} {} {} {} {} {} {} {} {} {} {} {}",
        request.operation_id,
        support.backend_id,
        support.evidence_id,
        support.recovery_id,
        request.identity.vin.to_ascii_uppercase(),
        request.identity.family,
        request.identity.bosch_hardware,
        request.identity.bmw_hardware,
        request.identity.software,
        request.identity.calibration,
        request.identity.bootloader,
        request.payload_sha256.to_ascii_lowercase(),
        request.backup_sha256.to_ascii_lowercase(),
    )
}

#[derive(Debug, PartialEq)]
pub(crate) enum Outcome {
    Verified,
    /// A mutating action was attempted; its actual state must be inspected.
    RecoveryRequired,
}

#[derive(Debug, PartialEq)]
pub(crate) enum RecordedStatus {
    InterruptedBeforeMutation,
    RecoveryRequired,
    Complete,
    Corrupt,
}

#[derive(Debug, PartialEq)]
pub(crate) struct Inspection {
    pub status: RecordedStatus,
    pub last_event: Option<String>,
}

#[derive(Debug, PartialEq)]
pub(crate) enum RecoveryDirective {
    NoAction,
    AbandonBeforeMutation,
    InspectTargetState,
    ReverifyTarget,
    UseDocumentedRecovery,
    ManualEvidenceReview,
}

/// Converts durable evidence into a conservative next action. This function
/// performs no I/O and never authorizes automatic retry or resume.
pub(crate) fn recovery_directive(inspection: &Inspection) -> RecoveryDirective {
    match inspection.status {
        RecordedStatus::Complete => RecoveryDirective::NoAction,
        RecordedStatus::Corrupt => RecoveryDirective::ManualEvidenceReview,
        RecordedStatus::InterruptedBeforeMutation => RecoveryDirective::AbandonBeforeMutation,
        RecordedStatus::RecoveryRequired => {
            let last = inspection.last_event.as_deref().unwrap_or_default();
            if last == "verify-intent"
                || last.starts_with("verify-result ")
                || last.contains("readback-mismatch")
            {
                RecoveryDirective::ReverifyTarget
            } else if last.starts_with("transfer-intent ") || last.starts_with("restore-intent ") {
                RecoveryDirective::InspectTargetState
            } else {
                RecoveryDirective::UseDocumentedRecovery
            }
        }
    }
}

/// Inspects durable evidence after restart. It never opens a target and never
/// resumes an operation. Once erase intent exists, uncertainty requires
/// recovery because the action may have reached the target before a crash.
pub(crate) fn inspect_journal(path: &Path) -> Inspection {
    let corrupt = |last_event| Inspection {
        status: RecordedStatus::Corrupt,
        last_event,
    };
    let bytes = match std::fs::read(path) {
        Ok(bytes) => bytes,
        Err(_) => return corrupt(None),
    };
    if bytes.is_empty() || !bytes.ends_with(b"\n") {
        return corrupt(None);
    }
    let text = match std::str::from_utf8(&bytes) {
        Ok(text) => text,
        Err(_) => return corrupt(None),
    };
    let mut events = Vec::new();
    for (expected, line) in text.lines().enumerate() {
        let Some((sequence, event)) = line.split_once(' ') else {
            return corrupt(events.last().cloned());
        };
        if sequence.parse::<usize>().ok() != Some(expected) || event.is_empty() {
            return corrupt(events.last().cloned());
        }
        events.push(event.to_string());
    }
    if events.first().map(String::as_str) != Some("synthetic-operation-v1") {
        return corrupt(events.last().cloned());
    }
    let last = events.last().cloned();
    let body = &events[1..];
    if body
        .first()
        .is_some_and(|event| event.starts_with("recovery "))
    {
        let fields = body[0].split_whitespace().collect::<Vec<_>>();
        if fields.len() != 6
            || fields[0] != "recovery"
            || !fields[1..5].iter().all(|value| safe_token(value))
            || !valid_sha256(fields[5])
        {
            return corrupt(last);
        }
        let recovery = &body[1..];
        if recovery.is_empty() || recovery == ["recovery-preflight-accepted"] {
            return Inspection {
                status: RecordedStatus::InterruptedBeforeMutation,
                last_event: last,
            };
        }
        let known = |event: &str| {
            event == "recovery-preflight-accepted"
                || event == "recovery-prepare-intent"
                || event == "recovery-prepare-result"
                || event.starts_with("restore-intent ")
                || event.starts_with("restore-result ")
                || event == "verify-intent"
                || event == "verify-result matching-backup"
                || event == "recovery-finalize-intent"
                || event == "recovery-finalize-result"
                || event.starts_with("recovery-required ")
                || event == "complete"
        };
        if recovery.first().map(String::as_str) != Some("recovery-preflight-accepted")
            || !recovery.iter().all(|event| known(event))
        {
            return corrupt(last);
        }
        let terminals = recovery
            .iter()
            .enumerate()
            .filter(|(_, event)| {
                event.as_str() == "complete" || event.starts_with("recovery-required ")
            })
            .collect::<Vec<_>>();
        if terminals.len() > 1
            || terminals
                .first()
                .is_some_and(|(position, _)| *position != recovery.len() - 1)
        {
            return corrupt(last);
        }
        if recovery.last().map(String::as_str) == Some("complete") {
            return if recovery
                .get(recovery.len().saturating_sub(2))
                .map(String::as_str)
                == Some("recovery-finalize-result")
            {
                Inspection {
                    status: RecordedStatus::Complete,
                    last_event: last,
                }
            } else {
                corrupt(last)
            };
        }
        return Inspection {
            status: if recovery
                .last()
                .is_some_and(|event| event.starts_with("recovery-required "))
                || recovery
                    .iter()
                    .any(|event| event.starts_with("restore-intent "))
            {
                RecordedStatus::RecoveryRequired
            } else {
                RecordedStatus::InterruptedBeforeMutation
            },
            last_event: last,
        };
    }
    let body = if body
        .first()
        .is_some_and(|event| event.starts_with("operation "))
    {
        if !valid_operation_event(&body[0]) {
            return corrupt(last);
        }
        &body[1..]
    } else {
        body
    };
    if body.is_empty() || body == ["preflight-accepted"] {
        return Inspection {
            status: RecordedStatus::InterruptedBeforeMutation,
            last_event: last,
        };
    }
    if body.first().map(String::as_str) != Some("preflight-accepted") {
        return corrupt(last);
    }
    let known = |event: &str| {
        event == "preflight-accepted"
            || event == "prepare-intent"
            || event == "prepare-result"
            || event == "erase-intent"
            || event == "erase-result"
            || event.starts_with("transfer-intent ")
            || event.starts_with("transfer-result ")
            || event == "verify-intent"
            || event == "verify-result matching-bytes"
            || event == "finalize-intent"
            || event == "finalize-result"
            || event.starts_with("recovery-required ")
            || event.starts_with("aborted-before-mutation ")
            || event == "complete"
    };
    if !body.iter().all(|event| known(event)) {
        return corrupt(last);
    }
    let terminals = body
        .iter()
        .enumerate()
        .filter(|(_, event)| {
            event.as_str() == "complete"
                || event.starts_with("recovery-required ")
                || event.starts_with("aborted-before-mutation ")
        })
        .collect::<Vec<_>>();
    if terminals.len() > 1
        || terminals
            .first()
            .is_some_and(|(position, _)| *position != body.len() - 1)
    {
        return corrupt(last);
    }
    if body.last().map(String::as_str) == Some("complete") {
        let previous = body.get(body.len().saturating_sub(2)).map(String::as_str);
        if previous != Some("verify-result matching-bytes") && previous != Some("finalize-result") {
            return corrupt(last);
        }
        return Inspection {
            status: RecordedStatus::Complete,
            last_event: last,
        };
    }
    if body
        .last()
        .is_some_and(|event| event.starts_with("aborted-before-mutation "))
    {
        return Inspection {
            status: RecordedStatus::InterruptedBeforeMutation,
            last_event: last,
        };
    }
    Inspection {
        status: RecordedStatus::RecoveryRequired,
        last_event: last,
    }
}

#[derive(Default)]
pub(crate) struct Faults {
    pub fail_after_chunk: Option<usize>,
    pub corrupt_readback: bool,
    pub reject_erase: bool,
    pub lose_erase_acknowledgement: bool,
    pub report_wrong_identity: bool,
    writes: usize,
}

#[derive(Clone, Copy)]
enum ReadPurpose {
    Preflight,
    Verify,
}

#[derive(Clone, Copy)]
enum OperationMode {
    Programming,
    Recovery,
}

#[derive(Debug)]
enum TargetFailure {
    Rejected(String),
    OutcomeUnknown(String),
}

trait ProgrammingTarget {
    fn begin_operation(&mut self);
    fn region_len(&self) -> usize;
    fn read_identity(&mut self) -> Result<TargetIdentity, TargetFailure>;
    fn read_region(&mut self, purpose: ReadPurpose) -> Result<Vec<u8>, TargetFailure>;
    fn prepare(&mut self, mode: OperationMode) -> Result<(), TargetFailure>;
    fn erase(&mut self) -> Result<(), TargetFailure>;
    fn write_chunk(&mut self, offset: usize, bytes: &[u8]) -> Result<(), TargetFailure>;
    fn finalize(&mut self, mode: OperationMode) -> Result<(), TargetFailure>;
}

/// Fixed-size synthetic memory. Owned bytes isolate tests from vehicle I/O.
pub(crate) struct MemoryTarget {
    pub bytes: Vec<u8>,
    pub faults: Faults,
}

impl ProgrammingTarget for MemoryTarget {
    fn begin_operation(&mut self) {
        self.faults.writes = 0;
    }

    fn region_len(&self) -> usize {
        self.bytes.len()
    }

    fn read_identity(&mut self) -> Result<TargetIdentity, TargetFailure> {
        Ok(TargetIdentity {
            vin: "WBS00000000000000".into(),
            family: "MEVD17.2.G".into(),
            bosch_hardware: "0261S00000".into(),
            bmw_hardware: "1234567".into(),
            software: if self.faults.report_wrong_identity {
                "OTHER"
            } else {
                "SW-TEST"
            }
            .into(),
            calibration: "CAL-TEST".into(),
            bootloader: "BOOT-TEST".into(),
        })
    }

    fn read_region(&mut self, purpose: ReadPurpose) -> Result<Vec<u8>, TargetFailure> {
        let mut bytes = self.bytes.clone();
        if matches!(purpose, ReadPurpose::Verify) && self.faults.corrupt_readback {
            bytes[0] ^= 1;
        }
        Ok(bytes)
    }

    fn prepare(&mut self, _mode: OperationMode) -> Result<(), TargetFailure> {
        Ok(())
    }

    fn erase(&mut self) -> Result<(), TargetFailure> {
        if self.faults.reject_erase {
            return Err(TargetFailure::Rejected("erase-rejected".into()));
        }
        self.bytes.fill(0xff);
        if self.faults.lose_erase_acknowledgement {
            return Err(TargetFailure::OutcomeUnknown(
                "erase-acknowledgement-lost".into(),
            ));
        }
        Ok(())
    }

    fn write_chunk(&mut self, offset: usize, bytes: &[u8]) -> Result<(), TargetFailure> {
        let end = offset
            .checked_add(bytes.len())
            .ok_or_else(|| TargetFailure::Rejected("Chunk range overflow".into()))?;
        if end > self.bytes.len() {
            return Err(TargetFailure::Rejected(
                "Chunk exceeds target region".into(),
            ));
        }
        self.bytes[offset..end].copy_from_slice(bytes);
        let write = self.faults.writes;
        self.faults.writes += 1;
        if self.faults.fail_after_chunk == Some(write) {
            return Err(TargetFailure::OutcomeUnknown(
                "chunk-acknowledgement-lost".into(),
            ));
        }
        Ok(())
    }

    fn finalize(&mut self, _mode: OperationMode) -> Result<(), TargetFailure> {
        Ok(())
    }
}

/// Entry point for the synthetic programming fixture. It binds exact support
/// and content hashes into durable evidence before any mutating intent.
fn run_bound<T: ProgrammingTarget>(
    access: &VehicleAccess,
    target: &mut T,
    payload: &[u8],
    backup: &[u8],
    request: &OperationRequest<'_>,
    support: &SupportProfile<'_>,
    journal: &mut Journal,
) -> Result<Outcome, String> {
    validate_binding(request, support, payload, backup)?;
    journal
        .record(&operation_event(request, support))
        .map_err(|error| error.to_string())?;
    run_transfer(
        access,
        target,
        payload,
        backup,
        support.chunk_size,
        Some(&support.identity),
        journal,
    )
}

/// Explicit synthetic restore. The source journal and backup must match the
/// original bound operation. It never resumes the interrupted transfer.
fn run_recovery<T: ProgrammingTarget>(
    access: &VehicleAccess,
    target: &mut T,
    backup: &[u8],
    source_journal: &Path,
    request: &OperationRequest<'_>,
    support: &SupportProfile<'_>,
    journal: &mut Journal,
) -> Result<Outcome, String> {
    if inspect_journal(source_journal).status != RecordedStatus::RecoveryRequired {
        return Err("Source operation does not require recovery".into());
    }
    let source = std::fs::read_to_string(source_journal).map_err(|error| error.to_string())?;
    if !source.lines().any(|line| {
        line.split_once(' ')
            .is_some_and(|(_, event)| event == operation_event(request, support))
    }) || backup.len() != support.region_size
        || target.region_len() != support.region_size
        || sha256_hex(backup) != request.backup_sha256.to_ascii_lowercase()
        || !same_identity(&request.identity, &support.identity)
    {
        return Err("Recovery evidence or backup does not match the source operation".into());
    }
    let _lease = access.programming()?;
    if journal.started || journal.failed {
        return Err("Recovery journal cannot be reused".into());
    }
    journal.started = true;
    target.begin_operation();
    let live_identity = target
        .read_identity()
        .map_err(|_| "Unable to read target identity for recovery".to_string())?;
    if !target_identity_matches(&live_identity, &support.identity) {
        return Err("Fresh target identity does not match the recovery profile".into());
    }
    let mut record = |event: &str| journal.record(event).map_err(|error| error.to_string());
    record(&format!(
        "recovery {} {} {} {} {}",
        request.operation_id,
        support.backend_id,
        support.evidence_id,
        support.recovery_id,
        request.backup_sha256.to_ascii_lowercase(),
    ))?;
    record("recovery-preflight-accepted")?;
    record("recovery-prepare-intent")?;
    if let Err(error) = target.prepare(OperationMode::Recovery) {
        let detail = match error {
            TargetFailure::Rejected(detail) => detail,
            TargetFailure::OutcomeUnknown(detail) => detail,
        };
        record(&format!("recovery-required {detail}"))?;
        return Ok(Outcome::RecoveryRequired);
    }
    record("recovery-prepare-result")?;
    for (index, chunk) in backup.chunks(support.chunk_size).enumerate() {
        let start = index * support.chunk_size;
        record(&format!("restore-intent {start} {}", chunk.len()))?;
        if let Err(error) = target.write_chunk(start, chunk) {
            let detail = match error {
                TargetFailure::Rejected(detail) => detail,
                TargetFailure::OutcomeUnknown(detail) => detail,
            };
            record(&format!("recovery-required {detail}"))?;
            return Ok(Outcome::RecoveryRequired);
        }
        record(&format!("restore-result {start} {}", chunk.len()))?;
    }
    record("verify-intent")?;
    let readback = match target.read_region(ReadPurpose::Verify) {
        Ok(bytes) => bytes,
        Err(_) => {
            record("recovery-required restored-readback-unavailable")?;
            return Ok(Outcome::RecoveryRequired);
        }
    };
    if readback != backup {
        record("recovery-required restored-readback-mismatch")?;
        return Ok(Outcome::RecoveryRequired);
    }
    record("verify-result matching-backup")?;
    record("recovery-finalize-intent")?;
    if let Err(error) = target.finalize(OperationMode::Recovery) {
        let detail = match error {
            TargetFailure::Rejected(detail) => detail,
            TargetFailure::OutcomeUnknown(detail) => detail,
        };
        record(&format!("recovery-required {detail}"))?;
        return Ok(Outcome::RecoveryRequired);
    }
    record("recovery-finalize-result")?;
    record("complete")?;
    Ok(Outcome::Verified)
}

/// This runner requires durable evidence and exclusive access. A failed action
/// is never retried. A storage error propagates with an unfinished journal.
fn run_transfer<T: ProgrammingTarget>(
    access: &VehicleAccess,
    target: &mut T,
    payload: &[u8],
    backup: &[u8],
    chunk_size: usize,
    expected_identity: Option<&ExactIdentity<'_>>,
    journal: &mut Journal,
) -> Result<Outcome, String> {
    let _lease = access.programming()?;
    if journal.started || journal.failed {
        return Err("Operation journal cannot be reused".into());
    }
    journal.started = true;
    if payload.is_empty() || payload.len() != target.region_len() || chunk_size == 0 {
        return Err("Synthetic target, backup or transfer size mismatch".into());
    }
    target.begin_operation();
    if let Some(expected) = expected_identity {
        let live_identity = target
            .read_identity()
            .map_err(|_| "Unable to read fresh target identity".to_string())?;
        if !target_identity_matches(&live_identity, expected) {
            return Err("Fresh target identity does not match the supported profile".into());
        }
    }
    let current = target
        .read_region(ReadPurpose::Preflight)
        .map_err(|_| "Unable to read target before mutation".to_string())?;
    if backup != current {
        return Err("Synthetic target, backup or transfer size mismatch".into());
    }
    let mut record = |event: &str| journal.record(event).map_err(|e| e.to_string());
    record("preflight-accepted")?;
    if expected_identity.is_some() {
        record("prepare-intent")?;
        if let Err(error) = target.prepare(OperationMode::Programming) {
            return match error {
                TargetFailure::Rejected(detail) => {
                    record(&format!("aborted-before-mutation {detail}"))?;
                    Err("Target rejected programming preparation".into())
                }
                TargetFailure::OutcomeUnknown(detail) => {
                    record(&format!("recovery-required {detail}"))?;
                    Ok(Outcome::RecoveryRequired)
                }
            };
        }
        record("prepare-result")?;
    }
    record("erase-intent")?;
    if let Err(error) = target.erase() {
        return match error {
            TargetFailure::Rejected(detail) => {
                record(&format!("aborted-before-mutation {detail}"))?;
                Err("Target rejected erase before mutation".into())
            }
            TargetFailure::OutcomeUnknown(detail) => {
                record(&format!("recovery-required {detail}"))?;
                Ok(Outcome::RecoveryRequired)
            }
        };
    }
    record("erase-result")?;
    for (index, chunk) in payload.chunks(chunk_size).enumerate() {
        let start = index * chunk_size;
        record(&format!("transfer-intent {start} {}", chunk.len()))?;
        if let Err(error) = target.write_chunk(start, chunk) {
            let detail = match error {
                TargetFailure::Rejected(detail) => detail,
                TargetFailure::OutcomeUnknown(detail) => detail,
            };
            record(&format!("recovery-required {detail}"))?;
            return Ok(Outcome::RecoveryRequired);
        }
        record(&format!("transfer-result {start} {}", chunk.len()))?;
    }
    record("verify-intent")?;
    let readback = match target.read_region(ReadPurpose::Verify) {
        Ok(bytes) => bytes,
        Err(_) => {
            record("recovery-required readback-unavailable")?;
            return Ok(Outcome::RecoveryRequired);
        }
    };
    if readback != payload {
        record("recovery-required readback-mismatch")?;
        return Ok(Outcome::RecoveryRequired);
    }
    record("verify-result matching-bytes")?;
    if expected_identity.is_some() {
        record("finalize-intent")?;
        if let Err(error) = target.finalize(OperationMode::Programming) {
            let detail = match error {
                TargetFailure::Rejected(detail) => detail,
                TargetFailure::OutcomeUnknown(detail) => detail,
            };
            record(&format!("recovery-required {detail}"))?;
            return Ok(Outcome::RecoveryRequired);
        }
        record("finalize-result")?;
    }
    record("complete")?;
    Ok(Outcome::Verified)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::{AtomicU64, Ordering};
    static NEXT: AtomicU64 = AtomicU64::new(0);

    fn identity(software: &str) -> ExactIdentity<'_> {
        ExactIdentity {
            vin: "WBS00000000000000",
            family: "MEVD17.2.G",
            bosch_hardware: "0261S00000",
            bmw_hardware: "1234567",
            software,
            calibration: "CAL-TEST",
            bootloader: "BOOT-TEST",
        }
    }

    struct Fixture(std::path::PathBuf);
    impl Fixture {
        fn new() -> Self {
            Self(std::env::temp_dir().join(format!(
                    "bimmerscope-rust-{}-{}-{}.journal",
                    std::process::id(),
                    std::time::SystemTime::now()
                        .duration_since(std::time::UNIX_EPOCH)
                        .unwrap()
                        .as_nanos(),
                    NEXT.fetch_add(1, Ordering::Relaxed)
                )))
        }
    }
    impl Drop for Fixture {
        fn drop(&mut self) {
            let _ = std::fs::remove_file(&self.0);
        }
    }

    #[test]
    fn production_registry_has_no_unverified_s55_profile() {
        assert!(lookup_approved_support(&identity("SW-TEST")).is_none());
        assert!(APPROVED_SUPPORT_PROFILES.is_empty());
    }

    #[test]
    fn stage_specific_directives_never_imply_retry_or_resume() {
        let cases = [
            (
                RecordedStatus::Complete,
                Some("complete"),
                RecoveryDirective::NoAction,
            ),
            (
                RecordedStatus::InterruptedBeforeMutation,
                Some("preflight-accepted"),
                RecoveryDirective::AbandonBeforeMutation,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("erase-intent"),
                RecoveryDirective::UseDocumentedRecovery,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("transfer-intent 3 3"),
                RecoveryDirective::InspectTargetState,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("transfer-result 3 3"),
                RecoveryDirective::UseDocumentedRecovery,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("verify-intent"),
                RecoveryDirective::ReverifyTarget,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("recovery-required readback-mismatch"),
                RecoveryDirective::ReverifyTarget,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("restore-intent 0 3"),
                RecoveryDirective::InspectTargetState,
            ),
            (
                RecordedStatus::RecoveryRequired,
                Some("restore-result 0 3"),
                RecoveryDirective::UseDocumentedRecovery,
            ),
            (
                RecordedStatus::Corrupt,
                None,
                RecoveryDirective::ManualEvidenceReview,
            ),
        ];
        for (status, last_event, expected) in cases {
            assert_eq!(
                recovery_directive(&Inspection {
                    status,
                    last_event: last_event.map(str::to_string),
                }),
                expected
            );
        }
    }

    #[test]
    fn confirmed_erase_rejection_and_unknown_outcome_are_distinct() {
        for unknown in [false, true] {
            let fixture = Fixture::new();
            let mut journal = Journal::create(&fixture.0).unwrap();
            let mut target = MemoryTarget {
                bytes: vec![0; 7],
                faults: Faults {
                    reject_erase: !unknown,
                    lose_erase_acknowledgement: unknown,
                    ..Faults::default()
                },
            };
            let result = run_transfer(
                &VehicleAccess::default(),
                &mut target,
                &[1; 7],
                &[0; 7],
                3,
                None,
                &mut journal,
            );
            let inspection = inspect_journal(&fixture.0);
            if unknown {
                assert_eq!(result.unwrap(), Outcome::RecoveryRequired);
                assert_eq!(target.bytes, vec![0xff; 7]);
                assert_eq!(inspection.status, RecordedStatus::RecoveryRequired);
                assert_eq!(
                    recovery_directive(&inspection),
                    RecoveryDirective::UseDocumentedRecovery
                );
            } else {
                assert!(result.is_err());
                assert_eq!(target.bytes, vec![0; 7]);
                assert_eq!(inspection.status, RecordedStatus::InterruptedBeforeMutation);
                assert_eq!(
                    recovery_directive(&inspection),
                    RecoveryDirective::AbandonBeforeMutation
                );
            }
        }
    }

    #[test]
    fn fresh_target_identity_mismatch_blocks_programming_and_recovery() {
        let payload = [1; 7];
        let backup = [0; 7];
        let payload_hash = sha256_hex(&payload);
        let backup_hash = sha256_hex(&backup);
        let request = OperationRequest {
            operation_id: "operation-live-identity",
            identity: identity("SW-TEST"),
            payload_sha256: &payload_hash,
            backup_sha256: &backup_hash,
        };
        let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
        let access = VehicleAccess::default();

        let blocked_fixture = Fixture::new();
        let mut blocked_journal = Journal::create(&blocked_fixture.0).unwrap();
        let mut blocked_target = MemoryTarget {
            bytes: backup.to_vec(),
            faults: Faults {
                report_wrong_identity: true,
                ..Faults::default()
            },
        };
        assert!(run_bound(
            &access,
            &mut blocked_target,
            &payload,
            &backup,
            &request,
            &support,
            &mut blocked_journal,
        )
        .is_err());
        assert_eq!(blocked_target.bytes, backup);
        assert_eq!(
            inspect_journal(&blocked_fixture.0).status,
            RecordedStatus::InterruptedBeforeMutation
        );

        let source_fixture = Fixture::new();
        let mut source_journal = Journal::create(&source_fixture.0).unwrap();
        let mut recovery_target = MemoryTarget {
            bytes: backup.to_vec(),
            faults: Faults {
                fail_after_chunk: Some(0),
                ..Faults::default()
            },
        };
        assert_eq!(
            run_bound(
                &access,
                &mut recovery_target,
                &payload,
                &backup,
                &request,
                &support,
                &mut source_journal,
            )
            .unwrap(),
            Outcome::RecoveryRequired
        );
        let before = recovery_target.bytes.clone();
        recovery_target.faults = Faults {
            report_wrong_identity: true,
            ..Faults::default()
        };
        let recovery_fixture = Fixture::new();
        let mut recovery_journal = Journal::create(&recovery_fixture.0).unwrap();
        assert!(run_recovery(
            &access,
            &mut recovery_target,
            &backup,
            &source_fixture.0,
            &request,
            &support,
            &mut recovery_journal,
        )
        .is_err());
        assert_eq!(recovery_target.bytes, before);
        assert_eq!(
            inspect_journal(&recovery_fixture.0).status,
            RecordedStatus::InterruptedBeforeMutation
        );
    }

    #[test]
    fn bound_runner_persists_identity_and_hashes_before_mutation() {
        let fixture = Fixture::new();
        let mut journal = Journal::create(&fixture.0).unwrap();
        let payload = [1, 2, 3, 4, 5, 6, 7];
        let backup = [0; 7];
        let payload_hash = sha256_hex(&payload);
        let backup_hash = sha256_hex(&backup);
        let request = OperationRequest {
            operation_id: "operation-1",
            identity: identity("SW-TEST"),
            payload_sha256: &payload_hash,
            backup_sha256: &backup_hash,
        };
        let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
        let mut target = MemoryTarget {
            bytes: backup.to_vec(),
            faults: Faults::default(),
        };
        assert_eq!(
            run_bound(
                &VehicleAccess::default(),
                &mut target,
                &payload,
                &backup,
                &request,
                &support,
                &mut journal,
            )
            .unwrap(),
            Outcome::Verified
        );
        let log = std::fs::read_to_string(&fixture.0).unwrap();
        assert!(log.contains("operation operation-1 synthetic-backend-v1"));
        assert!(log.contains(&payload_hash));
        assert!(log.contains(&backup_hash));
        assert_eq!(inspect_journal(&fixture.0).status, RecordedStatus::Complete);
    }

    #[test]
    fn binding_mismatch_is_rejected_before_mutation_or_operation_record() {
        for mismatch in ["identity", "payload", "backup", "size", "token"] {
            let fixture = Fixture::new();
            let mut journal = Journal::create(&fixture.0).unwrap();
            let payload = [1; 7];
            let backup = [0; 7];
            let payload_hash = sha256_hex(&payload);
            let backup_hash = sha256_hex(&backup);
            let request = OperationRequest {
                operation_id: if mismatch == "token" {
                    "bad token"
                } else {
                    "operation-1"
                },
                identity: identity(if mismatch == "identity" {
                    "OTHER"
                } else {
                    "SW-TEST"
                }),
                payload_sha256: if mismatch == "payload" {
                    &backup_hash
                } else {
                    &payload_hash
                },
                backup_sha256: if mismatch == "backup" {
                    &payload_hash
                } else {
                    &backup_hash
                },
            };
            let support = SupportProfile::synthetic(
                identity("SW-TEST"),
                if mismatch == "size" { 8 } else { 7 },
                3,
            );
            let mut target = MemoryTarget {
                bytes: backup.to_vec(),
                faults: Faults::default(),
            };
            assert!(run_bound(
                &VehicleAccess::default(),
                &mut target,
                &payload,
                &backup,
                &request,
                &support,
                &mut journal,
            )
            .is_err());
            assert_eq!(target.bytes, backup);
            let log = std::fs::read_to_string(&fixture.0).unwrap();
            assert!(!log.contains("operation operation-1"));
            assert_eq!(
                inspect_journal(&fixture.0).status,
                RecordedStatus::InterruptedBeforeMutation
            );
        }
    }

    #[test]
    fn recovery_restores_only_the_backup_bound_to_recovery_required_evidence() {
        let source_fixture = Fixture::new();
        let mut source_journal = Journal::create(&source_fixture.0).unwrap();
        let payload = [1; 7];
        let backup = [0; 7];
        let payload_hash = sha256_hex(&payload);
        let backup_hash = sha256_hex(&backup);
        let request = OperationRequest {
            operation_id: "operation-recovery",
            identity: identity("SW-TEST"),
            payload_sha256: &payload_hash,
            backup_sha256: &backup_hash,
        };
        let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
        let access = VehicleAccess::default();
        let mut target = MemoryTarget {
            bytes: backup.to_vec(),
            faults: Faults {
                fail_after_chunk: Some(0),
                ..Faults::default()
            },
        };
        assert_eq!(
            run_bound(
                &access,
                &mut target,
                &payload,
                &backup,
                &request,
                &support,
                &mut source_journal,
            )
            .unwrap(),
            Outcome::RecoveryRequired
        );
        assert_eq!(
            inspect_journal(&source_fixture.0).status,
            RecordedStatus::RecoveryRequired
        );

        target.faults = Faults::default();
        let before_recovery = target.bytes.clone();
        let wrong_fixture = Fixture::new();
        let mut wrong_journal = Journal::create(&wrong_fixture.0).unwrap();
        assert!(run_recovery(
            &access,
            &mut target,
            &[9; 7],
            &source_fixture.0,
            &request,
            &support,
            &mut wrong_journal,
        )
        .is_err());
        assert_eq!(target.bytes, before_recovery);

        let recovery_fixture = Fixture::new();
        let mut recovery_journal = Journal::create(&recovery_fixture.0).unwrap();
        assert_eq!(
            run_recovery(
                &access,
                &mut target,
                &backup,
                &source_fixture.0,
                &request,
                &support,
                &mut recovery_journal,
            )
            .unwrap(),
            Outcome::Verified
        );
        assert_eq!(target.bytes, backup);
        assert_eq!(
            inspect_journal(&recovery_fixture.0).status,
            RecordedStatus::Complete
        );
    }

    #[test]
    fn recovery_rejects_non_recovery_source_before_mutation() {
        let source_fixture = Fixture::new();
        let mut source_journal = Journal::create(&source_fixture.0).unwrap();
        let payload = [1; 7];
        let backup = [0; 7];
        let payload_hash = sha256_hex(&payload);
        let backup_hash = sha256_hex(&backup);
        let request = OperationRequest {
            operation_id: "operation-complete",
            identity: identity("SW-TEST"),
            payload_sha256: &payload_hash,
            backup_sha256: &backup_hash,
        };
        let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
        let access = VehicleAccess::default();
        let mut target = MemoryTarget {
            bytes: backup.to_vec(),
            faults: Faults::default(),
        };
        assert_eq!(
            run_bound(
                &access,
                &mut target,
                &payload,
                &backup,
                &request,
                &support,
                &mut source_journal,
            )
            .unwrap(),
            Outcome::Verified
        );
        let before = target.bytes.clone();
        let recovery_fixture = Fixture::new();
        let mut recovery_journal = Journal::create(&recovery_fixture.0).unwrap();
        assert!(run_recovery(
            &access,
            &mut target,
            &[9; 7],
            &source_fixture.0,
            &request,
            &support,
            &mut recovery_journal,
        )
        .is_err());
        assert_eq!(target.bytes, before);
        assert_eq!(
            inspect_journal(&recovery_fixture.0).status,
            RecordedStatus::InterruptedBeforeMutation
        );
    }

    #[test]
    fn recovery_storage_failure_at_every_record_never_completes() {
        for failed_record in 1..=15 {
            let source_fixture = Fixture::new();
            let mut source_journal = Journal::create(&source_fixture.0).unwrap();
            let payload = [1; 7];
            let backup = [0; 7];
            let payload_hash = sha256_hex(&payload);
            let backup_hash = sha256_hex(&backup);
            let request = OperationRequest {
                operation_id: "operation-recovery-storage",
                identity: identity("SW-TEST"),
                payload_sha256: &payload_hash,
                backup_sha256: &backup_hash,
            };
            let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
            let access = VehicleAccess::default();
            let mut target = MemoryTarget {
                bytes: backup.to_vec(),
                faults: Faults {
                    fail_after_chunk: Some(0),
                    ..Faults::default()
                },
            };
            assert_eq!(
                run_bound(
                    &access,
                    &mut target,
                    &payload,
                    &backup,
                    &request,
                    &support,
                    &mut source_journal,
                )
                .unwrap(),
                Outcome::RecoveryRequired
            );
            target.faults = Faults::default();
            let before = target.bytes.clone();
            let recovery_fixture = Fixture::new();
            let mut recovery_journal = Journal::create(&recovery_fixture.0).unwrap();
            recovery_journal.fail_at = Some(failed_record);
            assert!(run_recovery(
                &access,
                &mut target,
                &backup,
                &source_fixture.0,
                &request,
                &support,
                &mut recovery_journal,
            )
            .is_err());
            let mut expected = before;
            let restored = match failed_record {
                1..=5 => 0,
                6..=7 => 3,
                8..=9 => 6,
                _ => 7,
            };
            expected[..restored].copy_from_slice(&backup[..restored]);
            assert_eq!(target.bytes, expected, "failure at record {failed_record}");
            assert_eq!(
                inspect_journal(&recovery_fixture.0).status,
                if failed_record <= 5 {
                    RecordedStatus::InterruptedBeforeMutation
                } else {
                    RecordedStatus::RecoveryRequired
                }
            );
            assert!(!std::fs::read_to_string(&recovery_fixture.0)
                .unwrap()
                .contains("complete"));
        }
    }

    #[test]
    fn recovery_acknowledgement_loss_and_bad_readback_require_recovery() {
        for fault in 0..=3 {
            let source_fixture = Fixture::new();
            let mut source_journal = Journal::create(&source_fixture.0).unwrap();
            let payload = [1; 7];
            let backup = [0; 7];
            let payload_hash = sha256_hex(&payload);
            let backup_hash = sha256_hex(&backup);
            let request = OperationRequest {
                operation_id: "operation-recovery-fault",
                identity: identity("SW-TEST"),
                payload_sha256: &payload_hash,
                backup_sha256: &backup_hash,
            };
            let support = SupportProfile::synthetic(identity("SW-TEST"), 7, 3);
            let access = VehicleAccess::default();
            let mut target = MemoryTarget {
                bytes: backup.to_vec(),
                faults: Faults {
                    fail_after_chunk: Some(0),
                    ..Faults::default()
                },
            };
            assert_eq!(
                run_bound(
                    &access,
                    &mut target,
                    &payload,
                    &backup,
                    &request,
                    &support,
                    &mut source_journal,
                )
                .unwrap(),
                Outcome::RecoveryRequired
            );
            target.faults = if fault < 3 {
                Faults {
                    fail_after_chunk: Some(fault),
                    ..Faults::default()
                }
            } else {
                Faults {
                    corrupt_readback: true,
                    ..Faults::default()
                }
            };
            let recovery_fixture = Fixture::new();
            let mut recovery_journal = Journal::create(&recovery_fixture.0).unwrap();
            assert_eq!(
                run_recovery(
                    &access,
                    &mut target,
                    &backup,
                    &source_fixture.0,
                    &request,
                    &support,
                    &mut recovery_journal,
                )
                .unwrap(),
                Outcome::RecoveryRequired
            );
            assert_eq!(
                inspect_journal(&recovery_fixture.0).status,
                RecordedStatus::RecoveryRequired
            );
            assert!(!std::fs::read_to_string(&recovery_fixture.0)
                .unwrap()
                .contains("complete"));
        }
    }

    #[test]
    fn storage_failure_at_every_record_stops_and_poisons_the_operation() {
        for failed_record in 1..=12 {
            let fixture = Fixture::new();
            let mut journal = Journal::create(&fixture.0).unwrap();
            journal.fail_at = Some(failed_record);
            let access = VehicleAccess::default();
            let mut target = MemoryTarget {
                bytes: vec![0; 7],
                faults: Faults::default(),
            };
            assert!(run_transfer(
                &access,
                &mut target,
                &[1; 7],
                &[0; 7],
                3,
                None,
                &mut journal
            )
            .is_err());
            let mut expected = if failed_record <= 2 {
                vec![0; 7]
            } else {
                vec![0xff; 7]
            };
            let written = match failed_record {
                1..=4 => 0,
                5..=6 => 3,
                7..=8 => 6,
                _ => 7,
            };
            expected[..written].fill(1);
            assert_eq!(target.bytes, expected, "failure at record {failed_record}");
            let log = std::fs::read_to_string(&fixture.0).unwrap();
            assert!(!log.contains("complete"));
            assert_eq!(log.lines().count(), failed_record);
            assert_eq!(
                inspect_journal(&fixture.0).status,
                if failed_record <= 2 {
                    RecordedStatus::InterruptedBeforeMutation
                } else {
                    RecordedStatus::RecoveryRequired
                }
            );
            journal.fail_at = None;
            assert!(journal.record("complete").is_err());
            let backup = target.bytes.clone();
            assert!(run_transfer(
                &access,
                &mut target,
                &[2; 7],
                &backup,
                3,
                None,
                &mut journal
            )
            .is_err());
            assert_eq!(target.bytes, expected);
            assert!(access.diagnostic().is_ok());
        }
    }

    #[test]
    fn transfers_partial_final_chunk_and_verifies_persisted_result() {
        let fixture = Fixture::new();
        let mut journal = Journal::create(&fixture.0).unwrap();
        let access = VehicleAccess::default();
        let mut target = MemoryTarget {
            bytes: vec![0; 7],
            faults: Faults::default(),
        };
        let payload = [1, 2, 3, 4, 5, 6, 7];
        assert_eq!(
            run_transfer(
                &access,
                &mut target,
                &payload,
                &[0; 7],
                3,
                None,
                &mut journal
            )
            .unwrap(),
            Outcome::Verified
        );
        assert_eq!(target.bytes, payload);
        drop(journal);
        let log = std::fs::read_to_string(&fixture.0).unwrap();
        assert!(log.contains("transfer-result 6 1"));
        assert!(log.ends_with("complete\n"));
        assert!(Journal::create(&fixture.0).is_err());
        let inspection = inspect_journal(&fixture.0);
        assert_eq!(inspection.status, RecordedStatus::Complete);
        assert_eq!(inspection.last_event.as_deref(), Some("complete"));
    }

    #[test]
    fn lost_acknowledgement_at_each_chunk_never_completes_or_retries() {
        for index in 0..3 {
            let fixture = Fixture::new();
            let mut journal = Journal::create(&fixture.0).unwrap();
            let mut target = MemoryTarget {
                bytes: vec![0; 7],
                faults: Faults {
                    fail_after_chunk: Some(index),
                    ..Faults::default()
                },
            };
            assert_eq!(
                run_transfer(
                    &VehicleAccess::default(),
                    &mut target,
                    &[1; 7],
                    &[0; 7],
                    3,
                    None,
                    &mut journal
                )
                .unwrap(),
                Outcome::RecoveryRequired
            );
            let log = std::fs::read_to_string(&fixture.0).unwrap();
            assert!(!log.contains("complete"));
            assert_eq!(log.matches("transfer-intent").count(), index + 1);
            assert_eq!(log.matches("transfer-result").count(), index);
            assert_eq!(
                inspect_journal(&fixture.0).status,
                RecordedStatus::RecoveryRequired
            );
        }
    }

    #[test]
    fn mismatched_backup_and_busy_session_leave_target_untouched() {
        let fixture = Fixture::new();
        let mut journal = Journal::create(&fixture.0).unwrap();
        let access = VehicleAccess::default();
        let mut target = MemoryTarget {
            bytes: vec![0; 7],
            faults: Faults::default(),
        };
        assert!(run_transfer(
            &access,
            &mut target,
            &[1; 7],
            &[2; 7],
            3,
            None,
            &mut journal
        )
        .is_err());
        let _diagnostic = access.diagnostic().unwrap();
        assert!(run_transfer(
            &access,
            &mut target,
            &[1; 7],
            &[0; 7],
            3,
            None,
            &mut journal
        )
        .is_err());
        assert_eq!(target.bytes, vec![0; 7]);
    }

    #[test]
    fn readback_mismatch_requires_recovery() {
        let fixture = Fixture::new();
        let mut journal = Journal::create(&fixture.0).unwrap();
        let mut target = MemoryTarget {
            bytes: vec![0; 7],
            faults: Faults {
                corrupt_readback: true,
                ..Faults::default()
            },
        };
        assert_eq!(
            run_transfer(
                &VehicleAccess::default(),
                &mut target,
                &[1; 7],
                &[0; 7],
                3,
                None,
                &mut journal
            )
            .unwrap(),
            Outcome::RecoveryRequired
        );
        assert_eq!(
            inspect_journal(&fixture.0).status,
            RecordedStatus::RecoveryRequired
        );
    }

    #[test]
    fn restart_inspection_rejects_torn_or_invalid_terminal_records() {
        let torn = Fixture::new();
        std::fs::write(&torn.0, b"0 synthetic-operation-v1\n1 erase-in").unwrap();
        assert_eq!(inspect_journal(&torn.0).status, RecordedStatus::Corrupt);

        let invalid = Fixture::new();
        std::fs::write(
            &invalid.0,
            b"0 synthetic-operation-v1\n1 preflight-accepted\n2 erase-intent\n3 complete\n",
        )
        .unwrap();
        assert_eq!(inspect_journal(&invalid.0).status, RecordedStatus::Corrupt);

        let extra = Fixture::new();
        std::fs::write(
            &extra.0,
            b"0 synthetic-operation-v1\n1 preflight-accepted\n2 erase-intent\n3 recovery-required lost\n4 erase-result\n",
        )
        .unwrap();
        assert_eq!(inspect_journal(&extra.0).status, RecordedStatus::Corrupt);

        let bad_binding = Fixture::new();
        std::fs::write(
            &bad_binding.0,
            b"0 synthetic-operation-v1\n1 operation op backend evidence recovery VIN FAMILY BOSCH BMW SW CAL BOOT not-a-hash also-bad\n",
        )
        .unwrap();
        assert_eq!(
            inspect_journal(&bad_binding.0).status,
            RecordedStatus::Corrupt
        );
    }
}

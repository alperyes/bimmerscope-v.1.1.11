//! Passive classification of already-extracted HSFZ application frames.
//!
//! This module never opens a socket or constructs requests. It exists to turn
//! authorized capture evidence into a reviewable programming-service timeline.

#[derive(Clone, Debug, PartialEq, Eq)]
pub(crate) struct ProgrammingEvent {
    pub index: usize,
    pub source: u8,
    pub destination: u8,
    pub service: &'static str,
    pub request_sid: u8,
    pub kind: EventKind,
    pub state_changing: bool,
    pub negative_response_code: Option<u8>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) enum EventKind {
    Request,
    PositiveResponse,
    NegativeResponse,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub(crate) struct ProgrammingCaptureReport {
    pub events: Vec<ProgrammingEvent>,
    pub contains_state_changing_services: bool,
    pub observed_download: bool,
    pub observed_transfer: bool,
    pub observed_transfer_exit: bool,
    pub observed_reset: bool,
    pub pending_response_count: usize,
}

/// Classifies UDS payloads extracted from HSFZ frames. A report is evidence of
/// what was captured, never proof that omitted exchanges did not happen or
/// that the observed transaction is safe for another ECU/software version.
pub(crate) fn analyze_programming_capture<'a, I>(frames: I) -> ProgrammingCaptureReport
where
    I: IntoIterator<Item = (u8, u8, &'a [u8])>,
{
    let mut report = ProgrammingCaptureReport {
        events: Vec::new(),
        contains_state_changing_services: false,
        observed_download: false,
        observed_transfer: false,
        observed_transfer_exit: false,
        observed_reset: false,
        pending_response_count: 0,
    };

    for (index, (source, destination, uds)) in frames.into_iter().enumerate() {
        let Some((request_sid, kind, nrc)) = classify_payload(uds) else {
            continue;
        };
        let Some((service, state_changing)) = service_definition(request_sid) else {
            continue;
        };
        if kind == EventKind::NegativeResponse && nrc == Some(0x78) {
            report.pending_response_count += 1;
        }
        report.contains_state_changing_services |= state_changing;
        report.observed_download |= request_sid == 0x34;
        report.observed_transfer |= request_sid == 0x36;
        report.observed_transfer_exit |= request_sid == 0x37;
        report.observed_reset |= request_sid == 0x11;
        report.events.push(ProgrammingEvent {
            index,
            source,
            destination,
            service,
            request_sid,
            kind,
            state_changing,
            negative_response_code: nrc,
        });
    }
    report
}

fn classify_payload(uds: &[u8]) -> Option<(u8, EventKind, Option<u8>)> {
    let sid = *uds.first()?;
    if sid == 0x7F {
        if uds.len() < 3 {
            return None;
        }
        return Some((uds[1], EventKind::NegativeResponse, Some(uds[2])));
    }
    if sid >= 0x40 {
        Some((sid - 0x40, EventKind::PositiveResponse, None))
    } else {
        Some((sid, EventKind::Request, None))
    }
}

fn service_definition(sid: u8) -> Option<(&'static str, bool)> {
    Some(match sid {
        0x10 => ("DiagnosticSessionControl", true),
        0x11 => ("ECUReset", true),
        0x22 => ("ReadDataByIdentifier", false),
        0x23 => ("ReadMemoryByAddress", false),
        0x27 => ("SecurityAccess", true),
        0x28 => ("CommunicationControl", true),
        0x31 => ("RoutineControl", true),
        0x34 => ("RequestDownload", true),
        0x36 => ("TransferData", true),
        0x37 => ("RequestTransferExit", true),
        0x3E => ("TesterPresent", false),
        _ => return None,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn identifies_a_programming_lifecycle_without_interpreting_payload_secrets() {
        let frames: Vec<(u8, u8, &[u8])> = vec![
            (0xF4, 0x12, &[0x10, 0x02]),
            (0x12, 0xF4, &[0x50, 0x02]),
            (0xF4, 0x12, &[0x27, 0x11]),
            (0x12, 0xF4, &[0x67, 0x11, 0xAA]),
            (0xF4, 0x12, &[0x34, 0x00, 0x44]),
            (0x12, 0xF4, &[0x74, 0x20, 0x01, 0x00]),
            (0xF4, 0x12, &[0x36, 0x01, 0xDE, 0xAD]),
            (0x12, 0xF4, &[0x7F, 0x36, 0x78]),
            (0x12, 0xF4, &[0x76, 0x01]),
            (0xF4, 0x12, &[0x37]),
            (0x12, 0xF4, &[0x77]),
            (0xF4, 0x12, &[0x11, 0x01]),
        ];
        let report = analyze_programming_capture(frames);
        assert!(report.contains_state_changing_services);
        assert!(report.observed_download);
        assert!(report.observed_transfer);
        assert!(report.observed_transfer_exit);
        assert!(report.observed_reset);
        assert_eq!(report.pending_response_count, 1);
        assert_eq!(report.events[2].service, "SecurityAccess");
        assert_eq!(report.events[7].negative_response_code, Some(0x78));
    }

    #[test]
    fn read_only_capture_is_not_labelled_state_changing() {
        let frames: Vec<(u8, u8, &[u8])> = vec![
            (0xF4, 0x12, &[0x22, 0xF1, 0x90]),
            (0x12, 0xF4, &[0x62, 0xF1, 0x90, b'W']),
            (0xF4, 0x12, &[0x3E, 0x00]),
        ];
        let report = analyze_programming_capture(frames);
        assert!(!report.contains_state_changing_services);
        assert_eq!(report.events.len(), 3);
    }

    #[test]
    fn ignores_unknown_and_truncated_payloads_conservatively() {
        let frames: Vec<(u8, u8, &[u8])> = vec![
            (0xF4, 0x12, &[]),
            (0x12, 0xF4, &[0x7F, 0x36]),
            (0xF4, 0x12, &[0x99]),
        ];
        assert!(analyze_programming_capture(frames).events.is_empty());
    }
}

//! Transport-independent download codec. No ECU profile or network entry point.
//! Wire layouts cross-checked against the public python-udsoncan services.
#![allow(dead_code)]

#[derive(Debug, PartialEq, Eq)]
pub(crate) enum Error {
    Malformed,
    Unexpected,
    Negative(u8),
    State,
}

#[derive(Debug, PartialEq, Eq)]
pub(crate) enum Reply {
    Pending,
    Accepted,
}

fn response<'a>(bytes: &'a [u8], sid: u8) -> Result<Option<&'a [u8]>, Error> {
    if bytes.first() == Some(&0x7f) {
        if bytes.len() != 3 {
            return Err(Error::Malformed);
        }
        if bytes[1] != sid {
            return Err(Error::Unexpected);
        }
        return if bytes[2] == 0x78 {
            Ok(None)
        } else {
            Err(Error::Negative(bytes[2]))
        };
    }
    if bytes.first() != Some(&(sid + 0x40)) {
        return Err(Error::Unexpected);
    }
    Ok(Some(&bytes[1..]))
}

/// Uncompressed, unencrypted download using explicit 32-bit address and size.
/// Address selection and authorization belong to a reviewed ECU procedure.
pub(crate) fn request_download(address: u32, size: u32) -> Result<Vec<u8>, Error> {
    if size == 0 || address.checked_add(size - 1).is_none() {
        return Err(Error::Malformed);
    }
    let mut bytes = vec![0x34, 0, 0x44];
    bytes.extend(address.to_be_bytes());
    bytes.extend(size.to_be_bytes());
    Ok(bytes)
}

pub(crate) fn download_limit(bytes: &[u8], transport_limit: usize) -> Result<Option<usize>, Error> {
    let Some(data) = response(bytes, 0x34)? else {
        return Ok(None);
    };
    let format = *data.first().ok_or(Error::Malformed)?;
    let count = (format >> 4) as usize;
    if format & 0xf != 0 || count == 0 || count > 8 || data.len() != count + 1 {
        return Err(Error::Malformed);
    }
    let mut limit = 0u64;
    for byte in &data[1..] {
        limit = (limit << 8) | u64::from(*byte);
    }
    let limit = limit.min(transport_limit as u64);
    if limit <= 2 {
        return Err(Error::Malformed);
    }
    // SID and block counter consume two bytes of the negotiated message limit.
    Ok(Some(limit as usize - 2))
}

pub(crate) struct Transfer {
    payload: Vec<u8>,
    chunk_size: usize,
    acknowledged: usize,
    counter: u8,
    outstanding: Option<usize>,
    exiting: bool,
    complete: bool,
    failed: bool,
}

impl Transfer {
    pub(crate) fn new(payload: Vec<u8>, chunk_size: usize) -> Result<Self, Error> {
        if payload.is_empty() || chunk_size == 0 {
            return Err(Error::Malformed);
        }
        Ok(Self {
            payload,
            chunk_size,
            acknowledged: 0,
            counter: 1,
            outstanding: None,
            exiting: false,
            complete: false,
            failed: false,
        })
    }

    /// Returns each request once. The caller must persist intent before sending.
    /// Pending replies never cause retransmission; timeout requires explicit recovery.
    pub(crate) fn next_request(&mut self) -> Result<Vec<u8>, Error> {
        if self.failed || self.complete || self.exiting || self.outstanding.is_some() {
            return Err(Error::State);
        }
        if self.acknowledged == self.payload.len() {
            self.exiting = true;
            return Ok(vec![0x37]);
        }
        let len = self.chunk_size.min(self.payload.len() - self.acknowledged);
        let mut bytes = vec![0x36, self.counter];
        bytes.extend_from_slice(&self.payload[self.acknowledged..self.acknowledged + len]);
        self.outstanding = Some(len);
        Ok(bytes)
    }

    pub(crate) fn accept(&mut self, bytes: &[u8]) -> Result<Reply, Error> {
        if self.failed || self.complete || (!self.exiting && self.outstanding.is_none()) {
            return Err(Error::State);
        }
        let result = self.accept_inner(bytes);
        if result.is_err() {
            self.failed = true;
        }
        result
    }

    fn accept_inner(&mut self, bytes: &[u8]) -> Result<Reply, Error> {
        let sid = if self.exiting { 0x37 } else { 0x36 };
        let Some(data) = response(bytes, sid)? else {
            return Ok(Reply::Pending);
        };
        if self.exiting {
            // This generic profile supports no optional OEM response records.
            if !data.is_empty() {
                return Err(Error::Unexpected);
            }
            self.complete = true;
        } else {
            if data != [self.counter] {
                return Err(Error::Unexpected);
            }
            self.acknowledged += self.outstanding.take().ok_or(Error::State)?;
            self.counter = self.counter.wrapping_add(1);
        }
        Ok(Reply::Accepted)
    }

    pub(crate) fn outcome_unknown(&mut self) {
        self.failed = true;
    }
}

/// Transport must return only correlated ECU application replies and enforce
/// the supplied absolute deadline, including across response-pending messages.
pub(crate) trait DownloadTransport {
    fn send(&mut self, bytes: &[u8], deadline: std::time::Instant) -> Result<(), String>;
    fn receive(&mut self, deadline: std::time::Instant) -> Result<Vec<u8>, String>;
}

#[derive(Debug, PartialEq, Eq)]
pub(crate) enum ExchangeRecord {
    Intent(Vec<u8>),
    Response(Vec<u8>),
    TransferExited,
}

/// Append must durably persist each record before returning. This exchange
/// journal is distinct from the synthetic operation journal's versioned schema.
pub(crate) trait ExchangeJournal {
    fn append(&mut self, record: ExchangeRecord) -> Result<(), String>;
}

#[derive(Debug, PartialEq, Eq)]
pub(crate) enum ReplayStatus {
    Interrupted,
    Rejected(u8),
    TransferExited,
}

/// Offline validation against the independently supplied intended bytes.
/// No timing or ECU integrity claim is made; records do not carry timestamps.
pub(crate) fn validate_exchange_records(
    records: &[ExchangeRecord],
    address: u32,
    payload: Vec<u8>,
    transport_limit: usize,
) -> Result<ReplayStatus, Error> {
    if transport_limit <= 2 {
        return Err(Error::Malformed);
    }
    let size = u32::try_from(payload.len()).map_err(|_| Error::Malformed)?;
    let mut expected = request_download(address, size)?;
    let mut awaiting = false;
    let mut transfer: Option<Transfer> = None;
    let mut payload = Some(payload);
    for (index, record) in records.iter().enumerate() {
        match record {
            ExchangeRecord::Intent(bytes) => {
                if awaiting || transfer.as_ref().is_some_and(|t| t.complete) || *bytes != expected {
                    return Err(Error::Unexpected);
                }
                awaiting = true;
            }
            ExchangeRecord::Response(bytes) => {
                if !awaiting {
                    return Err(Error::State);
                }
                let result = if let Some(t) = transfer.as_mut() {
                    t.accept(bytes)
                } else {
                    download_limit(bytes, transport_limit).and_then(|limit| match limit {
                        None => Ok(Reply::Pending),
                        Some(limit) => {
                            transfer =
                                Some(Transfer::new(payload.take().ok_or(Error::State)?, limit)?);
                            Ok(Reply::Accepted)
                        }
                    })
                };
                match result {
                    Err(Error::Negative(code)) if index + 1 == records.len() => {
                        return Ok(ReplayStatus::Rejected(code))
                    }
                    Err(error) => return Err(error),
                    Ok(Reply::Pending) => {}
                    Ok(Reply::Accepted) => {
                        awaiting = false;
                        let t = transfer.as_mut().ok_or(Error::State)?;
                        if !t.complete {
                            expected = t.next_request()?;
                        }
                    }
                }
            }
            ExchangeRecord::TransferExited => {
                if awaiting
                    || !transfer.as_ref().is_some_and(|t| t.complete)
                    || index + 1 != records.len()
                {
                    return Err(Error::State);
                }
                return Ok(ReplayStatus::TransferExited);
            }
        }
    }
    Ok(ReplayStatus::Interrupted)
}

/// Runs only the download/transfer/exit phase. Its caller owns identity,
/// authorization, exclusive access, erase and subsequent ECU verification.
/// Success means transfer exit was acknowledged, not that flash is verified.
pub(crate) fn run_download(
    transport: &mut impl DownloadTransport,
    journal: &mut impl ExchangeJournal,
    address: u32,
    payload: Vec<u8>,
    transport_limit: usize,
    timeout: std::time::Duration,
) -> Result<(), String> {
    if transport_limit <= 2 || timeout.is_zero() {
        return Err("Invalid exchange limits".into());
    }
    let size = u32::try_from(payload.len()).map_err(|_| "Payload exceeds 32-bit size")?;
    let request = request_download(address, size).map_err(|e| format!("{e:?}"))?;
    let chunk_size = exchange(transport, journal, &request, timeout, |reply| {
        download_limit(reply, transport_limit)
    })?;
    let mut transfer = Transfer::new(payload, chunk_size).map_err(|e| format!("{e:?}"))?;
    loop {
        let request = transfer.next_request().map_err(|e| format!("{e:?}"))?;
        exchange(transport, journal, &request, timeout, |reply| {
            transfer.accept(reply).map(|result| match result {
                Reply::Pending => None,
                Reply::Accepted => Some(()),
            })
        })?;
        if transfer.complete {
            return journal.append(ExchangeRecord::TransferExited);
        }
    }
}

fn exchange<T>(
    transport: &mut impl DownloadTransport,
    journal: &mut impl ExchangeJournal,
    request: &[u8],
    timeout: std::time::Duration,
    mut parse: impl FnMut(&[u8]) -> Result<Option<T>, Error>,
) -> Result<T, String> {
    let deadline = std::time::Instant::now()
        .checked_add(timeout)
        .ok_or("Exchange deadline overflow")?;
    journal.append(ExchangeRecord::Intent(request.to_vec()))?;
    if std::time::Instant::now() >= deadline {
        return Err("Exchange deadline expired".into());
    }
    transport.send(request, deadline)?;
    loop {
        if std::time::Instant::now() >= deadline {
            return Err("Exchange outcome unknown: deadline expired".into());
        }
        let reply = transport.receive(deadline)?;
        journal.append(ExchangeRecord::Response(reply.clone()))?;
        if std::time::Instant::now() >= deadline {
            return Err("Exchange outcome unknown: late response".into());
        }
        match parse(&reply).map_err(|e| format!("UDS response rejected: {e:?}"))? {
            Some(value) => return Ok(value),
            None => continue,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::VecDeque;
    struct Wire {
        sent: Vec<Vec<u8>>,
        replies: VecDeque<Vec<u8>>,
        deadlines: Vec<std::time::Instant>,
    }
    impl DownloadTransport for Wire {
        fn send(&mut self, bytes: &[u8], deadline: std::time::Instant) -> Result<(), String> {
            self.sent.push(bytes.to_vec());
            self.deadlines.push(deadline);
            Ok(())
        }
        fn receive(&mut self, deadline: std::time::Instant) -> Result<Vec<u8>, String> {
            assert_eq!(Some(&deadline), self.deadlines.last());
            self.replies
                .pop_front()
                .ok_or("Injected lost acknowledgement".into())
        }
    }
    #[derive(Default)]
    struct Log {
        records: Vec<ExchangeRecord>,
        fail_at: Option<usize>,
    }
    impl ExchangeJournal for Log {
        fn append(&mut self, record: ExchangeRecord) -> Result<(), String> {
            if self.fail_at == Some(self.records.len()) {
                return Err("Injected disk failure".into());
            }
            self.records.push(record);
            Ok(())
        }
    }
    fn wire() -> Wire {
        Wire {
            sent: vec![],
            deadlines: vec![],
            replies: VecDeque::from(vec![
                vec![0x74, 0x10, 4],
                vec![0x7f, 0x36, 0x78],
                vec![0x76, 1],
                vec![0x76, 2],
                vec![0x77],
            ]),
        }
    }
    #[test]
    fn runner_negotiates_sends_once_and_records_exit_only_after_ack() {
        let mut wire = wire();
        let mut log = Log::default();
        run_download(
            &mut wire,
            &mut log,
            0x1000,
            vec![1, 2, 3],
            64,
            std::time::Duration::from_secs(1),
        )
        .unwrap();
        assert_eq!(
            &wire.sent[1..],
            &[vec![0x36, 1, 1, 2], vec![0x36, 2, 3], vec![0x37]]
        );
        assert_eq!(log.records.len(), 10);
        assert_eq!(log.records.last(), Some(&ExchangeRecord::TransferExited));
        assert_eq!(
            validate_exchange_records(&log.records, 0x1000, vec![1, 2, 3], 64),
            Ok(ReplayStatus::TransferExited)
        );
        for end in 0..log.records.len() {
            assert_eq!(
                validate_exchange_records(&log.records[..end], 0x1000, vec![1, 2, 3], 64),
                Ok(ReplayStatus::Interrupted)
            );
        }
        assert!(validate_exchange_records(&log.records, 0x1001, vec![1, 2, 3], 64).is_err());
        assert!(validate_exchange_records(&log.records, 0x1000, vec![1, 2, 4], 64).is_err());
    }

    #[test]
    fn replay_rejects_fabricated_completion_and_out_of_order_responses() {
        let intent = || ExchangeRecord::Intent(request_download(0x1000, 1).unwrap());
        for records in [
            vec![ExchangeRecord::TransferExited],
            vec![
                ExchangeRecord::Response(vec![0x77]),
                ExchangeRecord::TransferExited,
            ],
            vec![intent(), ExchangeRecord::TransferExited],
            vec![intent(), intent()],
            vec![
                intent(),
                ExchangeRecord::Response(vec![0x74, 0x10, 4]),
                ExchangeRecord::Response(vec![0x76, 1]),
            ],
        ] {
            assert!(validate_exchange_records(&records, 0x1000, vec![1], 64).is_err());
        }
        assert_eq!(
            validate_exchange_records(
                &[intent(), ExchangeRecord::Response(vec![0x7f, 0x34, 0x33])],
                0x1000,
                vec![1],
                64
            ),
            Ok(ReplayStatus::Rejected(0x33))
        );
    }
    #[test]
    fn every_journal_failure_stops_sends_at_the_durable_boundary() {
        // Four intents, five replies (including pending), one exit record.
        let allowed_sends = [0, 1, 1, 2, 2, 2, 3, 3, 4, 4];
        for (index, expected) in allowed_sends.into_iter().enumerate() {
            let mut wire = wire();
            let mut log = Log {
                records: vec![],
                fail_at: Some(index),
            };
            assert!(run_download(
                &mut wire,
                &mut log,
                0x1000,
                vec![1, 2, 3],
                64,
                std::time::Duration::from_secs(1)
            )
            .is_err());
            assert_eq!(wire.sent.len(), expected, "record {index}");
            assert!(!log.records.contains(&ExchangeRecord::TransferExited));
        }
    }
    #[test]
    fn lost_or_wrong_ack_does_not_retry_or_exit() {
        for replies in [
            vec![vec![0x74, 0x10, 4]],
            vec![vec![0x74, 0x10, 4], vec![0x76, 2]],
        ] {
            let mut wire = Wire {
                sent: vec![],
                deadlines: vec![],
                replies: replies.into(),
            };
            let mut log = Log::default();
            assert!(run_download(
                &mut wire,
                &mut log,
                0x1000,
                vec![1, 2, 3],
                64,
                std::time::Duration::from_secs(1)
            )
            .is_err());
            assert_eq!(wire.sent.len(), 2);
            assert!(!log.records.contains(&ExchangeRecord::TransferExited));
        }
    }
    #[test]
    fn negotiates_limits_and_rejects_invalid_download_responses() {
        assert_eq!(download_limit(&[0x74, 0x20, 1, 0], 1024), Ok(Some(254)));
        assert_eq!(download_limit(&[0x74, 0x20, 1, 0], 253), Ok(Some(251)));
        assert_eq!(download_limit(&[0x7f, 0x34, 0x78], 1024), Ok(None));
        for data in [
            vec![],
            vec![0x74],
            vec![0x74, 0],
            vec![0x74, 0x20, 1],
            vec![0x74, 0x11, 3],
            vec![0x74, 0x10, 2],
        ] {
            assert!(download_limit(&data, 1024).is_err());
        }
        assert!(request_download(u32::MAX, 2).is_err());
        assert_eq!(
            request_download(0x1000, 3).unwrap(),
            [0x34, 0, 0x44, 0, 0, 0x10, 0, 0, 0, 0, 3]
        );
    }
    #[test]
    fn partial_chunk_pending_and_exit_require_matching_acknowledgements() {
        let mut t = Transfer::new(vec![1, 2, 3], 2).unwrap();
        assert_eq!(t.next_request().unwrap(), [0x36, 1, 1, 2]);
        assert_eq!(t.accept(&[0x7f, 0x36, 0x78]), Ok(Reply::Pending));
        assert_eq!(t.acknowledged, 0);
        assert_eq!(t.next_request(), Err(Error::State));
        t.accept(&[0x76, 1]).unwrap();
        assert_eq!(t.next_request().unwrap(), [0x36, 2, 3]);
        t.accept(&[0x76, 2]).unwrap();
        assert_eq!(t.next_request().unwrap(), [0x37]);
        assert!(!t.complete);
        t.accept(&[0x77]).unwrap();
        assert!(t.complete);
    }
    #[test]
    fn counter_wraps_and_invalid_ack_or_timeout_stops_progress() {
        let mut t = Transfer::new(vec![0; 257], 1).unwrap();
        for index in 1..=257 {
            let request = t.next_request().unwrap();
            assert_eq!(request[1], index as u8);
            t.accept(&[0x76, index as u8]).unwrap();
        }
        for reply in [
            vec![0x76, 2],
            vec![0x76],
            vec![0x7f, 0x36, 0x73],
            vec![0x7f, 0x34, 0x78],
        ] {
            let mut t = Transfer::new(vec![1], 1).unwrap();
            t.next_request().unwrap();
            assert!(t.accept(&reply).is_err());
            assert_eq!(t.acknowledged, 0);
            assert!(t.next_request().is_err());
        }
        let mut t = Transfer::new(vec![1], 1).unwrap();
        t.next_request().unwrap();
        t.outcome_unknown();
        assert!(t.accept(&[0x76, 1]).is_err());
    }
}

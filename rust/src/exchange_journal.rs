//! Append-only exchange evidence. Restart interpretation remains separate.
#![allow(dead_code)]
use crate::uds_download::{ExchangeJournal, ExchangeRecord};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{self, Write};
use std::path::Path;

pub(crate) struct FileExchangeJournal {
    file: File,
    sequence: u64,
    failed: bool,
    ended: bool,
}

impl FileExchangeJournal {
    /// The caller supplies a fresh operation-specific path. The binding hash
    /// identifies the parent operation manifest (identity, payload, procedure).
    /// This records that binding; it does not validate the manifest itself.
    pub(crate) fn create(path: &Path, binding_hash: &[u8; 32]) -> io::Result<Self> {
        let mut file = OpenOptions::new().write(true).create_new(true).open(path)?;
        writeln!(file, "bimmerscope-exchange-v1 {}", hex(binding_hash))?;
        file.sync_all()?;
        Ok(Self {
            file,
            sequence: 0,
            failed: false,
            ended: false,
        })
    }
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|byte| format!("{byte:02x}")).collect()
}

pub(crate) fn inspect_download(
    path: &Path,
    expected_binding: &[u8; 32],
    address: u32,
    payload: Vec<u8>,
    transport_limit: usize,
) -> Result<crate::uds_download::ReplayStatus, String> {
    let records = read_records(path, expected_binding)?;
    crate::uds_download::validate_exchange_records(&records, address, payload, transport_limit)
        .map_err(|error| format!("Journal protocol mismatch: {error:?}"))
}

/// Structural evidence only: callers must replay/validate the protocol and
/// parent manifest before drawing conclusions about the target or recovery.
pub(crate) fn read_records(
    path: &Path,
    expected_binding: &[u8; 32],
) -> Result<Vec<ExchangeRecord>, String> {
    let text = std::fs::read_to_string(path).map_err(|e| e.to_string())?;
    parse_records(&text, expected_binding)
}

fn parse_records(text: &str, expected_binding: &[u8; 32]) -> Result<Vec<ExchangeRecord>, String> {
    if !text.ends_with('\n') {
        return Err("Truncated journal".into());
    }
    let mut lines = text.strip_suffix('\n').unwrap().split('\n');
    let expected_header = format!("bimmerscope-exchange-v1 {}", hex(expected_binding));
    if lines.next() != Some(expected_header.as_str()) {
        return Err("Journal schema or binding mismatch".into());
    }
    let mut records = Vec::new();
    for (index, line) in lines.enumerate() {
        if matches!(records.last(), Some(ExchangeRecord::TransferExited)) {
            return Err("Records after terminal marker".into());
        }
        let fields: Vec<_> = line.split(' ').collect();
        if fields.len() != 4 || fields[0] != index.to_string() {
            return Err("Invalid record sequence or format".into());
        }
        let (body, digest) = line.rsplit_once(' ').ok_or("Missing checksum")?;
        if digest != hex(&Sha256::digest(body.as_bytes())) {
            return Err("Record checksum mismatch".into());
        }
        let bytes = decode_hex(fields[2])?;
        let record = match fields[1] {
            "intent" => ExchangeRecord::Intent(bytes),
            "response" => ExchangeRecord::Response(bytes),
            "transfer-exited" if bytes.is_empty() => ExchangeRecord::TransferExited,
            _ => return Err("Unknown exchange record".into()),
        };
        records.push(record);
    }
    Ok(records)
}

fn decode_hex(text: &str) -> Result<Vec<u8>, String> {
    if text.len() % 2 != 0
        || !text
            .bytes()
            .all(|b| b.is_ascii_digit() || (b'a'..=b'f').contains(&b))
    {
        return Err("Invalid hex payload".into());
    }
    text.as_bytes()
        .chunks_exact(2)
        .map(|pair| {
            let digit = |b: u8| if b <= b'9' { b - b'0' } else { b - b'a' + 10 };
            Ok((digit(pair[0]) << 4) | digit(pair[1]))
        })
        .collect()
}

impl ExchangeJournal for FileExchangeJournal {
    fn append(&mut self, record: ExchangeRecord) -> Result<(), String> {
        if self.failed || self.ended {
            return Err("Exchange journal is closed or failed".into());
        }
        let (kind, payload) = match &record {
            ExchangeRecord::Intent(bytes) => ("intent", hex(bytes)),
            ExchangeRecord::Response(bytes) => ("response", hex(bytes)),
            ExchangeRecord::TransferExited => ("transfer-exited", String::new()),
        };
        let body = format!("{} {kind} {payload}", self.sequence);
        let digest = hex(&Sha256::digest(body.as_bytes()));
        let result = writeln!(self.file, "{body} {digest}").and_then(|_| self.file.sync_all());
        if let Err(error) = result {
            self.failed = true;
            return Err(format!("Exchange journal storage failed: {error}"));
        }
        self.sequence += 1;
        self.ended = matches!(record, ExchangeRecord::TransferExited);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::uds_download::{run_download, DownloadTransport};
    use std::collections::VecDeque;
    use std::sync::atomic::{AtomicU64, Ordering};
    static NEXT: AtomicU64 = AtomicU64::new(0);
    struct Fixture(std::path::PathBuf);
    impl Fixture {
        fn new() -> Self {
            let path = std::env::temp_dir().join(format!(
                "bimmerscope-exchange-{}-{}-{}",
                std::process::id(),
                std::time::SystemTime::now()
                    .duration_since(std::time::UNIX_EPOCH)
                    .unwrap()
                    .as_nanos(),
                NEXT.fetch_add(1, Ordering::Relaxed)
            ));
            Self(path)
        }
    }
    impl Drop for Fixture {
        fn drop(&mut self) {
            let _ = std::fs::remove_file(&self.0);
        }
    }
    struct Wire {
        replies: VecDeque<Vec<u8>>,
    }
    impl DownloadTransport for Wire {
        fn send(&mut self, _: &[u8], _: std::time::Instant) -> Result<(), String> {
            Ok(())
        }
        fn receive(&mut self, _: std::time::Instant) -> Result<Vec<u8>, String> {
            self.replies.pop_front().ok_or("No reply".into())
        }
    }
    #[test]
    fn real_file_records_survive_runner_and_cannot_be_overwritten() {
        let fixture = Fixture::new();
        let mut journal = FileExchangeJournal::create(&fixture.0, &[0x42; 32]).unwrap();
        let mut wire = Wire {
            replies: vec![vec![0x74, 0x10, 4], vec![0x76, 1], vec![0x77]].into(),
        };
        run_download(
            &mut wire,
            &mut journal,
            0x1000,
            vec![1, 2],
            64,
            std::time::Duration::from_secs(1),
        )
        .unwrap();
        assert!(journal.append(ExchangeRecord::Intent(vec![0x34])).is_err());
        drop(journal);
        let records = read_records(&fixture.0, &[0x42; 32]).unwrap();
        assert_eq!(
            inspect_download(&fixture.0, &[0x42; 32], 0x1000, vec![1, 2], 64).unwrap(),
            crate::uds_download::ReplayStatus::TransferExited
        );
        assert!(inspect_download(&fixture.0, &[0x42; 32], 0x1000, vec![2, 1], 64).is_err());
        assert_eq!(records.len(), 7);
        assert_eq!(records.last(), Some(&ExchangeRecord::TransferExited));
        assert!(read_records(&fixture.0, &[0; 32]).is_err());
        let text = std::fs::read_to_string(&fixture.0).unwrap();
        assert_eq!(text.lines().count(), 8);
        assert!(text.contains("2 intent 36010102 "));
        assert!(text.contains("5 response 77 "));
        assert!(text.contains("6 transfer-exited  "));
        for (index, line) in text.lines().skip(1).enumerate() {
            let (body, hash) = line.rsplit_once(' ').unwrap();
            assert!(body.starts_with(&format!("{index} ")));
            assert_eq!(hash, hex(&Sha256::digest(body.as_bytes())));
        }
        assert!(FileExchangeJournal::create(&fixture.0, &[0; 32]).is_err());
        assert_eq!(std::fs::read_to_string(&fixture.0).unwrap(), text);
    }
    #[test]
    fn filesystem_write_failure_permanently_poisons_journal() {
        let fixture = Fixture::new();
        drop(FileExchangeJournal::create(&fixture.0, &[0; 32]).unwrap());
        // A read-only file handle makes the OS reject writes deterministically.
        let mut journal = FileExchangeJournal {
            file: File::open(&fixture.0).unwrap(),
            sequence: 0,
            failed: false,
            ended: false,
        };
        assert!(journal.append(ExchangeRecord::Intent(vec![0x34])).is_err());
        assert!(journal.failed);
        assert!(journal.append(ExchangeRecord::TransferExited).is_err());
        assert_eq!(journal.sequence, 0);
    }

    #[test]
    fn restart_reader_rejects_torn_modified_reordered_and_trailing_records() {
        let fixture = Fixture::new();
        let mut journal = FileExchangeJournal::create(&fixture.0, &[0; 32]).unwrap();
        journal.append(ExchangeRecord::Intent(vec![0x37])).unwrap();
        journal
            .append(ExchangeRecord::Response(vec![0x77]))
            .unwrap();
        journal.append(ExchangeRecord::TransferExited).unwrap();
        drop(journal);
        let text = std::fs::read_to_string(&fixture.0).unwrap();
        for end in 0..text.len() {
            if !text[..end].ends_with('\n') {
                assert!(parse_records(&text[..end], &[0; 32]).is_err());
            }
        }
        assert!(parse_records(&text.replace("intent 37", "intent 36"), &[0; 32]).is_err());
        let lines: Vec<_> = text.lines().collect();
        let reordered = format!("{}\n{}\n{}\n{}\n", lines[0], lines[2], lines[1], lines[3]);
        assert!(parse_records(&reordered, &[0; 32]).is_err());
        assert!(parse_records(&(text.clone() + lines[1] + "\n"), &[0; 32]).is_err());
        // Intact prefixes remain evidence, without claiming successful transfer.
        let prefix = format!("{}\n{}\n", lines[0], lines[1]);
        assert_eq!(
            parse_records(&prefix, &[0; 32]).unwrap(),
            vec![ExchangeRecord::Intent(vec![0x37])]
        );
    }
}

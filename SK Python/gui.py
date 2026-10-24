"""Offline record inspector and native Python seed-response GUI."""

from __future__ import annotations

import csv
from pathlib import Path
import re
import queue
import threading
import tkinter as tk
import xml.etree.ElementTree as ET
from tkinter import filedialog, messagebox, ttk

from sec_file_parser import AuthenticationKeyMetadata, SecFileParser
from seed_response import calculate_response


class MetadataViewer(tk.Tk):
    COLUMNS = (
        "sgbm_id",
        "plain",
        "key_type",
        "digest",
        "has_key_data",
        "key_data_length",
    )
    HEADINGS = {
        "sgbm_id": "SGBM ID",
        "plain": "Plain",
        "key_type": "Type",
        "digest": "Digest",
        "has_key_data": "Has key data",
        "key_data_length": "Key data length",
    }

    def __init__(self) -> None:
        super().__init__()
        self.title("BM3 Seed Response & Metadata")
        self.geometry("1040x850")
        self.minsize(900, 740)
        self._response_queue = queue.Queue()
        self._response_hex = ""
        self._records: tuple[AuthenticationKeyMetadata, ...] = ()
        self._source_path: Path | None = None
        self._source_revision = 0
        self._build_ui()
        bundled_xml = Path(__file__).with_name("image3.xml")
        if bundled_xml.is_file():
            self.after_idle(lambda: self._load_path(bundled_xml, show_error=False))

    def _build_ui(self) -> None:
        outer = ttk.Frame(self, padding=14)
        outer.pack(fill="both", expand=True)

        ttk.Label(outer, text="Seed response & authentication metadata", style="Title.TLabel").pack(anchor="w")
        ttk.Label(
            outer,
            text="Calculate locally in Python. CSV exports contain record metadata only.",
        ).pack(anchor="w", pady=(4, 12))

        controls = ttk.Frame(outer)
        controls.pack(fill="x", pady=(0, 10))
        ttk.Button(controls, text="Open XML / resource…", command=self._open_file).pack(side="left")
        ttk.Button(controls, text="Export redacted CSV…", command=self._export_csv).pack(side="left", padx=(8, 0))
        ttk.Button(controls, text="Clear", command=self._clear).pack(side="left", padx=(8, 0))

        input_frame = ttk.LabelFrame(outer, text="Inspect seed and XML record", padding=10)
        input_frame.pack(fill="x", pady=(0, 10))
        ttk.Label(input_frame, text="SGBM ID (8 hex digits)").grid(row=0, column=0, sticky="w")
        self._id_var = tk.StringVar()
        ttk.Entry(input_frame, textvariable=self._id_var, width=22).grid(row=1, column=0, sticky="ew", padx=(0, 12))
        ttk.Label(input_frame, text="Seed (hex)").grid(row=0, column=1, sticky="w")
        self._seed_var = tk.StringVar()
        ttk.Entry(input_frame, textvariable=self._seed_var, width=52).grid(row=1, column=1, sticky="ew", padx=(0, 12))
        ttk.Button(input_frame, text="Inspect inputs", command=self._inspect_inputs).grid(row=1, column=2, sticky="ew")
        input_frame.columnconfigure(0, weight=1)
        input_frame.columnconfigure(1, weight=3)

        calculation_frame = ttk.Frame(input_frame)
        calculation_frame.grid(row=3, column=0, columnspan=3, sticky="ew", pady=(10, 0))
        self._calculate_button = ttk.Button(calculation_frame, text="Calculate response", command=self._calculate_response)
        self._calculate_button.pack(side="right")
        ttk.Label(input_frame, text="Calculation uses the loaded XML source and local Python resources.").grid(
            row=4, column=0, columnspan=3, sticky="w", pady=(6, 0))
        self._response = tk.Text(input_frame, height=5, wrap="char", font=("Consolas", 10), state="disabled")
        self._response.grid(row=5, column=0, columnspan=3, sticky="ew", pady=(6, 0))
        self._copy_button = ttk.Button(input_frame, text="Copy response", command=self._copy_response, state="disabled")
        self._copy_button.grid(row=6, column=2, sticky="e", pady=(6, 0))
        for variable in (self._id_var, self._seed_var):
            variable.trace_add("write", self._invalidate_response)

        self._analysis = tk.Text(input_frame, height=4, wrap="word", relief="flat", background="#f3f5f7")
        self._analysis.grid(row=2, column=0, columnspan=3, sticky="ew", pady=(10, 0))
        self._analysis.configure(state="disabled")
        self._set_analysis("Enter an SGBM ID and seed. The seed is validated locally and is not saved or sent anywhere.")

        filter_row = ttk.Frame(outer)
        filter_row.pack(fill="x", pady=(0, 8))
        ttk.Label(filter_row, text="Filter table by SGBM ID:").pack(side="left")
        self._filter_var = tk.StringVar()
        filter_entry = ttk.Entry(filter_row, textvariable=self._filter_var, width=30)
        filter_entry.pack(side="left", padx=(8, 8))
        filter_entry.bind("<KeyRelease>", lambda _event: self._render_rows())
        ttk.Button(filter_row, text="Reset filter", command=self._reset_filter).pack(side="left")
        self._count_var = tk.StringVar(value="No file loaded")
        ttk.Label(filter_row, textvariable=self._count_var).pack(side="right")

        table_frame = ttk.Frame(outer)
        table_frame.pack(fill="both", expand=True)
        self._tree = ttk.Treeview(table_frame, columns=self.COLUMNS, show="headings", selectmode="browse")
        widths = {"sgbm_id": 150, "plain": 80, "key_type": 80, "digest": 120, "has_key_data": 120, "key_data_length": 150}
        for column in self.COLUMNS:
            self._tree.heading(column, text=self.HEADINGS[column])
            self._tree.column(column, width=widths[column], anchor="w")
        self._tree.bind("<<TreeviewSelect>>", self._select_record)
        y_scroll = ttk.Scrollbar(table_frame, orient="vertical", command=self._tree.yview)
        x_scroll = ttk.Scrollbar(table_frame, orient="horizontal", command=self._tree.xview)
        self._tree.configure(yscrollcommand=y_scroll.set, xscrollcommand=x_scroll.set)
        self._tree.grid(row=0, column=0, sticky="nsew")
        y_scroll.grid(row=0, column=1, sticky="ns")
        x_scroll.grid(row=1, column=0, sticky="ew")
        table_frame.rowconfigure(0, weight=1)
        table_frame.columnconfigure(0, weight=1)

        self._status_var = tk.StringVar(value="Choose an XML file or XML-formatted resource to begin.")
        ttk.Label(outer, textvariable=self._status_var, relief="sunken", anchor="w", padding=(6, 4)).pack(fill="x", pady=(10, 0))

        style = ttk.Style(self)
        style.configure("Title.TLabel", font=("Segoe UI", 16, "bold"))

    def _set_analysis(self, text: str) -> None:
        self._analysis.configure(state="normal")
        self._analysis.delete("1.0", "end")
        self._analysis.insert("1.0", text)
        self._analysis.configure(state="disabled")

    def _open_file(self) -> None:
        selected = filedialog.askopenfilename(
            title="Open authentication metadata source",
            filetypes=(("XML or resource files", "*.xml *.png *.txt"), ("All files", "*.*")),
        )
        if selected:
            self._load_path(Path(selected))

    def _load_path(self, path: Path, *, show_error: bool = True) -> None:
        self._source_revision += 1
        self._invalidate_response()
        try:
            parser = SecFileParser.from_xml_metadata(path.read_bytes())
            self._records = parser.inventory()
            self._source_path = path
        except (OSError, ValueError, ET.ParseError) as exc:
            self._records = ()
            self._source_path = None
            self._render_rows()
            self._status_var.set("Could not read metadata from the selected file.")
            if show_error:
                messagebox.showerror(
                    "Unable to read file",
                    f"The selected file could not be parsed as metadata.\n\n{exc}",
                    parent=self,
                )
            return

        self._render_rows()
        self._status_var.set(f"Loaded redacted metadata from: {path.name}")

    def _inspect_inputs(self) -> None:
        if not self._records:
            self._set_analysis("Load image3.xml or another XML source first.")
            return

        raw_id = self._id_var.get().strip().upper()
        if not re.fullmatch(r"[0-9A-F]{8}", raw_id):
            self._set_analysis("Enter the SGBM ID as exactly eight hexadecimal digits.")
            return

        seed_text = self._seed_var.get().strip()
        if seed_text.lower().startswith("0x"):
            seed_text = seed_text[2:]
        seed_text = re.sub(r"\s+", "", seed_text)
        if not seed_text or len(seed_text) % 2 or not re.fullmatch(r"[0-9A-Fa-f]+", seed_text):
            self._set_analysis("Seed format is invalid. Enter an even number of hexadecimal digits.")
            return
        seed_bytes = bytes.fromhex(seed_text)

        record = next((row for row in self._records if row.sgbm_id.upper() == raw_id), None)
        if record is None:
            self._set_analysis(
                f"Seed format is valid ({len(seed_bytes)} bytes), but no matching SGBM ID was found in the loaded XML."
            )
            return

        self._set_analysis(
            "Inputs inspected.\n"
            f"SGBM ID: {record.sgbm_id}\n"
            f"Seed: valid hexadecimal, {len(seed_bytes)} bytes\n"
            f"XML record: plain={record.plain_key_data}, type={record.key_type}, "
            f"digest={record.digest_algorithm}, keyData present={record.has_key_data}, "
            f"keyData length={record.key_data_length}\n"
            "Select Calculate response to calculate locally in Python."
        )

    def _invalidate_response(self, *_args) -> None:
        self._response_hex = ""
        self._response.configure(state="normal")
        self._response.delete("1.0", "end")
        self._response.configure(state="disabled")
        self._copy_button.configure(state="disabled")

    def _calculate_response(self) -> None:
        if self._source_path is None:
            self._set_analysis("Load image3.xml or another XML source first.")
            return
        inputs = (self._source_path, self._id_var.get(), self._seed_var.get())
        revision = self._source_revision
        self._invalidate_response()
        self._calculate_button.configure(state="disabled")
        self._set_analysis("Calculating response locally…")

        def worker():
            try:
                result = calculate_response(*inputs)
                self._response_queue.put((inputs, revision, result, None))
            except Exception as exc:
                self._response_queue.put((inputs, revision, None, str(exc)))

        threading.Thread(target=worker, daemon=True).start()
        self.after(100, self._poll_response)

    def _poll_response(self) -> None:
        try:
            inputs, revision, result, error = self._response_queue.get_nowait()
        except queue.Empty:
            self.after(100, self._poll_response)
            return
        self._calculate_button.configure(state="normal")
        if revision != self._source_revision or inputs != (self._source_path, self._id_var.get(), self._seed_var.get()):
            self._set_analysis("Inputs changed during calculation. Calculate again with the current inputs.")
            return
        if error:
            self._set_analysis(f"Response calculation failed:\n{error}")
            self._status_var.set("Calculation failed. See the message above.")
            return
        self._response_hex = result
        self._response.configure(state="normal")
        self._response.insert("1.0", result)
        self._response.configure(state="disabled")
        self._copy_button.configure(state="normal")
        self._set_analysis(f"Response generated for SGBM ID {inputs[1].strip().upper()}: {len(result) // 2} bytes.")
        self._status_var.set("Response ready. Use Copy response to copy the hexadecimal result.")

    def _copy_response(self) -> None:
        if self._response_hex:
            self.clipboard_clear()
            self.clipboard_append(self._response_hex)
            self._status_var.set("Response copied to clipboard.")

    def _select_record(self, _event: tk.Event) -> None:
        selected = self._tree.selection()
        if selected:
            values = self._tree.item(selected[0], "values")
            if values:
                self._id_var.set(str(values[0]))

    def _render_rows(self) -> None:
        self._tree.delete(*self._tree.get_children())
        query = self._filter_var.get().strip().upper()
        visible = [record for record in self._records if query in record.sgbm_id.upper()]
        for record in visible:
            self._tree.insert(
                "",
                "end",
                values=(
                    record.sgbm_id,
                    "yes" if record.plain_key_data else "no",
                    record.key_type,
                    record.digest_algorithm,
                    "yes" if record.has_key_data else "no",
                    record.key_data_length,
                ),
            )
        if self._records:
            self._count_var.set(f"{len(visible)} shown / {len(self._records)} records")
        else:
            self._count_var.set("No file loaded")

    def _reset_filter(self) -> None:
        self._filter_var.set("")
        self._render_rows()

    def _clear(self) -> None:
        self._source_revision += 1
        self._invalidate_response()
        self._records = ()
        self._source_path = None
        self._filter_var.set("")
        self._id_var.set("")
        self._seed_var.set("")
        self._render_rows()
        self._set_analysis("Cleared. Load an XML source and enter the seed inputs to inspect them.")
        self._status_var.set("Cleared. Choose an XML file or XML-formatted resource to begin.")

    def _export_csv(self) -> None:
        if not self._records:
            messagebox.showinfo("Nothing to export", "Load a metadata file first.", parent=self)
            return
        destination = filedialog.asksaveasfilename(
            title="Export redacted metadata",
            defaultextension=".csv",
            initialfile="bm3_authentication_metadata.csv",
            filetypes=(("CSV files", "*.csv"),),
        )
        if not destination:
            return
        try:
            with Path(destination).open("w", newline="", encoding="utf-8-sig") as csv_file:
                writer = csv.writer(csv_file)
                writer.writerow(("sgbm_id", "plain_key_data", "key_type", "digest_algorithm", "has_key_data", "key_data_length"))
                for record in self._records:
                    writer.writerow((
                        record.sgbm_id,
                        record.plain_key_data,
                        record.key_type,
                        record.digest_algorithm,
                        record.has_key_data,
                        record.key_data_length,
                    ))
        except OSError as exc:
            messagebox.showerror("Export failed", f"Could not write the CSV file.\n\n{exc}", parent=self)
            return
        self._status_var.set(f"Exported {len(self._records)} redacted records to: {Path(destination).name}")


def main() -> None:
    MetadataViewer().mainloop()


if __name__ == "__main__":
    main()

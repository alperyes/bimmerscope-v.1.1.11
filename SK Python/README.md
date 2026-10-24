# Seed response GUI

Install the Python dependencies from this project directory:

```powershell
py -3 -m pip install -r requirements.txt
```

Double-click `run_gui.bat`. The bundled `image3.xml` loads automatically.
Enter the eight-digit SGBM ID and hexadecimal seed, then click
**Calculate response**. The seed remains visible as you type. The result
appears in the response field; use **Copy response** to copy the complete
hexadecimal result without spaces or line breaks.

Use **Open XML / resource…** to select a different XML source. Input inspection
and calculation both use that loaded source. Changing inputs, loading a file,
or clearing the viewer removes the previous response. If inputs or the loaded
source change during a calculation, its result is discarded.

## How calculation works

`seed_response.py` calculates locally in Python using the loaded XML records
and the bundled `resources/image1.png`, `resources/image2.png`, and encrypted
`resources/key_reference.json`. Resource passwords and decrypted key material
are handled in memory. No Java runtime is needed. The original
`agent.jar` is a static reference for the implementation only; the application
does not call it to calculate responses.

The displayed response includes the implementation's length field followed
by its signature. The GUI reports the total response byte count and does not
add diagnostic service or subfunction bytes. CSV export contains record
metadata only. Seeds and calculated responses are not saved by the GUI.

For RSA-1024 the complete calculated result is 132 bytes: the four-byte word
count `00000020` and 128 bytes of formatted RSA output. The reference uses a
custom raw RSA operation and word order; using a standard RSA signature API
would produce different output.

The supplied XML includes newer key types 24, 25, 40 and 41 that the reference
code does not implement. These produce an explicit unsupported-type error.
The supported records use symmetric or RSA key types up to 23.

The cryptography dependency is bounded below version 51 because the original
encrypted PKCS12 bundle uses BER and the tested reader supports that encoding.

## Checks

Run `py -3 -m unittest discover -s tests -v` from the project directory.
The regression fixture is the previously recorded response for synthetic seed
`00` repeated 16 times and SGBM ID `00000003`. It matches byte for byte with
external process creation and archive access blocked. Tests never run the
reference JAR. Local checks also cover each supported combination of key type,
digest and encoded key length, and GUI background calculation.

Vehicle acceptance has not been tested by these checks.

## BimmerScope integration

The guided DME preparation flow passes an eight-byte `67 11` seed and the
current BTLD's first eight hexadecimal digits to this calculator. A valid
result is sent once as `27 12 <key>`. Android embeds these modules with
Chaquopy. The Windows app extracts the same modules into its private app data
folder and invokes `py -3` (or `python`) locally; install the listed
requirements first. The calculated response is redacted from the app exchange
report and raw transport trace. This applies to the exact challenge request
in both guided prep and manual diagnostic messages.

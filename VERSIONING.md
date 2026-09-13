# BimmerScope versioning

The source of truth is the `version:` field in `pubspec.yaml`.

The current experimental release is `1.1.4+1`. Build numbers are never reused.
Experimental work happens on a feature branch and must use a distinct
pre-release name (for example `1.1.4-experimental.2`) until it is ready for
the stable `1.1.4` tag.

Distributed APK names use:

```text
BimmerScope-v<version-name>+<build-number>-<flavor>-<build-mode>.apk
```

For the current source tree, a Tune debug build is named:

```text
BimmerScope-v1.1.4+1-tune-debug.apk

## Git release safety

`main` is the release baseline. Experimental changes belong on the
`codex/experimental-v1.1.4` branch. The tag `v1.1.4-experimental-base` marks
the known-good starting point for that work; it must not be rewritten.

No build in this experimental line should be described as supporting ECU
flashing, unlocking, or calibration writing. Those capabilities remain
disabled until an exact ECU/software path has been validated on the bench and
on the target vehicle.
```

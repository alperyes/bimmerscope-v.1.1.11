# BimmerScope versioning

The source of truth is the `version:` field in `pubspec.yaml`.

The current experimental workspace is `1.1.8-experimental.1+53`. Build numbers
are never reused. This work is on the `codex/experimental-v1.1.8` branch.

Distributed APK names use:

```text
BimmerScope-v<version-name>+<build-number>-<flavor>-<build-mode>.apk
```

For the current source tree, a Tune debug build is named:

```text
BimmerScope-v1.1.8-experimental.1+53-tune-debug.apk
```

## Git release safety

`main` is the release baseline. Keep experimental changes on the versioned
experimental branch; do not move or rewrite existing tags.

No build in this experimental line should be described as supporting ECU
flashing, unlocking, or calibration writing. Those capabilities remain
disabled until an exact ECU/software path has been validated on the bench and
on the target vehicle.
```

# BimmerScope versioning

The source of truth is the `version:` field in `pubspec.yaml`.

`1.1.0-dev+24` is a prerelease version name (`1.1.0-dev`) with Android/iOS
build number `24`. Build numbers are never reused.

Distributed APK names use:

```text
BimmerScope-v<version-name>+<build-number>-<flavor>-<build-mode>.apk
```

For this source tree, a Tune debug build is named:

```text
BimmerScope-v1.1.0-dev+24-tune-debug.apk
```

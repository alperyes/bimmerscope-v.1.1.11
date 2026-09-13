param(
  [ValidateSet('core', 'tune')]
  [string]$Flavor = 'tune',
  [ValidateSet('debug', 'profile', 'release')]
  [string]$BuildMode = 'debug'
)

$buildDate = Get-Date -Format 'yyyy-MM-dd'
$buildTime = Get-Date -Format 'HH:mm:ss'
$edition = $Flavor
$versionLine = Get-Content -LiteralPath '.\pubspec.yaml' |
  Where-Object { $_ -match '^version:\s*(\S+)\s*$' } |
  Select-Object -First 1
if ($null -eq $versionLine -or $versionLine -notmatch '^version:\s*(\S+)\s*$') {
  throw 'Could not read the application version from pubspec.yaml.'
}
$fullVersion = $matches[1]
$versionParts = $fullVersion -split '\+', 2
if ($versionParts.Count -ne 2 -or [string]::IsNullOrWhiteSpace($versionParts[0]) -or [string]::IsNullOrWhiteSpace($versionParts[1])) {
  throw "Version '$fullVersion' must use <version-name>+<build-number> format."
}
$versionName = $versionParts[0]
$buildNumber = $versionParts[1]
$flutterApk = ".\build\app\outputs\flutter-apk\app-$Flavor-$BuildMode.apk"
$artifactName = "BimmerScope-v$versionName+$buildNumber-$Flavor-$BuildMode.apk"
$artifactPath = ".\build\app\outputs\flutter-apk\$artifactName"

flutter build apk `
  --$BuildMode `
  --flavor $Flavor `
  --dart-define=BIMMERSCOPE_EDITION=$edition `
  --dart-define=BIMMERSCOPE_VERSION=$fullVersion `
  --dart-define=BIMMERSCOPE_BUILD_DATE=$buildDate `
  --dart-define=BIMMERSCOPE_BUILD_TIME=$buildTime

if (-not (Test-Path -LiteralPath $flutterApk)) {
  throw "Flutter did not produce the expected APK: $flutterApk"
}
Move-Item -LiteralPath $flutterApk -Destination $artifactPath -Force
Write-Output "Versioned APK: $artifactPath"

param([Parameter(Mandatory=$true)][string]$KiswbRoot, [string]$Output = "$PSScriptRoot\..\lib\vehicle\vehicle_platform_registry.g.dart", [Parameter(Mandatory=$true)][string]$HsqlDbJar)
$ErrorActionPreference = 'Stop'
$outDir = Split-Path -Parent $Output
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
javac -cp $HsqlDbJar "$PSScriptRoot\extract_vehicle_registry.java"
java -cp "$HsqlDbJar;$PSScriptRoot" ExtractVehicleRegistry $KiswbRoot $Output

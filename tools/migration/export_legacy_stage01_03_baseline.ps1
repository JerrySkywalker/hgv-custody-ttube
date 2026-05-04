[CmdletBinding()]
param(
    [string]$LegacyRoot = "C:\Dev\src\hgv-custody-inversion-scheduling",
    [string]$NewRoot = "C:\Dev\src\hgv-custody-ttube",
    [string]$MatlabRoot = "",
    [string]$BaselineId = "stage01_03_minimal",
    [switch]$AllowLegacyRun,
    [switch]$RunMatlab
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingDirectory {
    param([string]$PathValue, [string]$Name)
    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        throw "$Name must not be empty."
    }
    $resolved = Resolve-Path -LiteralPath $PathValue -ErrorAction Stop
    if (-not (Test-Path -LiteralPath $resolved.Path -PathType Container)) {
        throw "$Name must be an existing directory: $PathValue"
    }
    return $resolved.Path
}

$legacyRootResolved = Resolve-ExistingDirectory -PathValue $LegacyRoot -Name "LegacyRoot"
$newRootResolved = Resolve-ExistingDirectory -PathValue $NewRoot -Name "NewRoot"
$baselineRoot = Join-Path $newRootResolved ("legacy_reference\golden_small\" + $BaselineId)

if (-not (Test-Path -LiteralPath $baselineRoot -PathType Container)) {
    New-Item -ItemType Directory -Path $baselineRoot | Out-Null
}

$mFile = Join-Path $newRootResolved "tools\migration\export_legacy_stage01_03_baseline.m"
if (-not (Test-Path -LiteralPath $mFile -PathType Leaf)) {
    throw "MATLAB scaffold not found: $mFile"
}

$allowValue = if ($AllowLegacyRun.IsPresent) { "true" } else { "false" }
$matlabCode = "addpath('$($newRootResolved.Replace('\','/'))'); export_legacy_stage01_03_baseline('LegacyRoot','$($legacyRootResolved.Replace('\','/'))','NewRoot','$($newRootResolved.Replace('\','/'))','BaselineId','$BaselineId','AllowLegacyRun',$allowValue);"

if ([string]::IsNullOrWhiteSpace($MatlabRoot)) {
    $matlabExe = "matlab"
} else {
    $matlabExe = Join-Path $MatlabRoot "bin\matlab.exe"
}

$cmd = @(
    "`"$matlabExe`"",
    "-batch",
    "`"$matlabCode`""
) -join " "

Write-Host "[dry-run] LegacyRoot     : $legacyRootResolved"
Write-Host "[dry-run] NewRoot        : $newRootResolved"
Write-Host "[dry-run] BaselineId     : $BaselineId"
Write-Host "[dry-run] Output         : $baselineRoot"
Write-Host "[dry-run] AllowLegacyRun : $allowValue"
Write-Host "[dry-run] MATLAB command : $cmd"

if (-not $RunMatlab.IsPresent) {
    Write-Host "[dry-run] RunMatlab was not specified; MATLAB was not launched."
    exit 0
}

Write-Host "[execute] Launching MATLAB scaffold. Legacy runners remain disabled unless AllowLegacyRun is explicitly set."
& $matlabExe -batch $matlabCode

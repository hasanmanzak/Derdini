[CmdletBinding()]
param(
    [switch]$ListOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$suiteRoot = Join-Path $PSScriptRoot 'capabilities'
$suiteSuffix = '.tests.ps1'
$environmentNames = @(
    'DERDINI_TEST_RUNNER_PID',
    'DERDINI_TEST_SUITE_ID',
    'DERDINI_TEST_TEMP_ROOT'
)

function Get-DirectoryPrefix([string]$Path) {
    $fullPath = [IO.Path]::GetFullPath($Path)
    return $fullPath.TrimEnd([char[]]@('\', '/')) +
        [IO.Path]::DirectorySeparatorChar
}

function Assert-OrdinaryDirectory([string]$Path, [string]$Label) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "$Label is absent."
    }
    $item = Get-Item -LiteralPath $Path -Force
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "$Label is linked or reparsed."
    }
}

function Assert-OrdinarySuitePath(
    [string]$SuiteRoot,
    [IO.FileInfo]$File
) {
    $suiteRootFull = [IO.Path]::GetFullPath($SuiteRoot)
    $suitePrefix = Get-DirectoryPrefix -Path $suiteRootFull
    $fileFull = [IO.Path]::GetFullPath($File.FullName)
    if (-not $fileFull.StartsWith(
        $suitePrefix,
        [StringComparison]::OrdinalIgnoreCase
    )) {
        throw "Discovered suite '$fileFull' escapes the capability root."
    }
    if (($File.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 -or
        $File.Length -eq 0) {
        throw "Discovered suite '$fileFull' is linked, reparsed, or empty."
    }

    $relative = $fileFull.Substring($suitePrefix.Length)
    $segments = @($relative -split '[\\/]')
    $current = $suiteRootFull
    for ($index = 0; $index -lt $segments.Count - 1; $index++) {
        $current = Join-Path $current $segments[$index]
        Assert-OrdinaryDirectory -Path $current `
            -Label "Suite parent '$current'"
    }
}

Assert-OrdinaryDirectory -Path $suiteRoot -Label 'Capability suite root'
$rootPrefix = Get-DirectoryPrefix -Path $root
$treeItems = @(Get-ChildItem -LiteralPath $suiteRoot -Recurse -Force)
foreach ($item in $treeItems) {
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Capability test tree entry '$($item.FullName)' is linked or reparsed."
    }
}
$suiteFiles = @($treeItems |
    Where-Object {
        -not $_.PSIsContainer -and
        $_.Name.EndsWith($suiteSuffix, [StringComparison]::Ordinal)
    })
if ($suiteFiles.Count -eq 0) {
    throw 'Capability suite discovery returned no canonical suites.'
}

$byId = [System.Collections.Generic.Dictionary[string, IO.FileInfo]]::new(
    [StringComparer]::Ordinal
)
$caseFolded = [System.Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
foreach ($file in $suiteFiles) {
    Assert-OrdinarySuitePath -SuiteRoot $suiteRoot -File $file
    $fileFull = [IO.Path]::GetFullPath($file.FullName)
    if (-not $fileFull.StartsWith(
        $rootPrefix,
        [StringComparison]::OrdinalIgnoreCase
    )) {
        throw "Discovered suite '$fileFull' escapes the repository root."
    }
    $identity = $fileFull.Substring($rootPrefix.Length).Replace('\', '/')
    if ($identity -cnotmatch '^tests/capabilities/[a-z][a-z0-9]*(?:-[a-z0-9]+)*(?:/[a-z][a-z0-9]*(?:-[a-z0-9]+)*)*/[a-z][a-z0-9]*(?:-[a-z0-9]+)*\.tests\.ps1$') {
        throw "Discovered suite identity '$identity' is noncanonical."
    }
    if ($byId.ContainsKey($identity) -or -not $caseFolded.Add($identity)) {
        throw "Discovered suite identity '$identity' is duplicated or case-ambiguous."
    }
    $byId.Add($identity, $file)
}

$suiteIds = [string[]]@($byId.Keys)
[Array]::Sort($suiteIds, [StringComparer]::Ordinal)
if ($ListOnly) {
    $suiteIds | Write-Output
    return
}

$hostPath = (Get-Process -Id $PID).Path
if ([string]::IsNullOrWhiteSpace($hostPath) -or
    -not (Test-Path -LiteralPath $hostPath -PathType Leaf)) {
    throw 'Current PowerShell executable could not be resolved.'
}

foreach ($suiteId in $suiteIds) {
    $suite = $byId[$suiteId]
    $tempRoot = Join-Path ([IO.Path]::GetTempPath()) `
        ('derdini-tests-' + [Guid]::NewGuid().ToString('N'))
    $previousEnvironment = @{}
    foreach ($name in $environmentNames) {
        $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable(
            $name,
            [EnvironmentVariableTarget]::Process
        )
    }

    [void](New-Item -ItemType Directory -Path $tempRoot)
    try {
        [Environment]::SetEnvironmentVariable(
            'DERDINI_TEST_RUNNER_PID',
            [string]$PID,
            [EnvironmentVariableTarget]::Process
        )
        [Environment]::SetEnvironmentVariable(
            'DERDINI_TEST_SUITE_ID',
            $suiteId,
            [EnvironmentVariableTarget]::Process
        )
        [Environment]::SetEnvironmentVariable(
            'DERDINI_TEST_TEMP_ROOT',
            $tempRoot,
            [EnvironmentVariableTarget]::Process
        )

        Write-Output "RUN: $suiteId"
        & $hostPath -NoProfile -NonInteractive -File $suite.FullName
        $suiteExitCode = $LASTEXITCODE
        if ($suiteExitCode -ne 0) {
            throw "Capability suite '$suiteId' failed with exit code $suiteExitCode."
        }
    }
    finally {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable(
                $name,
                $previousEnvironment[$name],
                [EnvironmentVariableTarget]::Process
            )
        }
        if (Test-Path -LiteralPath $tempRoot) {
            Remove-Item -LiteralPath $tempRoot -Recurse -Force
        }
    }
    if (Test-Path -LiteralPath $tempRoot) {
        throw "Capability suite '$suiteId' temporary root was not removed."
    }
}

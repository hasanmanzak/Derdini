[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$runner = Join-Path $root 'tests\Verify-MeAndAIAdoption.ps1'
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $failures.Add($Message) }
}

function Assert-Equal([string]$Actual, [string]$Expected, [string]$Message) {
    if ($Actual -cne $Expected) {
        $failures.Add("$Message Expected '$Expected', received '$Actual'.")
    }
}

function Read-GitBlobBytes {
    param(
        [Parameter(Mandatory)][string]$RepositoryRoot,
        [Parameter(Mandatory)][string]$ObjectSpec,
        [ValidateRange(1, 1048576)][int]$MaximumBytes = 1048576
    )

    if ($ObjectSpec -cnotmatch '^(?:HEAD|):(?:[A-Za-z0-9_.-]+/)*[A-Za-z0-9_.-]+$') {
        throw "Unsupported Git object identity '$ObjectSpec'."
    }

    $git = (Get-Command git -CommandType Application -ErrorAction Stop |
        Select-Object -First 1).Source
    $startInfo = [Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $git
    $startInfo.Arguments = "cat-file blob $ObjectSpec"
    $startInfo.WorkingDirectory = $RepositoryRoot
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    $memory = [IO.MemoryStream]::new()
    $started = $false
    try {
        if (-not $process.Start()) {
            throw "Unable to read Git object '$ObjectSpec'."
        }
        $started = $true
        $buffer = [byte[]]::new(81920)
        while (($read = $process.StandardOutput.BaseStream.Read(
            $buffer, 0, $buffer.Length
        )) -gt 0) {
            if ($memory.Length -gt ($MaximumBytes - $read)) {
                throw "Git object '$ObjectSpec' exceeds its size limit."
            }
            $memory.Write($buffer, 0, $read)
        }
        $errorText = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) {
            throw "Unable to read Git object '$ObjectSpec': $errorText"
        }
        return ,$memory.ToArray()
    }
    finally {
        if ($started -and -not $process.HasExited) { $process.Kill() }
        $memory.Dispose()
        $process.Dispose()
    }
}

function Read-CandidateLedgerBytes {
    param(
        [Parameter(Mandatory)][string]$RepositoryRoot,
        [Parameter(Mandatory)][string]$LedgerPath
    )

    $relativePath = '.ai/meandai-capabilities-state.json'
    $status = @(& git -C $RepositoryRoot status --porcelain=v1 `
        --untracked-files=all -- $relativePath 2>&1 | ForEach-Object { [string]$_ })
    if ($LASTEXITCODE -ne 0 -or $status.Count -gt 1) {
        throw 'Unable to resolve one unambiguous capability-ledger candidate.'
    }
    if ($status.Count -eq 0) {
        return ,(Read-GitBlobBytes -RepositoryRoot $RepositoryRoot `
            -ObjectSpec "HEAD:$relativePath")
    }

    $state = $status[0]
    if ($state.Length -lt 3 -or $state.Substring(3) -cne $relativePath) {
        throw 'Capability-ledger status is noncanonical or ambiguous.'
    }
    if ($state.StartsWith('??') -or $state[1] -cne ' ') {
        return ,[IO.File]::ReadAllBytes($LedgerPath)
    }
    if ($state[0] -cne ' ') {
        return ,(Read-GitBlobBytes -RepositoryRoot $RepositoryRoot `
            -ObjectSpec ":$relativePath")
    }
    throw 'Capability-ledger candidate state is unsupported.'
}

$hostPath = (Get-Process -Id $PID).Path
$expectedSuites = @(
    'tests/capabilities/protocol-adoption/protocol-adoption.tests.ps1'
    'tests/capabilities/test-architecture/test-architecture.tests.ps1'
)
$listedSuites = @(& $hostPath -NoProfile -NonInteractive -File $runner -ListOnly 2>&1 |
    ForEach-Object { [string]$_ })
$listExitCode = $LASTEXITCODE
Assert-True ($listExitCode -eq 0) `
    'TEST-0005: stable runner did not support successful list-only discovery.'
Assert-Equal ([string]$listedSuites.Count) ([string]$expectedSuites.Count) `
    'TEST-0005: discovered suite count differs.'
for ($index = 0; $index -lt [Math]::Min($listedSuites.Count, $expectedSuites.Count); $index++) {
    Assert-Equal $listedSuites[$index] $expectedSuites[$index] `
        "TEST-0005: suite identity at ordinal index $index differs."
}

$runnerPid = 0
Assert-True ([int]::TryParse(
    [string]$env:DERDINI_TEST_RUNNER_PID,
    [ref]$runnerPid
)) 'TEST-0006: runner process identity is absent or invalid.'
Assert-True ($runnerPid -ne $PID) `
    'TEST-0006: suite executed in the runner process.'
Assert-Equal ([string]$env:DERDINI_TEST_SUITE_ID) `
    'tests/capabilities/test-architecture/test-architecture.tests.ps1' `
    'TEST-0006: suite received the wrong canonical identity.'

$tempRoot = [string]$env:DERDINI_TEST_TEMP_ROOT
Assert-True (-not [string]::IsNullOrWhiteSpace($tempRoot)) `
    'TEST-0006: suite temporary root is absent.'
if (-not [string]::IsNullOrWhiteSpace($tempRoot)) {
    $systemTemp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $actualTemp = [IO.Path]::GetFullPath($tempRoot)
    Assert-True ($actualTemp.StartsWith(
        $systemTemp,
        [StringComparison]::OrdinalIgnoreCase
    )) 'TEST-0006: suite temporary root escapes the system temp boundary.'
    Assert-True (Test-Path -LiteralPath $actualTemp -PathType Container) `
        'TEST-0006: suite temporary root does not exist.'
    if (Test-Path -LiteralPath $actualTemp -PathType Container) {
        $initialItems = @(Get-ChildItem -LiteralPath $actualTemp -Force)
        Assert-True ($initialItems.Count -eq 0) `
            'TEST-0006: suite temporary root was not fresh.'
        [IO.File]::WriteAllText(
            (Join-Path $actualTemp 'cleanup-sentinel.txt'),
            'runner-owned cleanup evidence',
            [Text.UTF8Encoding]::new($false)
        )
    }
}

$ledgerPath = Join-Path $root '.ai\meandai-capabilities-state.json'
$manifestPath = Join-Path $root '.ai\adoption\meandai-capability-review.json'
Assert-True (Test-Path -LiteralPath $ledgerPath -PathType Leaf) `
    'TEST-0007: terminal capability ledger is absent.'
Assert-True (-not (Test-Path -LiteralPath $manifestPath)) `
    'TEST-0007: transient capability-review manifest remains.'

if (Test-Path -LiteralPath $ledgerPath -PathType Leaf) {
    $catalogModule = Join-Path $root '.ai\protocol\scripts\MeAndAI.CapabilityCatalog.psm1'
    Import-Module $catalogModule -Force
    $catalog = Import-MeAndAICapabilityCatalog `
        -IndexPath (Join-Path $root '.ai\protocol\capabilities\index.json')
    $ledgerBytes = Read-CandidateLedgerBytes -RepositoryRoot $root `
        -LedgerPath $ledgerPath
    $ledger = Import-MeAndAICapabilityLedger -Catalog $catalog `
        -Bytes $ledgerBytes
    Assert-True (@($ledger.Entries).Count -eq 1) `
        'TEST-0007: terminal capability ledger does not contain one exact entry.'
    if (@($ledger.Entries).Count -eq 1) {
        $entry = $ledger.Entries[0]
        Assert-Equal ([string]$entry.Slug) 'test-architecture' `
            'TEST-0007: ledger capability slug differs.'
        Assert-Equal ([string]$entry.DefinitionBlob) `
            '9a3a999f05abbbb4ee710f14d82fb26d86de5ad5' `
            'TEST-0007: ledger definition identity differs.'
        Assert-Equal ([string]$entry.Outcome) 'Conforming' `
            'TEST-0007: ledger terminal outcome differs.'
        Assert-Equal ([string]$entry.ReviewIdentity) 'pull-request:14' `
            'TEST-0007: ledger review identity differs.'
        Assert-Equal ([string]$entry.ReviewAuthority) `
            'https://github.com/hasanmanzak/Derdini/pull/14' `
            'TEST-0007: ledger review authority differs.'
        Assert-True (@($entry.Evidence).Count -ge 3) `
            'TEST-0007: ledger lacks reviewed topology, traceability, and isolation evidence.'
    }

    $ledgerText = [Text.UTF8Encoding]::new($false, $true).GetString($ledgerBytes)
    $crlfBytes = [Text.UTF8Encoding]::new($false).GetBytes(
        $ledgerText.Replace("`n", "`r`n")
    )
    $rejectedCrLf = $false
    try {
        [void](Import-MeAndAICapabilityLedger -Catalog $catalog -Bytes $crlfBytes)
    }
    catch {
        $rejectedCrLf = $_.Exception.Message.Contains('must use LF line endings')
    }
    Assert-True $rejectedCrLf `
        'TEST-0008: strict parser accepted non-LF committed ledger bytes.'
}

foreach ($path in @(
    '.ai/memory/log/2026-07-22-test-architecture-capability.md',
    'docs/features/FEAT-0002-test-architecture-capability/README.md',
    'docs/features/FEAT-0002-test-architecture-capability/test-cases.md',
    'docs/decisions/DEC-0002-minimal-capability-test-runner.md'
)) {
    Assert-True (Test-Path -LiteralPath (Join-Path $root $path) -PathType Leaf) `
        "TEST-0007: required project record '$path' is absent."
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'PASS: TEST-0005 deterministic capability-suite discovery'
Write-Output 'PASS: TEST-0006 separate process and temporary-state cleanup'
Write-Output 'PASS: TEST-0007 reviewed terminal capability evidence'
Write-Output 'PASS: TEST-0008 canonical Git-blob ledger evidence'

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $failures.Add($Message) }
}

function Assert-Equal([string]$Actual, [string]$Expected, [string]$Message) {
    if ($Actual -cne $Expected) {
        $failures.Add("$Message Expected '$Expected', received '$Actual'.")
    }
}

function Get-RegularBlobIdentity(
    [string]$Repository,
    [string]$Commit,
    [string]$Path,
    [string]$Label
) {
    $output = @(& git -C $Repository ls-tree $Commit -- $Path 2>&1 |
        ForEach-Object { [string]$_ })
    if ($LASTEXITCODE -ne 0 -or $output.Count -ne 1) {
        $failures.Add("TEST-0008: $Label tree entry could not be resolved.")
        return ''
    }
    $match = [regex]::Match(
        $output[0],
        '^100644 blob (?<oid>[0-9a-f]{40})\t(?<path>.+)$',
        [Text.RegularExpressions.RegexOptions]::CultureInvariant
    )
    if (-not $match.Success -or
        [string]$match.Groups['path'].Value -cne $Path) {
        $failures.Add("TEST-0008: $Label is not one exact regular blob at '$Path'.")
        return ''
    }
    return [string]$match.Groups['oid'].Value
}

function Get-GitLinkIdentity(
    [string]$Repository,
    [string]$Commit,
    [string]$Path,
    [string]$Label
) {
    $output = @(& git -C $Repository ls-tree $Commit -- $Path 2>&1 |
        ForEach-Object { [string]$_ })
    if ($LASTEXITCODE -ne 0 -or $output.Count -ne 1) {
        $failures.Add("TEST-0008: $Label gitlink could not be resolved.")
        return ''
    }
    $match = [regex]::Match(
        $output[0],
        '^160000 commit (?<oid>[0-9a-f]{40})\t(?<path>.+)$',
        [Text.RegularExpressions.RegexOptions]::CultureInvariant
    )
    if (-not $match.Success -or
        [string]$match.Groups['path'].Value -cne $Path) {
        $failures.Add("TEST-0008: $Label is not one exact gitlink at '$Path'.")
        return ''
    }
    return [string]$match.Groups['oid'].Value
}

$head = ((& git -C $root rev-parse HEAD) -join '').Trim()
Assert-True ($LASTEXITCODE -eq 0 -and $head -cmatch '^[0-9a-f]{40}$') `
    'TEST-0008: repository HEAD identity could not be resolved.'
$protocolRoot = Join-Path $root '.ai\protocol'
$protocolGitLink = Get-GitLinkIdentity -Repository $root -Commit $head `
    -Path '.ai/protocol' -Label 'pinned protocol'
$protocolItem = Get-Item -LiteralPath $protocolRoot -Force `
    -ErrorAction SilentlyContinue
Assert-True ($null -ne $protocolItem -and $protocolItem.PSIsContainer -and
    ($protocolItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) `
    'TEST-0008: protocol checkout is absent or unsafe.'
if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}
$protocolHead = ((& git -C $protocolRoot rev-parse HEAD) -join '').Trim()
Assert-True ($LASTEXITCODE -eq 0 -and $protocolHead -cmatch '^[0-9a-f]{40}$') `
    'TEST-0008: protocol checkout HEAD identity could not be resolved.'
Assert-Equal $protocolHead $protocolGitLink `
    'TEST-0008: protocol checkout HEAD differs from the consumer gitlink.'
if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

$catalogModule = Join-Path $root '.ai\protocol\scripts\MeAndAI.CapabilityCatalog.psm1'
$repositoryEvidenceModule = Join-Path $root `
    '.ai\protocol\scripts\MeAndAI.RepositoryEvidence.psm1'
$moduleSources = @(
    [pscustomobject]@{
        Path = $catalogModule
        RelativePath = 'scripts/MeAndAI.CapabilityCatalog.psm1'
    }
    [pscustomobject]@{
        Path = $repositoryEvidenceModule
        RelativePath = 'scripts/MeAndAI.RepositoryEvidence.psm1'
    }
)
foreach ($moduleSource in $moduleSources) {
    $moduleParent = Get-Item -LiteralPath (Split-Path -Parent $moduleSource.Path) `
        -Force -ErrorAction SilentlyContinue
    $moduleItem = Get-Item -LiteralPath $moduleSource.Path -Force `
        -ErrorAction SilentlyContinue
    $ordinaryParent = $null -ne $moduleParent -and
        $moduleParent.PSIsContainer -and
        ($moduleParent.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0
    $ordinaryModule = $ordinaryParent -and $null -ne $moduleItem -and
        -not $moduleItem.PSIsContainer -and
        ($moduleItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0
    Assert-True $ordinaryModule `
        "TEST-0008: pinned module '$($moduleSource.RelativePath)' is absent or unsafe."
    if (-not $ordinaryModule) { continue }
    $expectedModuleOid = Get-RegularBlobIdentity -Repository $protocolRoot `
        -Commit $protocolGitLink -Path $moduleSource.RelativePath `
        -Label "pinned module '$($moduleSource.RelativePath)'"
    $actualModuleOid = ((& git -C $protocolRoot hash-object --no-filters -- `
        $moduleSource.RelativePath 2>&1) -join '').Trim()
    Assert-True ($LASTEXITCODE -eq 0 -and
        $actualModuleOid -cmatch '^[0-9a-f]{40}$') `
        "TEST-0008: raw module identity for '$($moduleSource.RelativePath)' could not be resolved."
    Assert-Equal $actualModuleOid $expectedModuleOid `
        "TEST-0008: module '$($moduleSource.RelativePath)' bytes differ from the pinned blob."
}
if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}
Import-Module $catalogModule -Force
Import-Module $repositoryEvidenceModule -Force

$statusBefore = @(& git -C $root status --porcelain=v1 --untracked-files=all 2>&1 |
    ForEach-Object { [string]$_ }) -join "`n"
Assert-True ($LASTEXITCODE -eq 0) `
    'TEST-0008: repository state could not be captured before resolution.'
$ledgerEvidence = Get-MeAndAIRepositoryEvidence `
    -RepositoryRoot $root `
    -RelativePath '.ai/meandai-capabilities-state.json' `
    -Head $head
$ledgerEvidenceRerun = Get-MeAndAIRepositoryEvidence `
    -RepositoryRoot $root `
    -RelativePath '.ai/meandai-capabilities-state.json' `
    -Head $head
$statusAfter = @(& git -C $root status --porcelain=v1 --untracked-files=all 2>&1 |
    ForEach-Object { [string]$_ }) -join "`n"
Assert-True ($LASTEXITCODE -eq 0) `
    'TEST-0008: repository state could not be captured after resolution.'
Assert-True ($ledgerEvidence.Source -cin @('Head', 'Index', 'Worktree')) `
    'TEST-0008: shared resolver returned no supported byte authority.'
Assert-True ($null -ne $ledgerEvidence.Bytes) `
    'TEST-0008: shared resolver returned no ledger bytes.'
Assert-Equal ([string]$ledgerEvidenceRerun.Source) `
    ([string]$ledgerEvidence.Source) `
    'TEST-0008: unchanged rerun selected a different byte authority.'
Assert-Equal ([string]$ledgerEvidenceRerun.ObjectId) `
    ([string]$ledgerEvidence.ObjectId) `
    'TEST-0008: unchanged rerun selected a different object identity.'
if ($null -ne $ledgerEvidence.Bytes -and $null -ne $ledgerEvidenceRerun.Bytes) {
    Assert-Equal ([Convert]::ToBase64String([byte[]]$ledgerEvidenceRerun.Bytes)) `
        ([Convert]::ToBase64String([byte[]]$ledgerEvidence.Bytes)) `
        'TEST-0008: unchanged rerun returned different ledger bytes.'
}
Assert-Equal $statusAfter $statusBefore `
    'TEST-0008: repository-evidence resolution changed repository state.'

$catalog = Import-MeAndAICapabilityCatalog `
    -IndexPath (Join-Path $root '.ai\protocol\capabilities\index.json')
$ledger = Import-MeAndAICapabilityLedger -Catalog $catalog `
    -Bytes ([byte[]]$ledgerEvidence.Bytes)

$workflowPath = Join-Path $root '.github\workflows\meandai-protocol-update.yml'
$workflow = Get-Content -Raw $workflowPath
foreach ($token in @(
    ".meandai-update-source/scripts/Invoke-MeAndAICapabilityReview.ps1",
    '-ConsumerRoot (Get-Location).Path',
    '-ProtocolRoot (Resolve-Path ''.meandai-update-source'').Path'
)) {
    Assert-True $workflow.Contains($token) `
        "TEST-0008: managed workflow lacks pinned review delegation '$token'."
}

$managedAssets = @(
    [pscustomobject]@{
        Consumer = '.github/scripts/Invoke-MeAndAIProtocolUpdate.ps1'
        Template = 'templates/project/.github/scripts/Invoke-MeAndAIProtocolUpdate.ps1'
    }
    [pscustomobject]@{
        Consumer = '.github/scripts/MeAndAI.ProtocolUpdate.psm1'
        Template = 'templates/project/.github/scripts/MeAndAI.ProtocolUpdate.psm1'
    }
    [pscustomobject]@{
        Consumer = '.github/workflows/meandai-protocol-update.yml'
        Template = 'templates/project/.github/workflows/meandai-protocol-update.yml'
    }
)
foreach ($asset in $managedAssets) {
    $consumerOid = Get-RegularBlobIdentity -Repository $root -Commit $head `
        -Path $asset.Consumer -Label "managed consumer asset '$($asset.Consumer)'"
    $templateOid = Get-RegularBlobIdentity `
        -Repository (Join-Path $root '.ai\protocol') -Commit $protocolHead `
        -Path $asset.Template -Label "pinned template '$($asset.Template)'"
    Assert-True (-not [string]::IsNullOrWhiteSpace($consumerOid)) `
        "TEST-0008: managed consumer asset '$($asset.Consumer)' has no blob identity."
    Assert-Equal $consumerOid $templateOid `
        "TEST-0008: managed consumer asset '$($asset.Consumer)' differs from its pinned template."
}
Assert-True (-not (Test-Path -LiteralPath `
    (Join-Path $root '.github\scripts\MeAndAI.RepositoryEvidence.psm1'))) `
    'TEST-0008: consumer-local copy of the shared repository-evidence module exists.'

Assert-Equal ([string]@($ledger.Entries).Count) `
    ([string]@($catalog.Capabilities).Count) `
    'TEST-0009: terminal ledger is not the complete pinned catalog prefix.'
if (@($ledger.Entries).Count -ge 3) {
    $runtimeEntry = $ledger.Entries[1]
    Assert-Equal ([string]$runtimeEntry.Slug) 'test-runtime-efficiency' `
        'TEST-0009: runtime-efficiency ledger slug differs.'
    Assert-Equal ([string]$runtimeEntry.DefinitionBlob) `
        '20c6bc064d04be18ede7ab70983503feb4b799ea' `
        'TEST-0009: runtime-efficiency definition identity differs.'
    Assert-Equal ([string]$runtimeEntry.Outcome) 'NotApplicable' `
        'TEST-0009: runtime-efficiency disposition differs.'
    Assert-Equal ([string]$runtimeEntry.ReviewIdentity) 'pull-request:28' `
        'TEST-0009: runtime-efficiency review identity differs.'
    Assert-Equal ([string]$runtimeEntry.ReviewAuthority) `
        'https://github.com/hasanmanzak/Derdini/pull/28' `
        'TEST-0009: runtime-efficiency review authority differs.'
    Assert-True (@($runtimeEntry.Evidence).Count -ge 2) `
        'TEST-0009: runtime-efficiency assessment lacks inspected-boundary evidence.'

    $repositoryEntry = $ledger.Entries[2]
    Assert-Equal ([string]$repositoryEntry.Slug) `
        'canonical-repository-evidence' `
        'TEST-0009: repository-evidence ledger slug differs.'
    Assert-Equal ([string]$repositoryEntry.DefinitionBlob) `
        '5a323d1cc9b5e64564f63dc577ad0c937a1c91c0' `
        'TEST-0009: repository-evidence definition identity differs.'
    Assert-Equal ([string]$repositoryEntry.Outcome) 'Conforming' `
        'TEST-0009: repository-evidence disposition differs.'
    Assert-Equal ([string]$repositoryEntry.ReviewIdentity) 'pull-request:28' `
        'TEST-0009: repository-evidence review identity differs.'
    Assert-Equal ([string]$repositoryEntry.ReviewAuthority) `
        'https://github.com/hasanmanzak/Derdini/pull/28' `
        'TEST-0009: repository-evidence review authority differs.'
    Assert-True (@($repositoryEntry.Evidence).Count -ge 3) `
        'TEST-0009: repository-evidence assessment lacks source-map evidence.'
}

$manifestPath = Join-Path $root '.ai\adoption\meandai-capability-review.json'
Assert-True (-not (Test-Path -LiteralPath $manifestPath)) `
    'TEST-0009: transient capability-review manifest remains.'
foreach ($path in @(
    '.ai/memory/log/2026-07-24-semantic-capability-review.md',
    'docs/features/FEAT-0003-semantic-capability-review/README.md',
    'docs/features/FEAT-0003-semantic-capability-review/test-cases.md'
)) {
    Assert-True (Test-Path -LiteralPath (Join-Path $root $path) -PathType Leaf) `
        "TEST-0009: required project record '$path' is absent."
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'PASS: TEST-0008 canonical repository-evidence integration'
Write-Output 'PASS: TEST-0009 reviewed terminal capability assessments'

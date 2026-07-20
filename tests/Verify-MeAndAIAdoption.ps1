[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $failures.Add($Message) }
}

$stage = & git -C $root ls-files --stage -- .ai/protocol
Assert-True ($LASTEXITCODE -eq 0) 'TEST-0001: git index inspection failed.'
$stageMatch = [regex]::Match(
    (@($stage) -join "`n"),
    '^160000 (?<sha>[0-9a-f]{40}) 0\s+\.ai/protocol$',
    [Text.RegularExpressions.RegexOptions]::CultureInvariant
)
Assert-True $stageMatch.Success 'TEST-0001: protocol gitlink mode or commit differs.'
$protocolSha = if ($stageMatch.Success) {
    [string]$stageMatch.Groups['sha'].Value
}
else { '' }

$protocolVersionPath = Join-Path $root '.ai/protocol/VERSION'
$protocolVersionExists = Test-Path -LiteralPath $protocolVersionPath -PathType Leaf
Assert-True $protocolVersionExists 'TEST-0001: protocol VERSION is missing.'
if ($protocolVersionExists) {
    $protocolVersion = [IO.File]::ReadAllText($protocolVersionPath).Trim()
    Assert-True ($protocolVersion -match '^(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)$') 'TEST-0001: protocol VERSION is not canonical M.m.rev.'
}

$protocolCheckout = Join-Path $root '.ai/protocol'
if (Test-Path -LiteralPath $protocolCheckout -PathType Container) {
    $protocolHead = & git -C $protocolCheckout rev-parse HEAD
    Assert-True ($LASTEXITCODE -eq 0) 'TEST-0001: initialized protocol checkout could not be inspected.'
    if ($LASTEXITCODE -eq 0 -and $protocolSha) {
        Assert-True (((@($protocolHead) -join '').Trim()) -ceq $protocolSha) 'TEST-0001: initialized protocol checkout differs from the gitlink.'
    }
}
$modules = Get-Content -Raw (Join-Path $root '.gitmodules')
Assert-True ($modules -match '(?m)^\s*path = \.ai/protocol\s*$') 'TEST-0001: submodule path is missing.'
Assert-True ($modules -match '(?m)^\s*url = https://github\.com/hasanmanzak/meAndAI\.git\s*$') 'TEST-0001: canonical submodule URL is missing.'

$required = @(
    'AGENTS.md', '.ai/memory/README.md', '.ai/memory/project.md',
    '.ai/memory/log/2026-07-17-meandai-adoption.md',
    'docs/features/README.md',
    'docs/features/FEAT-0001-meandai-capabilities-adoption/README.md',
    'docs/features/FEAT-0001-meandai-capabilities-adoption/test-cases.md',
    'docs/decisions/README.md',
    'docs/decisions/DEC-0001-pinned-meandai-submodule.md'
)
foreach ($path in $required) {
    Assert-True (Test-Path -LiteralPath (Join-Path $root $path) -PathType Leaf) "TEST-0002: missing $path."
}

$feature = Get-Content -Raw (Join-Path $root 'docs/features/FEAT-0001-meandai-capabilities-adoption/README.md')
Assert-True ($feature.Contains('https://github.com/hasanmanzak/Derdini/issues/2')) 'TEST-0002: adoption issue link is missing.'
Assert-True ($feature.Contains('https://github.com/hasanmanzak/Derdini/pull/1')) 'TEST-0002: pull request link is missing.'

$markdownFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.ai[\\/]protocol([\\/]|$)' }
foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw $file.FullName
    foreach ($match in [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^(https?://|#|mailto:)') { continue }
        $pathPart = [Uri]::UnescapeDataString(($target -split '#', 2)[0])
        if (-not $pathPart) { continue }
        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
        Assert-True (Test-Path -LiteralPath $resolved) "TEST-0002: broken local link '$target' in $($file.FullName.Substring($root.Length + 1))."
    }
}

$instructions = Get-Content -Raw (Join-Path $root 'AGENTS.md')
$memory = Get-Content -Raw (Join-Path $root '.ai/memory/project.md')
$lineEndingVariants = @(
    [pscustomobject]@{ Name = 'LF'; Value = "`n" }
    [pscustomobject]@{ Name = 'CRLF'; Value = "`r`n" }
)
foreach ($label in @('Product purpose', 'Runtime and stack', 'Architecture', 'Product build command', 'Product test command')) {
    $pattern = "(?m)^- $([regex]::Escape($label)):\s+Not yet established\.\r?$"
    foreach ($variant in $lineEndingVariants) {
        $fixture = "- ${label}: Not yet established.$($variant.Value)"
        Assert-True ($fixture -match $pattern) "TEST-0003: AGENTS.md pattern rejects the $($variant.Name) variant for '$label'."
    }
    Assert-True ($instructions -match $pattern) "TEST-0003: AGENTS.md does not preserve unknown '$label'."
}
foreach ($label in @('Purpose', 'Runtime and stack', 'Build command', 'Product test command')) {
    $pattern = "(?m)^- $([regex]::Escape($label)):\s+Not yet established\.\r?$"
    foreach ($variant in $lineEndingVariants) {
        $fixture = "- ${label}: Not yet established.$($variant.Value)"
        Assert-True ($fixture -match $pattern) "TEST-0003: project-memory pattern rejects the $($variant.Name) variant for '$label'."
    }
    Assert-True ($memory -match $pattern) "TEST-0003: project memory does not preserve unknown '$label'."
}
Assert-True (-not (Test-Path -LiteralPath (Join-Path $root '.ai/adoption/meandai-capabilities.json'))) 'TEST-0004: transient adoption manifest still exists.'

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'PASS: TEST-0001 protocol identity'
Write-Output 'PASS: TEST-0002 project-owned records and local links'
Write-Output 'PASS: TEST-0003 unknown product facts remain explicit'
Write-Output 'PASS: TEST-0004 transient manifest absent'

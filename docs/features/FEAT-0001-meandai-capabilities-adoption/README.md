# FEAT-0001 - Adopt meAndAI AI capabilities

| Field | Value |
| --- | --- |
| Classification | Feature |
| Status | Complete |
| Target version | Not yet established |
| Issue | [Derdini #2](https://github.com/hasanmanzak/Derdini/issues/2) |
| Pull request | [Derdini #1](https://github.com/hasanmanzak/Derdini/pull/1) |
| Tests | [Test scenarios](test-cases.md) |

## Problem and outcome

The deterministic bootstrap installed generic protocol assets but could not
establish project-owned planning, memory, semantic decisions, or evidence. The
outcome is a reviewable Derdini-owned adoption of the exact meAndAI 0.9.2 pin
without inventing product behavior or technology.

## Scope

- Reconcile repository instructions and project-local memory.
- Record the immutable protocol integration decision.
- Create feature, decision, test, and bounded-review evidence.
- Validate the documentation graph and remove the transient handoff manifest.

## Non-goals

- Define Derdini's product purpose, runtime, stack, architecture, build, or
  product tests.
- Change the installed lifecycle workflow or contact external services.
- Publish Git changes or change pull-request state.

## Readiness evidence

- Domain and contracts: This is repository governance only. The contract is a
  Git index entry with mode `160000`, exact commit identity, canonical
  `.gitmodules` URL, project-owned records, and no product-domain behavior.
- Consumers and dependencies: repository contributors and the installed
  lifecycle updater consume these records. The launcher-owned issue and PR are
  external traceability authorities.
- Risks: `RISK-0001`—inventing absent project facts; owner: Derdini maintainers;
  response: retain explicit `Not yet established` values until future reviewed
  work establishes them. `RISK-0002`—protocol drift; owner: Derdini
  maintainers; response: exact gitlink pin plus review-only updater.
- Decision: [DEC-0001](../../decisions/DEC-0001-pinned-meandai-submodule.md).
- Verification: focused PowerShell structural checks, local Markdown-link
  validation, one fresh-diff review, and one bounded full-project scan.
- Baseline: product build/test N/A because no product source or tooling exists;
  adoption structural tests were planned before the records were completed.

## Definition of Ready

- [x] Stable ID and linked issue.
- [x] Problem, outcome, scope, and non-goals.
- [x] Acceptance criteria.
- [x] Boundary contracts, consumers, and dependencies.
- [x] Numbered risks and decision.
- [x] One independently reviewable adoption slice.
- [x] Numbered test scenarios and verification approach.
- [x] Test-code and baseline states recorded.

## Acceptance criteria

1. The consumer retains the exact meAndAI commit as a Git submodule and the
   lifecycle workflow remains unchanged.
2. Project-owned instructions, memory, feature, decision, tests, and indexes
   are complete and mutually linked.
3. Missing product facts are stated as `Not yet established`.
4. All local Markdown links resolve, the structural suite passes, and the
   transient adoption manifest is removed.

## Slice ledger

| ID | Slice | Tracking | Tests/run | Self-review/findings | Status |
| --- | --- | --- | --- | --- | --- |
| `FEAT-0001` | Repository-local protocol adoption | [Issue #2](https://github.com/hasanmanzak/Derdini/issues/2) | [TEST-0001–0004](test-cases.md), passed 2026-07-17 | Fresh-diff review, completion scan, and resolved `FIND-0001` below | Complete |

## Self-review and completion scan

On 2026-07-17, one fresh-diff pass reviewed all adoption changes plus the
unchanged workflow and gitlink boundary for semantic correctness, ownership,
secrets, test quality, documentation, and traceability. Validation budget: one
initial full-project scan and one confirmation only if remediation changed the
tree. Scope: every tracked consumer file and the working diff. Exclusions: the
external protocol tree was reviewed from the exact supplied source checkout;
GitHub state and external-link reachability were launcher-owned and network
access was disabled. Local link targets were checked automatically.

The initial scan found zero observations and therefore zero unresolved
`Blocking` findings; no finding register or unchanged confirmation scan was
needed. The dependency-ready queue was empty. The repository became locally
eligible for the launcher-owned converged publication and entered `Waiting`.
The launcher subsequently published [PR #1](https://github.com/hasanmanzak/Derdini/pull/1),
which merged into `main` at
`66dc71aa3676e9d0df314cca6685e991c52f3fa6`.

### Post-merge verifier correction

On 2026-07-17, merged-main verification at
`66dc71aa3676e9d0df314cca6685e991c52f3fa6` produced the finding below.
Shared confidence is `high`. Affected scope is the `TEST-0003` assertions in
[`Verify-MeAndAIAdoption.ps1`](../../../tests/Verify-MeAndAIAdoption.ps1) over
`AGENTS.md` and `.ai/memory/project.md`. Canonical links are
[Issue #2](https://github.com/hasanmanzak/Derdini/issues/2),
[PR #1](https://github.com/hasanmanzak/Derdini/pull/1), this `FEAT-0001`,
[`DEC-0001`](../../decisions/DEC-0001-pinned-meandai-submodule.md), and
[`TEST-0003`](test-cases.md).

| ID | Classification | Disposition | Dependencies | Priority | Severity | Impact rank | Specific evidence | Impact rationale and recommended action | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `FIND-0001` | Verified defect - test portability | `Blocking` | `None` | `p1` | `medium` | `medium` | The LF-only line anchor rejected required statements in both affected files in the real CRLF checkout although the text was present; the corrected pattern accepts the real files and named LF/CRLF fixtures. | The false negative blocked required adoption closure evidence on Windows. Accept the optional carriage return and retain explicit LF/CRLF regression fixtures. | `Resolved` |

The correction changes only verifier portability; it does not change adoption
content or establish any product fact. Its focused evidence is a passing full
`TEST-0001`–`TEST-0004` run under Windows PowerShell: `TEST-0003` exercises
named LF and CRLF fixtures as well as the real CRLF checkout.

The correction fresh-diff review covered the four changed consumer files,
every tracked consumer entry, the protocol gitlink identity, local links,
credential exposure, transient-manifest absence, test quality, documentation,
and traceability. The external protocol tree remained excluded as pinned
external content, while its exact gitlink commit was verified. `git diff
--check` passed. The one budgeted post-remediation confirmation scan found zero
new observations, zero unresolved `Blocking` findings, and an empty remediation
queue.

## Definition of Done

- [x] Acceptance criteria met.
- [x] Mandatory test code and scenario mapping complete.
- [x] Test command and successful result recorded.
- [x] Bounded self-review and post-development scan complete.
- [x] No unresolved `Blocking` finding.
- [x] Documentation, links, pin, and project memory current.
- [x] Issue, pull request, decision, and tests cross-linked.
- [x] CI is not configured for product validation because no product tooling is
  established; focused local adoption evidence is recorded.

## Post-merge release evidence

| Field | Evidence |
| --- | --- |
| External evidence authority | [Issue #2](https://github.com/hasanmanzak/Derdini/issues/2) |
| Release authority | `Pending` |
| Release identifier | `Pending` |
| Target commit | `Pending` |
| Verification evidence | `Pending` |

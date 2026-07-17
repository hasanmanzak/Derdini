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
| `FEAT-0001` | Repository-local protocol adoption | [Issue #2](https://github.com/hasanmanzak/Derdini/issues/2) | [TEST-0001–0004](test-cases.md), passed 2026-07-17 | Fresh-diff review and completion scan below | Complete |

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
needed. The dependency-ready queue was empty. The repository is locally
eligible for the launcher-owned converged publication and is now `Waiting` for
that publication; no commit or push identity is predicted here.

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

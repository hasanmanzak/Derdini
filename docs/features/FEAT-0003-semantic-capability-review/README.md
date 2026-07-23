# FEAT-0003 - Review the Runtime-Efficiency and Repository-Evidence Capabilities

| Field | Value |
| --- | --- |
| Classification | Feature |
| Status | Ready for Review |
| Target version | Not yet established |
| Issue | [Derdini #27](https://github.com/hasanmanzak/Derdini/issues/27) |
| Pull request | [Derdini #28](https://github.com/hasanmanzak/Derdini/pull/28) |
| Tests | [Test scenarios](test-cases.md) |

## Problem

The pinned capability catalog adds semantic review obligations for
`test-runtime-efficiency` and `canonical-repository-evidence`. Derdini has not
yet recorded terminal project-specific assessments for either definition, so
the managed lifecycle correctly keeps PR #28, issue #27, and the transient
review manifest open.

The baseline review also proved that the repository's strict capability-ledger
test can read checkout-transformed CRLF bytes instead of the canonical LF Git
blob. That makes canonical repository evidence applicable; treating both
capabilities as not applicable would conceal a real byte-authority defect.

## Outcome

Derdini records `test-runtime-efficiency` as reviewed `NotApplicable` because
its small validation surface provisions no reusable expensive deterministic
fixture. It records `canonical-repository-evidence` as reviewed `Conforming`,
routes ledger bytes through the pinned shared repository-evidence boundary,
keeps the release-declared updater projection under upstream ownership, and
removes the transient review manifest.

## Scope

- Review the stable test runner, every capability suite, the managed updater,
  and the capability-review workflow against both immutable definitions.
- Add one project-specific adapter test for the pinned shared repository-
  evidence boundary; do not reproduce its Git-state algorithm or anonymous
  fixture coverage.
- Append both terminal assessments to the ordered capability ledger with PR
  #28 as their review authority.
- Update feature, test, and project-memory evidence, then remove the transient
  capability-review manifest.

## Non-goals

- Add fixture pooling, operation-budget infrastructure, or performance claims
  to the current small validation surface.
- Copy, fork, or shadow the protocol's repository-evidence implementation,
  generic fixtures, or generic regression tests.
- Change the protocol gitlink, managed updater assets, product facts, or
  product architecture.
- Mark PR #28 ready, author owner attestation, approve, merge, or finalize the
  managed lifecycle.

## Readiness evidence

- Domain and contracts: the capability ledger is an ordered immutable-catalog
  prefix. Terminal outcomes are reviewed `Conforming` or `NotApplicable` only;
  strict ledger parsing consumes exact bytes selected by their owning Git
  state, and the transient manifest is absent only at completion.
- Consumers and dependencies: contributors invoke
  `tests/Verify-MeAndAIAdoption.ps1`; the ledger test consumes the pinned
  capability catalog and repository-evidence modules; the managed updater and
  workflow are consumer-owned managed projections of upstream-owned pinned
  templates; PR #28 is the semantic review authority.
- Compatibility: the stable validation command and `TEST-0001` through
  `TEST-0007` remain available. The existing `test-architecture` ledger entry
  remains the exact leading catalog assessment.
- `RISK-0006` - Misclassifying expensive setup as absent; owner: Derdini test
  maintainers; response: inspect the root runner, every suite, temporary-state
  lifecycle, and managed-workflow boundaries, then state why reuse and budgets
  provide no material benefit.
- `RISK-0007` - Duplicating the common Git-state algorithm; owner: meAndAI and
  Derdini maintainers; response: import the pinned shared module and add only a
  project-specific integration/source-map assertion.
- `RISK-0008` - Accepting checkout-filtered bytes as committed evidence; owner:
  Derdini test maintainers; response: reproduce the strict-parser failure and
  resolve the ledger through the shared HEAD/index/worktree authority matrix.
- `RISK-0009` - Claiming terminal evidence while the handoff remains present;
  owner: Derdini maintainers; response: executable exact-prefix, review-
  identity, and manifest-absence assertions must pass together.
- Decision: no new numbered decision is required. The implementation follows
  accepted DEC-0001 and DEC-0002 and introduces no architectural choice or
  protocol relaxation.
- Verification: expected-red Windows PowerShell baseline, focused capability
  suites, stable parent runner, parser validation, local-link validation,
  `git diff --check`, one fresh-diff review, and one bounded project scan.

| Test readiness | Gate 1 state | Evidence |
| --- | --- | --- |
| Scenarios | Defined | [TEST-0008 and TEST-0009](test-cases.md) |
| Test code | Green | One capability-local adapter suite plus the existing terminal-ledger owner pass through the stable runner |
| Baseline run | Failed as intended | PR #28 head `8996c55` rejected checkout-transformed CRLF ledger bytes before reaching terminal-manifest validation |

## Decomposition and subfeature gates

| ID | Slice | Tracking | Tests/run | Self-review/findings | Status |
| --- | --- | --- | --- | --- | --- |
| `SUBF-0002` | Review both definitions, repair canonical ledger acquisition, and record terminal evidence | [Issue #27](https://github.com/hasanmanzak/Derdini/issues/27) | [TEST-0008 and TEST-0009](test-cases.md); Windows PowerShell 5.1 and PowerShell 7 green | Fresh-diff and bounded project review complete; `FIND-0006` through `FIND-0011` resolved; no blocker remains | Ready for Review |

## Decisions and relationships

- Protocol integration: [DEC-0001](../../decisions/DEC-0001-pinned-meandai-submodule.md)
- Test ownership: [DEC-0002](../../decisions/DEC-0002-minimal-capability-test-runner.md)
- Test architecture baseline: [FEAT-0002](../FEAT-0002-test-architecture-capability/README.md)
- Capability handoff: [Issue #27](https://github.com/hasanmanzak/Derdini/issues/27) / [PR #28](https://github.com/hasanmanzak/Derdini/pull/28)

## Definition of Ready

- [x] Stable feature, subfeature, test, risk, issue, and pull-request IDs.
- [x] Problem, outcome, scope, and non-goals.
- [x] Acceptance criteria and boundary contracts.
- [x] Consumers, dependencies, compatibility, and ownership.
- [x] Numbered risks and explicit no-new-decision rationale.
- [x] One independently reviewable implementation slice.
- [x] Numbered test scenarios and verification approach.
- [x] Test-code and baseline states recorded before implementation.

## Acceptance criteria

1. The complete validation inventory proves that no repeated expensive
   deterministic setup can be reused without losing required evidence, and the
   ledger records `test-runtime-efficiency` as reviewed `NotApplicable`.
2. Strict ledger parsing obtains candidate bytes through the pinned shared
   repository-evidence module and succeeds for the appropriate exact HEAD,
   stage-zero index, or contained ordinary worktree authority.
3. Project-specific evidence proves workflow delegation and exact managed-
   asset ownership without copying the shared Git-state implementation or its
   generic anonymous-repository tests.
4. The ledger retains the exact `test-architecture` prefix, appends the two
   immutable definitions in catalog order, binds both new assessments to PR
   #28, and remains canonical.
5. `TEST-0001` through `TEST-0009` pass through the stable runner, project
   records and links resolve, and the transient capability-review manifest is
   absent.

## Self-review and convergence scan

On 2026-07-24, one fresh-diff review covered both semantic dispositions, the
shared-module trust boundary, strict ledger bytes and ordering, managed-asset
source mapping, suite ownership, transient-state removal, documentation,
memory, secrets, and traceability. The bounded full-project scan covered all
35 project-owned files. The pinned `.ai/protocol` implementation and GitHub
provider internals were excluded as external authorities; their exact gitlink,
module blobs, managed-template blobs, and live PR #14 / issue #13 closure
metadata were checked at their boundaries.

The finite validation budget was one expected-red baseline, focused checks
while resolving findings, one fresh-diff pass, one full-project scan, and one
post-remediation confirmation. No unchanged re-scan was added.

| ID | Classification | Disposition | Specific evidence and resolution | Status |
| --- | --- | --- | --- | --- |
| `FIND-0006` | Verified byte-authority defect | `Blocking` | Direct worktree ledger bytes were CRLF while the clean Git blob was canonical LF. Both ledger consumers now call the pinned shared HEAD/index/worktree resolver. | Resolved |
| `FIND-0007` | Verified extension brittleness | `Blocking` | TEST-0005 hard-coded two suites and TEST-0007 hard-coded a one-entry ledger. Discovery now includes the third ordinal suite while TEST-0007 preserves only its exact leading assessment; TEST-0009 owns the complete current suffix. | Resolved |
| `FIND-0008` | Verified cross-runtime serialization defect | `Blocking` | An apostrophe in initial evidence serialized differently under Windows PowerShell 5.1 and PowerShell 7. Canonical evidence wording now produces identical strict bytes and both runtimes pass. | Resolved |
| `FIND-0009` | Verified diff-hygiene defect | `Blocking` | The first review diff contained unintended CRLF churn in existing files and failed `git diff --check`. Intended files were restored to LF without BOM; the focused diff and check are clean. | Resolved |
| `FIND-0010` | Verified code-authority ordering defect | `Blocking` | The first TEST-0008 draft imported protocol modules before proving their pin. It now binds superproject HEAD to the exact `160000` gitlink, matches submodule HEAD, and verifies both ordinary module files against their pinned regular-blob raw identities before import. | Resolved |
| `FIND-0011` | Verified lifecycle-evidence ordering defect | `Blocking` | Initial terminal timestamps preceded completion of the bounded review. Both new ledger entries were regenerated at canonical UTC seconds only after every technical review finding was resolved. | Resolved |

The dependency-first remediation queue is empty. The confirmation reruns the
focused adapter, `TEST-0001` through `TEST-0009` through the stable runner on
both available PowerShell runtimes, parser and ordinal-list checks, local-link
validation, `git diff --check`, exact LF/no-BOM ledger validation, and a bounded
credential-pattern scan. It found no unresolved `Blocking` or `High` finding,
and the project is waiting only for maintainer-owned PR gates.

## Definition of Done

- [x] Acceptance criteria met.
- [x] Mandatory test code and scenario mapping complete.
- [x] Test commands and successful results recorded.
- [x] Bounded self-review and required convergence scan complete.
- [x] No unresolved `Blocking` finding.
- [x] Documentation, links, ledger, and project memory current.
- [x] Issue, pull request, feature, decisions, and tests cross-linked.
- [ ] Applicable local and hosted review gates pass.

## Post-merge release evidence

| Field | Evidence |
| --- | --- |
| External evidence authority | [Issue #27](https://github.com/hasanmanzak/Derdini/issues/27) |
| Release authority | `Pending`; this governance-only consumer change does not currently require a product release |
| Release identifier | `Pending` |
| Target commit | `Pending` |
| Verification evidence | `Pending` |

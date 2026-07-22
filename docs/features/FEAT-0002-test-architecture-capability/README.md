# FEAT-0002 - Adopt the Test Architecture Capability

| Field | Value |
| --- | --- |
| Classification | Feature |
| Status | Ready for Review |
| Target version | Not yet established |
| Issue | [Derdini #13](https://github.com/hasanmanzak/Derdini/issues/13) |
| Pull request | [Derdini #14](https://github.com/hasanmanzak/Derdini/pull/14) |
| Decision | [DEC-0002](../../decisions/DEC-0002-minimal-capability-test-runner.md) |
| Tests | [Test scenarios](test-cases.md) |

## Problem

Derdini owns one automated protocol-adoption verification script, so the
pinned protocol's `test-architecture` capability applies. The current script
combines runner mechanics and protocol assertions at the test root. It has no
recursive capability ownership or explicit separate-suite process boundary,
so reviewed terminal conformance cannot yet be recorded.

## Outcome

The existing verification command remains stable while a small root runner
discovers capability-owned suites deterministically and executes each in a
fresh process with an isolated temporary root. The reviewed terminal
assessment is recorded in the canonical capability ledger and the transient
review manifest is removed.

## Scope

- Preserve `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` as
  the repository's stable validation entry point.
- Place executable suites under `tests/capabilities/<capability>`.
- Discover normalized suite identities recursively in ordinal order and fail
  closed on empty, linked, escaping, noncanonical, or duplicate identities.
- Execute every suite in a separate PowerShell process with a fresh,
  runner-owned temporary root and deterministic cleanup.
- Preserve `TEST-0001` through `TEST-0004`, add capability-contract evidence,
  record one reviewed `Conforming` ledger entry, and remove the manifest.
- Update project-owned documentation and memory without inventing product
  purpose, runtime, architecture, build, or product-test facts.

## Non-goals

- Add product tests, select a product stack, or define product behavior.
- Copy the meAndAI test framework or introduce a shared fixture service.
- Add a hosted CI matrix, validator chain, package dependency, or generated
  test manifest for this one small validation surface.
- Change the protocol pin, updater workflow, or capability definition.

## Readiness evidence

- Domain and contracts: the only domain is repository validation. Canonical
  suite identity is a normalized repository-relative path; discovery is
  ordinal and case-sensitive; child process exit status is authoritative;
  temporary state is runner-owned and must be removed on success or failure.
- Consumers and dependencies: repository contributors and `AGENTS.md` consume
  the existing root command. Suites consume the pinned capability definition.
  The capability ledger is validated by the pinned protocol module and PR #14
  remains the semantic review authority.
- Compatibility: the root command and `TEST-0001` through `TEST-0004` outputs
  remain available. No product command exists to preserve.
- `RISK-0003` - Test architecture grows beyond the repository's needs; owner:
  Derdini maintainers; response: one runner, capability-local suites, and no
  shared module until a second concrete consumer requires it.
- `RISK-0004` - A ledger claims conformance without executable evidence;
  owner: Derdini maintainers; response: black-box discovery, process, cleanup,
  ledger, and manifest scenarios must pass before the ledger is committed.
- `RISK-0005` - Suite state leaks between cases; owner: test maintainers;
  response: one child process and one fresh temporary root per suite with
  cleanup enforced by the root runner.
- Verification: Windows PowerShell baseline and expected-red contract run,
  final Windows PowerShell and PowerShell 7 runs when available, local-link
  validation, one fresh-diff review, and one bounded full-project scan.

| Test readiness | Gate 1 state | Evidence |
| --- | --- | --- |
| Scenarios | Defined | [TEST-0005 through TEST-0007](test-cases.md) |
| Test code | Green | Capability-contract suite and migrated protocol assertions pass through the stable runner |
| Baseline run | Green | Existing `TEST-0001` through `TEST-0004` passed on PR #14 handoff head `e305bef` on 2026-07-22 |

## Decomposition and subfeature gates

| ID | Slice | Tracking | Tests/run | Self-review/findings | Status |
| --- | --- | --- | --- | --- | --- |
| `SUBF-0001` | Minimal capability-owned test topology and reviewed terminal evidence | [Issue #13](https://github.com/hasanmanzak/Derdini/issues/13) | [TEST-0005 through TEST-0007](test-cases.md) | Fresh-diff and full-project review complete; `FIND-0002` resolved; confirmation found no blockers | Ready for Review |

## Decisions and relationships

- Test runner decision: [DEC-0002](../../decisions/DEC-0002-minimal-capability-test-runner.md)
- Protocol integration: [DEC-0001](../../decisions/DEC-0001-pinned-meandai-submodule.md)
- Initial adoption: [FEAT-0001](../FEAT-0001-meandai-capabilities-adoption/README.md)
- Capability handoff: [Issue #13](https://github.com/hasanmanzak/Derdini/issues/13) / [PR #14](https://github.com/hasanmanzak/Derdini/pull/14)

## Definition of Ready

- [x] Stable feature, subfeature, test, risk, issue, and pull-request IDs.
- [x] Problem, outcome, scope, and non-goals.
- [x] Acceptance criteria and boundary contracts.
- [x] Consumers, dependencies, compatibility, and ownership.
- [x] Numbered risks and DEC-0002.
- [x] One independently reviewable implementation slice.
- [x] Numbered test scenarios and verification approach.
- [x] Test-code and baseline states recorded before implementation.

## Acceptance criteria

1. The existing root command recursively lists every canonical capability
   suite once in normalized ordinal order and rejects unsafe discovery.
2. Every discovered suite executes in a separate process with one fresh
   capability-local temporary root that is removed on exit.
3. `TEST-0001` through `TEST-0004` retain their behavior and evidence owner.
4. `TEST-0005` through `TEST-0007` prove topology, traceability, isolation,
   cleanup, exact terminal ledger identity, and transient-manifest removal.
5. Project documentation, links, and memory describe the reviewed structure
   without establishing unknown product facts.

## Self-review and convergence scan

The fresh-diff review covered runner-only mechanics, both capability suites,
scenario ownership, terminal ledger identity, manifest removal, documentation,
memory, local links, and credential-pattern exposure. The post-development
full-project scan covered every project-owned file and the protocol gitlink;
external protocol content and GitHub provider internals remained excluded as
pinned or external authorities.

| ID | Classification | Disposition | Priority | Evidence | Status |
| --- | --- | --- | --- | --- | --- |
| `FIND-0002` | Verified documentation traceability gap | `Blocking` | `p1` | FEAT-0001 still named the stable root runner, rather than the moved `protocol-adoption` suite, as the executable owner of `TEST-0001` through `TEST-0004` | Resolved by linking every scenario to its exact suite owner while retaining the runner as the stable entry point |
| `FIND-0003` | Verified unsafe-discovery gap | `Blocking` | `p1` | Initial discovery rejected reparsed suite files and discovered parents but could silently omit a reparsed directory that the host did not traverse | Resolved by rejecting every linked or reparsed entry in the capability test tree before selecting canonical suites |
| `FIND-0004` | Verified lifecycle-evidence ordering gap | `Blocking` | `p1` | The initial terminal ledger timestamp preceded completion of the bounded review | Resolved by completing the review first and regenerating the canonical ledger review timestamp |
| `FIND-0005` | Verified publication-authority ambiguity | `Blocking` | `p1` | Project memory's initial-adoption wording could be read as prohibiting an authorized agent from updating the exact semantic-review branch | Resolved by separating launcher-owned lifecycle reconciliation, agent-authorized branch updates, and maintainer-owned ready/approval/merge gates |

The single permitted confirmation scan reran `TEST-0001` through `TEST-0007`,
local-link validation, `git diff --check`, the bounded credential-pattern scan,
exact owner mapping, ledger validation, manifest absence, and temporary-root
cleanup. It found no unresolved `Blocking` or `High` finding. PowerShell 7 was
not installed on this host, so that optional local runtime was recorded as not
run rather than inferred.

## Definition of Done

- [x] Acceptance criteria met.
- [x] Mandatory test code and scenario mapping complete.
- [x] Test commands and successful results recorded.
- [x] Bounded self-review and required convergence scan complete.
- [x] No unresolved `Blocking` finding.
- [x] Documentation, links, ledger, and project memory current.
- [x] Issue, pull request, feature, decision, and tests cross-linked.
- [ ] Applicable local and hosted review gates pass.

## Post-merge release evidence

| Field | Evidence |
| --- | --- |
| External evidence authority | [Issue #13](https://github.com/hasanmanzak/Derdini/issues/13) |
| Release authority | `Pending`; this governance-only consumer change does not currently require a product release |
| Release identifier | `Pending` |
| Target commit | `Pending` |
| Verification evidence | `Pending` |

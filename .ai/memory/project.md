# Project Snapshot

Last verified: **2026-07-23**

## Verified facts

- Repository: [hasanmanzak/Derdini](https://github.com/hasanmanzak/Derdini)
- Purpose: Not yet established.
- Runtime and stack: Not yet established.
- Default branch: `main` (verified from the local repository baseline).
- Common protocol integration authority: the `.ai/protocol` gitlink supplies
  the current commit and the `VERSION` inside that exact checkout supplies its
  canonical version. Do not copy a live tag or SHA.
- Build command: Not yet established.
- Product test command: Not yet established.
- Adoption verification: `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1`
  recursively discovers capability-owned suites and executes each suite in a
  separate PowerShell process with runner-owned temporary state.

## Collaboration constraints

- Follow [the repository instructions](../../AGENTS.md) and the pinned common
  protocol.
- Keep credentials and secret values out of repository content and memory.
- The launcher owns lifecycle-record creation, reconciliation, and
  finalization. An explicitly authorized local agent may update the exact
  existing semantic-review branch and pull request; only the maintainer marks
  it ready, approves it, or merges it.

## Engineering direction

- Product architecture is not yet established.
- Protocol integration is defined by
  [DEC-0001](../../docs/decisions/DEC-0001-pinned-meandai-submodule.md).
- Test ownership and execution boundaries are defined by
  [DEC-0002](../../docs/decisions/DEC-0002-minimal-capability-test-runner.md).

## Active context

- Capability feature:
  [FEAT-0002](../../docs/features/FEAT-0002-test-architecture-capability/README.md)
- Capability issue: [#13](https://github.com/hasanmanzak/Derdini/issues/13)
- Capability pull request: [#14](https://github.com/hasanmanzak/Derdini/pull/14)
- Windows canonical-ledger correction:
  [BUG-0001 / issue #23](https://github.com/hasanmanzak/Derdini/issues/23)
- Managed protocol update awaiting maintainer review:
  [PR #22](https://github.com/hasanmanzak/Derdini/pull/22)

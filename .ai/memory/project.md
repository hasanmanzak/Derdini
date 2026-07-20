# Project Snapshot

Last verified: **2026-07-17**

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

## Collaboration constraints

- Follow [the repository instructions](../../AGENTS.md) and the pinned common
  protocol.
- Keep credentials and secret values out of repository content and memory.
- The launcher owns GitHub record reconciliation and publication; local agents
  do not publish or change GitHub state during adoption completion.

## Engineering direction

- Product architecture is not yet established.
- Protocol integration is defined by
  [DEC-0001](../../docs/decisions/DEC-0001-pinned-meandai-submodule.md).

## Active context

- Adoption feature:
  [FEAT-0001](../../docs/features/FEAT-0001-meandai-capabilities-adoption/README.md)
- Adoption issue: [#2](https://github.com/hasanmanzak/Derdini/issues/2)
- Adoption pull request: [#1](https://github.com/hasanmanzak/Derdini/pull/1)

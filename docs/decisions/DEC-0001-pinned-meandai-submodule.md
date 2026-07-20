# DEC-0001 - Pin meAndAI as a Git submodule

- Classification: Decision
- Status: Accepted
- Date: 2026-07-17
- Decision owners: Derdini maintainers
- Related features: [FEAT-0001](../features/FEAT-0001-meandai-capabilities-adoption/README.md)
- Related decisions: None

## Context

Derdini needs an immutable common development protocol while retaining
project-owned instructions, memory, planning records, and evidence. The
repository currently has no established product stack or architecture, so the
integration must not imply product choices.

## Decision

Reference `hasanmanzak/meAndAI` through the `.ai/protocol` Git submodule. In
each consumer revision, the `160000` gitlink supplies the exact protocol commit
and the `VERSION` file inside that checkout supplies its canonical version.
Keep consumer memory, feature and decision records, tests, and tracking
templates outside that submodule. Use the installed, consumer-owned lifecycle
workflow for reviewed compatible update proposals.

## Consequences

- The common protocol is immutable for a given consumer revision.
- A clone must initialize submodules to read `.ai/protocol/PROTOCOL.md` locally.
- Project facts remain independently maintainable and cannot be overwritten by
  the protocol updater.
- Product technology and behavior remain undecided.

## Alternatives considered

A moving branch was rejected because it is not immutable. Copying the protocol
was rejected because it would blur ownership and update provenance. An opaque
repository reference was unnecessary because Git submodules are already the
installed integration mechanism.

## Review condition

Review if the hosting platform can no longer initialize the pinned submodule or
if maintainers approve a different immutable protocol distribution mechanism.

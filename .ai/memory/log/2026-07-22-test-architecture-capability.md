# Test Architecture Capability

Date: **2026-07-22**

## Context

The pinned protocol declared the semantic `test-architecture` capability for
repositories that own automated validation. Derdini's existing adoption
verification made the capability applicable, while its combined root script
did not yet provide capability ownership or separate suite processes.

## Durable outcomes

- [FEAT-0002](../../../docs/features/FEAT-0002-test-architecture-capability/README.md)
  preserves the existing verification command and owns the adoption evidence.
- [DEC-0002](../../../docs/decisions/DEC-0002-minimal-capability-test-runner.md)
  keeps the solution deliberately small: one generic recursive runner and
  capability-local suites, with no copied protocol framework.
- Existing `TEST-0001` through `TEST-0004` assertions are owned by the
  `protocol-adoption` suite. `TEST-0005` through `TEST-0007` are owned by the
  `test-architecture` suite.
- `.ai/meandai-capabilities-state.json` records the immutable capability
  definition and [PR #14](https://github.com/hasanmanzak/Derdini/pull/14) as
  its review authority. The transient capability-review manifest is removed.
- Product purpose, runtime, architecture, build command, and product test
  command remain explicitly unknown.

## Continuation point

Maintainer review and merge of [PR #14](https://github.com/hasanmanzak/Derdini/pull/14)
remain the final gate. The managed lifecycle then owns closure of
[issue #13](https://github.com/hasanmanzak/Derdini/issues/13) and cleanup of
the exact automation branch.

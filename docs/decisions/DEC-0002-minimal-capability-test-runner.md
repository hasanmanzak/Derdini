# DEC-0002 - Use a Minimal Capability-Suite Test Runner

- Classification: Decision
- Status: Accepted
- Date: 2026-07-22
- Decision owners: Derdini maintainers
- Related features: [FEAT-0002](../features/FEAT-0002-test-architecture-capability/README.md)
- Related decisions: [DEC-0001](DEC-0001-pinned-meandai-submodule.md)

## Context

Derdini currently has one automated repository-validation surface and no
established product runtime or native test framework. The pinned semantic
capability requires capability ownership, deterministic recursive discovery,
separate suite processes, small common mechanics, and local fixture state.
Copying meAndAI's larger test infrastructure would exceed the repository's
needs, while keeping one combined root script would not satisfy the process
and discovery boundaries.

## Decision

Keep `tests/Verify-MeAndAIAdoption.ps1` as the stable command but make it a
generic runner only. Canonical suites live recursively below
`tests/capabilities/<capability>` with lowercase `*.tests.ps1` identities.
The runner validates ordinary contained paths, canonical case, and ordinally
unique identities, then invokes every suite through a new process of the
current PowerShell host. Each invocation receives a unique runner-owned
temporary root through process-local environment variables; the runner
restores its environment and removes the root on every exit.

Do not add a shared infrastructure module or persistent fixture layer until a
second concrete responsibility demonstrates common mechanics. Assertions and
fixtures remain with their owning capability.

## Consequences

- The existing contributor command remains compatible.
- New suites gain deterministic ownership and process isolation without a
  framework dependency.
- The runner contains only discovery, execution, environment, and cleanup
  mechanics; capability assertions cannot drift into it.
- Two small PowerShell processes add negligible local overhead for the current
  repository and avoid hosted CI expansion.
- Product tests may later use a repository-native runner if it proves an
  equivalent boundary and this decision is reviewed.

## Alternatives considered

Keeping the combined root script was rejected because it lacks recursive
ownership and a separate-suite process boundary. Copying meAndAI's full test
infrastructure was rejected as unnecessary coupling and complexity. Declaring
the capability not applicable was rejected because the repository already
owns an automated verification surface.

## Review condition

Review when Derdini establishes a product runtime or native test framework,
when capability suites need genuinely shared mechanics, or when the stable
root command can no longer provide equivalent cross-platform process
isolation.

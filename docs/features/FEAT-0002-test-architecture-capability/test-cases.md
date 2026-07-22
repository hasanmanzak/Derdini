# FEAT-0002 Test Scenarios

Test implementations:
[protocol-adoption suite](../../../tests/capabilities/protocol-adoption/protocol-adoption.tests.ps1)
and
[test-architecture suite](../../../tests/capabilities/test-architecture/test-architecture.tests.ps1).

| ID | Related slice | Scenario | Expected result | Level | Status | Automation |
| --- | --- | --- | --- | --- | --- | --- |
| `TEST-0005` | `SUBF-0001` | Canonical recursive capability-suite discovery | The stable runner lists the repository's exact normalized suite identities once in ordinal order; the discovery boundary fails closed on empty, linked, escaping, noncanonical, or duplicate candidates | Structural / integration and reviewed boundary | Passed | `test-architecture.tests.ps1` plus runner review |
| `TEST-0006` | `SUBF-0001` | Separate suite process and temporary-state isolation | Each suite observes a different runner PID, receives an initially empty unique temporary root, and runner cleanup removes that root after execution | Integration / cleanup | Passed | Runner plus `test-architecture.tests.ps1` |
| `TEST-0007` | `SUBF-0001` | Reviewed terminal capability evidence | The canonical ledger contains one exact `Conforming` assessment for the immutable definition and PR #14 review identity, project records resolve, and the transient manifest is absent | Structural / lifecycle | Passed | `test-architecture.tests.ps1` |

## Required coverage

- Existing `TEST-0001` through `TEST-0004` regression behavior.
- Recursive normalized ordinal discovery and exact physical ownership.
- Separate-process execution, fresh temporary state, and cleanup.
- Exact catalog/definition/review ledger identity and manifest removal.
- Project-local documentation and link integrity.

## Evidence

| Date | Commit | Environment | Command | Result |
| --- | --- | --- | --- | --- |
| 2026-07-22 | PR #14 handoff `e305bef` | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Baseline passed: TEST-0001 through TEST-0004; capability contracts not yet implemented |
| 2026-07-22 | Working tree | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/capabilities/test-architecture/test-architecture.tests.ps1` | Expected red pending runner, capability-owned protocol suite, ledger, and manifest removal |
| 2026-07-22 | Working tree | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Expected red after runner implementation: TEST-0001 through TEST-0006 passed; TEST-0007 rejected the absent terminal ledger and retained manifest |
| 2026-07-22 | Working tree | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Passed TEST-0001 through TEST-0007 |
| 2026-07-22 | Working tree | Windows PowerShell 5.1 | Parser validation for all three PowerShell scripts and `tests/Verify-MeAndAIAdoption.ps1 -ListOnly` | Passed; exact two-suite ordinal list returned |
| 2026-07-22 | Working tree | PowerShell 7 | Availability check | Not run because `pwsh` is not installed on this host |
| 2026-07-22 | Reviewed working tree | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Confirmation passed TEST-0001 through TEST-0007 after resolving `FIND-0002` |

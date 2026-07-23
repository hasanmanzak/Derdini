# FEAT-0003 Test Scenarios

Test implementations:
[canonical-repository-evidence suite](../../../tests/capabilities/canonical-repository-evidence/canonical-repository-evidence.tests.ps1)
and the existing
[test-architecture suite](../../../tests/capabilities/test-architecture/test-architecture.tests.ps1).
Stable entry point:
[adoption verification runner](../../../tests/Verify-MeAndAIAdoption.ps1).

| ID | Related slice | Scenario | Expected result | Level | Status | Automation |
| --- | --- | --- | --- | --- | --- | --- |
| `TEST-0008` | `SUBF-0002` | Canonical repository-evidence integration and source map | The Derdini adapter acquires strict ledger bytes from the pinned shared HEAD/index/worktree resolver; the workflow delegates semantic review to the pinned runner; managed updater projections retain exact upstream blob ownership; no consumer-local Git-state algorithm or generic fixture is introduced | Integration / Git authority / ownership | Passed | `canonical-repository-evidence.tests.ps1` |
| `TEST-0009` | `SUBF-0002` | Reviewed terminal capability assessments | The canonical ledger retains the exact first entry, appends reviewed `NotApplicable` runtime-efficiency and `Conforming` repository-evidence entries in catalog order with PR #28 authority and material evidence, and the transient review manifest is absent | Structural / lifecycle | Passed | `canonical-repository-evidence.tests.ps1` plus `test-architecture.tests.ps1` |

## Required coverage

- Complete Derdini test-suite and retained real-boundary inventory for the
  runtime-efficiency applicability decision.
- Exact shared resolver import and strict ledger parsing without text or
  newline normalization.
- Workflow delegation, immutable managed-projection source mapping, and no
  copied common implementation or generic fixture.
- Exact catalog-prefix order, definition blobs, terminal outcomes, evidence,
  PR #28 review identity, and transient-manifest removal.
- Regression behavior for `TEST-0001` through `TEST-0007`.

## Evidence

| Date | Commit | Environment | Command | Result |
| --- | --- | --- | --- | --- |
| 2026-07-24 | PR #28 handoff `8996c55` | Windows PowerShell 5.1, current checkout | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Expected red: protocol-adoption TEST-0001 through TEST-0004 passed; test-architecture stopped because strict ledger parsing received checkout-transformed CRLF bytes |
| 2026-07-24 | Test-first working tree | Windows PowerShell 5.1 | `powershell -NoProfile -File tests/capabilities/canonical-repository-evidence/canonical-repository-evidence.tests.ps1` | Expected red: TEST-0009 rejected the one-entry predecessor ledger before terminal entries and manifest removal were implemented |
| 2026-07-24 | Reviewed working tree based on `8996c55` | Windows PowerShell 5.1 | Focused TEST-0008/TEST-0009 suite, then `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Passed TEST-0001 through TEST-0009 after resolving the pre-import pin and module-byte authority finding |
| 2026-07-24 | Reviewed working tree based on `8996c55` | PowerShell 7 | `pwsh -NoProfile -NonInteractive -File tests/Verify-MeAndAIAdoption.ps1` | Passed TEST-0001 through TEST-0009 with the same canonical ledger bytes |
| 2026-07-24 | Reviewed working tree based on `8996c55` | Windows PowerShell 5.1 and repository diff | Parser validation, `tests/Verify-MeAndAIAdoption.ps1 -ListOnly`, `git diff --check`, local-link and bounded credential-pattern checks | Passed; exact three-suite ordinal list, LF/no-BOM intended files, resolved links, and zero credential-pattern files |

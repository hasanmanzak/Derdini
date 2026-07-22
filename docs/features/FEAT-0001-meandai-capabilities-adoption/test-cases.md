# FEAT-0001 Test Scenarios

Executable owner:
[protocol-adoption suite](../../../tests/capabilities/protocol-adoption/protocol-adoption.tests.ps1).
Stable entry point:
[adoption verification runner](../../../tests/Verify-MeAndAIAdoption.ps1).

| ID | Related slice | Scenario | Expected result | Level | Status | Automation |
| --- | --- | --- | --- | --- | --- | --- |
| `TEST-0001` | `FEAT-0001` | Protocol reference identity | `.ai/protocol` is a `160000` gitlink at the mandated commit and `.gitmodules` names the canonical repository | Structural | Passed | `protocol-adoption.tests.ps1` |
| `TEST-0002` | `FEAT-0001` | Project-owned adoption graph | Feature, decision, memory, issue, PR, and test references exist and local Markdown links resolve | Structural | Passed | `protocol-adoption.tests.ps1` |
| `TEST-0003` | `FEAT-0001` | Unknown product facts | Required product fields explicitly say `Not yet established`, LF and CRLF line-ending fixtures both satisfy the assertions, and no product behavior is invented | Structural | Passed | `protocol-adoption.tests.ps1` |
| `TEST-0004` | `FEAT-0001` | Transient handoff completion | The adoption manifest is absent at completion | Structural | Passed | `protocol-adoption.tests.ps1` |

## Evidence

| Date | Commit | Environment | Command | Result |
| --- | --- | --- | --- | --- |
| 2026-07-17 | Working tree based on `88e422f393d3b8bd50f79b13c6b8849fa089bce5` | Windows PowerShell, isolated clone, spawned network disabled | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Passed: 4 scenarios; local Markdown links validated |
| 2026-07-17 | Corrected working tree based on merged `main` at `66dc71aa3676e9d0df314cca6685e991c52f3fa6` | Windows PowerShell, standard CRLF checkout | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Passed: 4 scenarios after resolving `FIND-0001`; `TEST-0003` covered named LF/CRLF fixtures and the real checkout; local Markdown links validated |

# FEAT-0001 Test Scenarios

Test implementation: [structural adoption suite](../../../tests/Verify-MeAndAIAdoption.ps1)

| ID | Related slice | Scenario | Expected result | Level | Status | Automation |
| --- | --- | --- | --- | --- | --- | --- |
| `TEST-0001` | `FEAT-0001` | Protocol reference identity | `.ai/protocol` is a `160000` gitlink at the mandated commit and `.gitmodules` names the canonical repository | Structural | Passed | `Verify-MeAndAIAdoption.ps1` |
| `TEST-0002` | `FEAT-0001` | Project-owned adoption graph | Feature, decision, memory, issue, PR, and test references exist and local Markdown links resolve | Structural | Passed | `Verify-MeAndAIAdoption.ps1` |
| `TEST-0003` | `FEAT-0001` | Unknown product facts | Required product fields explicitly say `Not yet established` and no product behavior is invented | Structural | Passed | `Verify-MeAndAIAdoption.ps1` |
| `TEST-0004` | `FEAT-0001` | Transient handoff completion | The adoption manifest is absent at completion | Structural | Passed | `Verify-MeAndAIAdoption.ps1` |

## Evidence

| Date | Commit | Environment | Command | Result |
| --- | --- | --- | --- | --- |
| 2026-07-17 | Working tree based on `88e422f393d3b8bd50f79b13c6b8849fa089bce5` | Windows PowerShell, isolated clone, spawned network disabled | `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1` | Passed: 4 scenarios; local Markdown links validated |

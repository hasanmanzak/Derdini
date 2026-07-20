# Project Agent Instructions

These instructions apply to the consuming repository.

1. If `.ai/adoption/meandai-capabilities.json` exists, treat it as an active
   adoption handoff. Complete its project-specific tasks and remove the
   manifest before the pull request becomes ready or merges.
2. Read the [local common protocol](.ai/protocol/PROTOCOL.md) from the pinned
   `.ai/protocol` gitlink. Resolve its current version from
   [the checkout's `VERSION`](.ai/protocol/VERSION); do not duplicate a literal
   current tag or commit in consumer-owned instructions or records.
3. Read this project's `.ai/memory/README.md`.
4. Read the relevant project-owned feature and decision documents before work.
5. Apply project-specific rules below. A relaxation of the common protocol
   requires a numbered project decision.

## Project-specific rules

- Product purpose: Not yet established.
- Runtime and stack: Not yet established.
- Architecture: Not yet established.
- Product build command: Not yet established.
- Product test command: Not yet established.
- Until product tooling exists, validate protocol adoption with
  `powershell -NoProfile -File tests/Verify-MeAndAIAdoption.ps1`.
- Keep project facts and records outside the protocol submodule. Record newly
  established product facts in `.ai/memory/project.md` and the relevant
  feature or decision in the same change.

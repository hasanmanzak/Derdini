# Canonical Capability-Ledger Validation

Date: **2026-07-23**

## Context

Validation of managed protocol update [PR #22](https://github.com/hasanmanzak/Derdini/pull/22)
on Windows exposed a pre-existing false failure in Derdini's capability-owned
test. The committed `.ai/meandai-capabilities-state.json` blob was canonical
LF, while the system `core.autocrlf=true` checkout contained a CRLF-smudged
worktree copy that the strict protocol parser correctly rejected.

## Durable outcome

- [BUG-0001 / issue #23](https://github.com/hasanmanzak/Derdini/issues/23)
  owns the correction.
- `TEST-0008` reads clean ledger evidence from the exact binary-safe `HEAD`
  blob, a staged-only candidate from the index, and untracked or unstaged
  candidate bytes from the worktree.
- The strict UTF-8/LF parser remains unchanged and explicit non-LF candidate
  bytes remain rejected.
- The managed updater PR remains limited to its declared protocol gitlink and
  workflow paths.

## Continuation point

Publish the BUG-0001 correction through its own reviewed pull request. Then
validate the merge result of PR #22 against the corrected default branch;
the maintainer remains responsible for ready/approval/merge of the managed
update draft.

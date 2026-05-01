# Session Handoff

## Sprint

Implementation Sprint 0 on branch `codex/architecture-memory-sprint`.

## Constraints Followed

- Worked only inside `C:\Dev\src\hgv-custody-tpipe`.
- Did not read or modify the old project.
- Did not implement HGV dynamics, Walker generation, DG/DA/DT, ClosedD/OpenD, STK, C++/MEX, or GUI.
- Core code added in this sprint contains no file IO, plotting, STK, COM, cache, manifest, or GUI logic.
- Pipeline code intentionally uses file IO only for the `status.json` progress MVP.

## Files Added

Core:

- `src/+tpipe/+core/+visibility/extractWindowIndices.m`

Pipeline:

- `src/+tpipe/+pipeline/createRunStatus.m`
- `src/+tpipe/+pipeline/updateRunStepStatus.m`
- `src/+tpipe/+pipeline/readRunStatus.m`
- `src/+tpipe/+pipeline/showRunStatus.m`

Tests:

- `tests/unit/test_extractWindowIndices.m`
- `tests/unit/test_runStatus.m`

## Files Modified

- `docs/ARCHITECTURE_BACKLOG.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

## Implementation Summary

`tpipe.core.visibility.extractWindowIndices` extracts complete sliding windows over a monotonic time grid. It returns one full-span window when `Tw_s` is greater than or equal to the total time span. It supports non-1-second grids and window steps that are not integer multiples of sample spacing.

The pipeline progress MVP writes a simple `status.json` file:

- `createRunStatus` creates a run directory and initializes step states as `pending`;
- `updateRunStepStatus` updates a single step to one of `pending`, `running`, `done`, `failed`, or `skipped`;
- `readRunStatus` reads `status.json`;
- `showRunStatus` prints a compact command-line table.

GUI is not implemented. Future GUI work should read the same `status.json` file rather than introduce a separate progress state source.

## Test Results

MATLAB MCP validation:

- Code Analyzer on all new `.m` files: no warnings or issues after cleanup.
- `tests/smoke/test_startup.m`: passed.
- `tests/smoke/test_contracts.m`: passed.
- `tests/unit/test_extractWindowIndices.m`: passed.
- `tests/unit/test_runStatus.m`: passed.

## Remaining Non-Goals

- No DAG scheduler.
- No artifact cache.
- No resume implementation.
- No manifest schema beyond the minimal `status.json` progress file.
- No GUI.

## Suggested Next Sprint

Implementation Sprint 1 should stay small. Recommended choices:

1. Add `core.metrics` gap segment summarizer for synthetic logical masks, with unit tests.
2. Or add a pipeline manifest schema draft that references `status.json` but does not implement resume.
3. Keep old project read-only and do not run long experiments.

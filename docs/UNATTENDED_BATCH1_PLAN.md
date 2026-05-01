# Unattended Batch 1 Development Plan

## 1. Purpose

This document defines the safe unattended development scope for Batch 1 of the migration.

Batch 1 is not a legacy migration batch. It is a clean-core foundation batch.

The goal is to implement small, deterministic, independently testable primitives that later support Stage03/04/08/09 and Chapter 5 migration.

## 2. Why Batch 1 Comes First

Old Stage00-03 are not small pure modules. They mix:

- startup and path logic
- configuration
- cache discovery
- HGV trajectory generation
- casebank construction
- coordinate transforms
- Walker generation
- visibility calculation
- plotting
- summaries

Migrating them first risks copying the old Stage structure into the new repository.

Batch 1 instead builds clean primitives that can be tested without old project outputs. Later batches will connect these primitives to legacy golden baselines.

## 3. Batch 1 Scope

Allowed work:

1. Pure `core` utilities with synthetic tests.
2. Pipeline progress/status MVP.
3. Documentation updates.
4. No legacy output dependency.
5. No heavy computation.

Already completed before this plan:

- `ttube.core.visibility.extractWindowIndices`
- pipeline `status.json` MVP
- contract validators
- smoke tests

Completed Batch 1 function:

```text
ttube.core.metrics.summarizeGapSegments
```

This function is implemented with synthetic unit tests. The unattended Batch 1 sprint did not read the old project and did not depend on legacy outputs.

## 4. Function To Implement

### Function file

`src/+ttube/+core/+metrics/summarizeGapSegments.m`

### Purpose

Summarize false segments in a support/custody/visibility mask.

This function is a primitive used by later:

- Stage08 window sensitivity
- Stage09 DT/gap metrics
- Chapter 5 bubble/custody metrics

### Implemented signature

```matlab
summary = ttube.core.metrics.summarizeGapSegments(t_s, support_mask)
```

### Inputs

| Name | Type | Meaning |
| --- | --- | --- |
| `t_s` | `Nt x 1 double` | Monotonic time grid in seconds. |
| `support_mask` | `Nt x 1 logical` | `true` means supported, visible, or custody-satisfied; `false` means gap/outage. |

### Required output fields

- `summary.total_samples`
- `summary.total_span_s`
- `summary.support_samples`
- `summary.gap_samples`
- `summary.gap_fraction`
- `summary.gap_total_time_s`
- `summary.longest_gap_time_s`
- `summary.gap_count`
- `summary.gap_start_idx`
- `summary.gap_end_idx`
- `summary.gap_t0_s`
- `summary.gap_t1_s`
- `summary.has_gap`

### Rules

- A continuous false segment is one gap.
- All-true input gives `gap_count = 0` and `has_gap = false`.
- All-false input gives `gap_count = 1` and `has_gap = true`.
- Start and end gaps must be handled correctly.
- The function must not read or write files.
- The function must not call plotting, STK, COM, cache, pipeline, or GUI code.
- The function should be MATLAB Coder friendly as far as practical.
- The implemented duration rule is documented in the function: gap duration is approximated as gap sample count multiplied by `median(diff(t_s))`; a single-sample input uses zero sample interval.

### Error IDs

Use explicit error IDs:

- `ttube:metrics:InvalidTimeGrid`
- `ttube:metrics:InvalidSupportMask`

## 5. Required Tests

### Test file

`tests/unit/test_summarizeGapSegments.m`

### Required cases

- all true
- all false
- one gap in the middle
- multiple gaps
- gap at the beginning
- gap at the end
- invalid `t_s` row vector
- invalid nonmonotonic `t_s`
- invalid `support_mask` size
- invalid non-logical `support_mask`
- invalid empty `t_s`
- single-sample all-true and all-false cases

### Test style

Use MATLAB function-based unit tests:

```matlab
function tests = test_summarizeGapSegments
tests = functiontests(localfunctions);
end
```

## 6. Documentation Updates

Status: completed for Batch 1 closure.

Update:

- `docs/MIGRATION_MATRIX.md`
- `docs/ARCHITECTURE_BACKLOG.md`
- `docs/SESSION_HANDOFF.md`

Optional:

- `docs/D_METRIC_CONTRACT_DRAFT.md`

### MIGRATION_MATRIX.md

Update related rows:

- DT
- 可见性/access window
- bubble detection

Mark only the relevant primitive as started or implemented. Do not claim DG/DA/DT is implemented.

### ARCHITECTURE_BACKLOG.md

Marked:

- core.metrics gap segment summarizer

as completed.

Add next step:

- Draft DG/DA/DT contract before implementing any D-metric kernel.

### SESSION_HANDOFF.md

Record:

- added files
- modified docs
- test results
- Code Analyzer result
- next recommended prompt
- statement that this remains Batch 1 only

## 7. Forbidden Work During Unattended Batch 1

Do not:

- read or modify the old project
- run old Stage runners
- create legacy baselines
- implement HGV dynamics
- implement Walker generation
- implement access geometry
- implement FIM/Gramian
- implement DG/DA/DT
- implement ClosedD/OpenD
- implement STK adapter
- implement C++/MEX export
- implement GUI
- run long computations
- auto-commit unless the active sprint instructions explicitly request small-step commits

## 8. Validation Commands

Codex should use MATLAB MCP to run:

- `check_matlab_code` on new/modified `.m` files
- `tests/smoke/test_startup.m`
- `tests/smoke/test_contracts.m`
- `tests/unit/test_extractWindowIndices.m`
- `tests/unit/test_runStatus.m`
- `tests/unit/test_summarizeGapSegments.m`

## 9. Success Criteria

Status: satisfied for Batch 1.

Batch 1 unattended run is successful if:

- `summarizeGapSegments` exists
- all required unit tests exist
- all smoke/unit tests pass
- no old project files were read or modified
- no heavy experiment was run
- no forbidden module was implemented
- docs are updated
- `SESSION_HANDOFF.md` clearly describes next steps

## 10. Batch 1 Validation Scope

Validated with MATLAB MCP:

- `tests/smoke/test_startup.m`
- `tests/smoke/test_contracts.m`
- `tests/unit/test_extractWindowIndices.m`
- `tests/unit/test_runStatus.m`
- `tests/unit/test_summarizeGapSegments.m`

Code Analyzer reported no issues on the new Batch 1 MATLAB files.

## 11. What To Do After User Review

After the user reviews Batch 1:

- draft and review DG/DA/DT contracts;
- create synthetic D-metric toy fixtures only after contract agreement;
- do not proceed to legacy baseline extraction until contracts are reviewed;
- do not directly migrate Stage05/09 large scans.

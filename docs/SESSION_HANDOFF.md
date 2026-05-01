# Session Handoff

## Sprint

Batch 2 Sprint: D-metric contracts and synthetic toy kernels.

## Branch

`codex/batch2-dmetric-contracts`

## Constraints Followed

- Worked only inside `C:\Dev\src\hgv-custody-ttube`.
- Did not read or modify `C:\Dev\src\hgv-custody-inversion-scheduling`.
- Did not run any old project runner.
- Did not run long experiments.
- Did not implement HGV dynamics, Walker generation, real access geometry, real FIM/Gramian assembly, production DG/DA/DT, ClosedD/OpenD, STK, C++/MEX, or GUI.
- Did not enter Batch 3 or extract legacy golden baselines.
- Core additions contain no file IO, plotting, STK, COM, cache, manifest, pipeline, or GUI logic.

## Files Added

- `docs/D_METRIC_CONTRACT_DRAFT.md`
- `src/+ttube/+core/+metrics/computeRequirementMargin.m`
- `src/+ttube/+core/+metrics/combineDTriplet.m`
- `tests/unit/test_computeRequirementMargin.m`
- `tests/unit/test_combineDTriplet.m`
- `tests/fixtures/make_synthetic_d_metric_fixtures.m`

## Files Modified

- `docs/MIGRATION_MASTER_PLAN.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/ARCHITECTURE_BACKLOG.md`
- `docs/SESSION_HANDOFF.md`

## Implementation Summary

`docs/D_METRIC_CONTRACT_DRAFT.md` records draft DG/DA/DT semantics, common output fields, joint feasibility, tie rules, and unresolved questions. It explicitly states that Batch 2 does not define final dissertation metrics.

`ttube.core.metrics.computeRequirementMargin` normalizes metric values against positive requirements in `higher_is_better` or `lower_is_better` mode and returns `margin >= 1` feasibility.

`ttube.core.metrics.combineDTriplet` combines already-normalized synthetic DG/DA/DT margins. It returns `joint_margin`, `joint_feasible`, and `dominant_fail_tag` with tie priority `G > A > T`. Passing rows use `OK`.

Synthetic fixtures in `tests/fixtures/make_synthetic_d_metric_fixtures.m` cover all-pass, single-failure, multi-failure, and tie cases. They do not contain Stage09 or legacy data.

## Test Results

MATLAB MCP tests:

- `tests/smoke/test_startup.m`: 2 passed, 0 failed.
- `tests/smoke/test_contracts.m`: 5 passed, 0 failed.
- `tests/unit/test_extractWindowIndices.m`: 7 passed, 0 failed.
- `tests/unit/test_runStatus.m`: 3 passed, 0 failed.
- `tests/unit/test_summarizeGapSegments.m`: 14 passed, 0 failed.
- `tests/unit/test_computeRequirementMargin.m`: 9 passed, 0 failed.
- `tests/unit/test_combineDTriplet.m`: 9 passed, 0 failed.

Code Analyzer:

- `src/+ttube/+core/+metrics/computeRequirementMargin.m`: no issues.
- `tests/unit/test_computeRequirementMargin.m`: no issues.
- `src/+ttube/+core/+metrics/combineDTriplet.m`: no issues.
- `tests/unit/test_combineDTriplet.m`: no issues.
- `tests/fixtures/make_synthetic_d_metric_fixtures.m`: no issues.

## Commits

- `docs: draft d-metric contracts`
- `feat: add requirement margin primitive`
- `feat: add synthetic d-triplet combiner`
- `test: add synthetic d-metric fixtures`
- `docs: record batch2 d-metric scaffold`

## Remaining Issues

- DG/DA/DT production definitions still need research review.
- Zero-information window handling is not frozen.
- Outage window handling is not frozen.
- DA task projection and high-is-better versus low-is-better direction are not frozen.
- DT duration accounting is not frozen.
- ClosedD definition remains unfrozen.
- OpenD remains an artifact-family concept and is not implemented.

## Next Recommended Work

1. User/research review of `docs/D_METRIC_CONTRACT_DRAFT.md`.
2. After review, plan Batch 3 Stage01-03 legacy golden baseline extraction scaffold.
3. Do not directly migrate Stage05/09 large scans.

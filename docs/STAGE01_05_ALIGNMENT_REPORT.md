# Stage01-05 Alignment Report

## Summary

Status: partial.

The new repository now has a runnable Stage01-05 tiny pipeline for N01 using legacy helper-level adapters and the Stage05 DG metric lineage. It does not run the old full Stage05. A safe old Stage05 tiny runner with hard grid/case guards has not yet been implemented, so old-new Stage05 table parity remains blocked.

## Completed New Pipeline

The new tiny pipeline performs:

1. Stage01 N01 case extraction through `build_casebank_stage01`.
2. Stage02 N01 HGV propagation through `propagate_hgv_case_stage02`.
3. Stage03 Walker build/propagation through `build_single_layer_walker_stage03` and `propagate_constellation_stage03`.
4. Stage03 real access through `compute_visibility_matrix_stage03`.
5. Stage04 window FIM through `build_window_info_matrix_stage04`.
6. Stage05 tiny DG table through `DG = lambda_worst / gamma_req`.

Latest smoke output:

- Run directory: `runs/overnight_stage01_05_production_alignment_20260504_164129`
- New pipeline result file: `runs/overnight_stage01_05_production_alignment_20260504_164129/outputs/stage05_tiny_search.mat`
- Result CSV: `runs/overnight_stage01_05_production_alignment_20260504_164129/outputs/stage05_tiny_search.csv`

The smoke grid completed but found no feasible design. The observed tiny configurations produced zero worst-window DG under the short N01 segment and sparse Walker grids. This is a valid negative tiny result, not a pipeline failure.

## Production Aligned

| Area | Status | Evidence |
|---|---|---|
| Stage01 selected case fields | production aligned | Adapter calls `build_casebank_stage01`; N01 fields verified. |
| Stage02 HGV dynamics | production aligned helper adapter | Adapter calls `propagate_hgv_case_stage02`; `trajectory.v0` validates. |
| Stage03 Walker builder | production aligned helper adapter | Adapter calls `build_single_layer_walker_stage03`; Walker fields preserved. |
| Stage03 Walker propagation | production aligned helper adapter | Adapter calls `propagate_constellation_stage03`; state artifact validates. |
| Stage03 real access geometry | production aligned helper adapter | Adapter calls `compute_visibility_matrix_stage03`; access artifact validates. |
| Stage04 window/FIM | production aligned helper adapter | Adapter calls `build_window_info_matrix_stage04`; matrix dimensions and lambda values verified. |
| DG | production aligned for Stage04/05 | `computeDGProduction` implements `lambda_min_or_worst / gamma_req`. |

## Interface Ready Only

| Area | Status | Reason |
|---|---|---|
| DA | interface ready only | DA belongs to Stage09 metric line; no Stage05 production reference. |
| DT | interface ready only | Support-mask DT helper exists, but Stage09 production DT is not aligned. |
| OpenD | interface ready only | OpenD is a Stage14 artifact family; Stage14 scan is out of scope. |

## Old-New Comparison

Completed hard checks:

- Stage01 N01 case fields exist and match legacy selected-case semantics.
- Stage02 trajectory artifact validates and has monotonic `t_s`, `r_eci_km`, and finite-difference `v_eci_kmps`.
- Stage03 constellation state artifact validates.
- Stage03 access artifact validates.
- Stage04 window/FIM adapter returns 3-by-3 matrices and finite lambda values.
- Stage05 new tiny pipeline emits a result table with DG, feasibility, and summary fields.

Blocked:

- Old Stage05 tiny table comparison was not run. The legacy Stage05 runner loads Stage04 and Stage02 caches and uses configured grids. This sprint has not added a reviewed guard that proves case and grid restrictions before execution, so running it would risk violating the no-large-scan rule.

## Tolerances

Current tests are helper-level contract and smoke tests rather than numeric golden parity tests. Numeric tolerances are:

- DG synthetic unit tests: absolute tolerance `1e-12`.
- Artifact checks: finite values, monotonic time, and expected dimensions.

A future old-new numeric parity test should compare:

- Stage02 `t_s` exact equality under the same `Tmax_s/Ts_s`.
- Stage02 `r_eci_km` absolute tolerance around `1e-9` km when using the same helper.
- Stage03 access masks exact equality.
- Stage04 lambda values relative tolerance around `1e-10` when using the same helper and same windows.

## Blocked Reasons

1. No safe old Stage05 tiny runner exists yet.
2. No committed legacy golden Stage01-05 cache artifact exists.
3. `v_eci_kmps` is derived by finite differences because legacy Stage02 and Stage03 helper outputs expose positions but not full velocity arrays.
4. The tiny smoke grids are deliberately sparse and short; they verify execution, not feasibility.

## Next Steps

1. Add a guarded old Stage05 tiny runner that refuses to execute unless `caseId`, `h/i/P/T/F`, `Tmax_s`, plotting, cache size, and parallel settings are explicitly restricted.
2. Generate a small committed manifest for Stage01-05 alignment, excluding any file over 5 MB.
3. Add numeric parity assertions against helper-level legacy outputs for fixed tiny inputs.
4. Later, replace legacy adapters with new native core backends one module at a time.

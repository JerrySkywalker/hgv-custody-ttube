# Stage01-05 Alignment Design

## Goal

This sprint builds a small runnable new pipeline for the legacy Stage01-05 production line. The target is not a full dissertation-scale scan. The target is a traceable tiny loop:

Stage01 N01 case -> Stage02 HGV trajectory -> Stage03 Walker propagation -> Stage03 access geometry -> Stage04 window/FIM/gamma -> Stage05 tiny DG search.

## Legacy Stage To New Module Map

| Legacy stage/helper | New module | Alignment status |
|---|---|---|
| `build_casebank_stage01` | `ttube.experiments.stage05.buildStage01CasebankMinimal` | production aligned for selected case fields |
| `propagate_hgv_case_stage02` | `ttube.core.traj.propagateHgvTrajectory_legacyStage02` | production aligned adapter for helper-level small runs |
| `build_single_layer_walker_stage03` | `ttube.core.orbit.buildWalkerConstellation_legacyStage03` | production aligned adapter |
| `propagate_constellation_stage03` | `ttube.core.orbit.propagateWalkerConstellation_legacyStage03` | production aligned adapter; velocity is finite-difference derived |
| `compute_visibility_matrix_stage03` | `ttube.core.sensor.computeAccessGeometry_legacyStage03` | production aligned adapter for real legacy access geometry |
| `build_window_info_matrix_stage04` | `ttube.core.estimation.buildWindowInformationMatrix_legacyStage04` | production aligned adapter for window FIM |
| `lambda_worst / gamma_req` | `ttube.core.metrics.computeDGProduction` | production aligned for Stage04/05 DG |
| Stage09 DA/DT | `ttube.core.metrics.computeDAProduction`, `computeDTProduction` | interface ready, not Stage05 production aligned |
| Stage14 OpenD | `ttube.core.metrics.computeOpenDInterface` | interface ready, not Stage05 production aligned |

## HGV Dynamics Backend Interface

`ttube.core.traj.propagateHgvTrajectory(cfg)` is the dispatcher. Supported backends:

- `legacy_stage02`: calls `propagate_hgv_case_stage02` through `propagateHgvTrajectory_legacyStage02`.
- `cache`: extracts a selected trajectory from legacy Stage02 cache when available.

The core dispatcher does not know legacy paths beyond passing `cfg.legacyRoot` into the adapter. The adapter restores MATLAB path with `onCleanup`. The output is the `trajectory.v0` artifact. Legacy Stage02 exposes scalar speed, so `v_eci_kmps` is finite-difference derived from `r_eci_km` and documented in artifact metadata.

## Walker Propagator Backend Interface

`ttube.core.orbit.buildWalkerConstellation(cfg)` builds Walker definitions. `ttube.core.orbit.propagateWalkerConstellation(walker, t_s, cfg)` propagates them. The legacy backend wraps `build_single_layer_walker_stage03` and `propagate_constellation_stage03`.

The output is the `constellation_state.v0` artifact with `r_eci_km` converted from legacy `Nt x 3 x Ns` to contract `Nt x Ns x 3`. Velocity is finite-difference derived.

## Access Geometry Backend Interface

`ttube.core.sensor.computeAccessGeometry(trajectory, constellation, cfg)` dispatches access computation. The legacy backend reconstructs the old `traj_case` and `satbank` shapes and calls `compute_visibility_matrix_stage03`, preserving the old range, Earth occlusion, off-nadir, and optional elevation checks.

The output is the `access.v0` artifact.

## Window/FIM/Gamma Interface

`ttube.core.visibility.buildWindowGrid(access, Tw_s, step_s)` uses the new pure `extractWindowIndices` primitive and emits `window.v0`.

`ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, cfg)` calls the Stage04 adapter, which wraps `build_window_info_matrix_stage04` for each window. `ttube.core.metrics.calibrateGammaRequirement` provides a small new gamma interface for fixed and quantile modes.

## Metric Backend Interface

The unified metric shape uses:

- `metric_name`
- `value`
- `requirement`
- `margin`
- `feasible`
- `failure_tag`
- `direction`
- `production_alignment`

`computeDGProduction` implements Stage05-aligned `DG = lambda_min / gamma_req`, using `lambda_worst` or `info_matrix` input.

`computeDAProduction` intentionally raises `ttube:metrics:BackendNotImplemented`. DA is a Stage09 line and is not production aligned here.

`computeDTProduction` can summarize a support mask via `summarizeGapSegments` for interface tests, but it is labeled support-mask interface ready, not Stage09 production aligned.

`computeOpenDInterface` returns an OpenD interface artifact only. OpenD remains a Stage14 artifact family. No Stage14 scan is run.

## Stage05 Tiny Search Pipeline

`ttube.experiments.stage05.runStage05TinySearch(cfg)` runs the new tiny pipeline over a small table produced by `buildTinySearchGrid`. Each design calls:

1. Stage03 Walker builder adapter.
2. Stage03 Walker propagator adapter.
3. Stage03 real access adapter.
4. Stage04 window/FIM adapter.
5. Stage05 DG production metric.

Outputs are written under the configured run or output directory as `.mat` and `.csv`.

## Comparison Strategy

The hard checks compare contract shape and helper-level behavior:

- Stage01 selected N01 fields are present.
- Stage02 trajectory validates and has monotonic time and ECI position.
- Stage03 constellation and access artifacts validate.
- Stage04 FIM has one or more 3-by-3 windows and finite lambda values.
- Stage05 tiny search returns a table with DG and feasible flags.

Legacy full Stage05 is not run. A legacy Stage05 tiny reference should only be run if a reviewed safe override path restricts case ID and the Walker grid before execution. Until then, Stage05 comparison is new-pipeline smoke plus helper-level Stage01-04 alignment.

## Production Aligned Vs Interface Ready

Production aligned in this sprint:

- Stage01 selected casebank fields.
- Stage02 helper-level HGV trajectory adapter.
- Stage03 helper-level Walker builder and propagator.
- Stage03 helper-level real access geometry.
- Stage04 helper-level window information matrix.
- Stage05 DG formula `lambda_worst / gamma_req`.

Interface ready only:

- DA production backend.
- DT Stage09 production backend.
- OpenD Stage14 backend/artifact family.

Blocked:

- Safe old Stage05 tiny runner is not implemented yet. The old Stage05 script loads caches and its default grid can be large, so this sprint does not run it without a dedicated guard.

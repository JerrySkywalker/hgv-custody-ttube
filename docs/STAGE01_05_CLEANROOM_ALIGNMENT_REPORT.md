# Stage01-05 Clean-Room Alignment Report

## Status

Status: partial.

The new default Stage01-05 tiny pipeline now runs native clean-room code for Stage01 case construction, Stage02 trajectory propagation, Stage03 Walker propagation, Stage03 access geometry, Stage04 information matrix construction, and Stage05 DG search.

## Native Pipeline

Default call:

`ttube.experiments.stage05.runStage05TinySearch(cfg)`

Default backends:

- Stage01: `buildStage01CasebankNative`
- Stage02: `propagateHgvTrajectoryNative`
- Stage03 Walker: `buildWalkerConstellationNative`, `propagateWalkerConstellationNative`
- Stage03 access: `computeAccessGeometryNative`
- Stage04 FIM: `buildWindowInformationMatrixNative`
- DG: `computeDGProduction`

## Clean-Room Dependency Guard

`tests/static/test_noLegacyDependencyInCore.m` scans `src/+ttube/+core` and default Stage05 native experiment files for old helper names. It passed after legacy helper calls were moved to `src/+ttube/+legacy`.

## Old-New Comparison

Legacy comparison uses only helper adapters under `src/+ttube/+legacy`; it does not invoke the old full Stage05 runner.

Completed checks:

- Native access geometry compared against legacy helper geometry on the same legacy trajectory and Walker state.
- Native Stage04 information matrices compared against legacy helper FIM on the same access/constellation inputs.
- Native Stage05 tiny search compared against legacy-helper tiny evaluation for row count, `Ns`, finite DG, and feasible flag availability.

Validation suite:

- All requested smoke/unit/static/integration tests passed.
- `tests/regression/legacy/test_stage0103GoldenArtifacts.m` remains an expected incomplete assumption because the golden `manifest.json` has not been generated.
- Code Analyzer was clean for all new/modified `.m` files in this sprint.

## Alignment Detail

| Stage | Status | Notes |
|---|---|---|
| Stage01 | native geodetic parity for N01 | Uses WGS84 geodetic/ECEF, spherical direct geodesic, ENU heading, and simple GMST ECI rotation. N01 comparison against legacy helper passes strict tolerance. |
| Stage02 | VTC parity candidate, partial | Adds `native_vtc` backend with direct `[v, theta, sigma, phi, lambda, r]` propagation. N01 short-window comparison passes documented tolerances; task-capture event and broader grid parity remain pending. |
| Stage03 Walker | native aligned | Reimplements legacy Walker-T circular semantics. |
| Stage03 access | native aligned for formula | Implements range, Earth occlusion, and off-nadir checks independently. |
| Stage04 FIM | native aligned for formula | Reimplements LOS angle-information accumulation. |
| Stage05 tiny | native runnable | Uses native DG search by default; old full Stage05 not run. |
| DG | production formula aligned | `DG = lambda_worst / gamma_req`. |
| DA/DT/OpenD | interface ready only | Not Stage05 production aligned. |

## Blocked Or Approximate

- Stage02 native is intentionally approximate; full VTC state-equation and event parity remains future work.
- Old full Stage05 tiny table parity remains blocked until a guarded old-runner exists.
- No Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, or GUI work was performed.

## Stage01-02 Production Parity Update

Run: `runs/stage01_02_production_parity_20260505_011242`

New checks completed:

- `tests/unit/test_frameTransforms.m`
- `tests/unit/test_buildStage01CasebankNative.m`
- `tests/unit/test_hgvModelComponents.m`
- `tests/unit/test_hgvDynamicsPointMass.m`
- `tests/integration/test_stage01NativeVsLegacy.m`
- `tests/integration/test_stage02NativeVsLegacyTrajectory.m`
- Stage03-05 native tiny regressions

Validation summary for this sprint selection: 24 passed, 0 failed, 0 incomplete.

Stage01 judgment: production parity for the N01 geodetic/ECEF/ECI fields exercised by the tiny pipeline.

Stage02 judgment: improved partial. It now includes a direct native VTC-state backend and no longer relies on the spherical ECI point-mass prototype as the Stage05 tiny default. It is still not full production parity because task-capture event parity and broader case/grid comparisons remain pending.

## Stage02 Native VTC Parity Update

Run: `runs/stage02_native_vtc_parity_20260505_014722`

`native_vtc` is now the default trajectory backend for Stage05 tiny search. `native_point_mass` remains available as a backend option.

Validation summary for this sprint selection: 34 passed, 0 failed, 0 incomplete.

## Stage04-05 Result-Table Parity Update

Run: `runs/stage04_05_result_table_parity_20260505_022708`

Old full Stage05 runner: not run.

Legacy oracle: guarded helper-level oracle in `src/+ttube/+legacy`.

Native result table: standardized as `stage05_result_table.v0`.

Stage05 tiny result-table parity: complete for the guarded N01 tiny grid. Measured `D_G` max absolute error is approximately `7.5e-5`, feasible match ratio is `1`, and pass-ratio error is `0`.

Validation summary: 45 passed, 0 failed, 0 incomplete.

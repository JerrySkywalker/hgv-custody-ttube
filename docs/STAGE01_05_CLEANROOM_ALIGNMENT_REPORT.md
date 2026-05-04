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
| Stage01 | approximate native | Flat-ENU pseudo-ECI case matches N01 semantics but not full legacy geodetic conversion. |
| Stage02 | approximate native | Simplified point-mass trajectory; not bitwise legacy VTC parity. |
| Stage03 Walker | native aligned | Reimplements legacy Walker-T circular semantics. |
| Stage03 access | native aligned for formula | Implements range, Earth occlusion, and off-nadir checks independently. |
| Stage04 FIM | native aligned for formula | Reimplements LOS angle-information accumulation. |
| Stage05 tiny | native runnable | Uses native DG search by default; old full Stage05 not run. |
| DG | production formula aligned | `DG = lambda_worst / gamma_req`. |
| DA/DT/OpenD | interface ready only | Not Stage05 production aligned. |

## Blocked Or Approximate

- Stage02 native is intentionally approximate; full geodetic VTC parity remains future work.
- Stage01 full geodetic ECEF/ECI parity remains future work.
- Old full Stage05 tiny table parity remains blocked until a guarded old-runner exists.
- No Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, or GUI work was performed.

# Session Handoff

## Sprint

Clean-Room Stage01-05 Native Reimplementation Sprint.

## Branch

`codex/cleanroom-stage01-05-native`

## Base Branch

`codex/overnight-stage01-05-production-alignment`

## Commits

- `77689ef test: guard cleanroom core from legacy dependencies`
- `18dc736 feat: implement native minimal stage01 casebank`
- `d2bc76f feat: implement native hgv trajectory prototype`
- `2c20d88 feat: implement native walker constellation propagation`
- `2cc6aa5 feat: implement native access geometry`
- `9ace662 feat: implement native window information and dg`
- `d6486d2 feat: implement native stage05 tiny search`
- `641e814 refactor: isolate legacy helpers from cleanroom core`
- `634555a test: validate cleanroom stage01-05 alignment`
- `4da6bfe test: run cleanroom stage01-05 validation suite`

No push was performed.

## Run Directory

`runs/cleanroom_stage01_05_native_20260504_171235`

The run status was updated through the sprint. Run outputs were not committed.

## Native Status

Stage01 native: implemented minimal deterministic N01 case via `buildStage01CasebankNative`. It is flat-ENU pseudo-ECI and approximate; full geodetic parity remains pending.

Stage02 native HGV: implemented `propagateHgvTrajectoryNative`, `hgvDynamicsPointMass`, and `rk4Step`. It is a simplified point-mass prototype with replaceable dynamics/control/atmosphere/aero hooks. It is not full legacy VTC parity.

Stage03 native Walker: implemented Walker-T builder and circular two-body propagator. This matches the legacy helper's Walker parameter semantics.

Stage03 native access: implemented range, Earth occlusion, and off-nadir checks in `core.sensor`.

Stage04 native window/FIM/DG: `buildWindowGrid` remains native; `buildWindowInformationMatrixNative` implements LOS angle information; `computeDGProduction` supports scalar, matrix, and window-bank inputs.

Stage05 native tiny search: default `runStage05TinySearch` now uses only native casebank, trajectory, Walker, access, FIM, and DG paths.

## Legacy Isolation

Direct legacy helper calls were moved to `src/+ttube/+legacy`.

`tests/static/test_noLegacyDependencyInCore.m` passed and guards:

- `src/+ttube/+core`
- default native Stage05 experiment files

Legacy helper use remains allowed in:

- `src/+ttube/+legacy`
- `tools/migration`
- `tests/integration`
- `tests/regression`

## Old-New Comparison

No old full Stage05 runner was executed.

Comparison tests use only legacy helper adapters:

- access native vs legacy helper;
- Stage04 FIM/DG native vs legacy helper on same inputs;
- Stage05 tiny native vs legacy-helper tiny evaluation.

## Test Results

Requested clean-room validation suite passed:

- smoke tests;
- existing unit primitives;
- native Stage01/02/03/04/DG unit tests;
- static dependency guard;
- native and native-vs-legacy integration tests;
- legacy manifest regression test.

Expected incomplete:

- `tests/regression/legacy/test_stage0103GoldenArtifacts.m` because `legacy_reference/golden_small/stage01_03_minimal/manifest.json` has not been generated.

Code Analyzer:

- clean for new/modified `.m` files.

## Production Aligned Vs Approximate

Production/formula aligned:

- Stage03 Walker-T circular propagation semantics.
- Stage03 access geometry formula family.
- Stage04 LOS angle-information formula family.
- DG formula `lambda_worst / gamma_req`.

Approximate native:

- Stage01 geodetic fields are pseudo-ECI, not full legacy geodetic parity.
- Stage02 HGV trajectory is simplified point-mass, not full VTC/geodetic legacy parity.

Interface ready only:

- DA
- DT
- OpenD

Not implemented:

- ClosedD
- STK
- C++/MEX
- GUI
- Stage09/Stage14/Ch5 scans

## File Size And Git

- No file over 5 MB was added.
- `git status` was clean after final documentation commit check.
- No push was performed.

## Stage01-02 Production Parity Sprint Update

Run directory: `runs/stage01_02_production_parity_20260505_011242`

New commits:

- `7cb5a1b docs: plan stage01-02 production parity`
- `2982e33 feat: add native geodetic frame utilities`
- `96bb1c9 feat: upgrade native stage01 geodetic casebank`
- `dea2862 feat: factor native hgv model components`
- `3050ab0 feat: improve native hgv dynamics toward vtc parity`

Stage01 status: improved to N01 geodetic/ECEF/ECI parity. The default native casebank now uses WGS84 geodetic conversion, spherical direct-geodesic boundary placement, ENU heading rotation, and simple GMST ECEF-to-ECI rotation. `tests/integration/test_stage01NativeVsLegacy.m` passes strict N01 comparison against the read-only legacy helper.

Stage02 status: improved partial. The default native trajectory now uses Stage01 geodetic/ECI initial state plus VTC-inspired control, aero, and atmosphere modules. It remains a spherical ECI point-mass implementation, not full legacy VTC state-equation parity. `tests/integration/test_stage02NativeVsLegacyTrajectory.m` passes coarse magnitude comparison; the old adapter velocity field is finite-difference based, so initial speed comparison uses a coarse tolerance.

Static guard: passed. Legacy helper calls remain isolated outside native core/default pipeline.

Regression selection: passed 24 tests, 0 failed, 0 incomplete:

- static clean-room guard;
- frame, Stage01, HGV model component, and HGV dynamics unit tests;
- Stage01 and Stage02 native-vs-legacy integration tests;
- Stage03-05 native tiny regression tests.

Code Analyzer: clean for all new/modified MATLAB files checked in this sprint.

No push was performed. Run artifacts remain ignored under `runs/`.

## Next Steps

## Stage02 Native VTC Parity Sprint Update

Run directory: `runs/stage02_native_vtc_parity_20260505_014722`

New commits:

- `0ff8307 docs: plan native vtc stage02 parity`
- `3e17ea7 feat: add vtc state contract`
- `e0edf0f feat: implement native vtc dynamics kernel`
- `c69bb02 feat: add native vtc trajectory backend`
- `4c012ee test: compare native vtc trajectory with legacy stage02`
- `297fbac feat: route stage05 tiny search through native vtc backend`

Stage02 status: `native_vtc` is implemented and is now the Stage02 parity candidate. It propagates the VTC state `[v, theta, sigma, phi, lambda, r]`, uses native control/aero/atmosphere modules, converts to `trajectory.v0`, and passes N01 short-window comparison against the read-only legacy Stage02 adapter.

Default backend status: Stage05 tiny search now defaults to `trajectoryBackend = 'native_vtc'`. `native_point_mass` remains available and was not deleted.

Parity judgment: partial. The current N01 comparison passes documented tolerances, but full production parity is not claimed because task-capture event behavior, `ode45`/RK4 solver differences, finite-difference ECI velocity, and broader case/grid validation remain.

Validation: requested Stage02 native VTC regression suite passed 34 tests, 0 failed, 0 incomplete. Static guard passed. Code Analyzer was clean for all new/modified MATLAB files checked.

No push was performed. No large artifact was added.

## Next Steps

1. Tighten Stage02 native VTC parity for event termination, especially task-capture radius behavior.
2. Expand native_vtc vs legacy comparison beyond N01 and the short validation window.
3. Use `native_vtc` for Stage04/05 tiny result-table parity.
4. Add persisted Stage01-03 golden artifacts under size limits.
5. Add a guarded old Stage05 tiny runner only if strict case/grid/cache controls are implemented first.

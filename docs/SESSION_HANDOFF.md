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

## Stage05 Full Native Reimplementation Sprint Update

Branch: `codex/stage05-full-native-reimplementation`

Run directory: `runs/stage05_full_native_reimplementation_20260505_025047`

Old full Stage05 runner: not run.

New commits:

- `7e96823 docs: plan full native stage05 reimplementation`
- `8cd8d28 feat: add stage05 config and artifact contracts`
- `bd944b3 feat: implement native stage05 nominal search`
- `8a1fc8a feat: add stage05 summary frontier pareto and artifact io`
- `4eb9333 feat: add stage05 native plot bundle`
- `0b6a908 feat: add full native stage05 pipeline`
- `e8261b4 test: validate stage05 module parity with legacy oracle`
- `1767360 test: run stage05 medium-safe native reproduction`
- `e6561b4 test: validate full native stage05 suite`

Stage05.1 search status: native implementation complete for guarded small and medium-safe grids. The formal entry point is `ttube.experiments.stage05.runStage05NominalSearch`; `runStage05TinySearch` remains a compatibility wrapper.

Stage05 artifact/cache/resume status: `stage05_search_result.v0`, `stage05_summary.v0`, `stage05_frontier.v0`, `stage05_pareto_transition.v0`, and `stage05_plot_bundle.v0` are defined. Search results can be saved, loaded, indexed, and minimally resumed through config fingerprint matching.

Stage05.2 plot/postprocess status: native summary, ranking, frontier, heatmap-ready tables, and plot bundle export are implemented under `ttube.experiments.stage05` and `ttube.viz.stage05`. Viz consumes artifacts and does not recompute DG.

Stage05.3 Pareto/transition status: native Pareto front, inclination transition, and pass-ratio diagnostics artifacts are implemented and tested.

Medium-safe reproduction: passed on a 72-design native grid using `trajectoryBackend = native_vtc`; generated search, summary, frontier, Pareto/transition, and plot artifacts in temporary output only.

Legacy oracle status: helper-level guarded oracle only. Module-level parity is available for the tiny N01 grid. No old full Stage05 runner, default large grid, Stage09, Stage14, or Ch5 path was executed.

Validation: requested Stage05 full native suite passed 94 tests, 0 failed, 0 incomplete. Static clean-room guard passed. Code Analyzer was clean for checked new/modified MATLAB files.

Completion judgment: yes for native Stage05 module reimplementation over safe small/medium profiles; partial for production-scale/full legacy-runner parity because the old full runner was intentionally prohibited, plot parity is not pixel-level, and larger formal golden artifacts remain pending.

Next steps:

1. Add a larger safe Stage05 profile once runtime and artifact size bounds are fixed.
2. Persist Stage04/05 golden artifacts under the 5 MB Git limit.
3. Continue Stage02 event parity before broadening production claims.
4. Start Stage06 heading-family migration after Stage05 golden artifacts are stable.

## Stage04-05 Result-Table Parity Sprint Update

Branch: `codex/stage04-05-result-table-parity`

Run directory: `runs/stage04_05_result_table_parity_20260505_022708`

Old full Stage05 runner: not run.

Legacy oracle type: guarded helper-level oracle. It rejects unsafe grids, plotting, figure saving, parallel execution, and any full-runner request.

Native result table: `stage05_result_table.v0`, emitted by `runStage05TinySearch`.

Parity status: Stage05 tiny result-table parity complete for guarded N01 tiny grid.

Measured comparison:

- row count match: yes
- design key match: yes
- max absolute `D_G` error: about `7.5e-5`
- feasible match ratio: `1`
- pass-ratio error: `0`

Validation: Phase 8 suite passed 45 tests, 0 failed, 0 incomplete. Code Analyzer clean for checked new/modified MATLAB files.

Still partial/out of scope:

- Stage02 full VTC event parity;
- DA/DT/OpenD;
- ClosedD;
- old full Stage05 runner;
- Stage09/Stage14/Ch5;
- STK, C++/MEX, GUI.

Next recommendation: proceed to Stage05 small-scale formal reproduction using native_vtc and normalized result tables, while separately tightening Stage02 event parity.

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

## Next Steps

1. Upgrade native Stage01 from pseudo-ECI to full geodetic ECEF/ECI utilities.
2. Replace the Stage02 point-mass prototype with a native VTC-compatible dynamics implementation and tighter legacy trajectory comparisons.
3. Add persisted small golden artifacts under size limits.
4. Add a guarded old Stage05 tiny runner only if strict case/grid/cache controls are implemented first.

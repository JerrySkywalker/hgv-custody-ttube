# Session Handoff

## Sprint

Overnight Stage01-05 Production Alignment Sprint.

## Branch

`codex/overnight-stage01-05-production-alignment`

## Commits

- `ba6a10e feat: add stage01-05 tiny alignment pipeline`
- `85d1474 test: validate stage01-05 overnight alignment`

No push was performed.

## Constraints Followed

- Modified files only inside `C:\Dev\src\hgv-custody-ttube`.
- Treated `C:\Dev\src\hgv-custody-inversion-scheduling` as read-only.
- Read legacy Stage01-05 helper code and default params.
- Did not run old full Stage05.
- Did not run Stage09, Stage14, Ch5, ClosedD, STK, or C++/MEX.
- Ran only small new-pipeline smoke/integration tests and helper-level legacy adapter calls.
- Did not add any file over 5 MB.

## Added Or Modified Files

Core adapters:

- `src/+ttube/+core/+traj/propagateHgvTrajectory.m`
- `src/+ttube/+core/+traj/propagateHgvTrajectory_legacyStage02.m`
- `src/+ttube/+core/+orbit/buildWalkerConstellation.m`
- `src/+ttube/+core/+orbit/buildWalkerConstellation_legacyStage03.m`
- `src/+ttube/+core/+orbit/propagateWalkerConstellation.m`
- `src/+ttube/+core/+orbit/propagateWalkerConstellation_legacyStage03.m`
- `src/+ttube/+core/+sensor/computeAccessGeometry.m`
- `src/+ttube/+core/+sensor/computeAccessGeometry_legacyStage03.m`
- `src/+ttube/+core/+visibility/buildWindowGrid.m`
- `src/+ttube/+core/+estimation/buildWindowInformationMatrix.m`
- `src/+ttube/+core/+estimation/buildWindowInformationMatrix_legacyStage04.m`
- `src/+ttube/+core/+metrics/calibrateGammaRequirement.m`
- `src/+ttube/+core/+metrics/computeDGProduction.m`
- `src/+ttube/+core/+metrics/computeDAProduction.m`
- `src/+ttube/+core/+metrics/computeDTProduction.m`
- `src/+ttube/+core/+metrics/computeOpenDInterface.m`

Legacy helpers:

- `src/+ttube/+legacy/defaultLegacyRoot.m`
- `src/+ttube/+legacy/findLatestCache.m`
- `src/+ttube/+legacy/finiteDifferenceVelocity.m`
- `src/+ttube/+legacy/loadDefaultParams.m`
- `src/+ttube/+legacy/selectCaseById.m`
- `src/+ttube/+legacy/withLegacyPath.m`

Stage05 tiny pipeline:

- `src/+ttube/+experiments/+stage05/buildStage01CasebankMinimal.m`
- `src/+ttube/+experiments/+stage05/buildTinySearchGrid.m`
- `src/+ttube/+experiments/+stage05/evaluateWalkerDesignTiny.m`
- `src/+ttube/+experiments/+stage05/runStage05TinySearch.m`

Tests:

- `tests/unit/test_metricBackendInterfaces.m`
- `tests/integration/test_stage01CasebankMinimal.m`
- `tests/integration/test_stage02HgvTrajectoryAdapter.m`
- `tests/integration/test_stage03WalkerAccessAdapter.m`
- `tests/integration/test_stage04WindowInfoGammaAdapter.m`
- `tests/integration/test_stage04DGProductionAdapter.m`
- `tests/integration/test_stage05TinySearchPipeline.m`
- `tests/integration/test_stage01To05Alignment.m`
- `tests/regression/legacy/test_stage0103GoldenArtifacts.m`

Docs:

- `docs/STAGE01_05_ALIGNMENT_DESIGN.md`
- `docs/STAGE01_05_ALIGNMENT_REPORT.md`
- `docs/MIGRATION_MASTER_PLAN.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

## Run Directory

`runs/overnight_stage01_05_production_alignment_20260504_164129`

The run directory contains `status.json` plus small `.mat`/`.csv` smoke outputs. These were not committed.

## Alignment Status

Stage01: production aligned for selected N01 case fields through `build_casebank_stage01`.

Stage02 HGV dynamics: production aligned at helper-adapter level through `propagate_hgv_case_stage02`; `v_eci_kmps` is finite-difference derived because legacy helper output does not expose full ECI velocity.

Stage03 Walker propagator: production aligned at helper-adapter level through `build_single_layer_walker_stage03` and `propagate_constellation_stage03`; constellation velocity is finite-difference derived.

Stage03 real access geometry: production aligned at helper-adapter level through `compute_visibility_matrix_stage03`.

Stage04 window/FIM/gamma: production aligned at helper-adapter level for window FIM through `build_window_info_matrix_stage04`; gamma interface supports fixed and quantile modes.

Stage05 tiny search: new pipeline runs and writes result table. Old Stage05 tiny table parity is blocked because a guarded old tiny runner has not been implemented.

DG: production aligned for Stage04/05 formula `lambda_worst / gamma_req`.

DA/DT/OpenD: interface ready only. DA/DT are Stage09 line; OpenD is Stage14 line. They are not Stage05 production aligned.

## Test Results

Requested test set:

- All listed smoke/unit/integration tests passed.
- `tests/regression/legacy/test_legacyBaselineManifest.m` passed.
- `tests/regression/legacy/test_stage0103GoldenArtifacts.m` exists now and reports one expected incomplete assumption because `legacy_reference/golden_small/stage01_03_minimal/manifest.json` has not been generated.

Code Analyzer:

- Clean on all new/modified `.m` files from this sprint.

## Blocked Or Partial Items

- Old Stage05 tiny run was skipped. Blocked reason: no reviewed guard exists to prove strict case/grid/output limits before invoking legacy Stage05.
- No legacy golden Stage01-05 artifact pack was generated.
- Tiny smoke grid found no feasible design; the pipeline result is valid but negative for the sparse short-run configuration.

## File Size And Git Notes

- No committed file exceeds 5 MB.
- Run outputs were kept out of Git.
- No push was performed.

## Next Steps

1. Add a guarded old Stage05 tiny runner that refuses to run unless case, grid, time horizon, plotting, parallelism, and output size controls are explicitly restricted.
2. Generate a small Stage01-05 golden manifest and keep all files over 5 MB out of Git.
3. Add numeric old-new parity checks for Stage02 position, Stage03 access masks, Stage04 lambda values, and Stage05 result table.
4. Replace legacy adapters with native core implementations one backend at a time.

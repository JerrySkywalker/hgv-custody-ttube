# Session Handoff

## Sprint

Batch 3 Sprint: Stage01-03 legacy golden baseline extraction scaffold.

## Branch

`codex/batch3-stage01-03-baseline`

## Constraints Followed

- Modified files only inside `C:\Dev\src\hgv-custody-ttube`.
- Read `C:\Dev\src\hgv-custody-inversion-scheduling` only for Stage01-03 audit.
- Did not modify `C:\Dev\src\hgv-custody-inversion-scheduling`.
- Did not run any old project runner.
- Ran only the new PowerShell dry-run wrapper; it printed the MATLAB command and did not launch MATLAB.
- Did not run long experiments.
- Did not run Stage05/09/14 or Ch5.
- Did not implement HGV dynamics, Walker generation, real access geometry, real FIM/Gramian assembly, production DG/DA/DT, ClosedD/OpenD, STK, C++/MEX, or GUI.
- Did not extract or commit legacy golden baseline data.
- Did not commit large legacy outputs.

## Files Added

- `docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md`
- `legacy_reference/golden_small/README.md`
- `legacy_reference/golden_small/stage01_03_minimal/.gitkeep`
- `legacy_reference/golden_small/stage01_03_minimal/manifest.example.json`
- `tools/migration/legacy_paths.local.example.json`
- `tools/migration/export_legacy_stage01_03_baseline.ps1`
- `tools/migration/export_legacy_stage01_03_baseline.m`
- `tools/migration/README.md`
- `tests/regression/legacy/test_legacyBaselineManifest.m`

## Files Modified

- `docs/MIGRATION_MASTER_PLAN.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

## Implementation Summary

`docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md` records the read-only Stage01-03 audit and maps legacy casebank, trajbank, satbank, and visbank fields to the new data contracts.

`legacy_reference/golden_small/stage01_03_minimal/manifest.example.json` defines the first manifest schema for a future minimal golden baseline. No generated legacy data is present.

`tools/migration` contains a dry-run PowerShell wrapper and MATLAB scaffold. The wrapper defaults to printing the MATLAB command without launching MATLAB. The MATLAB scaffold is conservative: it writes only a dry-run manifest if called, refuses `AllowLegacyRun=true`, does not copy legacy outputs, and records legacy git metadata.

The audit found no Stage01-03-specific lightweight smoke runner or direct case-limit option. Stage02 and Stage03 currently operate over the full casebank and write cache/log/figure outputs. This sprint therefore did not run extraction.

## Test Results

Validation:

- `manifest.example.json` parsed successfully with PowerShell `ConvertFrom-Json`.
- `tools/migration/legacy_paths.local.example.json` parsed successfully with PowerShell `ConvertFrom-Json`.
- `tools/migration/export_legacy_stage01_03_baseline.ps1` dry-run completed without launching MATLAB.
- `tests/regression/legacy/test_legacyBaselineManifest.m`: 3 passed, 0 failed.
- Code Analyzer on `tools/migration/export_legacy_stage01_03_baseline.m`: no issues.
- Code Analyzer on `tests/regression/legacy/test_legacyBaselineManifest.m`: no issues.

## Commits

- `docs: plan stage01-03 legacy baseline extraction`
- `chore: scaffold legacy golden baseline manifest`
- `docs: record batch3 baseline scaffold`
- `tools: add dry-run legacy baseline extraction scaffold`
- `test: validate legacy baseline manifest schema`
- `docs: record batch3 baseline scaffold status`

## Remaining Issues

- Actual `stage01_03_minimal` extraction has not been run.
- A safe read-only cache extractor still needs review before any real extraction run.
- Stage02 trajectory contract requires a decision for `v_eci_kmps`; the legacy audit found scalar `v_mps` but not full ECI velocity vectors in `traj`.
- Stage03 constellation contract requires a decision for `v_eci_kmps`; legacy `satbank` exposes positions but not velocities.
- Files over 5 MB must remain out of Git.

## Next Recommended Work

1. Review `docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md`.
2. Review `tools/migration/export_legacy_stage01_03_baseline.m` and decide whether to extend it from dry-run manifest generation to one-case cache filtering.
3. Keep Stage05/09/14, Ch5, and production core migrations out of the next scaffold step.

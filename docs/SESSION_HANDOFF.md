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

## Files Modified

- `docs/MIGRATION_MASTER_PLAN.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

## Implementation Summary

`docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md` records the read-only Stage01-03 audit and maps legacy casebank, trajbank, satbank, and visbank fields to the new data contracts.

`legacy_reference/golden_small/stage01_03_minimal/manifest.example.json` defines the first manifest schema for a future minimal golden baseline. No generated legacy data is present.

The audit found no Stage01-03-specific lightweight smoke runner or direct case-limit option. Stage02 and Stage03 currently operate over the full casebank and write cache/log/figure outputs. This sprint therefore did not run extraction.

## Test Results

Validation:

- `manifest.example.json` parsed successfully with PowerShell `ConvertFrom-Json`.
- No MATLAB code was added or modified in this sprint.
- No MATLAB tests were required for the scaffold-only changes.

## Commits

- `docs: plan stage01-03 legacy baseline extraction`
- `chore: scaffold legacy golden baseline manifest`
- `docs: record batch3 baseline scaffold`

## Remaining Issues

- Actual `stage01_03_minimal` extraction has not been run.
- A safe read-only cache extractor still needs to be written or reviewed.
- Stage02 trajectory contract requires a decision for `v_eci_kmps`; the legacy audit found scalar `v_mps` but not full ECI velocity vectors in `traj`.
- Stage03 constellation contract requires a decision for `v_eci_kmps`; legacy `satbank` exposes positions but not velocities.
- Files over 5 MB must remain out of Git.

## Next Recommended Work

1. Review `docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md`.
2. Implement a new-repository read-only cache extractor that filters one case such as `N01`, if approved.
3. Keep Stage05/09/14, Ch5, and production core migrations out of the next scaffold step.

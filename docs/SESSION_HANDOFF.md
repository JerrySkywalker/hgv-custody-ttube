# Session Handoff

## Sprint

Architecture / Memory Sprint 1 for `C:\Dev\src\hgv-custody-tpipe`.

## Constraints Followed

- Old project remained read-only.
- No algorithms were migrated.
- No old project runner or long experiment was executed.
- New changes were limited to placeholder package directories and documentation.

## Read In New Repository

- `docs/PROJECT_MEMORY.md`
- `docs/LEGACY_AUDIT.md`
- `docs/COMPUTE_MODULES.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

## Read In Old Repository

Read-only ClosedD/OpenD audit areas:

- `stages/stage14_scan_openD_raan_grid.m`
- `src/search/evaluate_single_layer_walker_stage14.m`
- `src/search/build_stage14_search_grid.m`
- `src/stages/stage14/stage14_default_config.m`
- `run_stages/run_stage14_openD.m`
- `stages/stage14_plot_raan_profiles.m`
- `stages/stage14_plot_ns_envelopes.m`
- `stages/stage14_joint_phase_orientation.m`
- `stages/stage14_analyze_joint_phase_orientation.m`
- `stages/stage14_postprocess_joint_phase_orientation.m`
- `stages/stage14_formal_package_joint_phase_orientation.m`
- `tests/smoke/manual_smoke_stage14_F_RAAN_grid_A1_legacy_prepivot_20260329.m`

Also ran read-only text searches for `ClosedD`, `OpenD`, `closed_D`, `open_D`, `D_closed`, and `D_open`.

## New Or Modified Files

Added docs:

- `docs/DATA_CONTRACTS.md`
- `docs/CLOSED_OPEN_D_AUDIT.md`

Modified docs:

- `docs/MIGRATION_MATRIX.md`
- `docs/SESSION_HANDOFF.md`

Added placeholder package directories, tracked with `.gitkeep`:

- `src/+tpipe/+core/+traj`
- `src/+tpipe/+core/+orbit`
- `src/+tpipe/+core/+sensor`
- `src/+tpipe/+core/+visibility`
- `src/+tpipe/+core/+estimation`
- `src/+tpipe/+core/+metrics`
- `src/+tpipe/+core/+scheduler`
- `src/+tpipe/+pipeline`
- `src/+tpipe/+cache`
- `src/+tpipe/+viz`
- `src/+tpipe/+stk`
- `src/+tpipe/+export`

## Data Contracts Added

`docs/DATA_CONTRACTS.md` defines initial contracts for:

- trajectory artifact;
- constellation state artifact;
- access artifact;
- window artifact;
- metric artifact.

The contracts are intentionally implementation-neutral. They establish field names, units, ownership, baseline cases, and boundary rules without copying legacy algorithms.

## ClosedD / OpenD Audit Summary

OpenD appears to be a Stage14 experiment family rather than a single standalone scalar. The old Stage14 mainline performs DG-only scans over open orientation variables, primarily `RAAN_deg`, with fixed or scanned Walker phasing `F`. Per-row outputs include `D_G_min`, `D_G_mean`, `pass_ratio`, and `feasible_flag`; postprocessing derives RAAN profiles, Ns envelopes, robust stats by F, and best-F-by-RAAN tables.

ClosedD was not found as a clear standalone implementation, file, or function name. It remains undefined in engineering terms. It should not be implemented until the research definition is confirmed.

Practical decision: treat OpenD initially as an artifact family for orientation sensitivity summaries, not as a single metric kernel. Keep ClosedD as a documented unresolved item.

## Current Architecture State

The package namespace now has placeholders for:

- codegen-friendly core modules;
- pipeline/cache orchestration;
- visualization;
- STK adapter;
- export/codegen boundary.

No MATLAB functions were added yet. This avoids creating premature APIs before the contracts are reviewed.

## Test Status

No MATLAB tests were run in Sprint 1 because no MATLAB code was added or changed. Directory and documentation changes were verified with filesystem and git status checks.

## Suggested Next Sprint

Run Architecture / Memory Sprint 2:

1. Review `docs/DATA_CONTRACTS.md` and decide whether artifact metadata should live inside every core struct or only in pipeline artifacts.
2. Create minimal constructor/validator stubs for contracts only if the field names are accepted.
3. Add lightweight MATLAB package smoke tests for the new namespace.
4. Create synthetic fixture docs or tiny `.mat` fixtures for trajectory/access/window/metric baseline cases.
5. Ask research side to define ClosedD and the expected scalar summary of OpenD.

## Questions For Web ChatGPT

- What is the exact ClosedD definition in dissertation terms?
- Should OpenD remain DG-only for Stage14 compatibility, or should its final dissertation form include DA/DT?
- Should `RAAN_deg` be generalized as `orientation_deg` in new contracts?
- What single scalar, if any, should summarize an OpenD scan: worst RAAN DG, RAAN span, feasible RAAN ratio, min feasible Ns, or a combined score?
- Should core structs include artifact metadata, or should metadata be attached only by `pipeline/cache`?

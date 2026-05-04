# Batch 3 Legacy Stage01-03 Baseline Plan

## Status

This is a Batch 3 scaffold document. It plans a small Stage01-03 legacy golden baseline, but it does not run legacy stages and does not migrate algorithms into the new core.

The old repository was audited read-only:

```text
C:\Dev\src\hgv-custody-inversion-scheduling
```

No files were modified there.

## Read-Only Audit Scope

Files read in the old repository:

- `run_stages/run_stage01_scenario_disk.m`
- `run_stages/run_stage02_hgv_nominal.m`
- `run_stages/run_stage03_visibility_pipeline.m`
- `run_stages/rs_apply_parallel_policy.m`
- `stages/stage01_scenario_disk.m`
- `stages/stage02_hgv_nominal.m`
- `stages/stage03_visibility_pipeline.m`
- `src/common/configure_stage_output_paths.m`
- `src/common/find_stage_cache_files.m`
- `src/scenario/build_casebank_stage01.m`
- `src/target/propagate_hgv_case_stage02.m`
- `src/target/summarize_hgv_case_stage02.m`
- `src/constellation/build_single_layer_walker_stage03.m`
- `src/constellation/propagate_constellation_stage03.m`
- `src/sensing/compute_visibility_matrix_stage03.m`
- `src/sensing/compute_los_geometry_stage03.m`
- `src/sensing/summarize_visibility_case_stage03.m`
- `params/default_params.m` Stage01-03 sections
- `benchmarks/run_benchmark_stage01.m`
- `benchmarks/run_benchmark_stage02.m`
- `benchmarks/run_benchmark_stage03.m`

Old repository state observed during audit:

- branch: `cpt5-oldStable`
- commit: `e0fa575704bbabdac28494b8c228fea46d04f055`

## Stage Outputs

### Stage01 Scenario Disk

Entry points:

- wrapper: `run_stages/run_stage01_scenario_disk.m`
- implementation: `stages/stage01_scenario_disk.m`

Stage01 builds `out.casebank`, `out.summary`, optional `out.fig_file`, `out.log_file`, and `out.cache_file`.

`casebank` top-level fields:

- `meta`
- `nominal`
- `heading`
- `critical`

Observed case fields from `build_casebank_stage01.m`:

- identifiers: `case_id`, `family`, `subfamily`
- scenario parameters: `entry_theta_deg`, `heading_deg`, `heading_offset_deg`
- local fields: `entry_point_xy_km`, `entry_point_enu_km`, `entry_point_enu_m`, `heading_unit_xy`, `heading_unit_enu`
- geodetic fields: `entry_lat_deg`, `entry_lon_deg`, `entry_surface_dist_km`
- ECEF/ECI entry fields: `entry_point_ecef_m`, `entry_point_ecef_km`, `entry_point_eci_m_t0`, `entry_point_eci_km_t0`
- heading frame fields: `heading_unit_ecef_t0`, `heading_unit_eci_t0`
- metadata: `anchor_lat_deg`, `anchor_lon_deg`, `anchor_h_m`, `epoch_utc`, `scene_mode`

Default nominal/heading/critical counts appear to be 12 nominal, 60 heading, and 2 critical cases, for 74 total cases.

### Stage02 HGV Nominal

Entry points:

- wrapper: `run_stages/run_stage02_hgv_nominal.m`
- implementation: `stages/stage02_hgv_nominal.m`

Stage02 loads the latest Stage01 cache via `find_stage_cache_files`, then writes `out.casebank`, `out.trajbank`, `out.summary`, optional figures, logs, and cache.

`trajbank` top-level fields:

- `nominal`
- `heading`
- `critical`

Each trajectory record is shaped as:

- `case`
- `traj`
- `validation`
- `summary`

Observed `traj` fields from `propagate_hgv_case_stage02.m`:

- identifiers: `case_id`, `family`, `subfamily`
- time/state: `t_s`, `X`
- geodetic: `lat_deg`, `lon_deg`, `h_m`, `h_km`
- local/ECEF/ECI positions: `r_enu_m`, `r_enu_km`, `r_ecef_m`, `r_ecef_km`, `r_eci_m`, `r_eci_km`
- backward-compatible fields: `xy_km`, `v_mps`
- metadata: `scene_mode`, `anchor_lat_deg`, `anchor_lon_deg`, `anchor_h_m`, `epoch_utc`, `meta`

Default time settings observed in `default_params.m`:

- `Tmax_s = 800`
- `Ts_s = 1.0`

Stage02 therefore may produce up to hundreds of samples per case across the full 74-case bank.

### Stage03 Visibility Pipeline

Entry points:

- wrapper: `run_stages/run_stage03_visibility_pipeline.m`
- implementation: `stages/stage03_visibility_pipeline.m`

Stage03 loads the latest Stage02 cache, builds one common time grid, builds a single-layer Walker constellation, propagates satellites, computes visibility for all trajectory cases, and writes `out.walker`, `out.satbank`, `out.visbank`, `out.summary`, optional figure, logs, and cache.

Observed `walker` fields:

- `h_km`, `i_deg`, `P`, `T`, `F`, `Ns`
- `sat`, with `plane_id`, `sat_id_in_plane`, `raan_deg`, `M0_deg`, `h_km`, `i_deg`

Observed `satbank` fields from `propagate_constellation_stage03.m`:

- `t_s`
- `r_eci_km`, shaped `Nt x 3 x Ns`
- `Ns`
- `walker`

Observed `visbank` top-level fields:

- `nominal`
- `heading`
- `critical`

Each visibility record includes:

- `case_id`
- `family`
- `subfamily`
- `vis_case`
- `los_geom`
- `summary`

Observed `vis_case` fields from `compute_visibility_matrix_stage03.m`:

- `case_id`, `family`, `subfamily`
- `t_s`
- `visible_mask`, shaped `Nt x Ns`
- `num_visible`, shaped `Nt x 1`
- `dual_coverage_mask`, shaped `Nt x 1`
- `r_tgt_eci_km`

Observed `los_geom` fields:

- `min_crossing_angle_deg`
- `mean_crossing_angle_deg`

Default Walker and sensor settings observed in `default_params.m`:

- `h_km = 1000`
- `i_deg = 70`
- `P = 8`
- `T = 12`
- `F = 1`
- `Ns = 96`
- `max_range_km = 3500`
- `enable_offnadir_constraint = true`
- `max_offnadir_deg = 65`
- `require_earth_occlusion_check = true`

## Cache And Output Paths

`configure_stage_output_paths.m` maps stage outputs under:

```text
outputs/stage/stageXX
```

with stage-local:

- `cache`
- `figs`
- `tables`

Logs are mapped under:

```text
outputs/logs/stageXX
```

`find_stage_cache_files.m` searches stage-scoped cache folders under `cfg.paths.stage_outputs` and returns matches such as:

- `stage01_scenario_disk_*.mat`
- `stage02_hgv_nominal_*.mat`
- `stage03_visibility_pipeline_*.mat`

## Lightweight Smoke Or Case Limit Assessment

No Stage01-03-specific lightweight smoke runner or direct case-limit option was found in the audited Stage01-03 entrypoints.

Observed benchmark helpers can disable plotting and compare serial/parallel behavior, but they are benchmark runners, repeat execution, and are not suitable as a minimal golden extraction path.

Stage14 smoke files include `case_limit`, but Stage14 is outside this sprint and must not be run.

## Recommended Baseline Case

Recommended future baseline ID:

```text
stage01_03_minimal
```

Recommended minimal content, if a safe extractor is later written:

- Stage01: one nominal case, preferably `N01`, plus metadata needed to reproduce the selection.
- Stage02: the matching `N01` trajectory record with `t_s`, `r_eci_km`, optional `r_ecef_km`, optional `r_enu_km`, `v_mps` or derived velocity notes, and validation flags.
- Stage03: the common `satbank` for the baseline Walker and one `N01` visibility record with `visible_mask`, `num_visible`, and `dual_coverage_mask`.

Because Stage02 and Stage03 currently operate on the full casebank, this minimal baseline should be extracted from existing stage cache files or from a future dedicated extractor that filters after load. Do not edit legacy stage code to add this behavior.

## File Size Risk

Risk is moderate to high:

- Stage cache files are saved as `-v7.3` MAT files.
- Stage02 contains full trajectory banks across nominal, heading, and critical families.
- Stage03 contains a full `Nt x 3 x Ns` satellite bank and full `Nt x Ns` visibility masks for all cases.
- Files over 5 MB must not be committed. They should be reported in `docs/SESSION_HANDOFF.md` and kept outside Git unless explicitly approved.

## Run Recommendation

Do not run Stage01-03 extraction in this sprint.

Reasons:

- No audited Stage01-03 minimal smoke runner or case-limit configuration was found.
- Stage02 performs HGV propagation for the full casebank.
- Stage03 defaults to full-bank visibility and a 96-satellite Walker constellation.
- Stage wrappers write logs, cache, and figures into the old repository output layout.
- The sprint goal is scaffold and dry-run planning, not algorithm execution.

Recommended next action is to add a new-repository extraction scaffold that reads existing legacy cache files only after user approval and writes a small filtered artifact into `legacy_reference/golden_small/stage01_03_minimal`.

## Artifact Mapping Draft

| Legacy source | Legacy field | New contract target | Notes |
|---|---|---|---|
| Stage01 case | `case_id` | `trajectory_id` or case metadata | Used to link casebank to trajectory artifact. |
| Stage01 case | `family`, `subfamily` | `family`, `subfamily` | Direct semantic match. |
| Stage01 case | `epoch_utc` | `epoch_utc` | Direct semantic match when present. |
| Stage01 case | `entry_point_eci_km_t0` | trajectory `case_params` | Initial entry metadata, not the propagated trajectory. |
| Stage01 case | `heading_unit_eci_t0` | trajectory `case_params` | Initial heading metadata. |
| Stage02 traj | `t_s` | Trajectory Artifact `t_s` | Direct match. |
| Stage02 traj | `r_eci_km` | Trajectory Artifact `r_eci_km` | Direct match. |
| Stage02 traj | `r_ecef_km` | Trajectory Artifact optional `r_ecef_km` | Direct match if included. |
| Stage02 traj | `r_enu_km` | Trajectory Artifact optional `r_enu_km` | Direct match if regional frame is retained. |
| Stage02 traj | `v_mps` | Trajectory Artifact `v_eci_kmps` unresolved | Legacy currently exposes speed scalar, not full ECI velocity vector. Need derive or leave as optional metadata. |
| Stage02 validation | `validation.pass` | Trajectory Artifact `valid_mask` / validation metadata | Per-sample validity is not directly present; case-level pass can become validation metadata. |
| Stage03 walker | `walker.h_km`, `i_deg`, `P`, `T`, `F` | Constellation State Artifact `walker` | Direct match. |
| Stage03 walker.sat | `plane_id`, `sat_id_in_plane` | `plane_index`, `sat_index_in_plane` | Direct match. |
| Stage03 satbank | `t_s` | Constellation State Artifact `t_s` | Direct match. |
| Stage03 satbank | `r_eci_km` (`Nt x 3 x Ns`) | `r_eci_km` (`Nt x Ns x 3`) | Requires dimension permutation. |
| Stage03 satbank | velocity absent | `v_eci_kmps` unresolved | Need derive finite-difference velocity or keep absent until contract decision. |
| Stage03 vis_case | `case_id` | Access Artifact `trajectory_id` / `access_id` | Direct linkage. |
| Stage03 vis_case | `t_s` | Access Artifact `t_s` | Direct match. |
| Stage03 vis_case | `visible_mask` | Access Artifact `access_mask` | Direct semantic match. |
| Stage03 vis_case | `num_visible` | Access Artifact `num_visible` | Direct match. |
| Stage03 vis_case | `dual_coverage_mask` | Access Artifact `dual_coverage_mask` | Direct match. |
| Stage03 los_geom | crossing-angle fields | Access Artifact optional diagnostics | Not currently in Access Artifact required fields. |

## Dry-Run Checklist

Before any actual extraction:

1. Confirm the exact legacy commit and branch.
2. Confirm existing Stage01-03 cache files are available and small enough to inspect.
3. Load only metadata or selected variables first.
4. Filter to one case such as `N01`.
5. Write a new manifest next to generated artifacts.
6. Check every generated file size before `git add`.
7. Do not commit files larger than 5 MB.

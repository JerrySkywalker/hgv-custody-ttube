# Stage06 Artifact Contracts

## `stage06_heading_scope.v0`

Fields: `schema_version`, `caseId`, `heading_mode`, `heading_offsets_deg`, `num_headings`, `created_utc`, and `notes`.

## `stage06_heading_family.v0`

Fields: `schema_version`, `base_case_id`, `heading_offsets_deg`, `cases`, `trajectory_ids`, `backend`, and `created_utc`.

## `stage06_heading_search_result.v0`

Fields: `schema_version`, `cfg`, `scope`, `family`, `grid`, `result_table`, `summary`, `backend`, and `created_utc`.

The result table uses the Stage05 design key plus robust heading metrics:

- `design_id`
- `h_km`
- `i_deg`
- `P`
- `T`
- `F`
- `Ns`
- `gamma_req`
- `D_G_min`
- `D_G_mean`
- `pass_ratio`
- `worst_heading_offset_deg`
- `feasible`
- `backend`

## `stage06_vs_stage05_comparison.v0`

Fields: `schema_version`, `stage05_summary`, `stage06_summary`, `joined_table`, `feasible_count_change`, `best_Ns_change`, `pass_ratio_drop`, `DG_robustness_drop`, and `heading_risk_summary`.

## `stage06_plot_bundle.v0`

Fields: `schema_version`, `files`, `outputDir`, and `notes`. Plot bundles consume artifacts only and do not recompute metrics.

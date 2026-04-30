# ClosedD / OpenD Focused Audit

## Scope

Sprint 1 performed a read-only audit of the old project for ClosedD/OpenD definitions and Stage14 data products. No old project files were modified and no old runners were executed.

## Files Read Or Searched

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
- repository-wide text search for `ClosedD`, `OpenD`, `closed_D`, `open_D`, `D_closed`, and `D_open`.

## OpenD Findings

The old project uses `openD` primarily as a Stage14 naming and experiment concept, not as a single standalone scalar function.

Stage14.1 mainline is described in code as a raw DG-only scan over `(i, P, T, RAAN)` with fixed `F_ref`. It loads Stage04 `gamma_req`, loads Stage02 nominal trajectories, builds a Stage14 grid, evaluates each row through Stage03/Stage04-style visibility and worst-window logic, and writes `grid` plus `summary`.

The core Stage14 row evaluator:

- patches Walker parameters into Stage03 config;
- applies a relative RAAN offset to every satellite RAAN;
- propagates the constellation;
- computes visibility per nominal case;
- scans worst windows;
- computes `D_G = lambda_worst / gamma_req`;
- reports `D_G_min`, `D_G_mean`, `pass_ratio`, `feasible_flag`, and `rank_score`.

Stage14 profile and envelope layers consume the raw grid:

- fixed-design RAAN profile: `D_G_min` and `pass_ratio` versus `RAAN_deg`;
- Ns envelope: best `D_G_min` and best `pass_ratio` over `(P,T)` at each `RAAN_deg` for fixed `Ns`;
- multi-stat/postprocess layers: span/min/max/mean summaries over RAAN, F, inclination, or Ns.

The legacy pre-pivot Stage14 smoke performs a two-dimensional `(F, RAAN)` scan for A1 and outputs:

- `summary_table` with `h_km`, `i_deg`, `P`, `T`, `F`, `RAAN_deg`, `Ns`, `D_G_min`, `D_G_mean`, `pass_ratio`, `feasible_flag`;
- `pass_ratio_grid`;
- `DG_mean_grid`;
- `DG_min_grid`.

Initial conclusion: in the old project, OpenD should be interpreted as an open-orientation/relative-RAAN robustness family built on DG-only worst-window evaluation. It is not yet a separate core metric formula independent from Stage14 scan organization.

## ClosedD Findings

The search did not find a clear standalone `ClosedD` implementation, file, or function name. Sprint 0 suspected Stage09/Stage14 related sources, but Sprint 1 evidence shows Stage09 focuses on DG/DA/DT robust feasible-domain metrics, while Stage14 is explicitly OpenD/RAAN/phase oriented.

Initial conclusion: ClosedD is not frozen in the codebase under an obvious name. It may be an intended dissertation concept, a table/plot label, or a metric assembled indirectly from Stage09 closed-domain feasible designs. This requires input from research notes or a targeted audit of dissertation text and older notebooks/docs.

## Practical Contract Implications

Do not implement `ClosedD` yet.

For `OpenD`, do not implement a scalar metric yet. First define an OpenD artifact family:

- raw design grid over open orientation variable(s), initially `RAAN_deg` and optionally Walker phasing `F`;
- per-row metrics: `D_G_min`, `D_G_mean`, `pass_ratio`, `feasible_flag`;
- derived profile/envelope summaries: RAAN span, min/max, best F by RAAN, robust stats by F, and Ns envelope.

The first new-repo OpenD baseline should be a tiny synthetic grid that tests summarization semantics without running legacy Stage14.

## Unresolved Questions

- Is ClosedD intended to mean a closed-domain feasible-set metric over fixed orientation, or a closed-loop custody metric from Chapter 5?
- Should OpenD eventually include DA/DT, or remain Stage14-compatible DG-only?
- Should `RAAN_deg` be named `orientation_deg` in the new contract, with `RAAN_deg` as one backend-specific realization?
- What is the required dissertation-level scalar summary of an OpenD scan: worst RAAN, RAAN span, feasible RAAN ratio, min feasible Ns, or another statistic?

# Stage04-05 Result-Table Parity Plan

Created: 2026-05-05
Branch: `codex/stage04-05-result-table-parity`

## Legacy Stage05 Result Fields

Legacy Stage05 builds a Walker search grid from Stage05 config, inherits `gamma_req` from Stage04 cache, loads nominal Stage02 trajectories, evaluates each Walker design, and writes grid-level fields such as `h_km`, `i_deg`, `P`, `T`, `F`, `Ns`, `gamma_req`, `lambda_worst_min`, `D_G_min`, `pass_ratio`, and `feasible_flag`.

The old full runner also calls plot and Pareto stages. That path is not safe for this sprint because it can read default caches, run full configured grids, generate figures, and perform post-processing beyond the tiny oracle scope.

## Safe Limit Decision

The old full Stage05 runner is prohibited for this sprint. The result-table oracle uses a guarded helper-level path only:

- single `caseId = N01`;
- tiny explicit grid;
- no plotting;
- no parallel workers;
- no old output copying;
- all output in new-repo temp/run directories.

If any guard fails, the oracle rejects the request before any legacy call.

## Native Result Table Schema

Native Stage05 tiny output is normalized to `stage05_result_table.v0` with:

- `design_id`
- `h_km`, `i_deg`, `P`, `T`, `F`, `Ns`
- `gamma_req`
- `lambda_worst`
- `D_G`
- `feasible`
- `pass_ratio`
- `mean_visible`
- `dual_ratio`
- `backend`
- `notes`

## Comparison Metrics

Design keys are `(h_km, i_deg, P, T, F, Ns)`. Comparison reports:

- row count match;
- key match;
- `Ns` match;
- max absolute and relative `D_G` error;
- feasible match ratio;
- pass-ratio error;
- native-only and legacy-only designs.

## Tolerances

Tiny parity starts with deterministic helper-level tolerance:

- keys must match exactly;
- `Ns` must match exactly;
- `D_G` absolute tolerance: `1e-9` for identical helper-level calculations, otherwise report partial;
- feasible match ratio target: `1.0`.

## Blocked Conditions

- Any request to run the old full Stage05 runner.
- More than one `h_grid_km` value in the legacy oracle.
- More than two `i`, `P`, or `T` values in the legacy oracle.
- `Tmax_s > 120`, `Ts_s < 5`, or `Tw_s > 60`.
- plotting, saving figures, or parallel execution enabled.

## Out Of Scope

No Stage09/ClosedD/OpenD, Stage14, Ch5, STK, C++/MEX, GUI, or large scan work is performed.

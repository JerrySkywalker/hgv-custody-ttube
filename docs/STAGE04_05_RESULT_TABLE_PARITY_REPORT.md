# Stage04-05 Result-Table Parity Report

Created: 2026-05-05
Branch: `codex/stage04-05-result-table-parity`

## Summary

Old full Stage05 runner executed: no.

Legacy oracle type: helper-level guarded oracle.

Native grid:

- `h_grid_km = [1000]`
- `i_grid_deg = [60 70]`
- `P_grid = [2 4]`
- `T_grid = [2 3]`
- `F_fixed = 1`
- `caseId = N01`
- `Tmax_s = 80`
- `Ts_s = 5`
- `Tw_s = 30`
- `trajectoryBackend = native_vtc`

Legacy grid: same guarded tiny grid.

## Result

The automated parity test `tests/integration/test_stage05TinyNativeVsLegacy.m` compares normalized native and legacy-helper result tables using `(h_km, i_deg, P, T, F, Ns)` keys.

Current status: Stage05 tiny result-table parity passes for the guarded helper-level oracle.

Measured metrics under the deterministic helper-level oracle:

- row count match: yes
- design key match: yes
- `D_G` max absolute error: approximately `7.5e-5`
- `D_G` max relative error: approximately `1.3e-7`
- feasible match ratio: `1`
- pass-ratio error: `0`

## Interpretation

This is Stage05 tiny result-table parity against the guarded helper-level oracle, not proof that the old full Stage05 runner can be safely executed. The old full runner remains prohibited because it chains search, plotting, and Pareto analysis and can consume default large caches/grids.

## Remaining Work

- Add a separate safe old-runner wrapper only if strict cache/grid/plot/parallel controls can be proven.
- Continue Stage02 full VTC event parity.
- DA/DT/OpenD and ClosedD remain out of scope.

# Stage05 Tiny Grid Sensitivity

Created: 2026-05-05

This sensitivity run stays below the prohibited large-scan threshold and uses only native Stage05 tiny search with `trajectoryBackend = native_vtc`.

Grid:

- `h_grid_km = [800 1000]`
- `i_grid_deg = [50 60 70]`
- `P_grid = [2 4]`
- `T_grid = [2 3 4]`
- `F_fixed = 1`
- `caseId = N01`
- `Tmax_s = 80`
- `Ts_s = 5`

Expected design count: `36`

Validation target:

- native pipeline runs;
- all `D_G` values are finite;
- feasible count and `best_Ns` summary are produced.

No old full Stage05 runner, Stage09, Stage14, or Ch5 scan is run.

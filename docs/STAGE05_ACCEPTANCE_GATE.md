# Stage05 Acceptance Gate

The Stage05 acceptance gate is the native baseline used by Stage06.

Supported profiles:

- `smoke`
- `tiny`
- `medium_safe`
- `golden_safe`

`golden_safe` remains bounded by `maxDesignsGuard <= 300`, `Tmax_s <= 180`, and `Ts_s >= 5`. The gate runs the native full Stage05 wrapper, emits result/summary/frontier/Pareto/plot artifacts, and returns an acceptance struct with status, design count, feasible count, pass ratio, best `Ns`, artifact paths, and runtime.

The acceptance gate does not call legacy helpers and does not run old Stage05.

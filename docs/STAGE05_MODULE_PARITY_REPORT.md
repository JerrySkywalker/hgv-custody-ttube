# Stage05 Module Parity Report

Created: 2026-05-05

Old full Stage05 runner executed: no.

Legacy oracle: guarded helper-level oracle only.

Module checks:

- Search: native result table compared with guarded legacy helper oracle through normalized result table comparison.
- Summary/frontier: native and legacy-equivalent summaries are computed from their normalized tables using the same native post-processing functions.
- Pareto/transition: native and legacy-equivalent Pareto artifacts are computed from normalized tables.
- Plot: no pixel-level parity. Native plot bundle consumes artifacts and does not recompute metrics.

Tiny module parity test passed for the guarded N01 grid. Full old-runner parity remains unavailable by design because the old full runner can chain plotting, Pareto analysis, default caches, and larger grids.

## Final Module Status

Stage05.1 search: native implementation complete for guarded small and medium-safe grids. The native result table is normalized through the Stage05 result table contract and compared against the guarded helper-level legacy oracle for tiny grids.

Stage05.2 plot/postprocess: native summary, ranking, frontier, heatmap-ready table generation, and plot bundle export are implemented. Plot parity is artifact/smoke-level only; no pixel-level comparison is claimed.

Stage05.3 Pareto/transition: native Pareto front, inclination transition, and pass-ratio diagnostics artifacts are implemented and tested on tiny/medium-safe grids.

Old full Stage05 runner executed: no.

Legacy oracle status: helper-level only. This is sufficient for small module-level comparison, but not a claim of full old-runner cache/plot side-effect parity.

Validation: the Stage05 full native suite passed 94 tests, 0 failed, 0 incomplete. The native-vs-legacy helper tiny comparison remains the available parity oracle.

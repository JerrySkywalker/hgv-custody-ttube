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

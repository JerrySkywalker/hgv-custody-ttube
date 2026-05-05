# Stage06 Module Parity Report

Created: 2026-05-05

Old full Stage06 runner executed: no.

Legacy oracle status: blocked. A strict tiny guard is implemented in `ttube.legacy.runStage06TinyOracle`, but no safe standalone legacy Stage06 helper-level evaluator was confirmed. The old Stage06 path depends on Stage02/04/05 caches and the full Stage06 runner chain, which is prohibited for this sprint.

Native module status:

- Search: native Stage06 heading-family result table is produced.
- Summary/frontier: native summary and robust frontier artifacts are produced.
- Stage05 comparison: native Stage05-vs-Stage06 comparison artifact is produced.
- Plot: native plot bundle consumes artifacts and does not recompute metrics.

Parity judgment: native module implementation can be tested; legacy numeric parity is blocked pending a safe standalone old helper oracle.

## Final Status

Stage06.1 heading scope: native implementation complete.

Stage06.2 heading family: native case and trajectory-bank generation complete using Stage01 native geodetic cases and Stage02 `native_vtc`.

Stage06.3 heading search: native robust Walker search complete for guarded grids. Each design is evaluated across heading trajectories and reduced to `D_G_min`, `D_G_mean`, robust pass ratio, worst heading offset, and feasibility.

Stage06.4 compare with Stage05: native comparison artifact complete. It reports feasible-count change, best-`Ns` change, pass-ratio drop, `D_G` robustness drop, and heading risk summary.

Stage06.5 plot results: native plot bundle complete at render-smoke level. Plots consume artifacts and do not recompute metrics.

Legacy numeric parity: blocked. The old full Stage06 runner was not run. The old helper-level path remains unresolved because the visible Stage06 code depends on old caches and the full Stage06 chain.

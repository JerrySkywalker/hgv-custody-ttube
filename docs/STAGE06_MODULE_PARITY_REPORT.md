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

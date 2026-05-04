# Architecture Backlog

This backlog starts after the Architecture / Memory Sprint completion. Items here are implementation candidates, not permission to migrate legacy algorithms.

## Immediate Next Items

| Priority | Item | Target | Notes |
|---|---|---|---|
| P0 | Decide metadata placement | contracts / pipeline | Current contracts include artifact metadata. Core kernels may still accept stripped numeric structs. |
| P0 | Freeze ClosedD definition | research | Do not implement until definition is explicit. |
| P0 | Freeze OpenD summary statistic | metrics / experiments | Current evidence supports OpenD as Stage14 orientation-sensitivity artifact family. |
| P1 | Add synthetic access/window fixtures | tests | Started. `extractWindowIndices` now has unit coverage for regular and non-integer-step windows. |
| P1 | Review DG/DA/DT contract draft | docs / core.metrics | Draft completed in `docs/D_METRIC_CONTRACT_DRAFT.md`; production definitions still require review. |
| P1 | Add synthetic D-metric toy fixtures | tests | Completed for Batch 2 scaffold; extend only after contract review. |
| P1 | Plan Stage01-03 golden baseline extraction | docs / legacy_reference / tools | Completed scaffold plan, manifest schema, dry-run tools, and manifest regression test; next step is review before any extraction run. |
| P2 | Add scheduler trace contract | docs / core.scheduler | Needed before Chapter 5 policy stubs. |
| P2 | STK access report design | stk / docs | Legacy has state export but not a mature access adapter. |
| P2 | Codegen prototype candidate | export / codegen | First candidate should be a pure numeric validator-free kernel. |

## Migration Guardrails

- Do not copy large legacy stage scripts.
- Do not let plotting compute metrics.
- Do not put STK, COM, file IO, or cache logic in core.
- Do not use MATLAB tables as codegen-facing core inputs.
- Do not implement Chapter 5 dual-loop until scheduler trace and metric contracts are stable.

## Candidate First Implementations

1. `core.visibility` synthetic window-index extractor. Implemented in `ttube.core.visibility.extractWindowIndices`.
2. `core.metrics` gap segment summarizer for synthetic masks. Completed in `ttube.core.metrics.summarizeGapSegments`.
3. `core.scheduler` static-hold selection over synthetic candidate IDs.
4. `pipeline/cache` manifest schema draft. Progress status MVP started with `status.json`; manifest/schema/resume remain future work.
5. `stk` availability probe stub in new namespace.

Do not directly migrate Stage05/09 large scans. The next implementation sequence should be DG/DA/DT contract draft, synthetic D-metric toy fixtures, then Stage01-03 legacy golden baseline extraction planning.

Batch 2 scaffold now includes `ttube.core.metrics.computeRequirementMargin`, `ttube.core.metrics.combineDTriplet`, and synthetic D-metric fixtures. These are toy primitives only and are not production DG/DA/DT.

Batch 3 scaffold now includes `docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md`, `legacy_reference/golden_small/stage01_03_minimal/manifest.example.json`, `tools/migration/export_legacy_stage01_03_baseline.*`, and `tests/regression/legacy/test_legacyBaselineManifest.m`. No legacy data has been extracted or committed.

Each should arrive with one small MATLAB test and no dependency on old project outputs.

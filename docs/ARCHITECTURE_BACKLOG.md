# Architecture Backlog

This backlog starts after the Architecture / Memory Sprint completion. Items here are implementation candidates, not permission to migrate legacy algorithms.

## Immediate Next Items

| Priority | Item | Target | Notes |
|---|---|---|---|
| P0 | Decide metadata placement | contracts / pipeline | Current contracts include artifact metadata. Core kernels may still accept stripped numeric structs. |
| P0 | Freeze ClosedD definition | research | Do not implement until definition is explicit. |
| P0 | Freeze OpenD summary statistic | metrics / experiments | Current evidence supports OpenD as Stage14 orientation-sensitivity artifact family. |
| P1 | Add scheduler trace contract | docs / core.scheduler | Needed before Chapter 5 policy stubs. |
| P1 | Add synthetic access/window fixtures | tests | Current fixture covers minimal artifacts but not expected window extraction outputs. |
| P1 | Add first pure utility constructors | core modules | Only after validator contracts are accepted. |
| P2 | STK access report design | stk / docs | Legacy has state export but not a mature access adapter. |
| P2 | Codegen prototype candidate | export / codegen | First candidate should be a pure numeric validator-free kernel. |

## Migration Guardrails

- Do not copy large legacy stage scripts.
- Do not let plotting compute metrics.
- Do not put STK, COM, file IO, or cache logic in core.
- Do not use MATLAB tables as codegen-facing core inputs.
- Do not implement Chapter 5 dual-loop until scheduler trace and metric contracts are stable.

## Candidate First Implementations

1. `core.visibility` synthetic window-index extractor.
2. `core.metrics` gap segment summarizer for synthetic masks.
3. `core.scheduler` static-hold selection over synthetic candidate IDs.
4. `pipeline/cache` manifest schema draft.
5. `stk` availability probe stub in new namespace.

Each should arrive with one small MATLAB test and no dependency on old project outputs.

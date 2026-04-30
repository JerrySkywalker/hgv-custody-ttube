# Session Handoff

## Sprint

Architecture / Memory Sprint sequence completed on branch `codex/architecture-memory-sprint`.

## Constraints Followed

- Old project remained read-only.
- No old runner or long experiment was executed.
- No legacy algorithms were migrated.
- New repository changes were limited to documentation, package placeholders, contract validators, fixtures, and smoke tests.
- Work was split into small commits.

## Commits Created

- `b904f61 docs: establish architecture memory baseline`
- `d65671d docs: define architecture sprint completion plan`
- `35cbd2c test: add contract validators and smoke fixtures`
- `c3cd386 docs: audit stk and codegen boundaries`
- `763bebc docs: audit chapter 5 scheduler taxonomy`
- Final handoff/backlog commit should follow this file update.

## New Repository State

Architecture memory docs now include:

- `docs/PROJECT_MEMORY.md`
- `docs/RESEARCH_INTENT.md`
- `docs/ARCHITECTURE_PRINCIPLES.md`
- `docs/COMPUTE_MODULES.md`
- `docs/STK_AND_CODEGEN_BOUNDARIES.md`
- `docs/MIGRATION_MATRIX.md`
- `docs/LEGACY_AUDIT.md`
- `docs/DATA_CONTRACTS.md`
- `docs/CLOSED_OPEN_D_AUDIT.md`
- `docs/STK_CODEGEN_AUDIT.md`
- `docs/CH5_SCHEDULER_BUBBLE_TAXONOMY.md`
- `docs/ARCHITECTURE_SPRINT_PLAN.md`
- `docs/ARCHITECTURE_BACKLOG.md`

Package skeleton now exists under:

- `src/+tpipe/+core/+traj`
- `src/+tpipe/+core/+orbit`
- `src/+tpipe/+core/+sensor`
- `src/+tpipe/+core/+visibility`
- `src/+tpipe/+core/+estimation`
- `src/+tpipe/+core/+metrics`
- `src/+tpipe/+core/+scheduler`
- `src/+tpipe/+pipeline`
- `src/+tpipe/+cache`
- `src/+tpipe/+viz`
- `src/+tpipe/+stk`
- `src/+tpipe/+export`

Lightweight validators now exist for:

- trajectory artifacts;
- constellation state artifacts;
- access artifacts;
- window artifacts;
- metric artifacts.

Synthetic contract fixtures and smoke tests exist under:

- `tests/fixtures/make_minimal_contract_fixtures.m`
- `tests/smoke/test_contracts.m`

## Legacy Audit Summary

Broad legacy audit:

- Stage01/02/03/04/05/09/14 form the old Chapter 4 static/inverse-design mainline.
- Stage functions mix compute, cache, logging, progress, plotting, and orchestration.
- Chapter 5 has two major branches: `ch5_rebuild` and `ch5_dualloop`.

ClosedD/OpenD audit:

- OpenD is best treated as a Stage14 orientation/RAAN/F sensitivity artifact family, currently DG-only in observed code.
- ClosedD was not found as a clear standalone implementation and remains unresolved.

STK/codegen audit:

- Old STK code is partial and scenario/state-export oriented.
- No mature MATLAB Coder, MEX, or C++ export lineage was found.

Chapter 5 taxonomy:

- Static hold and tracking greedy are the safest first scheduler baselines.
- Bubble predictive and dual-loop policies require clearer contracts before implementation.
- Bubble, custody, RMSE, and NIS should be separated into metric/estimation/scheduler concerns.

## Test Status

Validated in this sprint sequence:

- `test_startup`: 2 passed, 0 failed.
- `test_contracts`: 5 passed, 0 failed.
- MATLAB Code Analyzer reported no issues on newly added validator and contract test files.

## Important Open Questions

- What is the exact ClosedD definition?
- Should OpenD remain DG-only for Stage14 compatibility or include DA/DT?
- Should `RAAN_deg` be generalized as `orientation_deg` in new contracts?
- Should artifact metadata be embedded in all contract structs or attached only by `pipeline/cache`?
- Which synthetic core utility should be implemented first: window extraction, gap segment metrics, or static-hold scheduler?

## Recommended Next Prompt

```text
进入 hgv-custody-tpipe Implementation Sprint 0。
请先阅读 docs/ARCHITECTURE_BACKLOG.md、docs/DATA_CONTRACTS.md、docs/SESSION_HANDOFF.md。
本轮只实现一个最小纯 MATLAB core utility，不迁移旧算法：
1. 选择 core.visibility 的 synthetic window-index extractor 或 core.metrics 的 gap segment summarizer；
2. 添加对应 unit test；
3. 保持 codegen-friendly；
4. 不读取旧工程输出，不运行长实验；
5. 小步 git commit。
```

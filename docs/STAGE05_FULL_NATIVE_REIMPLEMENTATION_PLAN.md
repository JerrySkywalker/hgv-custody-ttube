# Stage05 Full Native Reimplementation Plan

Created: 2026-05-05
Branch: `codex/stage05-full-native-reimplementation`

## Legacy Stage05 Module Boundaries

Step 5.1 `stage05_nominal_walker_search` loads Stage04 `gamma_req`, loads Stage02 nominal trajectories, builds an `(h, i, P, T, F)` Walker grid, evaluates each design, and writes a cache/result table.

Step 5.2 `stage05_plot_nominal_results` loads the Stage05 search cache, normalizes grid fields, builds feasible/best/frontier tables, exports CSV tables, and renders scatter/frontier/heatmap/profile figures.

Step 5.3 `stage05_analyze_pareto_transition` loads Stage05 results, builds the global `(Ns, D_G)` Pareto frontier, inclination-wise transition envelopes, transition summary tables, and transition figures.

## New Native Modules

`ttube.experiments.stage05` owns search configuration, search grid, native evaluator, result artifact, summary artifact, frontier artifact, Pareto/transition artifact, artifact save/load/index, and full pipeline wrapper.

`ttube.viz.stage05` owns plot rendering only. Viz consumes artifacts and must not recompute metrics.

`ttube.pipeline/cache` remains the general status/run infrastructure. Stage05-specific save/load helpers live in the experiment layer because they serialize Stage05 artifacts.

`ttube.legacy` remains comparison-only. It may provide guarded helper-level oracles but the native default pipeline must not call it.

## Artifact Families

- `stage05_search_result.v0`
- `stage05_summary.v0`
- `stage05_frontier.v0`
- `stage05_pareto_transition.v0`
- `stage05_plot_bundle.v0`

## Completion Standard

This sprint is complete if the native Stage05 pipeline can run safe small and medium grids, emit result/summary/frontier/Pareto/plot artifacts, save/load/index outputs, compare module-level results against the guarded legacy helper oracle, and pass automated tests without running old full Stage05.

## Prohibited Work

No old full Stage05 runner, Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, GUI, or large scan is run or implemented.

## Completion Update

Branch: `codex/stage05-full-native-reimplementation`

Implemented native modules:

- Stage05.1 search: `makeStage05Config`, `validateStage05Config`, `buildStage05SearchGrid`, `evaluateStage05DesignNative`, `packageStage05SearchResult`, and `runStage05NominalSearch`.
- Stage05 cache/resume: `saveStage05SearchArtifact`, `loadStage05SearchArtifact`, and `writeStage05RunIndex`.
- Stage05.2 postprocess/plot: `summarizeStage05Results`, `rankStage05FeasibleDesigns`, `extractStage05Frontier`, and `src/+ttube/+viz/+stage05/*`.
- Stage05.3 Pareto/transition: `extractParetoFront`, `analyzeInclinationTransition`, and `analyzeStage05ParetoTransition`.
- Full wrapper: `runStage05FullNative` with `smoke`, `tiny`, and `medium_safe` profiles.

Validation result: the requested Stage05-focused regression suite passed 94 tests, 0 failed, 0 incomplete. Code Analyzer was clean for checked new/modified MATLAB files.

Completion judgment: native Stage05 module reimplementation is complete for the intended safe small/medium-grid native stack. Production-scale parity is still partial because the old full Stage05 runner was intentionally not executed, plot parity is smoke/artifact-level rather than pixel-level, and larger formal reproduction/golden artifacts remain future work.

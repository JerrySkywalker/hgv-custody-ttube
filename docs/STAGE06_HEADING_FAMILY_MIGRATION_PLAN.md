# Stage06 Heading-Family Migration Plan

Created: 2026-05-05
Branch: `codex/stage06-heading-family-native`

## Legacy Module Boundaries

Step 6.1 `stage06_define_heading_scope` freezes the heading offset set, inherits the Stage05 Walker grid and Stage04 `gamma_req`, verifies the nominal Stage02 source family, and writes a scope/spec cache plus summary table.

Step 6.2 `stage06_build_heading_family_physical_demo` constructs a physical heading-family demonstration from nominal cases and heading offsets. Its role is family generation and diagnostic visualization, not the search itself.

Step 6.3 `stage06_heading_walker_search` expands nominal trajectories over heading offsets and evaluates each Walker design on the heading-extended family. The output table keeps robust metrics such as minimum `D_G`, pass ratio, feasibility, and case counts.

Step 6.4 `stage06_compare_with_stage05` joins Stage05 and Stage06 result grids by design key, reports feasible-count changes, best `Ns` changes, pass-ratio drops, and metric deltas.

Step 6.5 `stage06_plot_heading_results` renders heading-family search plots and Stage05-vs-Stage06 comparison figures from already computed tables.

## Native Module Mapping

`ttube.experiments.stage06` owns:

- heading scope config and validation;
- heading-family case artifact;
- heading trajectory bank generated through native Stage01/Stage02 backends;
- heading search result artifact;
- Stage06 summary/frontier/ranking artifacts;
- Stage05-vs-Stage06 comparison artifact;
- full native Stage06 wrapper.

`ttube.viz.stage06` owns Stage06 plot rendering only. It consumes Stage06 artifacts and must not recompute `D_G`.

`ttube.legacy` may provide guarded helper-level Stage06 comparison oracles. The native Stage06 pipeline must not call legacy helpers by default.

## Artifact Families

- `stage06_heading_scope.v0`
- `stage06_heading_family.v0`
- `stage06_heading_search_result.v0`
- `stage06_vs_stage05_comparison.v0`
- `stage06_plot_bundle.v0`

## Stage05 Reuse

Stage06 reuses the Stage05 native search grid, Walker evaluator pattern, result-table normalization, summary/frontier conventions, and plot-export discipline. The only production behavior change is that each Walker design is scored across multiple heading trajectories and reduced to robust/worst-heading metrics.

## Prohibited Work

This sprint does not run the old full Stage06 runner, old full Stage05 runner, Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, or GUI workflows.

## Completion Standard

Completion requires a native Stage05 acceptance gate, native Stage06 heading scope/family/search/comparison/plot modules, guarded helper-level Stage06 oracle tests, tiny and medium-safe native reproductions, documentation updates, and a push of `codex/stage06-heading-family-native`.

## Completion Update

Implemented:

- Stage05 acceptance gate with `smoke`, `tiny`, `medium_safe`, and `golden_safe` profiles.
- Stage06.1 native heading scope.
- Stage06.2 native heading family and trajectory bank.
- Stage06.3 native robust heading-family Walker search.
- Stage06.4 native Stage05-vs-Stage06 comparison artifact.
- Stage06.5 native plot bundle.
- Stage06 full native wrapper.
- Guarded Stage06 legacy oracle facade with blocked diagnostic.

Validation: requested Stage05/Stage06 suite passed 33 tests, 0 failed, 0 incomplete. Code Analyzer was clean after fixing one unused test argument.

Completion judgment: yes for native Stage06 module migration over safe profiles; partial for legacy numeric parity because no safe standalone old Stage06 helper oracle was confirmed and the old full Stage06 runner was intentionally not executed.

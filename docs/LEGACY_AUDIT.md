# Legacy Audit

## Scope

Sprint 0 read the old project only as evidence. No old files were modified. The audit focused on root structure, startup path chain, stage runners, Stage02/05/09/14, Chapter 5 rebuild and dual-loop branches, output/cache conventions, and migration risk.

## Root Structure And Startup

The old root is organized around `params`, `src`, `stages`, `run_stages`, `runners`, `ch5_rebuild`, `ch5_dualloop`, tests, tools, milestones, shared scenarios, and output folders.

`startup.m` recursively adds `params`, `src`, `stages`, `benchmarks`, `milestones`, `shared_scenarios`, `tests`, `run_milestones`, `run_shared_scenarios`, `run_stages`, and `tools`. It also creates a large `outputs/` tree, including stage caches, figures, tables, logs, bundles, milestones, and shared scenario folders. It sets graphics defaults and initializes project logging.

The startup path chain is convenient for exploration but too broad for the new architecture. It hides dependencies and makes it easy for plotting, runners, and compute helpers to call each other implicitly.

## Output And Cache Organization

The main stage pipeline writes to `outputs/stage/stageXX/cache`, `figs`, and `tables`, with logs under `outputs/logs/stageXX`. `configure_stage_output_paths` maps a stage name to these folders and also maintains deprecated compatibility fields such as `cfg.paths.cache`, `cfg.paths.figs`, and `cfg.paths.tables`.

Most stages save timestamped `.mat` files with an `out` struct. Many also write CSV tables and PNG figures. Stage code locates prior results through "latest matching cache" patterns such as `stage02_hgv_nominal_*.mat`.

The cache model is practical but not a true DAG. It has no clearly centralized manifest, artifact fingerprint, dependency lock, or backend identity. Resume is mostly accomplished by loading the latest cache and by stage-specific options such as early stop and save-cache switches.

## Stage Mainline

Stage01 builds casebanks. Stage02 propagates HGV trajectory families. Stage03 builds a Walker constellation and visibility/access data. Stage04 scans windowed information metrics and calibrates `gamma_req`. Stage05 performs a nominal-family static Walker search. Later stages broaden the inverse design, screening, and boundary analysis. Stage09 is a formal inverse-design feasible-domain scan over robust D-series constraints. Stage14 explores OpenD/RAAN/phase-orientation sensitivity.

This mainline is valuable, but compute, cache, logging, progress, plotting, and stage orchestration are usually in the same function or closely coupled helpers.

## Stage02 Data Flow

`run_stages/run_stage02_hgv_nominal.m` calls `stage02_hgv_nominal`.

Stage02 loads the latest Stage01 casebank, prepares HGV configs for nominal, heading, and critical families, propagates each case, validates trajectories, summarizes them, optionally plots 2D/3D figures, and saves a timestamped cache. Output includes `out.casebank`, `out.trajbank`, family summaries, plot files, log file, and benchmark mode.

Migration lesson: HGV propagation and trajectory contract belong in `core.traj`; family assembly belongs in pipeline/experiments; plotting belongs in `viz`.

## Stage05 Data Flow

`stage05_nominal_walker_search` loads latest Stage04 for `gamma_req` and latest Stage02 for nominal trajectories. It builds a Walker search grid over fixed height and `(i, P, T, F)`, optionally orders hard cases first, evaluates each design through Stage03/Stage04-style visibility and worst-window metrics, and writes result tables and cache.

`evaluate_single_layer_walker_stage05` builds a Walker and satellite bank, computes visibility for each nominal trajectory, scans worst windows, computes `D_G = lambda_worst / gamma_req`, pass ratio, feasibility, rank score, and early-stop status.

Migration lesson: Stage05 mixes core orbit, visibility, window metrics, search orchestration, parallel progress, and cache output. The new project should split these.

## Stage09 Data Flow

`stage09_build_feasible_domain` is the first clear inverse-design domain builder. It prepares a casebank, builds a search table over Walker design variables, resolves `gamma_req`, constructs an evaluation context, evaluates each design, summarizes feasible and infeasible domains, writes CSV tables, and optionally saves cache.

`evaluate_single_layer_walker_stage09` computes per-case visibility and LOS geometry, builds window grids, constructs window information matrices, computes `DG` and `DA`, computes `DT` from visibility gaps, forms a joint margin, fail tags, pass ratio, and robust minima. It explicitly avoids letting pure zero-information windows dominate DG/DA when DT is responsible for outage.

Migration lesson: DG/DA/DT definitions and zero-window rules must be frozen as core metric contracts before code migration.

## Stage14 Data Flow

`run_stages/run_stage14_openD.m` is a unified Stage14 runner. It supports raw RAAN grid scans, RAAN profiles, Ns envelopes, multi-Ns stats, multi-inclination comparisons, joint phase-orientation sensitivity, and a full mainline chain. It uses Stage05-aligned production presets and has options for case limits, hard-case-first ordering, pass ratio, DG thresholds, cache, tables, and figures.

Migration lesson: Stage14 is the likely OpenD and phase/orientation source. Its plotting and scanning are tightly bound; OpenD definitions need a second audit before implementation.

## Chapter 5 Rebuild

`ch5_rebuild` is the Chapter 5 reconstruction branch. Its README records a long evolution from static/tracking baselines through bubble-predictive scheduling, true RMSE replay, NIS, Gramian/key-direction repair, dual-loop concepts, and R8/R9/R10 lines. `run_ch5_bundle.m` runs R4/R5/R9/R10 diagnostics, replay, custody diagnostic bundles, and occupancy summaries under `outputs/ch5_rebuild/bundle_runs`.

Important source areas include `metrics`, `allocator`, `policies`, `inner_loop`, `outer_loop_A`, `outer_loop_B`, `diagnostics`, `plots`, and `r85_li_methods/core`.

Migration lesson: Chapter 5 contains the richest scheduling and bubble vocabulary, but it has many historical variants. Treat it as baseline/reference, not code to copy whole.

## Chapter 5 Dual Loop

`ch5_dualloop` is a separate branch with dual-loop custody concepts. It has `inner_loop`, `outer_loop_A`, `outer_loop_B`, `metrics`, `policies`, `prior`, `scenario`, `plots`, and many phase runners. `eval_custody_metrics` emphasizes `phi_series`, threshold, worst rolling window, outage, longest outage, and SC/DC/LoC ratios.

Migration lesson: dual-loop policy concepts belong in `core.scheduler` and `core.metrics`, while phase runners and docs are legacy baseline material.

## Generation And Metric Chain

The old pipeline appears to generate:

- trajectories through Stage02 VTC-HGV dynamics;
- Walker constellations and satellite banks through Stage03 helpers;
- access matrices through Stage03 visibility functions;
- worst windows and FIM/Gramian-like matrices through Stage04 window helpers;
- DG through worst eigenvalue versus `gamma_req`;
- DA through Stage09 window metric projection;
- DT through visibility gap metrics;
- ClosedD/OpenD through later Stage09/Stage14 families, but exact definitions need a second audit;
- bubble/custody through Chapter 5 metric and policy branches;
- RMSE through Chapter 5 inner-loop/replay and true-RMSE helpers;
- scheduling through static hold, greedy/tracking, bubble predictive, custody single-loop, and custody dual-loop policies.

## Coupling Assessment

Computation and plotting are coupled in several stage functions. Stage02, Stage03, Stage05, Stage09, Stage14, and Ch5 bundle scripts often compute, log, cache, and plot in one flow. Some analysis/plot files likely perform data reshaping or metric summarization beyond rendering.

The new `viz` layer should only render artifacts and must not re-run core metrics.

## Progress And Parallel Management

Long scans use stage-specific progress reporting, `parfor`, `parfeval`, `fetchNext`, auto pool startup, hard-case-first ordering, and early-stop flags. This behavior is useful but scattered.

The new project should centralize progress and resume in `pipeline/cache`, with core functions remaining unaware of parallel execution.

## Highest Migration Risks

- Metric definitions drifting during migration, especially DG/DA/DT, ClosedD/OpenD, bubble, and custody states.
- Time grid and coordinate frame mismatches between Stage02, Stage03, STK, and future codegen.
- Zero-information and outage handling in DG/DA/DT.
- Hidden plotting-side computation.
- Multiple Chapter 5 policy generations with similar names but different semantics.
- Cache "latest file" behavior causing non-reproducible comparisons.
- MATLAB table/struct-heavy interfaces blocking codegen if copied into core.
- STK adapter scope is not mature in old code and needs deliberate MVP design.

## Initial Placement Decisions

Move into `core`: numeric trajectory, orbit, sensor, visibility, estimation, metrics, and stable scheduler kernels.

Move into `pipeline/cache`: DAG steps, cache layout, artifact manifests, fingerprinting, backend selection, resume, and progress.

Move into `viz`: paper and diagnostic figures that consume saved artifacts.

Move into `stk`: STK scenario/object/access adapters and comparison tools.

Keep as legacy baseline: old runners, large stage scripts, Ch5 bundle scripts, historical policy branches, old output layout, and dissertation figure scripts until their contracts are extracted.

## Uncertain Items

- Exact ClosedD and OpenD definitions require a focused second audit.
- STK usage appears limited to helper/check functions in Sprint 0 evidence; full STK integration state needs a second audit.
- C++/MEX export lineage was not found in Sprint 0 and needs a dedicated search.
- Chapter 5 policy lineage should be mapped into a small taxonomy before any scheduler migration.

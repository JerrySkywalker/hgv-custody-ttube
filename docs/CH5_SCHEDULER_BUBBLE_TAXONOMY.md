# Chapter 5 Scheduler / Bubble Taxonomy

## Scope

Sprint 4 performed a read-only audit of Chapter 5 scheduler, bubble, custody, RMSE, NIS, and dual-loop evidence. No old project files were modified and no Chapter 5 runner was executed.

## Main Legacy Branches

`ch5_rebuild` is the richer reconstruction branch. It contains allocator functions, policy functions, real/proxy metrics, bubble prediction/correction logic, inner-loop filtering/replay, diagnostics, and R-series phase runners.

`ch5_dualloop` is the dual-loop custody branch. It contains inner-loop filtering, outer-loop A risk/prior estimation, outer-loop B window objective and action selection, custody metrics, tracking metrics, state-machine/guard logic, and phase summaries.

## Metric Families

### Bubble Metrics

Representative source: `ch5_rebuild/metrics/eval_bubble_metrics_real.m`.

Inputs are a `bubble` struct and sample interval `dt`. Core fields include:

- `is_bubble`;
- `bubble_depth`;
- optional `valid_for_bubble`.

Outputs include:

- total steps and valid steps;
- bubble steps;
- bubble fraction;
- bubble total time;
- longest and mean bubble segment duration;
- max and mean bubble depth;
- segment start/end indices.

Migration target: `core.metrics` for pure time-series segment metrics. Bubble prediction logic belongs outside the metric kernel.

### Custody Metrics

Representative sources:

- `ch5_rebuild/metrics/eval_custody_metrics_real.m`;
- `ch5_dualloop/metrics/eval_custody_metrics.m`.

Two related lineages exist:

- real-line custody treats bubble occurrence as custody loss and computes custody ratio over valid samples;
- dual-loop custody uses `phi_series` with a threshold, rolling worst-window score, outage ratio, longest outage, and SC/DC/LoC ratios.

Migration target: `core.metrics`. The new contract should distinguish:

- custody from bubble loss;
- custody from `phi_series`;
- SC/DC/LoC occupancy.

### RMSE / Tracking Metrics

Representative sources:

- `ch5_rebuild/metrics/eval_rmse_metrics_real.m`;
- `ch5_rebuild/analysis/ch5r_backfill_suite_rmse_from_mat.m`;
- `ch5_dualloop/metrics/eval_tracking_metrics.m`.

RMSE is used for tracking comparison and replay diagnostics, but Sprint 0/1 conclusions still apply: average RMSE must not become the sole custody objective.

Migration target: `core.estimation` for estimator outputs and `core.metrics` for RMSE summaries.

### NIS / Consistency

Representative sources:

- `ch5_rebuild/inner_loop/compute_nis_scalar.m`;
- `ch5_rebuild/inner_loop/classify_nis_consistency.m`;
- `ch5_dualloop/inner_loop/compute_nis_series.m`.

NIS supports inner-loop filter consistency and outer-loop risk signals.

Migration target: `core.estimation` for NIS kernels; policy use belongs in `core.scheduler`.

## Policy Families

### Static Hold

Representative sources:

- `ch5_rebuild/policies/policy_static_hold.m`;
- `ch5_dualloop/policies/policy_static_hold.m`.

Meaning: keep a bootstrap feasible constellation/resource selection fixed across the horizon.

Migration priority: first baseline policy. It is deterministic, simple, and useful for tests.

### Tracking Greedy

Representative sources:

- `ch5_rebuild/policies/policy_tracking_greedy.m`;
- `ch5_dualloop/policies/policy_tracking_dynamic.m`;
- allocator functions such as `select_satellite_set_tracking_greedy`.

Meaning: optimize tracking-oriented information or error proxy, often with hysteresis and minimum hold duration.

Migration priority: second baseline policy after static hold.

### Bubble Predictive

Representative sources:

- `ch5_rebuild/policies/policy_bubble_predictive_with_prior.m`;
- `ch5_rebuild/outer_loop/detect_bubble_precursor.m`;
- `ch5_rebuild/allocator/select_satellite_set_bubble_predictive*.m`.

Meaning: detect future bubble precursor, then switch to predictive selection or correction; otherwise hold or fallback.

Migration priority: after bubble/custody metric contracts are frozen.

### Single-Loop Custody

Representative source: `ch5_dualloop/policies/policy_custody_singleloop.m`.

Meaning: choose resources dynamically from a custody objective using current state and previous selection. It tracks selected sets, satellite count, switching, and RMSE proxy.

Migration priority: after static and greedy baselines.

### Dual-Loop Custody

Representative sources:

- `ch5_dualloop/policies/policy_custody_dualloop_min.m`;
- `ch5_dualloop/outer_loop_A/*`;
- `ch5_dualloop/outer_loop_B/*`;
- `ch5_rebuild/outer_loop_A/*`;
- `ch5_rebuild/outer_loop_B/*`.

Meaning: outer loop estimates risk/prior/requirement pressure over a horizon; inner or outerB action selector chooses resources with support, geometry, prior, and switching terms.

Migration priority: not first. It has many variants and should be reduced to a small interface before implementation.

## Candidate Scoring Components

Observed scoring terms include:

- dual support ratio;
- single support ratio;
- zero support ratio;
- longest single-support and zero-support runs;
- geometry terms such as lambda minimum, trace, crossing angle, or baseline;
- switching cost;
- deviation from reference/prior;
- prior region or fragility cost;
- gate penalty for infeasible support pattern.

New scheduler contract should separate:

- candidate generation;
- candidate feasibility gates;
- candidate scoring;
- switch/hold policy;
- policy trace packaging.

## State And Trace Concepts

Important state/trace concepts:

- `selection_trace`;
- selected pair/set;
- previous pair/set;
- switch flag;
- current time index;
- candidate pair bank;
- support window proxy;
- future window preview;
- bubble precursor;
- outer prior map;
- guard/state-machine mode;
- SC/DC/LoC occupancy.

These belong in `core.scheduler` contracts and pipeline artifacts, not in plotting code.

## Migration Order

Recommended order:

1. Define scheduler trace contract.
2. Implement static hold over synthetic candidate IDs.
3. Implement greedy score selection over synthetic numeric scores.
4. Implement switching penalty and minimum hold rule.
5. Implement bubble/custody metric kernels on synthetic time series.
6. Add bubble precursor interface with no legacy algorithm.
7. Only then audit and migrate a minimal bubble-predictive policy.
8. Defer dual-loop until outerA/outerB contracts are explicit.

## Risks

- Multiple names refer to similar but not identical policy ideas.
- Some policies mix candidate generation, FIM computation, scoring, switching, and result packaging.
- RMSE proxy scaling in old code is not necessarily a physical estimator result.
- Bubble can mean current loss, future precursor, requirement-induced area, or correction target.
- Dual-loop code has several generations and should not be copied whole.

## Open Questions

- Should the new primary Chapter 5 metric be `phi_series`, bubble loss, requirement margin, or a composite artifact?
- What is the formal relation between bubble and custody loss in the dissertation text?
- Which policy names should be kept in final paper terminology: static, tracking greedy, bubble predictive, single-loop custody, dual-loop custody?
- Should dual-loop outerA/outerB be implemented as separate scheduler plugins or as a single policy with sub-states?

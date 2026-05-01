# D-Metric Contract Draft

## Status

This document is a draft contract for Batch 2. It is not the final dissertation definition of DG, DA, DT, ClosedD, or OpenD.

Batch 2 only introduces synthetic toy primitives that make requirement margins and D-triplet feasibility testable without legacy outputs. It does not migrate Stage09 and does not implement production DG, DA, or DT.

## Scope

Allowed in this draft:

- candidate field names and output conventions;
- normalized toy margin semantics;
- deterministic joint feasibility rules;
- unresolved research and migration questions.

Out of scope:

- HGV dynamics;
- Walker generation;
- real access geometry;
- real FIM or Gramian assembly;
- final DG, DA, or DT formulas;
- ClosedD or OpenD implementation.

## DG Candidate Semantics

DG represents geometric or information-support margin. Its lineage is Stage04, Stage05, Stage09, and Stage14.

A typical future form may resemble:

```text
DG = lambda_min / gamma_req
```

where `lambda_min` is a worst-window information support quantity and `gamma_req` is a requirement threshold. The intended direction is high-is-better, with `DG >= 1` as a candidate pass rule.

Unresolved: zero-information window handling is not frozen. Candidate choices include zero margin, explicit outage tag, exclusion from calibration but not evaluation, or a separate invalid-window state.

Batch 2 toy scope: use generic requirement margins only. Do not compute real DG.

## DA Candidate Semantics

DA represents accuracy or task-projected observability margin. Its lineage is Stage09.

Future DA may come from a task-projected FIM, Gramian, CRLB, covariance proxy, or accuracy proxy. The production direction is not frozen:

- high-is-better if DA is expressed as support or inverse error margin;
- low-is-better if DA is expressed directly as error or uncertainty.

Batch 2 toy scope: use generic requirement margins only. Do not compute task projection, CRLB, covariance, or real DA.

## DT Candidate Semantics

DT represents time-continuity, gap, outage, or custody margin. It is related to `ttube.core.metrics.summarizeGapSegments`, which summarizes false segments in a synthetic support mask.

The current gap primitive uses sample-count duration:

```text
gap duration = gap sample count * median(diff(t_s))
```

This is a Batch 1 simplification. Production DT must decide whether to use interval-aware duration, sample-count duration, window-level outage duration, or a mixed rule for nonuniform time grids.

Batch 2 toy scope: use generic requirement margins only. Do not compute formal DT.

## Common D-Metric Output Draft

A future per-metric result should use plain structs and codegen-friendly numeric fields where practical.

Suggested fields:

| Field | Meaning |
|---|---|
| `metric_name` | `DG`, `DA`, or `DT`. |
| `value` | Raw scalar or array before normalization. |
| `requirement` | Requirement scalar or array used for normalization. |
| `margin` | Normalized pass margin. Candidate pass threshold is `margin >= 1`. |
| `feasible` | Logical pass/fail mask. |
| `failure_tag` | `G`, `A`, `T`, or empty/`OK` depending on context. |
| `source_artifact_ids` | Artifact IDs used to compute the metric. |
| `notes` | Short contract or diagnostic notes. |

Batch 2 implements only the generic margin and joint-combiner primitives needed to test this shape.

## Joint Feasibility Draft

Given already-normalized `DG_margin`, `DA_margin`, and `DT_margin`:

```text
joint_feasible = DG_margin >= 1 && DA_margin >= 1 && DT_margin >= 1
joint_margin = min(DG_margin, DA_margin, DT_margin)
```

For array inputs, the same rule applies elementwise.

`dominant_fail_tag` is the dimension with the smallest margin. The Batch 2 tie rule is fixed as:

```text
G before A before T
```

If all three margins pass, `dominant_fail_tag` is `OK`.

This joint rule is a synthetic scaffold. It is not ClosedD and is not a production Stage09 migration.

## Unresolved Questions

- ClosedD definition is not frozen.
- OpenD is currently treated as a Stage14 orientation, RAAN, and phasing artifact family, not a Batch 2 scalar.
- Zero-information windows need a production rule.
- Outage windows need a production rule.
- DA task projection must be defined.
- DT time-length accounting must choose sample-count duration, interval-aware duration, or another rule.
- The project must decide whether `>= 1` is the unified pass standard for DG, DA, and DT.
- Failure tags and tie rules need review before legacy regression baselines depend on them.

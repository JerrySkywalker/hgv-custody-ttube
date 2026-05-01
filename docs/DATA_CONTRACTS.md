# Data Contracts

This document defines the initial artifact contracts for the new repository. These are architecture contracts, not implemented algorithms. Field names are provisional but should remain stable once code starts depending on them.

## Common Rules

- All time arrays use seconds relative to `epoch_utc` unless a document explicitly says otherwise.
- Position and velocity fields must declare frame and units.
- Core contracts should prefer numeric arrays and plain structs over MATLAB tables.
- Artifact contracts may add table views for export, but the core compute input should remain codegen-friendly.
- Every artifact should include `schema_version`, `producer`, `created_utc`, `backend`, and `source_fingerprint`.
- Unknown or unavailable optional fields should be present only when meaningful; do not encode large optional data as empty nested structures by default.

## Trajectory Artifact

Purpose: represent one target trajectory or a family member produced by `core.traj` or an external backend.

Owner: `src/+ttube/+core/+traj` for numeric state contract; `pipeline/cache` for artifact metadata.

Required fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `schema_version` | char/string | none | Contract version, initially `trajectory.v0`. |
| `trajectory_id` | char/string | none | Stable ID, for example `N01` or `C2_small_crossing_angle`. |
| `family` | char/string | none | Family label such as `nominal`, `heading`, `critical`. |
| `subfamily` | char/string | none | More specific case grouping. |
| `epoch_utc` | char/string | UTC | Epoch for relative time. |
| `t_s` | `Nt x 1 double` | s | Monotonic time grid. |
| `r_eci_km` | `Nt x 3 double` | km | Target position in ECI. |
| `v_eci_kmps` | `Nt x 3 double` | km/s | Target velocity in ECI. |
| `frame_primary` | char/string | none | Primary state frame, expected `ECI`. |
| `valid_mask` | `Nt x 1 logical` | none | True for valid samples. |

Recommended optional fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `r_ecef_km` | `Nt x 3 double` | km | ECEF position if available. |
| `v_ecef_kmps` | `Nt x 3 double` | km/s | ECEF velocity if available. |
| `r_enu_km` | `Nt x 3 double` | km | Local ENU position if regional frame is used. |
| `control` | struct | mixed | Control profile arrays such as bank/alpha. |
| `events` | struct | mixed | Termination and capture event metadata. |
| `validation` | struct | mixed | Pass/fail flags and range checks. |
| `case_params` | struct | mixed | Entry point, heading, and initial-condition parameters. |

Baseline case: one nominal trajectory on a fixed one-second grid, with ECI position/velocity and deterministic metadata.

## Constellation State Artifact

Purpose: represent a satellite constellation definition and propagated satellite state bank.

Owner: `core.orbit`.

Required fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `schema_version` | char/string | none | Initially `constellation_state.v0`. |
| `constellation_id` | char/string | none | Stable ID for the design. |
| `epoch_utc` | char/string | UTC | Epoch for relative time. |
| `t_s` | `Nt x 1 double` | s | Time grid shared by all satellites. |
| `sat_id` | `Ns x 1 string` | none | Satellite IDs. |
| `plane_index` | `Ns x 1 double/int` | none | Walker plane index. |
| `sat_index_in_plane` | `Ns x 1 double/int` | none | Satellite index within plane. |
| `r_eci_km` | `Nt x Ns x 3 double` | km | Satellite positions in ECI. |
| `v_eci_kmps` | `Nt x Ns x 3 double` | km/s | Satellite velocities in ECI. |
| `walker` | struct | mixed | Walker parameters `h_km`, `i_deg`, `P`, `T`, `F`, and optional RAAN offset. |

Recommended optional fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `r_ecef_km` | `Nt x Ns x 3 double` | km | ECEF positions. |
| `orbit_model` | struct | mixed | Propagation model and constants. |
| `frame_primary` | char/string | none | Expected `ECI`. |

Baseline case: Walker `h=1000 km, i=70 deg, P=8, T=12, F=1` on a short fixed grid.

## Access Artifact

Purpose: represent visibility/access support between one trajectory and one constellation/sensor model.

Owner: `core.visibility`, with sensor geometry from `core.sensor`.

Required fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `schema_version` | char/string | none | Initially `access.v0`. |
| `access_id` | char/string | none | Stable artifact ID. |
| `trajectory_id` | char/string | none | Source trajectory ID. |
| `constellation_id` | char/string | none | Source constellation ID. |
| `sensor_model_id` | char/string | none | Source sensor model ID. |
| `epoch_utc` | char/string | UTC | Epoch for relative time. |
| `t_s` | `Nt x 1 double` | s | Access sample grid. |
| `access_mask` | `Nt x Ns logical` | none | True when satellite can support measurement at sample time. |
| `num_visible` | `Nt x 1 double/int` | count | Count of visible satellites. |
| `dual_coverage_mask` | `Nt x 1 logical` | none | True when at least two satellites support measurement. |

Recommended optional fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `range_km` | `Nt x Ns double` | km | Slant range, NaN if not applicable. |
| `offnadir_deg` | `Nt x Ns double` | deg | Off-nadir angle. |
| `los_unit_eci` | `Nt x Ns x 3 double` | none | LOS unit vector from sensor to target. |
| `constraint_flags` | struct | none | Per-constraint pass masks, such as range, FOV, occlusion. |
| `backend_report_ref` | char/string | none | Link to STK or external report artifact. |

Baseline case: one target, two satellites, short time grid, expected access mask.

## Window Artifact

Purpose: represent extracted time windows and worst-window metric inputs.

Owner: `core.visibility` for windows/gaps; `core.estimation` for information matrices.

Required fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `schema_version` | char/string | none | Initially `window.v0`. |
| `window_id` | char/string | none | Stable ID. |
| `access_id` | char/string | none | Source access artifact. |
| `Tw_s` | double | s | Window duration. |
| `step_s` | double | s | Window start step. |
| `start_idx` | `Nw x 1 double/int` | index | Inclusive sample start indices. |
| `end_idx` | `Nw x 1 double/int` | index | Inclusive sample end indices. |
| `t0_s` | `Nw x 1 double` | s | Window start times. |
| `t1_s` | `Nw x 1 double` | s | Window end times. |

Recommended optional fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `info_matrix` | `Nx x Nx x Nw double` | problem-defined | Window FIM/Gramian matrices. |
| `window_visible_count_min` | `Nw x 1 double` | count | Minimum visible count inside each window. |
| `window_visible_count_mean` | `Nw x 1 double` | count | Mean visible count inside each window. |
| `gap_summary` | struct | mixed | Gap and custody summaries linked to this window set. |

Baseline case: known `t_s`, `Tw_s`, and `step_s` where expected start/end indices are exact.

## Metric Artifact

Purpose: store scalar and time/window metrics without recomputing core quantities in viz or report layers.

Owner: `core.metrics`.

Required fields:

| Field | Type | Units | Description |
|---|---|---|---|
| `schema_version` | char/string | none | Initially `metric.v0`. |
| `metric_id` | char/string | none | Stable ID. |
| `source_artifact_ids` | cell/string array | none | Inputs used to compute metrics. |
| `thresholds` | struct | mixed | Requirement thresholds such as `gamma_req`, `sigma_A_req`, `dt_crit_s`. |
| `case_metrics` | struct array | mixed | Per-case metrics. |
| `robust_metrics` | struct | mixed | Robust minima/maxima across cases or windows. |
| `pass_ratio` | double | fraction | Fraction of cases/windows satisfying requirement. |
| `failure_tags` | struct/string array | none | Failure labels such as `G`, `A`, `T`, or combined tags. |

Initial metric names:

| Name | Meaning | Initial source |
|---|---|---|
| `DG` | Geometric/information margin relative to `gamma_req`. | Stage04/05/09/14 lineage. |
| `DA` | Task-projected accuracy/observability margin. | Stage09 lineage. |
| `DT` | Time/gap/custody margin. | Stage09 gap lineage. |
| `ClosedD` | Closed-domain robust design metric. | Definition not frozen; needs follow-up. |
| `OpenD` | Open-domain orientation/RAAN sensitivity metric family. | Stage14 DG-only RAAN/phase lineage. |
| `bubble` | Bubble interval/depth/area or requirement-induced bubble signal. | Ch5 lineage. |
| `RMSE` | Tracking error summary. | Ch5 replay/inner-loop lineage. |

Baseline case: one synthetic case with known `DG`, `DA`, `DT`, `pass_ratio`, and failure tag behavior.

## Boundary Notes

Contracts define data shape and semantics only. They do not authorize copying legacy algorithms. Implementations should be added later in small tested slices.

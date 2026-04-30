# Compute Modules

## `core.traj`

Function: HGV trajectory generation, control-law evaluation, perturbation families, and trajectory data contracts.

Input: case definitions, initial states, time grid, vehicle/control parameters, environment constants.

Output: trajectory structs or arrays with time, position, velocity, attitude/control summaries, coordinate frames, validation flags, and metadata.

Codegen: yes for propagation kernels and coordinate transforms; maybe for high-level casebank assembly.

STK comparison: yes, for ephemeris and coordinate-frame sanity checks.

Legacy source: `stages/stage02_hgv_nominal.m`, `src/target`, and Stage02 helpers.

## `core.orbit`

Function: Walker constellation generation, orbit propagation, satellite state banks, and constellation metadata.

Input: Walker parameters `(h, i, P, T, F)`, epoch, time grid, Earth constants, propagation model options.

Output: constellation definition, satellite state arrays, plane/satellite indices, and frame labels.

Codegen: yes for simple analytic propagation; maybe for higher-fidelity propagation.

STK comparison: yes, STK should verify constellation object construction and ephemerides.

Legacy source: `src/constellation`, `build_single_layer_walker_stage03`, `propagate_constellation_stage03`.

## `core.sensor`

Function: payload model, FOV, line of sight, range/off-nadir/elevation constraints, Earth occultation, and measurement model.

Input: target states, satellite states, sensor parameters, Earth model, measurement noise.

Output: per-sensor visibility flags, LOS geometry, measurement Jacobians or measurement records.

Codegen: yes for geometric kernels and measurement Jacobians.

STK comparison: yes, especially access and geometry constraints.

Legacy source: `src/sensing`, Stage03 visibility helpers.

## `core.visibility`

Function: access matrix generation, access-window extraction, gap metrics, custody ratios, and worst-window scans.

Input: trajectory state, constellation state, sensor constraints, time grid, window settings.

Output: access matrix, visible counts, dual/multi-coverage masks, window lists, gap statistics, worst-window markers.

Codegen: yes for access/gap/window kernels.

STK comparison: yes, access windows should be compared against STK access output.

Legacy source: `stages/stage03_visibility_pipeline.m`, `src/window`, `compute_gap_metrics_stage09`.

## `core.estimation`

Function: FIM/Gramian assembly, CRLB-like metrics, EKF interface, RMSE summaries, and tracking diagnostics.

Input: visibility/access records, measurement model, noise model, trajectory truth, estimator state/covariance settings.

Output: window information matrices, covariance proxies, EKF traces, RMSE series, NIS or consistency signals.

Codegen: yes for FIM, Gramian, EKF numeric kernels; maybe for full diagnostic packaging.

STK comparison: indirect. STK supplies geometry/access, while estimation remains MATLAB/core.

Legacy source: `build_window_info_matrix_stage04`, `compute_window_metrics_stage09`, `ch5_rebuild/inner_loop`, `ch5_dualloop/inner_loop`.

## `core.metrics`

Function: DG, DA, DT, ClosedD, OpenD, pass ratio, bubble, custody, SC/DC/LoC occupancy, and worst-window summaries.

Input: information matrices, access/gap records, covariance/RMSE traces, threshold requirements, window definitions.

Output: scalar metrics, per-case tables, robust minima, failure tags, bubble intervals, occupancy summaries.

Codegen: yes for scalar/time-series metric kernels; maybe for table packaging.

STK comparison: indirect through STK-provided access/geometric inputs.

Legacy source: Stage04/09/14 metric functions, `ch5_rebuild/metrics`, `ch5_dualloop/metrics`.

## `core.scheduler`

Function: static hold, greedy tracking, bubble-oriented scheduling, resource scoring, switching penalties, guard logic, and dual-loop policy interfaces.

Input: candidate resource sets, metric forecasts, current tracker/custody state, switching cost, policy parameters.

Output: selected satellite/resource set over time, switch trace, policy diagnostics, score traces.

Codegen: maybe. Simple scoring and selection kernels should be codegen-friendly; high-level policy experiments may stay MATLAB-only.

STK comparison: no direct dependency; it may consume STK-derived access artifacts.

Legacy source: `ch5_rebuild/policies`, `ch5_rebuild/allocator`, `ch5_dualloop/policies`, `ch5_dualloop/outer_loop_A`, `ch5_dualloop/outer_loop_B`.

## `pipeline/cache`

Function: DAG, step execution, artifact storage, fingerprinting, manifest, logging, and resume.

Input: step definitions, config structs, artifact references, backend choice, run tags.

Output: artifact records, cache files, manifest files, logs, resumable run state.

Codegen: no.

STK comparison: yes as an orchestrator, not as a numeric kernel.

Legacy source: stage cache/log/table conventions, `configure_stage_output_paths`, `find_stage_cache_files`, Ch5 bundle output patterns.

## `viz`

Function: Chapter 4 and Chapter 5 paper figures, diagnostic plots, report-ready visual summaries.

Input: saved artifacts, metric tables, trajectory/access/scheduler traces.

Output: figures, tables, export-ready plot assets.

Codegen: no.

STK comparison: may render STK-vs-core comparison artifacts, but should not call STK directly unless routed through prepared artifacts.

Legacy source: `src/analysis/plot_*`, `ch5_rebuild/plots`, `ch5_dualloop/plots`.

## `stk`

Function: MATLAB-to-STK and STK-to-MATLAB adaptation for scenarios, objects, ephemerides, access reports, and geometry validation.

Input: core trajectory/constellation/sensor contracts, STK connection settings, scenario metadata.

Output: STK scenario objects, exported ephemerides/access reports, comparison artifacts.

Codegen: no.

STK comparison: this is the STK comparison layer.

Legacy source: `src/analysis/build_stk_walker_scenario_geometry.m`, `check_stk_matlab_availability.m`. Current legacy STK coverage appears partial and needs second audit.

## `export/codegen`

Function: MATLAB Coder configuration, MEX/C++ entrypoints, type definitions, backend consistency tests.

Input: stable core functions, fixed-size or bounded-size type contracts, sample baseline cases.

Output: generated MEX/C++ artifacts, codegen reports, backend comparison results.

Codegen: this layer manages codegen but should keep generated code out of source logic.

STK comparison: no direct STK calls; may participate in three-backend consistency tests using common artifacts.

Legacy source: no clear mature legacy source found in Sprint 0; uncertain, needs later audit.

# Clean-Room Stage01-05 Reimplementation Plan

## Why The Previous Sprint Was Helper-Level

The previous Stage01-05 alignment sprint intentionally wrapped legacy helper functions to obtain a small runnable baseline quickly. That created useful contracts and smoke tests, but it was not a clean-room implementation because default experiment code still called legacy helpers through core adapters.

## Current Legacy Helper Dependencies

Legacy helper names found before this sprint:

- `build_casebank_stage01`
- `propagate_hgv_case_stage02`
- `build_single_layer_walker_stage03`
- `propagate_constellation_stage03`
- `compute_visibility_matrix_stage03`
- `build_window_info_matrix_stage04`

They appeared in helper-level adapter files under `src/+ttube/+core` and in Stage05 experiment code. This violates the new clean-room boundary.

## Allowed Legacy Locations

Legacy calls may remain only in:

- `src/+ttube/+legacy`
- `tools/migration`
- `tests/integration`
- `tests/regression`

These locations are comparison, migration, or baseline layers. They are not native production paths.

## Calls To Remove From Core And Native Pipeline

The following must not appear in `src/+ttube/+core` or default native Stage05 pipeline code:

- absolute legacy repository path strings;
- direct old helper calls;
- cache-oriented legacy runner calls;
- old Stage05 runner calls.

## Layering

Native path:

`ttube.experiments.stage05.runStage05TinySearch -> native casebank -> core.traj/native -> core.orbit/native -> core.sensor/native -> core.estimation/native -> core.metrics.DG`

Legacy comparison path:

`tests/integration` or explicit comparison helper -> `src/+ttube/+legacy` -> read-only old project helpers.

## Clean-Room Criteria

- `src/+ttube/+core` does not contain old helper function names.
- Default `ttube.experiments.stage05` native path does not contain old helper function names.
- Native core functions do not perform file IO, plotting, STK, COM, cache, manifest, pipeline, or GUI work.
- Legacy helpers are used only for comparison, not for native production behavior.

## Tonight's Goal

Implement a native Stage01-05 tiny pipeline that runs without invoking legacy helpers:

- native Stage01 minimal N01 case;
- native HGV trajectory prototype;
- native Walker constellation and circular propagation;
- native access geometry;
- native window information matrix and DG;
- native Stage05 tiny search;
- static dependency guard;
- old-new helper comparison tests and report.

## Non-Goals

- Full Stage05 dissertation-scale scan.
- Stage09 DA/DT production migration.
- Stage14 OpenD scan.
- Ch5.
- ClosedD.
- STK, C++/MEX, GUI.

## Expected Limitations

Native Stage02 is a simplified point-mass/flat-ENU prototype, not a bitwise reproduction of the old VTC geodetic ODE. Numeric comparisons to legacy are coarse sanity checks, not production parity.

Native Stage04 uses the same stated LOS angle-information form, but it is a new implementation. One-window comparisons should be close for the same geometry; differences must be recorded rather than hidden.

# Stage01-02 Production Parity Plan

Created: 2026-05-05
Branch: `codex/cleanroom-stage01-05-native`

## Context

The clean-room Stage01-05 native pipeline is intentionally functional but still partial for the first two stages. The current Stage01 native casebank keeps the legacy ENU boundary convention, but maps it to a pseudo-ECI frame anchored near `[R_E, 0, 0]`. The current Stage02 native trajectory generator is a simplified flat-ENU point-mass prototype. Those choices were sufficient to prove a native tiny Stage01-05 software pipeline, but they are not production parity with the legacy Stage01/Stage02 geodetic and VTC-HGV flow.

This sprint keeps the clean-room architecture: default native code must not call legacy helper functions. The legacy project is read-only reference material and a comparison oracle only.

## Stage01 Gap

Legacy Stage01 builds protected-disk entry cases in geodetic mode when the default configuration enables a geodetic anchor. The N01 default case is generated from:

- anchor latitude/longitude/height from `cfg.geo`;
- protected-disk entry radius from `cfg.stage01.R_in_km`;
- spherical direct geodesic from the anchor;
- WGS84 geodetic-to-ECEF conversion;
- simple GMST Earth rotation from ECEF to ECI at the epoch;
- ENU heading direction rotated into ECEF and ECI.

The current native Stage01 pseudo-ECI shortcut does not preserve geodetic latitude/longitude, Earth rotation, ECEF, or ECI heading parity. This can produce plausible dimensions but not meaningful Stage01 production alignment.

## Stage02 Gap

Legacy Stage02 propagates a VTC-style HGV state `[v, theta, sigma, phi, lambda, r]` using:

- Stage01 geodetic entry point for initial latitude/longitude;
- heading-to-sigma mapping from the Stage01 local heading convention;
- open-loop alpha/bank profile selected by case family;
- public HGV mass, reference area, and lift/drag polynomial coefficients;
- simple US76-like atmosphere density and speed-of-sound approximation;
- geodetic, ECEF, ENU, and ECI trajectory outputs.

The current native Stage02 uses a flat local point-mass model with inline placeholder control, atmosphere, and aero behavior. It must be upgraded to use geodetic/ECI initial conditions and replaceable VTC-inspired control/aero/atmosphere modules. Full bitwise parity is not expected in this sprint because the native implementation remains a clean-room model rather than a direct legacy function port.

## Native Capabilities To Implement

- WGS84 geodetic-to-ECEF utilities without Mapping Toolbox.
- Simple GMST Earth rotation ECEF-to-ECI utilities.
- ENU direction and position transforms for Stage01 case generation.
- Stage01 native N01 case with geodetic, ECEF, and ECI fields.
- Stage02 native control, aero, and atmosphere component factories.
- Stage02 native trajectory propagation from Stage01 geodetic/ECI initial conditions.
- Native-vs-legacy integration comparisons for N01 case and trajectory.

## Read-Only Legacy References

The following old-project files are reference or comparison-only inputs:

- `params/default_params.m`
- `src/scenario/build_casebank_stage01.m`
- `stages/stage01_scenario_disk.m`
- `src/target/propagate_hgv_case_stage02.m`
- `src/target/validate_hgv_trajectory_stage02.m`
- `src/target/summarize_hgv_case_stage02.m`
- legacy `src/geo` conversion helpers
- legacy Stage02 control, atmosphere, and VTC dynamics helpers

Legacy calls remain confined to `src/+ttube/+legacy`, `tools/migration`, `tests/integration`, and `tests/regression`.

## Error Policy

Acceptable for this sprint:

- Stage01 ECI parity within small numerical tolerance from equivalent WGS84/direct-geodesic/simple-GMST formulas.
- Stage02 trajectory magnitude parity for time grid, initial/terminal altitude scale, speed scale, and ECI dimensions.
- Documented Stage02 curve differences caused by clean-room spherical ECI dynamics and simplified event handling.

Not acceptable:

- Native core calling old helper functions.
- Default native Stage05 path calling legacy functions.
- Keeping pseudo-ECI as the Stage01 production path.
- Marking the upgraded Stage02 model as full VTC parity if trajectory curves still differ materially.

## Out Of Scope

This sprint does not run full legacy Stage05, Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, or GUI work. Stage03-05 are regression surfaces only for this sprint.

## Completion Notes

Implemented:

- native WGS84/geodetic/ECEF/ECI frame utilities;
- native Stage01 N01 geodetic casebank output;
- native Stage02 control, aero, and atmosphere component factories;
- native Stage02 spherical ECI point-mass propagation from Stage01 geodetic/ECI initial conditions;
- N01 native-vs-legacy Stage01 and Stage02 comparison tests;
- Stage03-05 tiny regression validation after the Stage01/02 changes.

Validation:

- Stage01 N01 geodetic/ECEF/ECI comparison passed strict tolerance.
- Stage02 short N01 trajectory comparison passed coarse magnitude tolerance.
- Static clean-room guard passed.
- Selected sprint regression suite passed 24 tests, 0 failed, 0 incomplete.
- Code Analyzer was clean for new/modified MATLAB files checked in this sprint.

Current judgment:

- Stage01: production parity for N01 fields exercised by the tiny native pipeline.
- Stage02: improved partial, because the native model is still spherical ECI point-mass rather than exact legacy VTC state propagation.

## Native VTC Follow-Up

The next sprint added a direct VTC-state backend. Stage02 now has two native trajectory backends:

- `native_point_mass` / `native`: spherical ECI point-mass prototype retained for comparison.
- `native_vtc`: VTC-state parity candidate propagating `[v, theta, sigma, phi, lambda, r]`.

`native_vtc` is now the default Stage05 tiny trajectory backend, but Stage02 remains partial rather than full production parity until task-capture event parity and broader legacy case/grid comparisons are complete.

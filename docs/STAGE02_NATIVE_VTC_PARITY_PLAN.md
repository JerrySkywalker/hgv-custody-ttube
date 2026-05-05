# Stage02 Native VTC Parity Plan

Created: 2026-05-05
Branch: `codex/cleanroom-stage01-05-native`

## Legacy Stage02 Inputs

Legacy Stage02 consumes one Stage01 case and the project default config. The case provides `case_id`, `family`, `subfamily`, `heading_deg`, geodetic entry fields, and ECEF/ECI entry fields. The config provides Stage02 initial speed, initial altitude, initial flight-path angle, control commands, time grid, stop conditions, and geodetic/time constants.

## Legacy VTC State

The propagated state is:

`X = [v, theta, sigma, phi, lambda, r]^T`

Units:

- `v`: speed `[m/s]`
- `theta`: flight-path angle `[rad]`
- `sigma`: heading convention `[rad]`, where `0 deg` is north, `-90 deg` is east, and `+90 deg` is west
- `phi`: geodetic latitude `[rad]`
- `lambda`: longitude `[rad]`
- `r`: geocentric radius `[m]`

The legacy initial heading mapping is `sigma0_deg = heading_deg - 90`.

## Legacy Control Law

The legacy control profile is constant alpha/bank selected by case family:

- nominal: `alpha_nominal_deg`, `bank_nominal_deg`
- heading: `alpha_heading_deg`, `bank_heading_deg`
- critical C1/C2: critical-family alpha/bank fields

N01 uses nominal defaults: `alpha = 11 deg`, `bank = 0 deg`.

## Legacy Aero And Atmosphere

The legacy local Stage02 parameter set uses:

- `Re = 6378137 m`
- `mu = 3.986e14 m^3/s^2`
- `g0 = 9.80665 m/s^2`
- `m = 907.2 kg`
- `S = 0.4839 m^2`
- `coef_L = [0.0301, 2.2992, 1.2287, -1.3001e-4, 0.2047, -6.1460e-2]`
- `coef_D = [0.0100, -0.1748, 2.7247, 4.5781e-4, 0.3591, -6.9440e-2]`

Atmosphere is a simple US76-like exponential density fallback with constant speed of sound `295 m/s`.

## Legacy Termination Conditions

Legacy Stage02 stops on event conditions:

- altitude below `h_min_m`
- altitude above `h_max_m`
- speed below `v_min_mps`
- speed above `v_max_mps`
- optional task capture radius in the regional frame
- optional landing event

The native candidate implements altitude and speed bounds first. Task-capture parity is documented as remaining work unless explicitly added.

## Legacy Outputs

Legacy outputs include:

- `t_s`
- `X`
- `lat_deg`, `lon_deg`, `h_m`, `h_km`
- `r_enu_m`, `r_enu_km`, `xy_km`
- `r_ecef_m`, `r_ecef_km`
- `r_eci_m`, `r_eci_km`
- `v_mps`
- metadata including HGV config, control commands, and sigma0

## Native VTC Backend Target

The new `native_vtc` backend should:

- use the native Stage01 geodetic case fields;
- propagate the VTC state directly with clean-room dynamics;
- use native control/aero/atmosphere components;
- convert VTC state to a `trajectory.v0` artifact;
- keep legacy helper calls out of `src/+ttube/+core`;
- allow comparison against legacy Stage02 in integration tests.

## Backend Difference

`native_point_mass` / `native` is the existing spherical ECI point-mass prototype. It propagates `[r_eci; v_eci]` and is useful as a simpler clean-room backend.

`native_vtc` propagates `[v, theta, sigma, phi, lambda, r]` and is the Stage02 production-parity candidate.

## Acceptable Error

This sprint aims for close N01 parity over small time windows. Strict bitwise equality is not required. Acceptable residuals include:

- small numerical differences from solver choice and interpolation;
- finite-difference ECI velocity differences;
- missing task-capture event parity if the short validation window does not hit capture.

Large curve differences in altitude, speed, or displacement must be reported as partial parity rather than hidden.

## Out Of Scope

No full legacy Stage05, Stage09, Stage14, Ch5, ClosedD, STK, C++/MEX, GUI, or large-scan work is performed in this sprint.

## Completion Notes

Implemented:

- `docs/VTC_STATE_CONTRACT.md`
- `validateVtcStateSeries`
- `hgvDynamicsVtc`
- `vtcStateToEcef`
- `vtcStateToTrajectoryArtifact`
- `propagateHgvTrajectoryNativeVtc`
- backend dispatch for `native_vtc`
- Stage05 tiny `trajectoryBackend` option with default `native_vtc`

Validation:

- requested regression suite passed 34 tests, 0 failed, 0 incomplete;
- static clean-room guard passed;
- Code Analyzer was clean for all new/modified MATLAB files checked in this sprint;
- no old full Stage05, Stage09, Stage14, or Ch5 scans were run.

Current judgment: `native_vtc` is the Stage02 parity candidate and the default Stage05 tiny trajectory backend. It is still partial, not full production parity, because native task-capture event parity and broader case/grid validation remain pending.

# Stage02 Native VTC Parity Report

Created: 2026-05-05

## Summary

Status: parity candidate, still partial until broader trajectory grids and event behavior are validated.

Implemented backend: `native_vtc`

Default Stage05 tiny trajectory backend: `native_vtc`

Comparison oracle: read-only legacy Stage02 through `src/+ttube/+legacy` adapter in integration tests.

## Current Comparison

Test: `tests/integration/test_stage02NativeVtcVsLegacyTrajectory.m`

Case: `N01`

Window: `Tmax_s = 80`, `Ts_s = 5`

Compared:

- time grid start/end/sample count;
- initial altitude;
- altitude curve;
- speed magnitude curve;
- ECI displacement magnitude;
- valid mask.

Current tolerance policy:

- initial altitude error `< 1e-6 km`;
- max altitude error `< 1 km`;
- max speed magnitude error `< 0.8 km/s`;
- max displacement magnitude error `< 60 km`.

The current test passed under this policy.

## Interpretation

The native backend now propagates the same VTC state family `[v, theta, sigma, phi, lambda, r]` rather than the previous ECI point-mass state. This materially improves Stage02 alignment and creates a production parity candidate.

The current automated comparison uses geocentric altitude derived from `norm(r_eci) - Re` for both native and legacy artifacts because the legacy comparison adapter exposes only trajectory artifact fields, not the full legacy `h_km` helper output. Native VTC still stores geodetic `h_km` in its VTC state.

Remaining partial status is due to:

- finite-difference ECI velocity in the artifact conversion;
- simple RK4 fixed-step integration instead of legacy `ode45` plus interpolation;
- task-capture event parity not yet implemented in the native backend;
- comparison presently limited to N01 and a short time window.

No legacy helper is called from native core.

## Stage05 Tiny Impact

`ttube.experiments.stage05.runStage05TinySearch` now accepts `cfg.trajectoryBackend`:

- `native_vtc`
- `native_point_mass`

The default is `native_vtc`. Stage05 tiny regression passed with `native_vtc`, and a backend-option test confirms point-mass and VTC runs produce the same tiny-grid row count and finite DG values.

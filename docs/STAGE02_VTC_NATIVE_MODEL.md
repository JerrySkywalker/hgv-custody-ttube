# Stage02 VTC Native Model

Created: 2026-05-05

## Legacy Reference Summary

The old Stage02 helper propagates an HGV state `[v, theta, sigma, phi, lambda, r]` with a constant open-loop alpha/bank profile. It derives initial latitude/longitude from the Stage01 geodetic entry point, maps Stage01 heading to `sigma0 = heading_deg - 90 deg`, and emits geodetic, ECEF, ENU, and ECI trajectory fields.

Public legacy constants used as native reference values:

- Earth radius: `6378137 m`
- Earth gravity parameter: `3.986e14 m^3/s^2`
- Sea-level gravity: `9.80665 m/s^2`
- HGV mass: `907.2 kg`
- Reference area: `0.4839 m^2`
- Lift coefficients: `[0.0301, 2.2992, 1.2287, -1.3001e-4, 0.2047, -6.1460e-2]`
- Drag coefficients: `[0.0100, -0.1748, 2.7247, 4.5781e-4, 0.3591, -6.9440e-2]`
- Nominal alpha: `11 deg`
- Nominal bank: `0 deg`
- Default initial speed: `5500 m/s`
- Default initial altitude: `50000 m`
- Default flight-path angle: `0 deg`

## Native Component Split

The native implementation exposes replaceable modules:

- `makeHgvControlProfile`: family-based constant alpha/bank command.
- `makeHgvAeroModel`: VTC-inspired CL/CD polynomial in alpha and Mach.
- `makeHgvAtmosphereModel`: simple US76-like exponential density and constant speed-of-sound fallback.
- `hgvDynamicsPointMass`: ECI spherical point-mass dynamics consuming the replaceable modules.
- `propagateHgvTrajectoryNative`: artifact-level propagator using Stage01 geodetic/ECI initial fields.

## Clean-Room Boundary

The native component functions do not call old helper functions, read files, write files, draw plots, or access cache. Legacy code remains only a read-only reference and comparison oracle in `src/+ttube/+legacy` and tests.

## Unresolved Items

- The native model is not a direct state-equation clone of the legacy VTC integrator. It uses spherical ECI point-mass dynamics while preserving the main public control/aero/atmosphere parameterization.
- Legacy event termination behavior is not fully reproduced. Tiny-pipeline validation uses fixed short propagation windows.
- The atmosphere is the same simple exponential fallback shape visible in the legacy Stage02 helper, not a high-fidelity US76 implementation.

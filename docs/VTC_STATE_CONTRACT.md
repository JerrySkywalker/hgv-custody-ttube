# VTC State Contract

Schema: `vtc_state.v0`

## Required Fields

- `schema_version`: must be `vtc_state.v0`
- `trajectory_id`: trajectory/case identifier
- `epoch_utc`: UTC epoch string
- `t_s`: `Nt x 1` time grid `[s]`
- `X`: `Nt x 6` state matrix `[v, theta, sigma, phi, lambda, r]`
- `v_mps`: speed `[m/s]`
- `theta_rad`: flight-path angle `[rad]`
- `sigma_rad`: heading angle `[rad]`
- `phi_rad`: geodetic latitude `[rad]`
- `lambda_rad`: longitude `[rad]`
- `r_m`: geocentric radius `[m]`
- `h_m`: altitude above reference radius `[m]`
- `h_km`: altitude above reference radius `[km]`
- `alpha_rad`: control angle of attack `[rad]`, scalar or `Nt x 1`
- `bank_rad`: bank angle `[rad]`, scalar or `Nt x 1`

## Optional Fields

- `theta_deg`, `sigma_deg`, `lat_deg`, `lon_deg`
- `r_ecef_km`, `r_eci_km`
- `v_eci_kmps`
- `meta`

## Units And Angle Conventions

The state follows the legacy Stage02 VTC convention:

- `theta`: positive above local horizontal.
- `sigma`: `0 deg` points north, `-90 deg` points east, `+90 deg` points west.
- `phi`: latitude in radians.
- `lambda`: longitude in radians. Native code may wrap longitude to `[-pi, pi)`.
- `r`: geocentric radius in meters.

## Trajectory Artifact Conversion

The VTC state converts to a `trajectory.v0` artifact by:

1. Computing altitude `h_m = r_m - Re_m`.
2. Converting `lat_deg`, `lon_deg`, and `h_m` to WGS84 ECEF.
3. Rotating ECEF to ECI with the native simple GMST model at each `t_s`.
4. Computing `v_eci_kmps` by finite difference on `r_eci_km` unless an analytic conversion is supplied.

Finite-difference velocity must be recorded in artifact metadata.

## Clean-Room Boundary

Validators and converters must not call old-project helper functions. Legacy Stage02 is only a comparison oracle in integration tests or `src/+ttube/+legacy`.

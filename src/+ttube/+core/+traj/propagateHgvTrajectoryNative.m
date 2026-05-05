function artifact = propagateHgvTrajectoryNative(cfg)
%PROPAGATEHGVTRAJECTORYNATIVE Propagate a native geodetic/ECI HGV trajectory.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);
caseInfo = local_case_info(cfg);

params = local_params(cfg);
controlProfile = ttube.core.traj.makeHgvControlProfile(cfg, caseInfo);
atmosphereModel = ttube.core.traj.makeHgvAtmosphereModel(cfg);
aeroModel = ttube.core.traj.makeHgvAeroModel(cfg);
params.controlFcn = local_field(cfg, 'controlFcn', controlProfile.controlFcn);
params.atmosphereFcn = local_field(cfg, 'atmosphereFcn', atmosphereModel.atmosphereFcn);
params.aeroFcn = local_field(cfg, 'aeroFcn', aeroModel.aeroFcn);

t_s = (cfg.t0_s:cfg.Ts_s:cfg.Tmax_s).';
n = numel(t_s);
x = zeros(6, n);
x(:,1) = local_initial_state(caseInfo, cfg);
for k = 2:n
    dt = t_s(k) - t_s(k-1);
    x(:,k) = ttube.core.traj.rk4Step(cfg.dynamicsFcn, t_s(k-1), x(:,k-1), dt, params);
    altitudeKm = norm(x(1:3,k)) - cfg.earth_radius_km;
    if altitudeKm < cfg.h_min_km
        x = x(:,1:k);
        t_s = t_s(1:k);
        break;
    end
end

r_eci_km = x(1:3,:).';
v_eci_kmps = x(4:6,:).';
r0_surface = caseInfo.entry_point_eci_km_t0(:).';
r_enu_km = r_eci_km - r0_surface;
v_enu_kmps = v_eci_kmps;

artifact = struct();
artifact.schema_version = 'trajectory.v0';
artifact.trajectory_id = char(string(caseInfo.case_id));
artifact.family = char(string(caseInfo.family));
artifact.subfamily = char(string(caseInfo.subfamily));
artifact.epoch_utc = char(string(caseInfo.epoch_utc));
artifact.t_s = t_s(:);
artifact.r_eci_km = r_eci_km;
artifact.v_eci_kmps = v_eci_kmps;
artifact.frame_primary = 'ECI';
artifact.valid_mask = all(isfinite(r_eci_km), 2) & all(isfinite(v_eci_kmps), 2);
artifact.r_enu_km = r_enu_km;
artifact.v_enu_kmps = v_enu_kmps;
artifact.case_params = caseInfo;
artifact.backend = 'native_geodetic_eci_point_mass_vtc_inspired';
artifact.producer = 'ttube.core.traj.propagateHgvTrajectoryNative';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'native_cleanroom_stage02';
artifact.meta = struct();
artifact.meta.notes = ['Native Stage02 uses Stage01 geodetic/ECI initial conditions, ' ...
    'spherical ECI point-mass dynamics, and VTC-inspired control/aero/atmosphere modules. ' ...
    'It is improved partial parity, not bitwise legacy VTC parity.'];
artifact.meta.control_profile = rmfield(controlProfile, 'controlFcn');
ttube.core.traj.validateTrajectoryArtifact(artifact);
end

function cfg = local_defaults(cfg)
cfg.t0_s = local_field(cfg, 't0_s', 0);
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 120);
cfg.Ts_s = local_field(cfg, 'Ts_s', 2);
cfg.h0_km = local_field(cfg, 'h0_km', 50);
cfg.v0_kmps = local_field(cfg, 'v0_kmps', 5.5);
cfg.flight_path_deg = local_field(cfg, 'flight_path_deg', 0);
cfg.h_min_km = local_field(cfg, 'h_min_km', 15);
cfg.earth_radius_km = local_field(cfg, 'earth_radius_km', 6378.137);
cfg.case = local_field(cfg, 'case', struct());
cfg.dynamicsFcn = local_field(cfg, 'dynamicsFcn', @ttube.core.traj.hgvDynamicsPointMass);
end

function caseInfo = local_case_info(cfg)
if isfield(cfg.case, 'case_id')
    caseInfo = cfg.case;
else
    caseInfo = ttube.experiments.stage05.buildStage01CasebankNative(cfg);
end
end

function x0 = local_initial_state(caseInfo, cfg)
rSurface = caseInfo.entry_point_eci_km_t0(:);
radial = ttube.core.frames.normalizeVector(rSurface, 1);
r0 = rSurface + cfg.h0_km * radial;

heading = caseInfo.heading_unit_eci_t0(:);
heading = heading - dot(heading, radial) * radial;
heading = ttube.core.frames.normalizeVector(heading, 1);
gamma = deg2rad(cfg.flight_path_deg);
v0 = cfg.v0_kmps * (cos(gamma) * heading + sin(gamma) * radial);
x0 = [r0(:); v0(:)];
end

function params = local_params(cfg)
params = struct();
params.mass_kg = local_field(cfg, 'mass_kg', 907.2);
params.ref_area_m2 = local_field(cfg, 'ref_area_m2', 0.4839);
params.g0_mps2 = local_field(cfg, 'g0_mps2', 9.80665);
params.earth_radius_km = local_field(cfg, 'earth_radius_km', 6378.137);
params.mu_km3_s2 = local_field(cfg, 'mu_km3_s2', 398600.4418);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

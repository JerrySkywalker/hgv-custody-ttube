function artifact = propagateHgvTrajectoryNative(cfg)
%PROPAGATEHGVTRAJECTORYNATIVE Propagate a native flat-ENU HGV prototype.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);
caseInfo = local_case_info(cfg);

params = local_params(cfg);
params.controlFcn = cfg.controlFcn;
params.atmosphereFcn = cfg.atmosphereFcn;
params.aeroFcn = cfg.aeroFcn;

t_s = (cfg.t0_s:cfg.Ts_s:cfg.Tmax_s).';
n = numel(t_s);
x = zeros(6, n);
x(:,1) = local_initial_state(caseInfo, cfg);
for k = 2:n
    dt = t_s(k) - t_s(k-1);
    x(:,k) = ttube.core.traj.rk4Step(cfg.dynamicsFcn, t_s(k-1), x(:,k-1), dt, params);
    if x(3,k) < cfg.h_min_km
        x = x(:,1:k);
        t_s = t_s(1:k);
        break;
    end
end

r_enu_km = x(1:3,:).';
v_enu_kmps = x(4:6,:).';
anchor = [cfg.earth_radius_km, 0, 0];
r_eci_km = r_enu_km + anchor;
v_eci_kmps = v_enu_kmps;

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
artifact.backend = 'native_flat_enu_point_mass';
artifact.producer = 'ttube.core.traj.propagateHgvTrajectoryNative';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'native_cleanroom_stage02';
artifact.meta = struct();
artifact.meta.notes = ['Native Stage02 uses a simplified flat-ENU point-mass ' ...
    'prototype mapped to pseudo-ECI. It is not bitwise legacy VTC parity.'];
ttube.core.traj.validateTrajectoryArtifact(artifact);
end

function cfg = local_defaults(cfg)
cfg.t0_s = local_field(cfg, 't0_s', 0);
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 120);
cfg.Ts_s = local_field(cfg, 'Ts_s', 2);
cfg.h0_km = local_field(cfg, 'h0_km', 50);
cfg.v0_kmps = local_field(cfg, 'v0_kmps', 5.5);
cfg.flight_path_deg = local_field(cfg, 'flight_path_deg', -3);
cfg.h_min_km = local_field(cfg, 'h_min_km', 15);
cfg.earth_radius_km = local_field(cfg, 'earth_radius_km', 6378.137);
cfg.case = local_field(cfg, 'case', struct());
cfg.dynamicsFcn = local_field(cfg, 'dynamicsFcn', @ttube.core.traj.hgvDynamicsPointMass);
cfg.controlFcn = local_field(cfg, 'controlFcn', @local_default_control);
cfg.atmosphereFcn = local_field(cfg, 'atmosphereFcn', @local_default_atmosphere);
cfg.aeroFcn = local_field(cfg, 'aeroFcn', @local_default_aero);
end

function caseInfo = local_case_info(cfg)
if isfield(cfg.case, 'case_id')
    caseInfo = cfg.case;
else
    caseInfo = ttube.experiments.stage05.buildStage01CasebankNative(cfg);
end
end

function x0 = local_initial_state(caseInfo, cfg)
p0 = caseInfo.entry_point_enu_km(:);
heading = caseInfo.heading_unit_enu(:);
gamma = deg2rad(cfg.flight_path_deg);
horizontal = [heading(1); heading(2); 0];
horizontal = horizontal / max(norm(horizontal), eps);
v0 = cfg.v0_kmps * (cos(gamma) * horizontal + sin(gamma) * [0;0;1]);
x0 = [p0(1); p0(2); cfg.h0_km; v0(:)];
end

function params = local_params(cfg)
params = struct();
params.mass_kg = local_field(cfg, 'mass_kg', 907.2);
params.ref_area_m2 = local_field(cfg, 'ref_area_m2', 0.4839);
params.g0_mps2 = local_field(cfg, 'g0_mps2', 9.80665);
end

function control = local_default_control(~, ~, ~)
control = struct('alpha_rad', deg2rad(11.0), 'bank_rad', 0.0);
end

function rho = local_default_atmosphere(alt_m, ~)
rho0 = 1.225;
H_m = 7200;
rho = rho0 * exp(-max(alt_m, 0) / H_m);
end

function [CL, CD] = local_default_aero(speed_mps, ~, control, ~)
mach = speed_mps / 295;
alpha = control.alpha_rad;
CL = max(0, 0.0301 + 2.2992 * alpha + 1.2287 * alpha^2);
CD = max(0.01, 0.0100 - 0.1748 * alpha + 2.7247 * alpha^2 + 0.01 * mach);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

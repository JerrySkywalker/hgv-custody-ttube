function artifact = propagateHgvTrajectoryNativeVtc(cfg)
%PROPAGATEHGVTRAJECTORYNATIVEVTC Propagate HGV trajectory using native VTC state.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);
caseInfo = local_case_info(cfg);
params = local_params(cfg, caseInfo);

t_s = (cfg.t0_s:cfg.Ts_s:cfg.Tmax_s).';
n = numel(t_s);
X = zeros(n, 6);
X(1,:) = local_initial_state(caseInfo, cfg);
for k = 2:n
    dt = t_s(k) - t_s(k-1);
    X(k,:) = ttube.core.traj.rk4Step(@ttube.core.traj.hgvDynamicsVtc, ...
        t_s(k-1), X(k-1,:).', dt, params).';
    if local_should_stop(X(k,:), cfg)
        X = X(1:k,:);
        t_s = t_s(1:k);
        break;
    end
end

control = params.controlFcn(0, X(1,:).', params);
vtc = local_pack_vtc_state(caseInfo, cfg, X, t_s, control);
artifact = ttube.core.traj.vtcStateToTrajectoryArtifact(vtc, struct( ...
    'ellipsoid', struct('a_m', cfg.a_m, 'f', cfg.f, 'e2', cfg.e2), ...
    'backend', 'native_vtc'));
artifact.backend = 'native_vtc';
artifact.producer = 'ttube.core.traj.propagateHgvTrajectoryNativeVtc';
artifact.case_params = caseInfo;
artifact.meta.notes = ['Native Stage02 VTC candidate propagates [v,theta,sigma,phi,lambda,r] ' ...
    'with clean-room dynamics matched to the legacy public equations.'];
artifact.meta.control_profile = struct('alpha_rad', control.alpha_rad, 'bank_rad', control.bank_rad);
end

function cfg = local_defaults(cfg)
cfg.t0_s = local_field(cfg, 't0_s', 0);
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 120);
cfg.Ts_s = local_field(cfg, 'Ts_s', 2);
cfg.v0_mps = local_field(cfg, 'v0_mps', 5500);
cfg.h0_m = local_field(cfg, 'h0_m', 50000);
cfg.theta0_deg = local_field(cfg, 'theta0_deg', 0);
cfg.h_min_m = local_field(cfg, 'h_min_m', 15000);
cfg.h_max_m = local_field(cfg, 'h_max_m', 120000);
cfg.v_min_mps = local_field(cfg, 'v_min_mps', 1500);
cfg.v_max_mps = local_field(cfg, 'v_max_mps', 9000);
cfg.Re_m = local_field(cfg, 'Re_m', 6378137.0);
cfg.mu_m3_s2 = local_field(cfg, 'mu_m3_s2', 3.986e14);
cfg.g0_mps2 = local_field(cfg, 'g0_mps2', 9.80665);
cfg.mass_kg = local_field(cfg, 'mass_kg', 907.2);
cfg.ref_area_m2 = local_field(cfg, 'ref_area_m2', 0.4839);
cfg.a_m = local_field(cfg, 'a_m', 6378137.0);
cfg.f = local_field(cfg, 'f', 1 / 298.257223563);
cfg.e2 = local_field(cfg, 'e2', 2 * cfg.f - cfg.f^2);
cfg.case = local_field(cfg, 'case', struct());
end

function caseInfo = local_case_info(cfg)
if isfield(cfg.case, 'case_id')
    caseInfo = cfg.case;
else
    caseInfo = ttube.experiments.stage05.buildStage01CasebankNative(cfg);
end
end

function params = local_params(cfg, caseInfo)
control = ttube.core.traj.makeHgvControlProfile(cfg, caseInfo);
atmosphere = ttube.core.traj.makeHgvAtmosphereModel(cfg);
aero = ttube.core.traj.makeHgvAeroModel(cfg);
params = struct();
params.Re_m = cfg.Re_m;
params.mu_m3_s2 = cfg.mu_m3_s2;
params.g0_mps2 = cfg.g0_mps2;
params.mass_kg = cfg.mass_kg;
params.ref_area_m2 = cfg.ref_area_m2;
params.controlFcn = local_field(cfg, 'controlFcn', control.controlFcn);
params.atmosphereFcn = local_field(cfg, 'atmosphereFcn', atmosphere.atmosphereFcn);
params.aeroFcn = local_field(cfg, 'aeroFcn', aero.aeroFcn);
end

function X0 = local_initial_state(caseInfo, cfg)
if isfield(caseInfo, 'entry_lat_deg') && isfinite(caseInfo.entry_lat_deg)
    phi0 = deg2rad(caseInfo.entry_lat_deg);
elseif isfield(caseInfo, 'anchor_lat_deg')
    phi0 = deg2rad(caseInfo.anchor_lat_deg);
else
    phi0 = 0;
end

if isfield(caseInfo, 'entry_lon_deg') && isfinite(caseInfo.entry_lon_deg)
    lambda0 = deg2rad(caseInfo.entry_lon_deg);
elseif isfield(caseInfo, 'anchor_lon_deg')
    lambda0 = deg2rad(caseInfo.anchor_lon_deg);
else
    lambda0 = 0;
end

headingDeg = local_field(caseInfo, 'heading_deg', 180.0);
sigma0Deg = local_wrap_to_180(headingDeg - 90.0);
X0 = [cfg.v0_mps, deg2rad(cfg.theta0_deg), deg2rad(sigma0Deg), ...
    phi0, lambda0, cfg.Re_m + cfg.h0_m];
end

function tf = local_should_stop(X, cfg)
h = X(6) - cfg.Re_m;
v = X(1);
tf = h < cfg.h_min_m || h > cfg.h_max_m || v < cfg.v_min_mps || v > cfg.v_max_mps;
end

function vtc = local_pack_vtc_state(caseInfo, cfg, X, t_s, control)
vtc = struct();
vtc.schema_version = 'vtc_state.v0';
vtc.trajectory_id = char(string(local_field(caseInfo, 'case_id', 'N01')));
vtc.family = char(string(local_field(caseInfo, 'family', 'nominal')));
vtc.subfamily = char(string(local_field(caseInfo, 'subfamily', 'nominal')));
vtc.epoch_utc = char(string(local_field(caseInfo, 'epoch_utc', '2026-01-01 00:00:00')));
vtc.t_s = t_s(:);
vtc.X = X;
vtc.v_mps = X(:,1);
vtc.theta_rad = X(:,2);
vtc.sigma_rad = X(:,3);
vtc.phi_rad = X(:,4);
vtc.lambda_rad = local_wrap_to_pi(X(:,5));
vtc.r_m = X(:,6);
vtc.h_m = X(:,6) - cfg.Re_m;
vtc.h_km = vtc.h_m / 1000;
vtc.theta_deg = rad2deg(vtc.theta_rad);
vtc.sigma_deg = rad2deg(vtc.sigma_rad);
vtc.lat_deg = rad2deg(vtc.phi_rad);
vtc.lon_deg = rad2deg(vtc.lambda_rad);
vtc.alpha_rad = control.alpha_rad;
vtc.bank_rad = control.bank_rad;
vtc.meta = struct('state_order', '[v_mps, theta_rad, sigma_rad, phi_rad, lambda_rad, r_m]');
ttube.core.traj.validateVtcStateSeries(vtc);
end

function y = local_wrap_to_pi(x)
y = mod(x + pi, 2 * pi) - pi;
end

function y = local_wrap_to_180(x)
y = mod(x + 180, 360) - 180;
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

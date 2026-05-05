function ok = validateVtcStateSeries(vtc)
%VALIDATEVTCSTATESERIES Validate a native VTC state-series struct.

required = {'schema_version','trajectory_id','epoch_utc','t_s','X','v_mps', ...
    'theta_rad','sigma_rad','phi_rad','lambda_rad','r_m','h_m','h_km', ...
    'alpha_rad','bank_rad'};
for k = 1:numel(required)
    assert(isfield(vtc, required{k}), 'ttube:traj:InvalidVtcState', ...
        'Missing VTC field: %s', required{k});
end
assert(strcmp(char(string(vtc.schema_version)), 'vtc_state.v0'), ...
    'ttube:traj:InvalidVtcState', 'Unexpected VTC schema_version.');

t = vtc.t_s(:);
assert(~isempty(t) && all(isfinite(t)), 'ttube:traj:InvalidVtcState', ...
    't_s must be nonempty and finite.');
assert(all(diff(t) >= 0), 'ttube:traj:InvalidVtcState', ...
    't_s must be monotonic nondecreasing.');

nt = numel(t);
assert(isequal(size(vtc.X), [nt, 6]), 'ttube:traj:InvalidVtcState', ...
    'X must be Nt-by-6.');
assert(all(isfinite(vtc.X), 'all'), 'ttube:traj:InvalidVtcState', ...
    'X must be finite.');

local_check_vector(vtc.v_mps, nt, 'v_mps');
local_check_vector(vtc.theta_rad, nt, 'theta_rad');
local_check_vector(vtc.sigma_rad, nt, 'sigma_rad');
local_check_vector(vtc.phi_rad, nt, 'phi_rad');
local_check_vector(vtc.lambda_rad, nt, 'lambda_rad');
local_check_vector(vtc.r_m, nt, 'r_m');
local_check_vector(vtc.h_m, nt, 'h_m');
local_check_vector(vtc.h_km, nt, 'h_km');
local_check_scalar_or_vector(vtc.alpha_rad, nt, 'alpha_rad');
local_check_scalar_or_vector(vtc.bank_rad, nt, 'bank_rad');

assert(all(vtc.v_mps(:) > 0), 'ttube:traj:InvalidVtcState', ...
    'v_mps must be positive.');
assert(all(vtc.r_m(:) > 0), 'ttube:traj:InvalidVtcState', ...
    'r_m must be positive.');

ok = true;
end

function local_check_vector(v, nt, name)
assert(isnumeric(v), 'ttube:traj:InvalidVtcState', '%s must be numeric.', name);
assert(numel(v) == nt, 'ttube:traj:InvalidVtcState', ...
    '%s must have one value per time sample.', name);
assert(all(isfinite(v(:))), 'ttube:traj:InvalidVtcState', ...
    '%s must be finite.', name);
end

function local_check_scalar_or_vector(v, nt, name)
assert(isnumeric(v), 'ttube:traj:InvalidVtcState', '%s must be numeric.', name);
assert(isscalar(v) || numel(v) == nt, 'ttube:traj:InvalidVtcState', ...
    '%s must be scalar or have one value per time sample.', name);
assert(all(isfinite(v(:))), 'ttube:traj:InvalidVtcState', ...
    '%s must be finite.', name);
end

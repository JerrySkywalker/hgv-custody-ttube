function ok = validateTrajectoryArtifact(a)
%VALIDATETRAJECTORYARTIFACT Validate the trajectory artifact contract.

required = {'schema_version','trajectory_id','family','subfamily', ...
    'epoch_utc','t_s','r_eci_km','v_eci_kmps','frame_primary','valid_mask'};
local_require_fields(a, required, 'ttube:traj:MissingField');

t = a.t_s;
assert(isnumeric(t) && iscolumn(t) && ~isempty(t), ...
    'ttube:traj:InvalidTime', 't_s must be a non-empty numeric column vector.');
assert(all(isfinite(t)) && all(diff(t) >= 0), ...
    'ttube:traj:InvalidTime', 't_s must be finite and monotonic nondecreasing.');

n = numel(t);
local_require_matrix(a.r_eci_km, n, 3, 'r_eci_km', 'ttube:traj:InvalidPosition');
local_require_matrix(a.v_eci_kmps, n, 3, 'v_eci_kmps', 'ttube:traj:InvalidVelocity');

assert(islogical(a.valid_mask) && iscolumn(a.valid_mask) && numel(a.valid_mask) == n, ...
    'ttube:traj:InvalidMask', 'valid_mask must be an Nt-by-1 logical vector.');

ok = true;
end

function local_require_fields(s, names, id)
assert(isstruct(s) && isscalar(s), id, 'Artifact must be a scalar struct.');
for k = 1:numel(names)
    assert(isfield(s, names{k}), id, 'Missing required field: %s', names{k});
end
end

function local_require_matrix(x, nrow, ncol, label, id)
assert(isnumeric(x) && ismatrix(x) && size(x,1) == nrow && size(x,2) == ncol, ...
    id, '%s must be an Nt-by-%d numeric matrix.', label, ncol);
assert(all(isfinite(x), 'all'), id, '%s must contain finite values.', label);
end

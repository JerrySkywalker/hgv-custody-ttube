function ok = validateAccessArtifact(a)
%VALIDATEACCESSARTIFACT Validate the access artifact contract.

required = {'schema_version','access_id','trajectory_id','constellation_id', ...
    'sensor_model_id','epoch_utc','t_s','access_mask','num_visible','dual_coverage_mask'};
local_require_fields(a, required, 'tpipe:visibility:MissingField');

t = a.t_s;
assert(isnumeric(t) && iscolumn(t) && ~isempty(t), ...
    'tpipe:visibility:InvalidTime', 't_s must be a non-empty numeric column vector.');
assert(all(isfinite(t)) && all(diff(t) >= 0), ...
    'tpipe:visibility:InvalidTime', 't_s must be finite and monotonic nondecreasing.');

nt = numel(t);
assert(islogical(a.access_mask) && ismatrix(a.access_mask) && size(a.access_mask,1) == nt, ...
    'tpipe:visibility:InvalidAccessMask', 'access_mask must be Nt-by-Ns logical.');

ns = size(a.access_mask, 2);
assert(ns >= 1, 'tpipe:visibility:InvalidAccessMask', 'access_mask must have at least one satellite column.');
assert(isnumeric(a.num_visible) && iscolumn(a.num_visible) && numel(a.num_visible) == nt, ...
    'tpipe:visibility:InvalidVisibleCount', 'num_visible must be Nt-by-1 numeric.');
assert(islogical(a.dual_coverage_mask) && iscolumn(a.dual_coverage_mask) && ...
    numel(a.dual_coverage_mask) == nt, ...
    'tpipe:visibility:InvalidDualCoverage', 'dual_coverage_mask must be Nt-by-1 logical.');

ok = true;
end

function local_require_fields(s, names, id)
assert(isstruct(s) && isscalar(s), id, 'Artifact must be a scalar struct.');
for k = 1:numel(names)
    assert(isfield(s, names{k}), id, 'Missing required field: %s', names{k});
end
end

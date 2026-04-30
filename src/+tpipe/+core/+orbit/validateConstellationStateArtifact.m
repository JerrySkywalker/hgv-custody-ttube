function ok = validateConstellationStateArtifact(a)
%VALIDATECONSTELLATIONSTATEARTIFACT Validate the constellation state contract.

required = {'schema_version','constellation_id','epoch_utc','t_s','sat_id', ...
    'plane_index','sat_index_in_plane','r_eci_km','v_eci_kmps','walker'};
local_require_fields(a, required, 'tpipe:orbit:MissingField');

t = a.t_s;
assert(isnumeric(t) && iscolumn(t) && ~isempty(t), ...
    'tpipe:orbit:InvalidTime', 't_s must be a non-empty numeric column vector.');
assert(all(isfinite(t)) && all(diff(t) >= 0), ...
    'tpipe:orbit:InvalidTime', 't_s must be finite and monotonic nondecreasing.');

ns = numel(a.sat_id);
nt = numel(t);
assert(ns >= 1, 'tpipe:orbit:InvalidSatId', 'sat_id must contain at least one satellite.');
assert(numel(a.plane_index) == ns && numel(a.sat_index_in_plane) == ns, ...
    'tpipe:orbit:InvalidIndex', 'plane and satellite indices must match sat_id length.');

local_require_state_array(a.r_eci_km, nt, ns, 'r_eci_km');
local_require_state_array(a.v_eci_kmps, nt, ns, 'v_eci_kmps');
assert(isstruct(a.walker), 'tpipe:orbit:InvalidWalker', 'walker must be a struct.');

ok = true;
end

function local_require_fields(s, names, id)
assert(isstruct(s) && isscalar(s), id, 'Artifact must be a scalar struct.');
for k = 1:numel(names)
    assert(isfield(s, names{k}), id, 'Missing required field: %s', names{k});
end
end

function local_require_state_array(x, nt, ns, label)
assert(isnumeric(x) && ndims(x) == 3 && size(x,1) == nt && ...
    size(x,2) == ns && size(x,3) == 3, ...
    'tpipe:orbit:InvalidStateArray', '%s must be Nt-by-Ns-by-3.', label);
assert(all(isfinite(x), 'all'), ...
    'tpipe:orbit:InvalidStateArray', '%s must contain finite values.', label);
end

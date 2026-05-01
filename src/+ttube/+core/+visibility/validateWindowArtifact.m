function ok = validateWindowArtifact(a)
%VALIDATEWINDOWARTIFACT Validate the window artifact contract.

required = {'schema_version','window_id','access_id','Tw_s','step_s', ...
    'start_idx','end_idx','t0_s','t1_s'};
local_require_fields(a, required, 'ttube:visibility:MissingField');

assert(isnumeric(a.Tw_s) && isscalar(a.Tw_s) && isfinite(a.Tw_s) && a.Tw_s > 0, ...
    'ttube:visibility:InvalidWindowDuration', 'Tw_s must be a positive finite scalar.');
assert(isnumeric(a.step_s) && isscalar(a.step_s) && isfinite(a.step_s) && a.step_s > 0, ...
    'ttube:visibility:InvalidWindowStep', 'step_s must be a positive finite scalar.');

nw = numel(a.start_idx);
assert(nw >= 1, 'ttube:visibility:InvalidWindowIndex', 'At least one window is required.');
local_require_column(a.start_idx, nw, 'start_idx');
local_require_column(a.end_idx, nw, 'end_idx');
local_require_column(a.t0_s, nw, 't0_s');
local_require_column(a.t1_s, nw, 't1_s');

assert(all(a.start_idx >= 1) && all(a.end_idx >= a.start_idx), ...
    'ttube:visibility:InvalidWindowIndex', 'Window indices must be positive and ordered.');
assert(all(a.t1_s >= a.t0_s), ...
    'ttube:visibility:InvalidWindowTime', 'Window times must be ordered.');

ok = true;
end

function local_require_fields(s, names, id)
assert(isstruct(s) && isscalar(s), id, 'Artifact must be a scalar struct.');
for k = 1:numel(names)
    assert(isfield(s, names{k}), id, 'Missing required field: %s', names{k});
end
end

function local_require_column(x, n, label)
assert(isnumeric(x) && iscolumn(x) && numel(x) == n && all(isfinite(x)), ...
    'ttube:visibility:InvalidWindowVector', '%s must be a finite numeric column vector.', label);
end

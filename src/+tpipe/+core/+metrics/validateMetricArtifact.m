function ok = validateMetricArtifact(a)
%VALIDATEMETRICARTIFACT Validate the metric artifact contract.

required = {'schema_version','metric_id','source_artifact_ids','thresholds', ...
    'case_metrics','robust_metrics','pass_ratio','failure_tags'};
local_require_fields(a, required, 'tpipe:metrics:MissingField');

assert(isstruct(a.thresholds), ...
    'tpipe:metrics:InvalidThresholds', 'thresholds must be a struct.');
assert(isstruct(a.case_metrics), ...
    'tpipe:metrics:InvalidCaseMetrics', 'case_metrics must be a struct array.');
assert(isstruct(a.robust_metrics), ...
    'tpipe:metrics:InvalidRobustMetrics', 'robust_metrics must be a struct.');
assert(isnumeric(a.pass_ratio) && isscalar(a.pass_ratio) && isfinite(a.pass_ratio) && ...
    a.pass_ratio >= 0 && a.pass_ratio <= 1, ...
    'tpipe:metrics:InvalidPassRatio', 'pass_ratio must be a scalar fraction in [0, 1].');

ok = true;
end

function local_require_fields(s, names, id)
assert(isstruct(s) && isscalar(s), id, 'Artifact must be a scalar struct.');
for k = 1:numel(names)
    assert(isfield(s, names{k}), id, 'Missing required field: %s', names{k});
end
end

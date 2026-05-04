function result = computeDTProduction(supportMask, t_s, requirement_s)
%COMPUTEDTPRODUCTION Interface-ready DT based on support-mask gaps.

if nargin < 3
    error('ttube:metrics:BackendNotImplemented', ...
        'DT production Stage09 contract is not aligned; provide synthetic support inputs only.');
end
gap = ttube.core.metrics.summarizeGapSegments(t_s(:), logical(supportMask(:)));
value = requirement_s - gap.max_gap_s;
[margin, feasible] = ttube.core.metrics.computeRequirementMargin( ...
    max(value, 0), requirement_s, 'higher_is_better');
result = struct();
result.metric_name = 'DT';
result.value = value;
result.requirement = requirement_s;
result.margin = margin;
result.feasible = feasible;
result.failure_tag = string('T');
if feasible
    result.failure_tag = string('OK');
end
result.gap_summary = gap;
result.production_alignment = 'interface_ready_support_mask_not_stage09_aligned';
end

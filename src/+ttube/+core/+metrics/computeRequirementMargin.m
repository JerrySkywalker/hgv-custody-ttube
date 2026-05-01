function [result_margin, feasible] = computeRequirementMargin(value, requirement, mode)
%COMPUTEREQUIREMENTMARGIN Normalize metric values against requirements.
%
% This Batch 2 primitive is a generic toy margin helper. It does not
% compute production DG, DA, or DT.

local_validate_value(value);
local_validate_requirement(requirement);

mode_char = local_normalize_mode(mode);
if ~isscalar(value) && ~isscalar(requirement) && ~isequal(size(value), size(requirement))
    error('ttube:metrics:InvalidRequirement', ...
        'requirement must be a scalar or the same size as value.');
end

switch mode_char
    case 'higher_is_better'
        result_margin = value ./ requirement;
    case 'lower_is_better'
        assert(all(value(:) > 0), ...
            'ttube:metrics:InvalidMetricValue', ...
            'value must be positive for lower_is_better mode.');
        result_margin = requirement ./ value;
    otherwise
        error('ttube:metrics:InvalidMarginMode', ...
            'mode must be higher_is_better or lower_is_better.');
end

feasible = result_margin >= 1;
end

function local_validate_value(value)
assert(isnumeric(value) && ~isempty(value) && all(isfinite(value(:))), ...
    'ttube:metrics:InvalidMetricValue', ...
    'value must be a non-empty finite numeric scalar or array.');
end

function local_validate_requirement(requirement)
assert(isnumeric(requirement) && ~isempty(requirement) && ...
    all(isfinite(requirement(:))) && all(requirement(:) > 0), ...
    'ttube:metrics:InvalidRequirement', ...
    'requirement must be a positive finite numeric scalar or array.');
end

function mode_char = local_normalize_mode(mode)
if isstring(mode)
    assert(isscalar(mode), ...
        'ttube:metrics:InvalidMarginMode', ...
        'mode must be a character vector or scalar string.');
    mode_char = char(mode);
elseif ischar(mode)
    mode_char = mode;
else
    error('ttube:metrics:InvalidMarginMode', ...
        'mode must be a character vector or scalar string.');
end
end

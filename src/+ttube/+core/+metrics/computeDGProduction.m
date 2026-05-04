function result = computeDGProduction(input, gamma_req)
%COMPUTEDGPRODUCTION Compute Stage05-aligned DG = lambda_min / gamma_req.

if isstruct(input)
    if isfield(input, 'lambda_min')
        lambda = input.lambda_min;
    elseif isfield(input, 'lambda_worst')
        lambda = input.lambda_worst;
    elseif isfield(input, 'info_matrix')
        lambda = local_lambda_from_info(input.info_matrix);
    else
        error('ttube:metrics:InvalidMetricInput', ...
            'DG input requires lambda_min, lambda_worst, or info_matrix.');
    end
else
    lambda = input;
end

[margin, feasible] = ttube.core.metrics.computeRequirementMargin(lambda, gamma_req, 'higher_is_better');
result = struct();
result.metric_name = 'DG';
result.value = lambda;
result.requirement = gamma_req;
result.margin = margin;
result.feasible = feasible;
result.failure_tag = local_failure_tag(feasible, 'G');
result.direction = 'higher_is_better';
result.production_alignment = 'stage04_05_lambda_min_over_gamma_req';
end

function lambda = local_lambda_from_info(info)
assert(isnumeric(info) && ndims(info) == 3 && size(info,1) == size(info,2), ...
    'ttube:metrics:InvalidMetricInput', 'info_matrix must be Nx-by-Nx-by-Nw.');
nw = size(info, 3);
lambda = zeros(nw, 1);
for k = 1:nw
    W = 0.5 * (info(:,:,k) + info(:,:,k).');
    lambda(k) = max(min(real(eig(W))), 0);
end
end

function tags = local_failure_tag(feasible, failTag)
tags = strings(size(feasible));
tags(:) = "OK";
tags(~feasible) = string(failTag);
end

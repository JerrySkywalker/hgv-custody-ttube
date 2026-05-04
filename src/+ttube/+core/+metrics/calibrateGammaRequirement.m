function gamma = calibrateGammaRequirement(lambdaValues, cfg)
%CALIBRATEGAMMAREQUIREMENT Calibrate gamma_req for DG from lambda samples.

if nargin < 2
    cfg = struct();
end
mode = 'fixed';
if isfield(cfg, 'mode')
    mode = char(string(cfg.mode));
end
floorValue = 1.0;
if isfield(cfg, 'gamma_floor')
    floorValue = cfg.gamma_floor;
end

gamma = struct();
gamma.mode = mode;
gamma.gamma_floor = floorValue;
gamma.sample_size = nnz(isfinite(lambdaValues(:)));
gamma.sample_min = min(lambdaValues(:), [], 'omitnan');
gamma.sample_median = median(lambdaValues(:), 'omitnan');
gamma.sample_max = max(lambdaValues(:), [], 'omitnan');

switch mode
    case 'fixed'
        gamma.gamma_req = local_field(cfg, 'gamma_req_fixed', 1.0);
        gamma.source_family = 'fixed';
        gamma.quantile = NaN;
    case 'nominal_quantile'
        q = local_field(cfg, 'gamma_quantile', 0.50);
        vals = lambdaValues(isfinite(lambdaValues));
        assert(~isempty(vals), 'ttube:metrics:InvalidRequirement', ...
            'lambdaValues must contain finite samples for quantile calibration.');
        gamma.gamma_req = max(quantile(vals, q), floorValue);
        gamma.source_family = 'nominal';
        gamma.quantile = q;
    otherwise
        error('ttube:metrics:BackendNotImplemented', ...
            'Unsupported gamma calibration mode: %s', mode);
end
gamma.gamma_req = max(gamma.gamma_req, floorValue);
end

function v = local_field(s, f, defaultValue)
if isfield(s, f)
    v = s.(f);
else
    v = defaultValue;
end
end

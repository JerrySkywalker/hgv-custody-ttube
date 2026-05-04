function result = buildWindowInformationMatrixNative(accessArtifact, constellation, windowArtifact, cfg)
%BUILDWINDOWINFORMATIONMATRIXNATIVE Native LOS angle-information windows.

if nargin < 4
    cfg = struct();
end
cfg = local_defaults(cfg);

nw = numel(windowArtifact.start_idx);
info = zeros(3, 3, nw);
lambda_min = zeros(nw, 1);
trace_wr = zeros(nw, 1);

for w = 1:nw
    Wr = zeros(3,3);
    for k = windowArtifact.start_idx(w):windowArtifact.end_idx(w)
        visible = accessArtifact.access_mask(k, :);
        if ~any(visible)
            continue;
        end
        rTgt = accessArtifact.r_tgt_eci_km(k, :);
        rSat = squeeze(constellation.r_eci_km(k, visible, :));
        if isvector(rSat)
            rSat = reshape(rSat, 1, 3);
        end
        Wr = Wr + local_accumulate_los_info(rSat, rTgt, cfg.sigma_angle_rad^2, cfg.eps_reg);
    end
    Wr = 0.5 * (Wr + Wr.');
    info(:,:,w) = Wr;
    ev = eig(Wr);
    lambda_min(w) = max(min(real(ev)), 0);
    trace_wr(w) = trace(Wr);
end

result = struct();
result.schema_version = 'window_information.v0';
result.window_id = windowArtifact.window_id;
result.info_matrix = info;
result.lambda_min = lambda_min;
result.lambda_worst = min(lambda_min);
result.trace_Wr = trace_wr;
result.idx_worst = find(lambda_min == min(lambda_min), 1, 'first');
result.backend = 'native_los_angle_information';
result.producer = 'ttube.core.estimation.buildWindowInformationMatrixNative';
result.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
result.source_fingerprint = 'native_cleanroom_stage04_info';
end

function Wr = local_accumulate_los_info(rSat, rTgt, sigma2, epsReg)
if isempty(rSat)
    Wr = zeros(3,3);
    return;
end
los = rSat - rTgt;
rho2 = sum(los.^2, 2);
valid = isfinite(rho2) & rho2 > 0;
if ~any(valid)
    Wr = zeros(3,3);
    return;
end
los = los(valid, :);
rho2 = rho2(valid);
alpha = 1 ./ (sigma2 * rho2 + epsReg);
beta = alpha ./ rho2;
Wr = sum(alpha) * eye(3) - los.' * (los .* beta);
end

function cfg = local_defaults(cfg)
cfg.sigma_angle_rad = local_field(cfg, 'sigma_angle_rad', deg2rad(5 / 3600));
cfg.eps_reg = local_field(cfg, 'eps_reg', 1e-12);
if isfield(cfg, 'stage04')
    cfg.sigma_angle_rad = local_field(cfg.stage04, 'sigma_angle_rad', cfg.sigma_angle_rad);
    cfg.eps_reg = local_field(cfg.stage04, 'eps_reg', cfg.eps_reg);
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

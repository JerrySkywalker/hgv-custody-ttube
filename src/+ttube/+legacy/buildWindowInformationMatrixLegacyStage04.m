function result = buildWindowInformationMatrixLegacyStage04(accessArtifact, constellation, windowArtifact, cfg)
%BUILDWINDOWINFORMATIONMATRIXLEGACYSTAGE04 Legacy comparison adapter.

cleanupObj = ttube.legacy.withLegacyPath(cfg.legacyRoot); %#ok<NASGU>
legacyCfg = ttube.legacy.loadDefaultParams(cfg.legacyRoot, local_stage04_overrides(cfg, windowArtifact));
vis_case = local_legacy_vis_case(accessArtifact);
satbank = local_legacy_satbank(constellation);

nw = numel(windowArtifact.start_idx);
info = zeros(3, 3, nw);
lambda_min = zeros(nw, 1);
for w = 1:nw
    Wr = build_window_info_matrix_stage04(vis_case, ...
        windowArtifact.start_idx(w), windowArtifact.end_idx(w), satbank, legacyCfg);
    Wr = 0.5 * (Wr + Wr.');
    ev = eig(Wr);
    info(:, :, w) = Wr;
    lambda_min(w) = max(min(real(ev)), 0);
end

result = struct();
result.schema_version = 'window_information.v0';
result.window_id = windowArtifact.window_id;
result.info_matrix = info;
result.lambda_min = lambda_min;
result.lambda_worst = min(lambda_min);
result.idx_worst = find(lambda_min == min(lambda_min), 1, 'first');
result.backend = 'legacy_stage04';
result.producer = 'ttube.legacy.buildWindowInformationMatrixLegacyStage04';
result.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
result.source_fingerprint = 'legacy_function:build_window_info_matrix_stage04';
end

function overrides = local_stage04_overrides(cfg, windowArtifact)
overrides = struct();
overrides.stage04 = struct('Tw_s', windowArtifact.Tw_s, 'window_step_s', windowArtifact.step_s);
if isfield(cfg, 'stage04')
    names = fieldnames(cfg.stage04);
    for k = 1:numel(names)
        overrides.stage04.(names{k}) = cfg.stage04.(names{k});
    end
end
end

function vis_case = local_legacy_vis_case(accessArtifact)
vis_case = struct();
vis_case.case_id = char(string(accessArtifact.trajectory_id));
vis_case.family = '';
vis_case.subfamily = '';
vis_case.t_s = accessArtifact.t_s(:);
vis_case.visible_mask = logical(accessArtifact.access_mask);
vis_case.num_visible = accessArtifact.num_visible(:);
vis_case.dual_coverage_mask = logical(accessArtifact.dual_coverage_mask(:));
vis_case.r_tgt_eci_km = accessArtifact.r_tgt_eci_km;
end

function satbank = local_legacy_satbank(constellation)
satbank = struct();
satbank.t_s = constellation.t_s(:);
satbank.r_eci_km = permute(constellation.r_eci_km, [1 3 2]);
satbank.Ns = numel(constellation.sat_id);
satbank.walker = constellation.walker;
end

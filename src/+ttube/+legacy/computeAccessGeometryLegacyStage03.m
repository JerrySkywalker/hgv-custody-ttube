function artifact = computeAccessGeometryLegacyStage03(trajectory, constellation, cfg)
%COMPUTEACCESSGEOMETRYLEGACYSTAGE03 Legacy comparison adapter.

cleanupObj = ttube.legacy.withLegacyPath(cfg.legacyRoot); %#ok<NASGU>
legacyCfg = ttube.legacy.loadDefaultParams(cfg.legacyRoot, local_stage03_overrides(cfg));
trajCase = local_legacy_traj_case(trajectory);
satbank = local_legacy_satbank(constellation);
vis_case = compute_visibility_matrix_stage03(trajCase, satbank, legacyCfg);

artifact = struct();
artifact.schema_version = 'access.v0';
artifact.access_id = sprintf('%s__%s__legacy_stage03', ...
    char(string(trajectory.trajectory_id)), char(string(constellation.constellation_id)));
artifact.trajectory_id = char(string(trajectory.trajectory_id));
artifact.constellation_id = char(string(constellation.constellation_id));
artifact.sensor_model_id = 'legacy_stage03_range_occlusion_offnadir';
artifact.epoch_utc = trajectory.epoch_utc;
artifact.t_s = vis_case.t_s(:);
artifact.access_mask = logical(vis_case.visible_mask);
artifact.num_visible = vis_case.num_visible(:);
artifact.dual_coverage_mask = logical(vis_case.dual_coverage_mask(:));
artifact.r_tgt_eci_km = vis_case.r_tgt_eci_km;
artifact.backend = 'legacy_stage03';
artifact.producer = 'ttube.legacy.computeAccessGeometryLegacyStage03';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'legacy_function:compute_visibility_matrix_stage03';
ttube.core.visibility.validateAccessArtifact(artifact);
end

function overrides = local_stage03_overrides(cfg)
overrides = struct();
if isfield(cfg, 'sensor')
    overrides.stage03 = cfg.sensor;
end
end

function trajCase = local_legacy_traj_case(trajectory)
traj = struct();
traj.case_id = char(string(trajectory.trajectory_id));
traj.family = char(string(trajectory.family));
traj.subfamily = char(string(trajectory.subfamily));
traj.t_s = trajectory.t_s(:);
traj.r_eci_km = trajectory.r_eci_km;
traj.epoch_utc = char(string(trajectory.epoch_utc));

case_i = struct();
case_i.case_id = traj.case_id;
case_i.family = traj.family;
case_i.subfamily = traj.subfamily;

trajCase = struct('case', case_i, 'traj', traj);
end

function satbank = local_legacy_satbank(constellation)
satbank = struct();
satbank.t_s = constellation.t_s(:);
satbank.r_eci_km = permute(constellation.r_eci_km, [1 3 2]);
satbank.Ns = numel(constellation.sat_id);
satbank.walker = constellation.walker;
end

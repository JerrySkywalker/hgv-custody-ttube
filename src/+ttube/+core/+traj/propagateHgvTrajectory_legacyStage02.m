function artifact = propagateHgvTrajectory_legacyStage02(cfg)
%PROPAGATEHGVTRAJECTORY_LEGACYSTAGE02 Adapt legacy Stage02 HGV output.

legacyRoot = cfg.legacyRoot;
caseId = char(string(cfg.caseId));

if isfield(cfg, 'legacyRecord')
    rec = cfg.legacyRecord;
    legacyTraj = rec.traj;
    legacyCase = rec.case;
else
    overrides = struct();
    if isfield(cfg, 'legacyOverrides')
        overrides = cfg.legacyOverrides;
    end
    cleanupObj = ttube.legacy.withLegacyPath(legacyRoot); %#ok<NASGU>
    legacyCfg = ttube.legacy.loadDefaultParams(legacyRoot, overrides);
    casebank = build_casebank_stage01(legacyCfg, struct('mode', 'serial'));
    legacyCase = ttube.legacy.selectCaseById(casebank, caseId);
    legacyTraj = propagate_hgv_case_stage02(legacyCase, legacyCfg, []);
end

artifact = local_convert(legacyTraj, legacyCase);
ttube.core.traj.validateTrajectoryArtifact(artifact);
end

function artifact = local_convert(traj, case_i)
t_s = traj.t_s(:);
r_eci_km = traj.r_eci_km;
if size(r_eci_km, 2) ~= 3
    r_eci_km = r_eci_km.';
end
v_eci_kmps = ttube.legacy.finiteDifferenceVelocity(t_s, r_eci_km);

artifact = struct();
artifact.schema_version = 'trajectory.v0';
artifact.trajectory_id = char(string(traj.case_id));
artifact.family = char(string(traj.family));
artifact.subfamily = char(string(traj.subfamily));
artifact.epoch_utc = char(string(traj.epoch_utc));
artifact.t_s = t_s;
artifact.r_eci_km = r_eci_km;
artifact.v_eci_kmps = v_eci_kmps;
artifact.frame_primary = 'ECI';
artifact.valid_mask = isfinite(t_s) & all(isfinite(r_eci_km), 2);
artifact.case_params = case_i;
artifact.meta = struct('notes', ...
    'v_eci_kmps derived by finite differences from legacy Stage02 r_eci_km.');
artifact.backend = 'legacy_stage02';
artifact.producer = 'ttube.core.traj.propagateHgvTrajectory_legacyStage02';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'legacy_function:propagate_hgv_case_stage02';
end

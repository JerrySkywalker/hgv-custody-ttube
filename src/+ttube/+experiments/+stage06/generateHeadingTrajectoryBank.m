function bank = generateHeadingTrajectoryBank(cfg, family)
%GENERATEHEADINGTRAJECTORYBANK Propagate native VTC trajectories for heading cases.

cfg = ttube.experiments.stage06.makeStage06Config(cfg);
if nargin < 2 || isempty(family)
    family = ttube.experiments.stage06.buildHeadingFamily(cfg);
end
n = numel(family.cases);
trajectories = cell(n, 1);
ids = strings(n, 1);
for k = 1:n
    traj = ttube.core.traj.propagateHgvTrajectory(struct( ...
        'backend', cfg.trajectoryBackend, 'case', family.cases(k), ...
        'Tmax_s', cfg.Tmax_s, 'Ts_s', cfg.Ts_s));
    trajectories{k} = traj;
    ids(k) = string(traj.trajectory_id);
    ttube.core.traj.validateTrajectoryArtifact(traj);
end
family.trajectory_ids = ids;
bank = struct();
bank.schema_version = 'stage06_heading_trajectory_bank.v0';
bank.family = family;
bank.trajectories = trajectories;
bank.trajectory_ids = ids;
bank.backend = cfg.trajectoryBackend;
bank.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

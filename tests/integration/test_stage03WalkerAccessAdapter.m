function tests = test_stage03WalkerAccessAdapter
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testWalkerAndAccessAdapters(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
traj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'backend', 'legacy_stage02', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
walker = ttube.core.orbit.buildWalkerConstellation(struct( ...
    'legacyRoot', legacyRoot, 'h_km', 1000, 'i_deg', 70, 'P', 2, 'T', 2, 'F', 1));
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, traj.t_s, ...
    struct('legacyRoot', legacyRoot, 'epoch_utc', traj.epoch_utc));
verifyTrue(testCase, ttube.core.orbit.validateConstellationStateArtifact(constellation));
access = ttube.core.sensor.computeAccessGeometry(traj, constellation, ...
    struct('legacyRoot', legacyRoot));
verifyTrue(testCase, ttube.core.visibility.validateAccessArtifact(access));
verifySize(testCase, access.access_mask, [numel(access.t_s), numel(constellation.sat_id)]);
end

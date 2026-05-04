function tests = test_stage02HgvTrajectoryAdapter
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testLegacyStage02Adapter(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
artifact = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'backend', 'legacy_stage02', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(artifact));
verifyTrue(testCase, all(diff(artifact.t_s) >= 0));
verifySize(testCase, artifact.r_eci_km, [numel(artifact.t_s), 3]);
verifySize(testCase, artifact.v_eci_kmps, [numel(artifact.t_s), 3]);
end

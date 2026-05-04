function tests = test_stage03AccessNativeVsLegacy
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeAccessAgainstLegacyHelper(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
traj = ttube.legacy.propagateHgvTrajectoryLegacyStage02(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
walker = ttube.legacy.buildWalkerConstellationLegacyStage03(struct( ...
    'legacyRoot', legacyRoot, 'h_km', 1000, 'i_deg', 70, 'P', 2, 'T', 2, 'F', 1));
const = ttube.legacy.propagateWalkerConstellationLegacyStage03(walker, traj.t_s, ...
    struct('legacyRoot', legacyRoot, 'epoch_utc', traj.epoch_utc));
native = ttube.core.sensor.computeAccessGeometry(traj, const, struct('backend','native'));
legacy = ttube.legacy.computeAccessGeometryLegacyStage03(traj, const, struct('legacyRoot', legacyRoot));
verifyEqual(testCase, size(native.access_mask), size(legacy.access_mask));
verifyEqual(testCase, sum(native.access_mask, 'all'), sum(legacy.access_mask, 'all'));
verifyEqual(testCase, mean(native.dual_coverage_mask), mean(legacy.dual_coverage_mask), 'AbsTol', 0.25);
end

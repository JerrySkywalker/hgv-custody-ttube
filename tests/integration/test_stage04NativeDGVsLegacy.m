function tests = test_stage04NativeDGVsLegacy
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeWindowInfoAgainstLegacyHelper(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
[access, constellation] = local_fixture(legacyRoot);
window = ttube.core.visibility.buildWindowGrid(access, 20, 10);
native = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, struct('backend','native'));
legacy = ttube.legacy.buildWindowInformationMatrixLegacyStage04(access, constellation, window, ...
    struct('legacyRoot', legacyRoot));
verifySize(testCase, native.info_matrix, size(legacy.info_matrix));
verifyEqual(testCase, native.lambda_min, legacy.lambda_min, 'AbsTol', 1e-10);
dg = ttube.core.metrics.computeDGProduction(native.lambda_worst, 1.0);
verifyTrue(testCase, isfinite(dg.margin));
end

function [access, constellation] = local_fixture(legacyRoot)
traj = ttube.legacy.propagateHgvTrajectoryLegacyStage02(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
walker = ttube.legacy.buildWalkerConstellationLegacyStage03(struct( ...
    'legacyRoot', legacyRoot, 'h_km', 1000, 'i_deg', 70, 'P', 2, 'T', 2, 'F', 1));
constellation = ttube.legacy.propagateWalkerConstellationLegacyStage03(walker, traj.t_s, ...
    struct('legacyRoot', legacyRoot, 'epoch_utc', traj.epoch_utc));
access = ttube.legacy.computeAccessGeometryLegacyStage03(traj, constellation, ...
    struct('legacyRoot', legacyRoot));
end

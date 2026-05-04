function tests = test_stage04WindowInfoGammaAdapter
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testWindowInfoGamma(testCase)
[access, constellation] = local_access_fixture(testCase);
window = ttube.core.visibility.buildWindowGrid(access, 20, 10);
verifyTrue(testCase, ttube.core.visibility.validateWindowArtifact(window));
info = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, ...
    struct('legacyRoot', ttube.legacy.defaultLegacyRoot()));
verifySize(testCase, info.info_matrix, [3, 3, numel(window.start_idx)]);
verifyTrue(testCase, all(isfinite(info.lambda_min)));
gamma = ttube.core.metrics.calibrateGammaRequirement(info.lambda_min, ...
    struct('mode', 'fixed', 'gamma_req_fixed', 1.0));
verifyEqual(testCase, gamma.gamma_req, 1.0);
end

function [access, constellation] = local_access_fixture(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
traj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'backend', 'legacy_stage02', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 60, 'Ts_s', 5))));
walker = ttube.core.orbit.buildWalkerConstellation(struct( ...
    'legacyRoot', legacyRoot, 'h_km', 1000, 'i_deg', 70, 'P', 4, 'T', 3, 'F', 1));
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, traj.t_s, ...
    struct('legacyRoot', legacyRoot, 'epoch_utc', traj.epoch_utc));
access = ttube.core.sensor.computeAccessGeometry(traj, constellation, struct('legacyRoot', legacyRoot));
end

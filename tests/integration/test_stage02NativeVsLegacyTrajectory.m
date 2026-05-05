function tests = test_stage02NativeVsLegacyTrajectory
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeTrajectoryMagnitudeAgainstLegacy(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');

nativeTraj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'backend', 'native', 'Tmax_s', 40, 'Ts_s', 5));
legacyTraj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'backend', 'legacy_stage02', ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));

verifyEqual(testCase, nativeTraj.t_s(1), legacyTraj.t_s(1), 'AbsTol', 1e-12);
verifyEqual(testCase, nativeTraj.t_s(end), legacyTraj.t_s(end), 'AbsTol', 5);
verifySize(testCase, nativeTraj.r_eci_km, [numel(nativeTraj.t_s), 3]);
verifySize(testCase, nativeTraj.v_eci_kmps, [numel(nativeTraj.t_s), 3]);

reKm = 6378.137;
nativeAltKm = vecnorm(nativeTraj.r_eci_km, 2, 2) - reKm;
legacyAltKm = vecnorm(legacyTraj.r_eci_km, 2, 2) - reKm;
nativeSpeedKmps = vecnorm(nativeTraj.v_eci_kmps, 2, 2);
legacySpeedKmps = vecnorm(legacyTraj.v_eci_kmps, 2, 2);

verifyGreaterThan(testCase, min(nativeAltKm), 0);
verifyEqual(testCase, nativeAltKm(1), legacyAltKm(1), 'AbsTol', 2.0);
verifyEqual(testCase, nativeSpeedKmps(1), legacySpeedKmps(1), 'AbsTol', 0.6);
verifyLessThan(testCase, abs(nativeAltKm(end) - legacyAltKm(end)), 50.0);
verifyLessThan(testCase, abs(nativeSpeedKmps(end) - legacySpeedKmps(end)), 1.0);
end

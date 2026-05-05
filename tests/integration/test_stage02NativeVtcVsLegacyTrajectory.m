function tests = test_stage02NativeVtcVsLegacyTrajectory
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeVtcAgainstLegacyN01(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');

cfg = struct('Tmax_s', 80, 'Ts_s', 5);
nativeTraj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'backend', 'native_vtc', 'Tmax_s', cfg.Tmax_s, 'Ts_s', cfg.Ts_s));
legacyTraj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'backend', 'legacy_stage02', ...
    'legacyOverrides', struct('stage02', cfg)));

verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(nativeTraj));
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(legacyTraj));
verifyEqual(testCase, nativeTraj.t_s(1), legacyTraj.t_s(1), 'AbsTol', 1e-12);
verifyEqual(testCase, nativeTraj.t_s(end), legacyTraj.t_s(end), 'AbsTol', cfg.Ts_s);
verifyEqual(testCase, numel(nativeTraj.t_s), numel(legacyTraj.t_s), 'AbsTol', 1);

nativeAlt = local_geocentric_altitude_km(nativeTraj);
legacyAlt = local_geocentric_altitude_km(legacyTraj);
nativeSpeed = nativeTraj.v_mps(:) / 1000;
legacySpeed = vecnorm(legacyTraj.v_eci_kmps, 2, 2);

commonN = min(numel(nativeAlt), numel(legacyAlt));
altErrKm = abs(nativeAlt(1:commonN) - legacyAlt(1:commonN));
speedErrKmps = abs(nativeSpeed(1:commonN) - legacySpeed(1:commonN));
dispErrKm = abs(vecnorm(nativeTraj.r_eci_km(1:commonN,:) - nativeTraj.r_eci_km(1,:), 2, 2) - ...
    vecnorm(legacyTraj.r_eci_km(1:commonN,:) - legacyTraj.r_eci_km(1,:), 2, 2));

verifyLessThan(testCase, altErrKm(1), 1e-6);
verifyLessThan(testCase, max(altErrKm), 1.0);
verifyLessThan(testCase, max(speedErrKmps), 0.8);
verifyLessThan(testCase, max(dispErrKm), 60.0);
verifyTrue(testCase, all(nativeTraj.valid_mask));
end

function hKm = local_geocentric_altitude_km(traj)
hKm = vecnorm(traj.r_eci_km, 2, 2) - 6378.137;
end

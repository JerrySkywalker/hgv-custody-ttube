function tests = test_stage02HgvTrajectoryNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeTrajectoryArtifact(testCase)
traj = ttube.core.traj.propagateHgvTrajectory(struct('backend', 'native', ...
    'Tmax_s', 40, 'Ts_s', 5));
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(traj));
verifyTrue(testCase, all(diff(traj.t_s) >= 0));
verifySize(testCase, traj.r_eci_km, [numel(traj.t_s), 3]);
verifySize(testCase, traj.v_eci_kmps, [numel(traj.t_s), 3]);
verifyTrue(testCase, all(isfinite(traj.r_eci_km), 'all'));
verifyTrue(testCase, all(isfinite(traj.v_eci_kmps), 'all'));
end

function testNativeDeterministic(testCase)
a = ttube.core.traj.propagateHgvTrajectory(struct('backend', 'native', 'Tmax_s', 20));
b = ttube.core.traj.propagateHgvTrajectory(struct('backend', 'native', 'Tmax_s', 20));
verifyEqual(testCase, a.r_eci_km, b.r_eci_km);
verifyEqual(testCase, a.v_eci_kmps, b.v_eci_kmps);
end

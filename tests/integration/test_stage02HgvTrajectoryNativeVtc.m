function tests = test_stage02HgvTrajectoryNativeVtc
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeVtcTrajectoryArtifact(testCase)
traj = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'backend', 'native_vtc', 'Tmax_s', 40, 'Ts_s', 5));
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(traj));
verifyEqual(testCase, traj.backend, 'native_vtc');
verifyTrue(testCase, isfield(traj, 'vtc_state'));
verifyTrue(testCase, ttube.core.traj.validateVtcStateSeries(traj.vtc_state));
verifySize(testCase, traj.r_eci_km, [numel(traj.t_s), 3]);
verifySize(testCase, traj.v_eci_kmps, [numel(traj.t_s), 3]);
verifyGreaterThan(testCase, min(traj.h_km), 0);
verifyLessThan(testCase, max(abs(diff(traj.vtc_state.theta_rad))), 0.1);
end

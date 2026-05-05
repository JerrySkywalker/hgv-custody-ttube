function tests = test_validateVtcStateSeries
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testValidVtcState(testCase)
vtc = local_vtc();
verifyTrue(testCase, ttube.core.traj.validateVtcStateSeries(vtc));
end

function testMissingFieldFails(testCase)
vtc = rmfield(local_vtc(), 'v_mps');
verifyError(testCase, @() ttube.core.traj.validateVtcStateSeries(vtc), ...
    'ttube:traj:InvalidVtcState');
end

function vtc = local_vtc()
t = (0:5:10).';
X = [5500, 0, pi/2, deg2rad(30), deg2rad(-120), 6428137; ...
     5490, -0.01, pi/2, deg2rad(30.01), deg2rad(-120.01), 6427000; ...
     5480, -0.02, pi/2, deg2rad(30.02), deg2rad(-120.02), 6426000];
vtc = struct();
vtc.schema_version = 'vtc_state.v0';
vtc.trajectory_id = 'N01';
vtc.epoch_utc = '2026-01-01 00:00:00';
vtc.t_s = t;
vtc.X = X;
vtc.v_mps = X(:,1);
vtc.theta_rad = X(:,2);
vtc.sigma_rad = X(:,3);
vtc.phi_rad = X(:,4);
vtc.lambda_rad = X(:,5);
vtc.r_m = X(:,6);
vtc.h_m = X(:,6) - 6378137;
vtc.h_km = vtc.h_m / 1000;
vtc.alpha_rad = deg2rad(11);
vtc.bank_rad = 0;
end

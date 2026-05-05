function tests = test_vtcStateToTrajectoryArtifact
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testArtifactConversion(testCase)
vtc = local_vtc();
artifact = ttube.core.traj.vtcStateToTrajectoryArtifact(vtc);
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(artifact));
verifySize(testCase, artifact.r_ecef_km, [numel(vtc.t_s), 3]);
verifySize(testCase, artifact.r_eci_km, [numel(vtc.t_s), 3]);
verifySize(testCase, artifact.v_eci_kmps, [numel(vtc.t_s), 3]);
verifyEqual(testCase, artifact.meta.velocity_method, 'finite_difference_r_eci_km');
end

function vtc = local_vtc()
t = (0:5:10).';
lat = deg2rad([30; 30.01; 30.02]);
lon = deg2rad([-120; -120.01; -120.02]);
r = [6428137; 6427000; 6426000];
X = [5500 * ones(3,1), zeros(3,1), pi/2 * ones(3,1), lat, lon, r];
vtc = struct();
vtc.schema_version = 'vtc_state.v0';
vtc.trajectory_id = 'N01';
vtc.family = 'nominal';
vtc.subfamily = 'nominal';
vtc.epoch_utc = '2026-01-01 00:00:00';
vtc.t_s = t;
vtc.X = X;
vtc.v_mps = X(:,1);
vtc.theta_rad = X(:,2);
vtc.sigma_rad = X(:,3);
vtc.phi_rad = X(:,4);
vtc.lambda_rad = X(:,5);
vtc.r_m = X(:,6);
vtc.h_m = r - 6378137;
vtc.h_km = vtc.h_m / 1000;
vtc.alpha_rad = deg2rad(11);
vtc.bank_rad = 0;
end

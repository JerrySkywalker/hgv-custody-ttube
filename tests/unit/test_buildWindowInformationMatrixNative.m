function tests = test_buildWindowInformationMatrixNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeInformationMatrix(testCase)
[access, constellation] = local_fixture();
window = ttube.core.visibility.buildWindowGrid(access, 10, 10);
info = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, ...
    struct('backend','native'));
verifySize(testCase, info.info_matrix, [3 3 numel(window.start_idx)]);
verifyEqual(testCase, info.info_matrix(:,:,1), info.info_matrix(:,:,1).', 'AbsTol', 1e-12);
verifyTrue(testCase, all(isfinite(info.lambda_min)));
end

function [access, constellation] = local_fixture()
traj = ttube.core.traj.propagateHgvTrajectory(struct('backend','native','Tmax_s',20,'Ts_s',10));
walker = ttube.core.orbit.buildWalkerConstellation(struct('backend','native','P',2,'T',2));
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, traj.t_s, struct('backend','native'));
access = ttube.core.sensor.computeAccessGeometry(traj, constellation, struct( ...
    'backend','native','max_range_km',10000,'require_earth_occlusion_check',false, ...
    'enable_offnadir_constraint',false));
end

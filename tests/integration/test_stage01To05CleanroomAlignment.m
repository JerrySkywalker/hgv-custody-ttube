function tests = test_stage01To05CleanroomAlignment
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeStage01To05Pipeline(testCase)
outDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(outDir));
out = ttube.experiments.stage05.runStage05TinySearch(struct( ...
    'outputDir', outDir, 'caseId', 'N01', ...
    'h_grid_km', 1000, 'i_grid_deg', [60 70], ...
    'P_grid', [2 4], 'T_grid', [2 3], 'F_fixed', 1, ...
    'Tw_s', 20, 'window_step_s', 10, 'Tmax_s', 40, 'Ts_s', 5, ...
    'gamma_req', 1.0, 'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false)));
verifyEqual(testCase, out.case.case_id, 'N01');
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(out.trajectory));
verifyEqual(testCase, out.trajectory.backend, 'native_vtc');
verifyEqual(testCase, height(out.result_table), 8);
verifyTrue(testCase, all(isfinite(out.result_table.lambda_worst)));
verifyTrue(testCase, all(isfinite(out.result_table.D_G)));
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

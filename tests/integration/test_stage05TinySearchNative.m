function tests = test_stage05TinySearchNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeTinySearch(testCase)
outDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(outDir)); %#ok<NASGU>
out = ttube.experiments.stage05.runStage05TinySearch(struct( ...
    'outputDir', outDir, 'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', [60 70], 'P_grid', [2 4], 'T_grid', [2 3], ...
    'F_fixed', 1, 'Tw_s', 20, 'window_step_s', 10, ...
    'Tmax_s', 40, 'Ts_s', 5, 'gamma_req', 1.0, ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false)));
verifyEqual(testCase, height(out.result_table), 8);
verifyTrue(testCase, all(isfinite(out.result_table.D_G)));
verifyTrue(testCase, isfile(fullfile(outDir, 'stage05_tiny_search.mat')));
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

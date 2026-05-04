function tests = test_stage05TinySearchPipeline
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testStage05TinySearchSmoke(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
outputDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(outputDir));
out = ttube.experiments.stage05.runStage05TinySearch(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', 70, 'P_grid', 2, 'T_grid', 2, 'F_fixed', 1, ...
    'Tw_s', 20, 'window_step_s', 10, 'gamma_req', 1.0, ...
    'outputDir', outputDir, ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
verifyEqual(testCase, height(out.result_table), 1);
verifyTrue(testCase, ismember('D_G', out.result_table.Properties.VariableNames));
verifyTrue(testCase, isfile(fullfile(outputDir, 'stage05_tiny_search.mat')));
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

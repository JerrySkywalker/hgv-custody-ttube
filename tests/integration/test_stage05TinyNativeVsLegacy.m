function tests = test_stage05TinyNativeVsLegacy
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testTinyNativeVsLegacyHelper(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
outDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(outDir));
comparison = ttube.experiments.stage05.compareStage05TinyWithLegacy(struct( ...
    'legacyRoot', legacyRoot, 'outputDir', outDir, 'caseId', 'N01', ...
    'h_grid_km', 1000, 'i_grid_deg', 70, 'P_grid', 2, 'T_grid', 2, ...
    'F_fixed', 1, 'Tw_s', 20, 'window_step_s', 10, ...
    'Tmax_s', 40, 'Ts_s', 5, 'gamma_req', 1.0, ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false)));
verifyTrue(testCase, comparison.rows_match);
verifyTrue(testCase, comparison.Ns_match);
verifyTrue(testCase, all(isfinite(comparison.native.result_table.D_G)));
verifyTrue(testCase, all(isfinite(comparison.legacy.result_table.D_G)));
verifyGreaterThanOrEqual(testCase, comparison.feasible_match_fraction, 0);
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

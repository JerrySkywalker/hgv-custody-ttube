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
cfg = struct( ...
    'legacyRoot', legacyRoot, 'outputDir', outDir, 'caseId', 'N01', ...
    'h_grid_km', 1000, 'i_grid_deg', [60 70], 'P_grid', [2 4], 'T_grid', [2 3], ...
    'F_fixed', 1, 'Tw_s', 30, 'window_step_s', 10, ...
    'Tmax_s', 80, 'Ts_s', 5, 'gamma_req', 1.0, 'trajectoryBackend', 'native_vtc', ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false));
native = ttube.experiments.stage05.runStage05TinySearch(cfg);
legacy = ttube.legacy.runStage05TinyOracle(cfg);
comparison = ttube.experiments.stage05.compareStage05ResultTables( ...
    native.result_table, legacy.result_table, struct('D_G_abs_tol', 1e-3, 'D_G_rel_tol', 1e-6));
verifyEqual(testCase, legacy.used_old_full_stage05_runner, false);
verifyEqual(testCase, legacy.oracle_type, 'helper-level');
verifyEqual(testCase, comparison.status, 'pass');
verifyTrue(testCase, comparison.row_count_match);
verifyTrue(testCase, comparison.design_key_match);
verifyEqual(testCase, comparison.feasible_match_ratio, 1);
verifyLessThan(testCase, comparison.max_abs_D_G_error, 1e-3);
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

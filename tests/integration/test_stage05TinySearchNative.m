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
cleanupObj = onCleanup(@() local_remove_dir(outDir));
out = ttube.experiments.stage05.runStage05TinySearch(struct( ...
    'outputDir', outDir, 'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', [60 70], 'P_grid', [2 4], 'T_grid', [2 3], ...
    'F_fixed', 1, 'Tw_s', 20, 'window_step_s', 10, ...
    'Tmax_s', 40, 'Ts_s', 5, 'gamma_req', 1.0, ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false)));
verifyEqual(testCase, height(out.result_table), 8);
verifyTrue(testCase, all(isfinite(out.result_table.D_G)));
verifyEqual(testCase, out.trajectory.backend, 'native_vtc');
verifyEqual(testCase, out.schema_version, 'stage05_result_table.v0');
verifyEqual(testCase, out.backend, 'native');
verifyEqual(testCase, out.trajectoryBackend, 'native_vtc');
verifyTrue(testCase, ismember('design_id', out.result_table.Properties.VariableNames));
verifyTrue(testCase, islogical(out.result_table.feasible));
verifyTrue(testCase, isfile(fullfile(outDir, 'stage05_search_result.mat')));
end

function testPointMassAndVtcBackendOptions(testCase)
outDirA = tempname;
outDirB = tempname;
cleanupObj = onCleanup(@() local_remove_two(outDirA, outDirB));
baseCfg = struct( ...
    'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', [60 70], 'P_grid', [2 4], 'T_grid', [2 3], ...
    'F_fixed', 1, 'Tw_s', 20, 'window_step_s', 10, ...
    'Tmax_s', 40, 'Ts_s', 5, 'gamma_req', 1.0, ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false));
cfgA = baseCfg;
cfgA.outputDir = outDirA;
cfgA.trajectoryBackend = 'native_point_mass';
cfgB = baseCfg;
cfgB.outputDir = outDirB;
cfgB.trajectoryBackend = 'native_vtc';
pointMass = ttube.experiments.stage05.runStage05TinySearch(cfgA);
vtc = ttube.experiments.stage05.runStage05TinySearch(cfgB);
verifyEqual(testCase, height(pointMass.result_table), height(vtc.result_table));
verifyEqual(testCase, pointMass.result_table.Ns, vtc.result_table.Ns);
verifyTrue(testCase, all(isfinite(vtc.result_table.D_G)));
verifyTrue(testCase, islogical(vtc.result_table.feasible));
verifyEqual(testCase, isfinite(pointMass.summary.best_Ns), isfinite(vtc.summary.best_Ns));
end

function testNativeTinyDeterministic(testCase)
outDirA = tempname;
outDirB = tempname;
cleanupObj = onCleanup(@() local_remove_two(outDirA, outDirB));
cfg = struct('outputDir', outDirA, 'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', [60 70], 'P_grid', [2 4], 'T_grid', [2 3], ...
    'F_fixed', 1, 'Tw_s', 20, 'window_step_s', 10, ...
    'Tmax_s', 40, 'Ts_s', 5, 'gamma_req', 1.0, ...
    'sensor', struct('max_range_km', 10000, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false));
a = ttube.experiments.stage05.runStage05TinySearch(cfg);
cfg.outputDir = outDirB;
b = ttube.experiments.stage05.runStage05TinySearch(cfg);
verifyEqual(testCase, a.result_table.D_G, b.result_table.D_G);
verifyEqual(testCase, a.summary.best_Ns, b.summary.best_Ns);
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

function local_remove_two(a, b)
local_remove_dir(a);
local_remove_dir(b);
end

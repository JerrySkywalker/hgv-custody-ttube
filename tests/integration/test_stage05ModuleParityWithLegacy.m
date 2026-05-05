function tests = test_stage05ModuleParityWithLegacy
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testTinyModuleParity(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir)); %#ok<NASGU>
cfg = struct('legacyRoot',legacyRoot,'outputDir',outDir,'saveOutputs',false, ...
    'h_grid_km',1000,'i_grid_deg',[60 70],'P_grid',[2 4],'T_grid',[2 3], ...
    'Tmax_s',80,'Ts_s',5,'Tw_s',30,'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false));
native = ttube.experiments.stage05.runStage05NominalSearch(cfg);
legacy = ttube.legacy.runStage05TinyOracle(cfg);
cmp = ttube.experiments.stage05.compareStage05ResultTables(native.result_table, legacy.result_table, struct('D_G_abs_tol',1e-3,'D_G_rel_tol',1e-6));
verifyEqual(testCase, cmp.status, 'pass');
nativeSummary = ttube.experiments.stage05.summarizeStage05Results(native.result_table);
legacySummary = ttube.experiments.stage05.summarizeStage05Results(legacy.result_table);
verifyEqual(testCase, nativeSummary.num_designs, legacySummary.num_designs);
verifyEqual(testCase, nativeSummary.num_feasible, legacySummary.num_feasible);
nativePareto = ttube.experiments.stage05.analyzeStage05ParetoTransition(native.result_table);
legacyPareto = ttube.experiments.stage05.analyzeStage05ParetoTransition(legacy.result_table);
verifyEqual(testCase, height(nativePareto.pareto_table), height(legacyPareto.pareto_table));
verifyFalse(testCase, legacy.used_old_full_stage05_runner);
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

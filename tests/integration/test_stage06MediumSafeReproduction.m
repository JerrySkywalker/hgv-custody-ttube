function tests = test_stage06MediumSafeReproduction
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testMediumSafeNative(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
tStart = tic;
b = ttube.experiments.stage06.runStage06FullNative(struct( ...
    'profile','medium_safe','outputDir',outDir,'saveOutputs',true,'makePlots',false, ...
    'heading_offsets_deg',[-10 0 10], 'h_grid_km',[800 1000], ...
    'i_grid_deg',[50 60 70], 'P_grid',[2 4], 'T_grid',[2 3 4], ...
    'Tmax_s',80,'Ts_s',5,'maxDesignsGuard',100,'maxDesignHeadingEvalsGuard',300));
runtimeS = toc(tStart);
verifyEqual(testCase, height(b.search.result_table), 36);
verifyEqual(testCase, numel(b.search.scope.heading_offsets_deg), 3);
verifyGreaterThanOrEqual(testCase, b.summary.feasible_count, 0);
verifyTrue(testCase, isfield(b.comparison, 'DG_robustness_drop'));
verifyLessThan(testCase, runtimeS, 120);
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

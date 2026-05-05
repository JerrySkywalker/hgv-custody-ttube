function tests = test_stage05MediumSafeReproduction
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testMediumSafeNative(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
tStart = tic;
b = ttube.experiments.stage05.runStage05FullNative(struct('profile','medium_safe', ...
    'outputDir',outDir,'saveOutputs',true,'makePlots',true,'Tmax_s',80, ...
    'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false)));
runtime = toc(tStart);
verifyEqual(testCase, height(b.search.result_table), 72);
verifyTrue(testCase, all(isfinite(b.search.result_table.D_G)));
verifyTrue(testCase, isfield(b.summary, 'best_Ns'));
verifyGreaterThan(testCase, height(b.pareto.transition_envelope), 0);
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_full_native_bundle.mat')));
verifyLessThan(testCase, runtime, 180);
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

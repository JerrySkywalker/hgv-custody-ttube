function tests = test_stage05FullNativePipeline
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testFullNativeSmoke(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir)); %#ok<NASGU>
b = ttube.experiments.stage05.runStage05FullNative(struct('profile','smoke','outputDir',outDir,'saveOutputs',true,'makePlots',false));
verifyEqual(testCase, b.schema_version, 'stage05_full_native_bundle.v0');
verifyEqual(testCase, b.search.schema_version, 'stage05_search_result.v0');
verifyEqual(testCase, b.summary.schema_version, 'stage05_summary.v0');
verifyEqual(testCase, b.frontier.schema_version, 'stage05_frontier.v0');
verifyEqual(testCase, b.pareto.schema_version, 'stage05_pareto_transition.v0');
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_full_native_bundle.mat')));
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

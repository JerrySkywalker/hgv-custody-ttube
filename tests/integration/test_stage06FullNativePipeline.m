function tests = test_stage06FullNativePipeline
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testFullNativeSmoke(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
b = ttube.experiments.stage06.runStage06FullNative(struct( ...
    'profile','smoke','outputDir',outDir,'saveOutputs',true,'makePlots',true, ...
    'Tmax_s',30,'heading_offsets_deg',[-5 0 5]));
verifyEqual(testCase, b.schema_version, 'stage06_full_native_bundle.v0');
verifyEqual(testCase, b.search.schema_version, 'stage06_heading_search_result.v0');
verifyTrue(testCase, isfield(b, 'comparison'));
verifyTrue(testCase, isfile(fullfile(outDir, 'stage06_full_native_bundle.mat')));
verifyTrue(testCase, isfile(b.plot_bundle.files.robustness_png));
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

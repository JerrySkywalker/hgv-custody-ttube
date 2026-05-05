function tests = test_stage06CompareWithStage05
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testCompare(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
s5 = ttube.experiments.stage05.runStage05NominalSearch(struct('profile','smoke','outputDir',fullfile(outDir,'s5'),'saveOutputs',false,'Tmax_s',30));
s6 = ttube.experiments.stage06.runStage06HeadingSearch(struct('profile','smoke','outputDir',fullfile(outDir,'s6'),'saveOutputs',false,'Tmax_s',30,'heading_offsets_deg',[-5 0 5]));
c = ttube.experiments.stage06.compareStage06WithStage05(s5, s6);
verifyEqual(testCase, c.schema_version, 'stage06_vs_stage05_comparison.v0');
verifyEqual(testCase, height(c.joined_table), 1);
verifyTrue(testCase, isfield(c, 'DG_robustness_drop'));
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

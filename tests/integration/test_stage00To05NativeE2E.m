function tests = test_stage00To05NativeE2E
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testSmokeE2E(testCase)
runDir = tempname; cleanup = onCleanup(@() local_rm(runDir));
r = ttube.experiments.stage00_05.runStage00To05Native(struct('profile','smoke','runDir',runDir,'saveOutputs',false));
verifyTrue(testCase, r.validation.passed);
verifyEqual(testCase, r.manifest.schema_version, 'stage00_05_run_manifest.v0');
verifyTrue(testCase, isfile(fullfile(runDir,'stage00_05_manifest.json')));
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

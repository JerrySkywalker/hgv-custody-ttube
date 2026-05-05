function tests = test_stage00BootstrapNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testBootstrapArtifact(testCase)
runDir = tempname; cleanup = onCleanup(@() local_rm(runDir));
a = ttube.experiments.stage00.runStage00Bootstrap(struct('runDir',runDir,'outputDir',fullfile(runDir,'outputs'),'random_seed',123));
ttube.experiments.stage00.validateStage00BootstrapArtifact(a);
verifyEqual(testCase, a.schema_version, 'stage00_bootstrap.v0');
verifyTrue(testCase, isfile(fullfile(runDir, 'stage00_bootstrap_summary.json')));
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

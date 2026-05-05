function tests = test_stage00To05OutputCompleteness
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testTinyCompleteness(testCase)
runDir = tempname; cleanup = onCleanup(@() local_rm(runDir));
r = ttube.experiments.stage00_05.runStage00To05Native(struct('profile','tiny','runDir',runDir,'saveOutputs',false,'Tmax_s',40));
verifyTrue(testCase, r.validation.passed);
verifyEqual(testCase, r.stage01.summary.nominal_count, 3);
verifyEqual(testCase, r.stage02.summary.heading_count, 3);
verifyTrue(testCase, isfield(r.stage03.summary, 'critical'));
verifyTrue(testCase, isfield(r.stage04.summary, 'gamma_meta'));
verifyTrue(testCase, isfield(r.stage05, 'pareto'));
verifyTrue(testCase, isfield(r.stage05, 'frontier'));
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

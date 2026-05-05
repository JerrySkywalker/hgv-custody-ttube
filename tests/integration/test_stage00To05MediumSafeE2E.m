function tests = test_stage00To05MediumSafeE2E
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testMediumSafeE2E(testCase)
runDir = tempname; cleanup = onCleanup(@() local_rm(runDir));
r = ttube.experiments.stage00_05.runStage00To05Native(struct('profile','medium_safe','runDir',runDir,'saveOutputs',false,'Tmax_s',50,'stage05Profile','smoke'));
verifyTrue(testCase, r.validation.passed);
verifyGreaterThanOrEqual(testCase, r.stage01.summary.nominal_count, 6);
verifyGreaterThanOrEqual(testCase, r.stage01.summary.heading_count, 6);
verifyGreaterThanOrEqual(testCase, r.stage01.summary.critical_count, 2);
verifyGreaterThan(testCase, height(r.stage05.search.result_table), 0);
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

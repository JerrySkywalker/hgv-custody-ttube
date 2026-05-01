function tests = test_runStatus
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testRunStatusLifecycle(testCase)
runDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(runDir));

stepIds = {'prepare', 'compute', 'report'};
created = ttube.pipeline.createRunStatus(runDir, 'run_status_test', stepIds);
verifyTrue(testCase, isfolder(runDir));
verifyTrue(testCase, isfile(fullfile(runDir, 'status.json')));
verifyEqual(testCase, created.run_id, 'run_status_test');
verifyEqual(testCase, numel(created.steps), 3);
verifyEqual(testCase, {created.steps.status}, {'pending', 'pending', 'pending'});

ttube.pipeline.updateRunStepStatus(runDir, 'compute', 'running', 'started compute');
ttube.pipeline.updateRunStepStatus(runDir, 'compute', 'done', 'finished compute');
ttube.pipeline.updateRunStepStatus(runDir, 'report', 'failed', 'report failed');

readBack = ttube.pipeline.readRunStatus(runDir);
verifyEqual(testCase, readBack.run_id, 'run_status_test');
verifyEqual(testCase, readBack.steps(2).step_id, 'compute');
verifyEqual(testCase, readBack.steps(2).status, 'done');
verifyEqual(testCase, readBack.steps(2).message, 'finished compute');
verifyEqual(testCase, readBack.steps(3).status, 'failed');

printed = evalc('ttube.pipeline.showRunStatus(runDir);');
verifyNotEmpty(testCase, printed);
verifyTrue(testCase, contains(printed, 'run_status_test'));
verifyTrue(testCase, contains(printed, 'compute'));
end

function testInvalidStatus(testCase)
runDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(runDir));

ttube.pipeline.createRunStatus(runDir, 'invalid_status_test', {'step1'});
verifyError(testCase, @() ttube.pipeline.updateRunStepStatus(runDir, 'step1', 'unknown', ''), ...
    'ttube:pipeline:InvalidStepStatus');
end

function testMissingStep(testCase)
runDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(runDir));

ttube.pipeline.createRunStatus(runDir, 'missing_step_test', {'step1'});
verifyError(testCase, @() ttube.pipeline.updateRunStepStatus(runDir, 'step2', 'running', ''), ...
    'ttube:pipeline:StepNotFound');
end

function local_remove_dir(runDir)
if isfolder(runDir)
    rmdir(runDir, 's');
end
end

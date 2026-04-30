function tests = test_startup
tests = functiontests(localfunctions);
end

function testStartupConfiguresProjectPath(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);

projectRoot = startup('force', true);

verifyEqual(testCase, projectRoot, repoRoot);
verifyEqual(testCase, exist(fullfile(repoRoot, 'startup.m'), 'file'), 2);
verifyTrue(testCase, contains(path, fullfile(repoRoot, 'src')));
verifyTrue(testCase, contains(path, fullfile(repoRoot, 'scripts')));
verifyTrue(testCase, contains(path, fullfile(repoRoot, 'tests')));
end

function testCheckEnvironmentReportsRepository(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);

info = check_environment();

verifyEqual(testCase, info.repoRoot, repoRoot);
verifyTrue(testCase, info.hasStartup);
verifyTrue(testCase, info.hasSrc);
verifyTrue(testCase, info.hasScripts);
verifyTrue(testCase, info.hasTests);
end

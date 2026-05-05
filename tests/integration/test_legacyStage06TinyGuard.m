function tests = test_legacyStage06TinyGuard
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testGuardRejectsLargeGrid(testCase)
f = @() ttube.legacy.runStage06TinyOracle(struct('i_grid_deg',1:20));
verifyError(testCase, f, 'ttube:legacy:Stage06GuardRejected');
end

function testGuardRejectsPlot(testCase)
f = @() ttube.legacy.runStage06TinyOracle(struct('make_plot',true));
verifyError(testCase, f, 'ttube:legacy:Stage06GuardRejected');
end

function testTinyOracleBlockedDiagnostic(testCase)
o = ttube.legacy.runStage06TinyOracle(struct('heading_offsets_deg',[-5 0 5]));
verifyEqual(testCase, o.status, 'blocked');
verifyNotEmpty(testCase, o.blocked_reason);
end

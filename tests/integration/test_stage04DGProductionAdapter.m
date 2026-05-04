function tests = test_stage04DGProductionAdapter
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDGFromStage04Info(testCase)
info = struct('lambda_worst', 2.0);
dg = ttube.core.metrics.computeDGProduction(info, 1.0);
verifyEqual(testCase, dg.margin, 2.0);
verifyTrue(testCase, dg.feasible);
verifyEqual(testCase, dg.production_alignment, 'stage04_05_lambda_min_over_gamma_req');
end

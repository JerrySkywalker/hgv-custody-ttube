function tests = test_computeDGProduction
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDGMonotonicWithGamma(testCase)
dg1 = ttube.core.metrics.computeDGProduction(2, 1);
dg2 = ttube.core.metrics.computeDGProduction(2, 2);
verifyGreaterThan(testCase, dg1.margin, dg2.margin);
verifyEqual(testCase, dg1.margin, 2);
verifyEqual(testCase, dg2.margin, 1);
end

function testDGFromInfoStruct(testCase)
info = zeros(3,3,1);
info(:,:,1) = 3 * eye(3);
dg = ttube.core.metrics.computeDGProduction(struct('info_matrix', info), 1);
verifyEqual(testCase, dg.margin, 3, 'AbsTol', 1e-12);
verifyTrue(testCase, dg.feasible);
end

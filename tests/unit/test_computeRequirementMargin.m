function tests = test_computeRequirementMargin
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testHigherIsBetterScalarPass(testCase)
[margin, feasible] = ttube.core.metrics.computeRequirementMargin(12, 10, 'higher_is_better');
verifyEqual(testCase, margin, 1.2, 'AbsTol', 1e-12);
verifyTrue(testCase, feasible);
end

function testHigherIsBetterScalarFail(testCase)
[margin, feasible] = ttube.core.metrics.computeRequirementMargin(8, 10, "higher_is_better");
verifyEqual(testCase, margin, 0.8, 'AbsTol', 1e-12);
verifyFalse(testCase, feasible);
end

function testLowerIsBetterScalarPass(testCase)
[margin, feasible] = ttube.core.metrics.computeRequirementMargin(4, 5, 'lower_is_better');
verifyEqual(testCase, margin, 1.25, 'AbsTol', 1e-12);
verifyTrue(testCase, feasible);
end

function testLowerIsBetterScalarFail(testCase)
[margin, feasible] = ttube.core.metrics.computeRequirementMargin(8, 5, 'lower_is_better');
verifyEqual(testCase, margin, 0.625, 'AbsTol', 1e-12);
verifyFalse(testCase, feasible);
end

function testVectorInput(testCase)
value = [1; 2; 4];
requirement = [2; 2; 2];
[margin, feasible] = ttube.core.metrics.computeRequirementMargin(value, requirement, 'higher_is_better');
verifyEqual(testCase, margin, [0.5; 1; 2]);
verifyEqual(testCase, feasible, [false; true; true]);

[marginScalarReq, feasibleScalarReq] = ttube.core.metrics.computeRequirementMargin(value, 2, 'higher_is_better');
verifyEqual(testCase, marginScalarReq, [0.5; 1; 2]);
verifyEqual(testCase, feasibleScalarReq, [false; true; true]);
end

function testInvalidRequirement(testCase)
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(1, 0, 'higher_is_better'), ...
    'ttube:metrics:InvalidRequirement');
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(1, -1, 'higher_is_better'), ...
    'ttube:metrics:InvalidRequirement');
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin([1; 2], [1 2], 'higher_is_better'), ...
    'ttube:metrics:InvalidRequirement');
end

function testInvalidNanInf(testCase)
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(NaN, 1, 'higher_is_better'), ...
    'ttube:metrics:InvalidMetricValue');
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(1, Inf, 'higher_is_better'), ...
    'ttube:metrics:InvalidRequirement');
end

function testInvalidMode(testCase)
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(1, 1, 'larger'), ...
    'ttube:metrics:InvalidMarginMode');
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(1, 1, ["a", "b"]), ...
    'ttube:metrics:InvalidMarginMode');
end

function testLowerIsBetterInvalidValue(testCase)
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(0, 1, 'lower_is_better'), ...
    'ttube:metrics:InvalidMetricValue');
verifyError(testCase, @() ttube.core.metrics.computeRequirementMargin(-1, 1, 'lower_is_better'), ...
    'ttube:metrics:InvalidMetricValue');
end

function tests = test_combineDTriplet
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
addpath(fullfile(repoRoot, 'tests', 'fixtures'));
testCase.TestData.fixtures = make_synthetic_d_metric_fixtures();
end

function testAllPass(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.all_pass);
end

function testGFailure(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.fail_G);
end

function testAFailure(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.fail_A);
end

function testTFailure(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.fail_T);
end

function testMultipleFailures(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.fail_multiple);
end

function testTieRule(testCase)
verifyFixtureCase(testCase, testCase.TestData.fixtures.tie_case);

jointA = ttube.core.metrics.combineDTriplet(1.1, 0.8, 0.8);
verifyJoint(testCase, jointA, 0.8, false, "A");
end

function testVectorMargins(testCase)
joint = ttube.core.metrics.combineDTriplet([1.2; 0.8; 1.2], [1.1; 1.2; 0.7], [1.3; 1.2; 0.9]);
verifyEqual(testCase, joint.joint_margin, [1.1; 0.8; 0.7]);
verifyEqual(testCase, joint.joint_feasible, [true; false; false]);
verifyEqual(testCase, joint.dominant_fail_tag, ["OK"; "G"; "A"]);
end

function testInvalidNanInf(testCase)
verifyError(testCase, @() ttube.core.metrics.combineDTriplet(NaN, 1, 1), ...
    'ttube:metrics:InvalidDMargin');
verifyError(testCase, @() ttube.core.metrics.combineDTriplet(1, Inf, 1), ...
    'ttube:metrics:InvalidDMargin');
end

function testIncompatibleSizes(testCase)
verifyError(testCase, @() ttube.core.metrics.combineDTriplet([1; 1], 1, [1; 1]), ...
    'ttube:metrics:IncompatibleDMarginSize');
end

function verifyJoint(testCase, joint, expectedMargin, expectedFeasible, expectedTag)
verifyEqual(testCase, joint.joint_margin, expectedMargin, 'AbsTol', 1e-12);
verifyEqual(testCase, joint.joint_feasible, expectedFeasible);
verifyEqual(testCase, joint.dominant_fail_tag, expectedTag);
end

function verifyFixtureCase(testCase, fixtureCase)
joint = ttube.core.metrics.combineDTriplet(fixtureCase.DG_margin, ...
    fixtureCase.DA_margin, fixtureCase.DT_margin);
verifyJoint(testCase, joint, fixtureCase.joint_margin, ...
    fixtureCase.joint_feasible, fixtureCase.dominant_fail_tag);
end

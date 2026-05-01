function tests = test_combineDTriplet
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testAllPass(testCase)
joint = ttube.core.metrics.combineDTriplet(1.2, 1.1, 1.3);
verifyJoint(testCase, joint, 1.1, true, "OK");
end

function testGFailure(testCase)
joint = ttube.core.metrics.combineDTriplet(0.8, 1.2, 1.3);
verifyJoint(testCase, joint, 0.8, false, "G");
end

function testAFailure(testCase)
joint = ttube.core.metrics.combineDTriplet(1.2, 0.7, 1.3);
verifyJoint(testCase, joint, 0.7, false, "A");
end

function testTFailure(testCase)
joint = ttube.core.metrics.combineDTriplet(1.2, 1.3, 0.6);
verifyJoint(testCase, joint, 0.6, false, "T");
end

function testMultipleFailures(testCase)
joint = ttube.core.metrics.combineDTriplet(0.9, 0.7, 0.8);
verifyJoint(testCase, joint, 0.7, false, "A");
end

function testTieRule(testCase)
jointG = ttube.core.metrics.combineDTriplet(0.8, 0.8, 0.9);
verifyJoint(testCase, jointG, 0.8, false, "G");

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

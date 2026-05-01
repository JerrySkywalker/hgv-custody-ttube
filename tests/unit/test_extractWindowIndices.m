function tests = test_extractWindowIndices
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testOneSecondGrid(testCase)
t = (0:10).';
[i0, i1, t0, t1] = tpipe.core.visibility.extractWindowIndices(t, 3, 2);
verifyEqual(testCase, i0, [1; 3; 5; 7]);
verifyEqual(testCase, i1, [4; 6; 8; 10]);
verifyEqual(testCase, t0, [0; 2; 4; 6]);
verifyEqual(testCase, t1, [3; 5; 7; 9]);
end

function testNonOneSecondGrid(testCase)
t = (0:0.5:5).';
[i0, i1, t0, t1] = tpipe.core.visibility.extractWindowIndices(t, 1.5, 1.0);
verifyEqual(testCase, i0, [1; 3; 5; 7]);
verifyEqual(testCase, i1, [4; 6; 8; 10]);
verifyEqual(testCase, t0, [0; 1; 2; 3]);
verifyEqual(testCase, t1, [1.5; 2.5; 3.5; 4.5]);
end

function testWindowLongerThanSpan(testCase)
t = (10:12).';
[i0, i1, t0, t1] = tpipe.core.visibility.extractWindowIndices(t, 10, 1);
verifyEqual(testCase, i0, 1);
verifyEqual(testCase, i1, 3);
verifyEqual(testCase, t0, 10);
verifyEqual(testCase, t1, 12);
end

function testStepNotIntegerMultipleOfSample(testCase)
t = (0:10).';
[i0, i1, t0, t1] = tpipe.core.visibility.extractWindowIndices(t, 3, 2.5);
verifyEqual(testCase, i0, [1; 4; 6]);
verifyEqual(testCase, i1, [4; 6; 9]);
verifyEqual(testCase, t0, [0; 2.5; 5]);
verifyEqual(testCase, t1, [3; 5.5; 8]);
end

function testInvalidTimeGrid(testCase)
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices([0 1 2], 1, 1), ...
    'tpipe:visibility:InvalidTimeGrid');
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices([0; 2; 1], 1, 1), ...
    'tpipe:visibility:InvalidTimeGrid');
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices([0; NaN; 2], 1, 1), ...
    'tpipe:visibility:InvalidTimeGrid');
end

function testInvalidWindowDuration(testCase)
t = (0:3).';
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices(t, 0, 1), ...
    'tpipe:visibility:InvalidWindowDuration');
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices(t, Inf, 1), ...
    'tpipe:visibility:InvalidWindowDuration');
end

function testInvalidWindowStep(testCase)
t = (0:3).';
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices(t, 1, 0), ...
    'tpipe:visibility:InvalidWindowStep');
verifyError(testCase, @() tpipe.core.visibility.extractWindowIndices(t, 1, NaN), ...
    'tpipe:visibility:InvalidWindowStep');
end

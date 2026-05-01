function tests = test_summarizeGapSegments
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testAllTrue(testCase)
t = (0:4).';
summary = ttube.core.metrics.summarizeGapSegments(t, true(5, 1));
verifyGapSummary(testCase, summary, 0, false, zeros(0, 1), zeros(0, 1), ...
    0, 0, 0, 0);
verifyEqual(testCase, summary.support_samples, 5);
verifyEqual(testCase, summary.total_span_s, 4);
end

function testAllFalse(testCase)
t = (0:4).';
summary = ttube.core.metrics.summarizeGapSegments(t, false(5, 1));
verifyGapSummary(testCase, summary, 1, true, 1, 5, 5, 1, 5, 5);
verifyEqual(testCase, summary.gap_t0_s, 0);
verifyEqual(testCase, summary.gap_t1_s, 4);
end

function testOneMiddleGap(testCase)
t = (0:4).';
summary = ttube.core.metrics.summarizeGapSegments(t, [true; false; false; true; true]);
verifyGapSummary(testCase, summary, 1, true, 2, 3, 2, 0.4, 2, 2);
end

function testMultipleGaps(testCase)
t = (0:6).';
mask = [false; true; false; false; true; false; true];
summary = ttube.core.metrics.summarizeGapSegments(t, mask);
verifyGapSummary(testCase, summary, 3, true, [1; 3; 6], [1; 4; 6], 4, 4/7, 2, 4);
verifyEqual(testCase, summary.gap_t0_s, [0; 2; 5]);
verifyEqual(testCase, summary.gap_t1_s, [0; 3; 5]);
end

function testGapAtBeginning(testCase)
t = (10:14).';
summary = ttube.core.metrics.summarizeGapSegments(t, [false; false; true; true; true]);
verifyGapSummary(testCase, summary, 1, true, 1, 2, 2, 0.4, 2, 2);
end

function testGapAtEnd(testCase)
t = (10:14).';
summary = ttube.core.metrics.summarizeGapSegments(t, [true; true; true; false; false]);
verifyGapSummary(testCase, summary, 1, true, 4, 5, 2, 0.4, 2, 2);
end

function testNonuniformMedianInterval(testCase)
t = [0; 1; 3; 6; 10];
summary = ttube.core.metrics.summarizeGapSegments(t, [true; false; false; true; true]);
verifyGapSummary(testCase, summary, 1, true, 2, 3, 2, 0.4, 5, 5);
end

function testInvalidRowVectorTime(testCase)
verifyError(testCase, @() ttube.core.metrics.summarizeGapSegments([0 1 2], true(3, 1)), ...
    'ttube:metrics:InvalidTimeGrid');
end

function testInvalidNonmonotonicTime(testCase)
verifyError(testCase, @() ttube.core.metrics.summarizeGapSegments([0; 2; 1], true(3, 1)), ...
    'ttube:metrics:InvalidTimeGrid');
end

function testInvalidEmptyTime(testCase)
verifyError(testCase, @() ttube.core.metrics.summarizeGapSegments(zeros(0, 1), false(0, 1)), ...
    'ttube:metrics:InvalidTimeGrid');
end

function testInvalidSupportMaskSize(testCase)
verifyError(testCase, @() ttube.core.metrics.summarizeGapSegments((0:2).', true(2, 1)), ...
    'ttube:metrics:InvalidSupportMask');
end

function testInvalidNonLogicalSupportMask(testCase)
verifyError(testCase, @() ttube.core.metrics.summarizeGapSegments((0:2).', [1; 0; 1]), ...
    'ttube:metrics:InvalidSupportMask');
end

function testSingleSampleAllTrue(testCase)
summary = ttube.core.metrics.summarizeGapSegments(42, true);
verifyGapSummary(testCase, summary, 0, false, zeros(0, 1), zeros(0, 1), ...
    0, 0, 0, 0);
verifyEqual(testCase, summary.total_span_s, 0);
end

function testSingleSampleAllFalse(testCase)
summary = ttube.core.metrics.summarizeGapSegments(42, false);
verifyGapSummary(testCase, summary, 1, true, 1, 1, 1, 1, 0, 0);
verifyEqual(testCase, summary.gap_t0_s, 42);
verifyEqual(testCase, summary.gap_t1_s, 42);
end

function verifyGapSummary(testCase, summary, gapCount, hasGap, startIdx, endIdx, ...
    gapSamples, gapFraction, longestGapTime_s, gapTotalTime_s)
verifyEqual(testCase, summary.gap_count, gapCount);
verifyEqual(testCase, summary.has_gap, hasGap);
verifyEqual(testCase, summary.gap_start_idx, startIdx);
verifyEqual(testCase, summary.gap_end_idx, endIdx);
verifyEqual(testCase, summary.gap_samples, gapSamples);
verifyEqual(testCase, summary.gap_fraction, gapFraction, 'AbsTol', 1e-12);
verifyEqual(testCase, summary.longest_gap_time_s, longestGapTime_s, 'AbsTol', 1e-12);
verifyEqual(testCase, summary.gap_total_time_s, gapTotalTime_s, 'AbsTol', 1e-12);
end

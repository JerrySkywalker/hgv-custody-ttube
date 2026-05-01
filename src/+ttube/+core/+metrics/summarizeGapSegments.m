function summary = summarizeGapSegments(t_s, support_mask)
%SUMMARIZEGAPSEGMENTS Summarize false segments in a support mask.
%
% A gap is one contiguous false segment in support_mask. This Batch 1
% primitive uses a simple duration approximation: each gap duration is the
% gap sample count multiplied by median(diff(t_s)). For a single-sample
% input, the sample interval is zero. Nonuniform grids therefore use the
% median sample interval as a codegen-friendly approximation; later DT
% metrics may replace this with interval-aware duration accounting.

local_validate_time_grid(t_s);
local_validate_support_mask(support_mask, numel(t_s));

total_samples = numel(t_s);
gap_mask = ~support_mask;
gap_samples = sum(gap_mask);
support_samples = total_samples - gap_samples;

if total_samples > 1
    sample_interval_s = median(diff(t_s));
else
    sample_interval_s = 0;
end

gap_edges = diff([false; gap_mask; false]);
gap_start_idx = find(gap_edges == 1);
gap_end_idx = find(gap_edges == -1) - 1;
gap_count = numel(gap_start_idx);

gap_lengths_samples = gap_end_idx - gap_start_idx + 1;
gap_durations_s = gap_lengths_samples .* sample_interval_s;

if gap_count > 0
    longest_gap_time_s = max(gap_durations_s);
else
    longest_gap_time_s = 0;
end

summary = struct();
summary.total_samples = total_samples;
summary.total_span_s = t_s(end) - t_s(1);
summary.support_samples = support_samples;
summary.gap_samples = gap_samples;
summary.gap_fraction = gap_samples / total_samples;
summary.gap_total_time_s = sum(gap_durations_s);
summary.longest_gap_time_s = longest_gap_time_s;
summary.gap_count = gap_count;
summary.gap_start_idx = gap_start_idx;
summary.gap_end_idx = gap_end_idx;
summary.gap_t0_s = t_s(gap_start_idx);
summary.gap_t1_s = t_s(gap_end_idx);
summary.has_gap = gap_count > 0;
end

function local_validate_time_grid(t_s)
assert(isnumeric(t_s) && iscolumn(t_s) && ~isempty(t_s), ...
    'ttube:metrics:InvalidTimeGrid', ...
    't_s must be a non-empty numeric column vector.');
assert(all(isfinite(t_s)), ...
    'ttube:metrics:InvalidTimeGrid', ...
    't_s must contain only finite values.');
assert(all(diff(t_s) >= 0), ...
    'ttube:metrics:InvalidTimeGrid', ...
    't_s must be monotonic nondecreasing.');
end

function local_validate_support_mask(support_mask, expected_count)
assert(islogical(support_mask) && iscolumn(support_mask) && ...
    numel(support_mask) == expected_count, ...
    'ttube:metrics:InvalidSupportMask', ...
    'support_mask must be a logical column vector with the same length as t_s.');
end

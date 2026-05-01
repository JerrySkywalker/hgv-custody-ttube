function [start_idx, end_idx, t0_s, t1_s] = extractWindowIndices(t_s, Tw_s, step_s)
%EXTRACTWINDOWINDICES Extract sample index ranges for sliding time windows.
%
% Each output row represents the samples in [t0, t0 + Tw_s]. Only full
% windows within the time grid span are emitted, except that a window
% duration greater than or equal to the total span returns one full-span
% window.

local_validate_time_grid(t_s);
local_validate_positive_scalar(Tw_s, 'tpipe:visibility:InvalidWindowDuration', ...
    'Tw_s must be a positive finite scalar.');
local_validate_positive_scalar(step_s, 'tpipe:visibility:InvalidWindowStep', ...
    'step_s must be a positive finite scalar.');

t_first = t_s(1);
t_last = t_s(end);
total_span = t_last - t_first;

if Tw_s >= total_span
    start_idx = 1;
    end_idx = numel(t_s);
    t0_s = t_first;
    t1_s = t_last;
    return;
end

n_max = floor((total_span - Tw_s) / step_s) + 1;
start_idx = zeros(n_max, 1);
end_idx = zeros(n_max, 1);
t0_s = zeros(n_max, 1);
t1_s = zeros(n_max, 1);

n_out = 0;
for k = 1:n_max
    t0 = t_first + (k - 1) * step_s;
    t1 = t0 + Tw_s;

    i0 = local_first_ge(t_s, t0);
    i1 = local_last_le(t_s, t1);

    if i0 > 0 && i1 >= i0
        n_out = n_out + 1;
        start_idx(n_out) = i0;
        end_idx(n_out) = i1;
        t0_s(n_out) = t0;
        t1_s(n_out) = t1;
    end
end

start_idx = start_idx(1:n_out);
end_idx = end_idx(1:n_out);
t0_s = t0_s(1:n_out);
t1_s = t1_s(1:n_out);
end

function local_validate_time_grid(t_s)
assert(isnumeric(t_s) && iscolumn(t_s) && ~isempty(t_s), ...
    'tpipe:visibility:InvalidTimeGrid', ...
    't_s must be a non-empty numeric column vector.');
assert(all(isfinite(t_s)), ...
    'tpipe:visibility:InvalidTimeGrid', ...
    't_s must contain only finite values.');
assert(all(diff(t_s) >= 0), ...
    'tpipe:visibility:InvalidTimeGrid', ...
    't_s must be monotonic nondecreasing.');
end

function local_validate_positive_scalar(x, id, message)
assert(isnumeric(x) && isscalar(x) && isfinite(x) && x > 0, id, message);
end

function idx = local_first_ge(x, value)
idx = 0;
for k = 1:numel(x)
    if x(k) >= value
        idx = k;
        return;
    end
end
end

function idx = local_last_le(x, value)
idx = 0;
for k = numel(x):-1:1
    if x(k) <= value
        idx = k;
        return;
    end
end
end

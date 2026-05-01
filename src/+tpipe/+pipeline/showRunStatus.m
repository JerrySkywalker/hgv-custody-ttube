function showRunStatus(runDir)
%SHOWRUNSTATUS Print a compact status table for a run.

statusDoc = tpipe.pipeline.readRunStatus(runDir);

fprintf('Run: %s\n', char(string(statusDoc.run_id)));
fprintf('%-24s %-10s %s\n', 'Step', 'Status', 'Message');
fprintf('%-24s %-10s %s\n', repmat('-', 1, 24), repmat('-', 1, 10), repmat('-', 1, 32));

steps = statusDoc.steps;
for k = 1:numel(steps)
    fprintf('%-24s %-10s %s\n', ...
        char(string(steps(k).step_id)), ...
        char(string(steps(k).status)), ...
        char(string(steps(k).message)));
end
end

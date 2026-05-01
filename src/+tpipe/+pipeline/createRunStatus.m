function statusDoc = createRunStatus(runDir, runId, stepIds)
%CREATERUNSTATUS Create a minimal JSON run status file.
%
% The status.json file is intentionally simple so a future GUI can read the
% same file without depending on MATLAB pipeline internals.

if nargin < 3
    error('tpipe:pipeline:InvalidInput', 'runDir, runId, and stepIds are required.');
end

runDir = char(string(runDir));
runId = char(string(runId));
stepIds = local_normalize_step_ids(stepIds);

if ~isfolder(runDir)
    mkdir(runDir);
end

nowText = local_now_text();
steps = repmat(struct('step_id', '', 'status', 'pending', ...
    'message', '', 'updated_utc', nowText), numel(stepIds), 1);
for k = 1:numel(stepIds)
    steps(k).step_id = stepIds{k};
end

statusDoc = struct();
statusDoc.schema_version = 'run_status.v0';
statusDoc.run_id = runId;
statusDoc.created_utc = nowText;
statusDoc.updated_utc = nowText;
statusDoc.status_file = fullfile(runDir, 'status.json');
statusDoc.steps = steps;

local_write_status(statusDoc.status_file, statusDoc);
end

function ids = local_normalize_step_ids(stepIds)
if ischar(stepIds)
    ids = {stepIds};
elseif isstring(stepIds)
    ids = cellstr(stepIds(:));
elseif iscellstr(stepIds)
    ids = stepIds(:);
else
    error('tpipe:pipeline:InvalidStepIds', ...
        'stepIds must be a char, string array, or cell array of character vectors.');
end
assert(~isempty(ids), 'tpipe:pipeline:InvalidStepIds', 'stepIds must not be empty.');
for k = 1:numel(ids)
    assert(~isempty(ids{k}), 'tpipe:pipeline:InvalidStepIds', ...
        'stepIds must not contain empty IDs.');
end
end

function local_write_status(path, statusDoc)
txt = jsonencode(statusDoc, 'PrettyPrint', true);
fid = fopen(path, 'w');
assert(fid > 0, 'tpipe:pipeline:StatusWriteFailed', 'Failed to open status file for writing.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', txt);
end

function s = local_now_text()
s = char(datetime("now", "TimeZone", "UTC", "Format", "yyyy-MM-dd'T'HH:mm:ss"));
end

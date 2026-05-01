function statusDoc = updateRunStepStatus(runDir, stepId, stepStatus, message)
%UPDATERUNSTEPSTATUS Update one step in a minimal JSON run status file.

if nargin < 4
    message = '';
end

stepId = char(string(stepId));
stepStatus = char(string(stepStatus));
message = char(string(message));
local_validate_step_status(stepStatus);

statusDoc = ttube.pipeline.readRunStatus(runDir);

idx = local_find_step(statusDoc.steps, stepId);
assert(idx > 0, 'ttube:pipeline:StepNotFound', 'Step not found: %s', stepId);

statusDoc.steps(idx).status = stepStatus;
statusDoc.steps(idx).message = message;
statusDoc.steps(idx).updated_utc = local_now_text();
statusDoc.updated_utc = statusDoc.steps(idx).updated_utc;

local_write_status(fullfile(char(string(runDir)), 'status.json'), statusDoc);
end

function local_validate_step_status(stepStatus)
allowed = {'pending','running','done','failed','skipped'};
tf = false;
for k = 1:numel(allowed)
    if strcmp(stepStatus, allowed{k})
        tf = true;
        break;
    end
end
assert(tf, 'ttube:pipeline:InvalidStepStatus', ...
    'Invalid step status. Allowed values: pending, running, done, failed, skipped.');
end

function idx = local_find_step(steps, stepId)
idx = 0;
for k = 1:numel(steps)
    if strcmp(char(string(steps(k).step_id)), stepId)
        idx = k;
        return;
    end
end
end

function local_write_status(path, statusDoc)
txt = jsonencode(statusDoc, 'PrettyPrint', true);
fid = fopen(path, 'w');
assert(fid > 0, 'ttube:pipeline:StatusWriteFailed', 'Failed to open status file for writing.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', txt);
end

function s = local_now_text()
s = char(datetime("now", "TimeZone", "UTC", "Format", "yyyy-MM-dd'T'HH:mm:ss"));
end

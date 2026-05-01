function statusDoc = readRunStatus(runDir)
%READRUNSTATUS Read a minimal JSON run status file.

statusFile = fullfile(char(string(runDir)), 'status.json');
assert(isfile(statusFile), 'ttube:pipeline:StatusFileNotFound', ...
    'Status file not found: %s', statusFile);

txt = fileread(statusFile);
statusDoc = jsondecode(txt);
statusDoc.status_file = statusFile;
end

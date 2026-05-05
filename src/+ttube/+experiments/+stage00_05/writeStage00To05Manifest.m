function manifest = writeStage00To05Manifest(report, path)
%WRITESTAGE00TO05MANIFEST Write E2E manifest JSON.

manifest = struct();
manifest.schema_version = 'stage00_05_run_manifest.v0';
manifest.profile = report.cfg.profile;
manifest.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
manifest.stage_schemas = struct('stage00',report.stage00.schema_version, ...
    'stage01',report.stage01.schema_version,'stage02',report.stage02.schema_version, ...
    'stage03',report.stage03.schema_version,'stage04',report.stage04.schema_version, ...
    'stage05',report.stage05.schema_version);
manifest.validation_passed = report.validation.passed;
manifest.producer = 'ttube.experiments.stage00_05.runStage00To05Native';
if nargin > 1 && ~isempty(path)
    fid = fopen(path, 'w'); assert(fid > 0, 'ttube:stage00_05:WriteFailed', 'Failed to write manifest.');
    cleanup = onCleanup(@() fclose(fid));
    fprintf(fid, '%s', jsonencode(manifest, 'PrettyPrint', true));
end
end

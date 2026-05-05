function validation = validateStage00To05Outputs(report)
%VALIDATESTAGE00TO05OUTPUTS Validate Stage00-05 E2E output completeness.

checks = struct();
checks.stage00 = strcmp(report.stage00.schema_version, 'stage00_bootstrap.v0');
checks.stage01 = strcmp(report.stage01.schema_version, 'stage01_casebank_bundle.v0') && isfield(report.stage01,'nominal');
checks.stage02 = strcmp(report.stage02.schema_version, 'stage02_trajbank_bundle.v0') && isfield(report.stage02.trajbank,'nominal');
checks.stage03 = strcmp(report.stage03.schema_version, 'stage03_access_bundle.v0') && isfield(report.stage03.visbank,'nominal');
checks.stage04 = strcmp(report.stage04.schema_version, 'stage04_window_gamma_bundle.v0') && isfinite(report.stage04.gamma_req);
checks.stage05 = strcmp(report.stage05.schema_version, 'stage05_search_bundle.v0') && height(report.stage05.search.result_table) > 0;
names = fieldnames(checks);
tf = true;
for k = 1:numel(names), tf = tf && checks.(names{k}); end
validation = struct('schema_version','stage00_05_validation.v0','checks',checks,'passed',tf);
assert(tf, 'ttube:stage00_05:OutputIncomplete', 'Stage00-05 output validation failed.');
end

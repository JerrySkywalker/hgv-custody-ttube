function artifact = packageStage06SearchResult(cfg, scope, trajectoryBank, grid, resultTable, evalBank)
%PACKAGESTAGE06SEARCHRESULT Package native Stage06 search artifact.

summary = ttube.experiments.stage06.summarizeStage06Results(resultTable);
artifact = struct();
artifact.schema_version = 'stage06_heading_search_result.v0';
artifact.cfg = cfg;
artifact.scope = scope;
artifact.family = trajectoryBank.family;
artifact.grid = grid;
artifact.result_table = resultTable;
artifact.summary = summary;
artifact.eval_bank = evalBank;
artifact.backend = 'native';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.producer = 'ttube.experiments.stage06.packageStage06SearchResult';
end

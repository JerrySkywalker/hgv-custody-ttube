function artifact = packageStage05SearchResult(cfg, grid, resultTable, evalBank, caseArtifact, trajectory)
%PACKAGESTAGE05SEARCHRESULT Package native Stage05 search artifact.

resultTable = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable, ...
    struct('backend','native','notes',['trajectoryBackend=' char(string(cfg.trajectoryBackend))]));
summary = ttube.experiments.stage05.summarizeStage05Results(resultTable);

artifact = struct();
artifact.schema_version = 'stage05_search_result.v0';
artifact.cfg = cfg;
artifact.grid = grid;
artifact.result_table = resultTable;
artifact.summary = summary;
artifact.eval_bank = evalBank;
artifact.case = caseArtifact;
artifact.trajectory = trajectory;
artifact.backend = 'native';
artifact.trajectoryBackend = cfg.trajectoryBackend;
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.producer = 'ttube.experiments.stage05.runStage05NominalSearch';
end

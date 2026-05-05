function scope = defineHeadingScope(cfg)
%DEFINEHEADINGSCOPE Build native Stage06 heading scope artifact.

cfg = ttube.experiments.stage06.makeStage06Config(cfg);
offsets = cfg.heading_offsets_deg(:).';
scope = struct();
scope.schema_version = 'stage06_heading_scope.v0';
scope.caseId = cfg.caseId;
scope.heading_mode = char(string(cfg.heading_mode));
scope.heading_offsets_deg = offsets;
scope.num_headings = numel(offsets);
scope.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
scope.notes = 'Native Stage06 heading scope; no legacy helper calls.';
end

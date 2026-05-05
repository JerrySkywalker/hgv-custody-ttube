function family = buildHeadingFamily(cfg, scope)
%BUILDHEADINGFAMILY Build native Stage06 heading case family.

cfg = ttube.experiments.stage06.makeStage06Config(cfg);
if nargin < 2 || isempty(scope)
    scope = ttube.experiments.stage06.defineHeadingScope(cfg);
end
baseCase = ttube.experiments.stage05.buildStage01CasebankNative(cfg.caseCfg);
cases = repmat(baseCase, numel(scope.heading_offsets_deg), 1);
baseHeadingDeg = baseCase.heading_deg;
for k = 1:numel(cases)
    offset = scope.heading_offsets_deg(k);
    caseCfg = cfg.caseCfg;
    caseCfg.heading_deg = baseHeadingDeg + offset;
    c = ttube.experiments.stage05.buildStage01CasebankNative(caseCfg);
    c.case_id = sprintf('%s_H%+g', baseCase.case_id, offset);
    c.family = 'heading';
    c.subfamily = 'heading';
    c.heading_offset_deg = offset;
    cases(k) = c;
end
family = struct();
family.schema_version = 'stage06_heading_family.v0';
family.base_case_id = baseCase.case_id;
family.heading_offsets_deg = scope.heading_offsets_deg;
family.cases = cases;
family.trajectory_ids = strings(numel(cases), 1);
family.backend = 'native_stage01_geodetic';
family.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

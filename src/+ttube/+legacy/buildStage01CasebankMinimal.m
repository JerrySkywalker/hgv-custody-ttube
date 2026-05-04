function caseArtifact = buildStage01CasebankMinimal(cfg)
%BUILDSTAGE01CASEBANKMINIMAL Legacy comparison adapter for one Stage01 case.

caseId = char(string(local_field(cfg, 'caseId', 'N01')));
mode = char(string(local_field(cfg, 'mode', 'cache')));
legacyRoot = char(string(local_field(cfg, 'legacyRoot', ttube.legacy.defaultLegacyRoot())));

switch mode
    case 'cache'
        caseArtifact = local_from_cache(legacyRoot, caseId);
    case 'legacy_function'
        caseArtifact = local_from_function(legacyRoot, caseId, cfg);
    otherwise
        error('ttube:legacy:InvalidMode', 'Unsupported Stage01 minimal mode: %s', mode);
end
end

function caseArtifact = local_from_cache(legacyRoot, caseId)
cacheFile = ttube.legacy.findLatestCache(legacyRoot, 'stage01_scenario_disk_*.mat');
if isempty(cacheFile)
    caseArtifact = local_from_function(legacyRoot, caseId, struct());
    caseArtifact.meta.cache_miss = true;
    return;
end
S = load(cacheFile, 'out');
case_i = ttube.legacy.selectCaseById(S.out.casebank, caseId);
caseArtifact = local_convert(case_i, 'cache', cacheFile);
end

function caseArtifact = local_from_function(legacyRoot, caseId, cfg)
overrides = struct();
if isfield(cfg, 'legacyOverrides')
    overrides = cfg.legacyOverrides;
end
cleanupObj = ttube.legacy.withLegacyPath(legacyRoot); %#ok<NASGU>
legacyCfg = ttube.legacy.loadDefaultParams(legacyRoot, overrides);
casebank = build_casebank_stage01(legacyCfg, struct('mode', 'serial'));
case_i = ttube.legacy.selectCaseById(casebank, caseId);
caseArtifact = local_convert(case_i, 'legacy_function', 'build_casebank_stage01');
end

function caseArtifact = local_convert(case_i, mode, source)
caseArtifact = struct();
caseArtifact.schema_version = 'case.v0';
caseArtifact.case_id = char(string(case_i.case_id));
caseArtifact.family = char(string(case_i.family));
caseArtifact.subfamily = char(string(case_i.subfamily));
caseArtifact.epoch_utc = char(string(case_i.epoch_utc));
caseArtifact.entry_point_eci_km_t0 = case_i.entry_point_eci_km_t0(:).';
caseArtifact.heading_unit_eci_t0 = case_i.heading_unit_eci_t0(:).';
caseArtifact.legacy_case = case_i;
caseArtifact.backend = mode;
caseArtifact.source_fingerprint = source;
caseArtifact.meta = struct('production_alignment', 'legacy_stage01_casebank_fields');
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f)
    v = s.(f);
else
    v = defaultValue;
end
end

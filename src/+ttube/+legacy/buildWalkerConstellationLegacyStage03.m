function walker = buildWalkerConstellationLegacyStage03(cfg)
%BUILDWALKERCONSTELLATIONLEGACYSTAGE03 Legacy comparison adapter.

cleanupObj = ttube.legacy.withLegacyPath(cfg.legacyRoot); %#ok<NASGU>
legacyCfg = ttube.legacy.loadDefaultParams(cfg.legacyRoot, local_legacy_overrides(cfg));
walker = build_single_layer_walker_stage03(legacyCfg);
end

function overrides = local_legacy_overrides(cfg)
overrides = struct();
overrides.stage03 = struct();
fields = {'h_km','i_deg','P','T','F'};
for k = 1:numel(fields)
    f = fields{k};
    if isfield(cfg, f)
        overrides.stage03.(f) = cfg.(f);
    elseif isfield(cfg, 'walker') && isfield(cfg.walker, f)
        overrides.stage03.(f) = cfg.walker.(f);
    end
end
end

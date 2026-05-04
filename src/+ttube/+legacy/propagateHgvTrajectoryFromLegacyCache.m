function artifact = propagateHgvTrajectoryFromLegacyCache(cfg)
%PROPAGATEHGVTRAJECTORYFROMLEGACYCACHE Extract trajectory from legacy cache.

legacyRoot = cfg.legacyRoot;
caseId = cfg.caseId;
cacheFile = '';
if isfield(cfg, 'cacheFile')
    cacheFile = cfg.cacheFile;
end
if isempty(cacheFile)
    cacheFile = ttube.legacy.findLatestCache(legacyRoot, 'stage02_hgv_nominal_*.mat');
end
assert(~isempty(cacheFile) && isfile(cacheFile), 'ttube:traj:CacheNotFound', ...
    'Stage02 cache not found.');
S = load(cacheFile, 'out');
record = ttube.legacy.selectCaseById(S.out.trajbank, caseId);
artifact = ttube.legacy.propagateHgvTrajectoryLegacyStage02(struct( ...
    'legacyRoot', legacyRoot, 'caseId', caseId, 'legacyRecord', record));
artifact.backend = 'cache';
artifact.source_fingerprint = cacheFile;
end

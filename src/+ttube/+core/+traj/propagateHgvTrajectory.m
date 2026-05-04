function artifact = propagateHgvTrajectory(cfg)
%PROPAGATEHGVTRAJECTORY Dispatch HGV trajectory generation backends.

backend = local_get_backend(cfg);
switch backend
    case 'legacy_stage02'
        artifact = ttube.core.traj.propagateHgvTrajectory_legacyStage02(cfg);
    case 'cache'
        artifact = local_from_cache(cfg);
    otherwise
        error('ttube:traj:BackendNotImplemented', ...
            'Unsupported HGV trajectory backend: %s', backend);
end
end

function backend = local_get_backend(cfg)
if isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
elseif isfield(cfg, 'trajBackend')
    backend = char(string(cfg.trajBackend));
else
    backend = 'legacy_stage02';
end
end

function artifact = local_from_cache(cfg)
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
artifact = ttube.core.traj.propagateHgvTrajectory_legacyStage02(struct( ...
    'legacyRoot', legacyRoot, 'caseId', caseId, 'legacyRecord', record));
artifact.backend = 'cache';
artifact.source_fingerprint = cacheFile;
end

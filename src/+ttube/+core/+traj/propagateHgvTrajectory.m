function artifact = propagateHgvTrajectory(cfg)
%PROPAGATEHGVTRAJECTORY Dispatch HGV trajectory generation backends.

backend = local_get_backend(cfg);
switch backend
    case 'native'
        artifact = ttube.core.traj.propagateHgvTrajectoryNative(cfg);
    case 'legacy_stage02'
        artifact = ttube.legacy.propagateHgvTrajectoryLegacyStage02(cfg);
    case 'cache'
        artifact = ttube.legacy.propagateHgvTrajectoryFromLegacyCache(cfg);
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
    backend = 'native';
end
end

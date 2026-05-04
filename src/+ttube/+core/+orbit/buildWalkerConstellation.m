function walker = buildWalkerConstellation(cfg)
%BUILDWALKERCONSTELLATION Dispatch Walker constellation builder backends.

backend = local_backend(cfg);
switch backend
    case 'native'
        walker = ttube.core.orbit.buildWalkerConstellationNative(cfg);
    case 'legacy_stage03'
        walker = ttube.legacy.buildWalkerConstellationLegacyStage03(cfg);
    otherwise
        error('ttube:orbit:BackendNotImplemented', ...
            'Unsupported Walker builder backend: %s', backend);
end
end

function backend = local_backend(cfg)
if isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
elseif isfield(cfg, 'orbitBackend')
    backend = char(string(cfg.orbitBackend));
else
    backend = 'native';
end
end

function walker = buildWalkerConstellation(cfg)
%BUILDWALKERCONSTELLATION Dispatch Walker constellation builder backends.

backend = local_backend(cfg);
switch backend
    case 'legacy_stage03'
        walker = ttube.core.orbit.buildWalkerConstellation_legacyStage03(cfg);
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
    backend = 'legacy_stage03';
end
end

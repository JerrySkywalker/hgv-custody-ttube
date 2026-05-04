function artifact = propagateWalkerConstellation(walker, t_s, cfg)
%PROPAGATEWALKERCONSTELLATION Dispatch Walker propagation backends.

if nargin < 3
    cfg = struct();
end
backend = 'legacy_stage03';
if isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
end
switch backend
    case 'legacy_stage03'
        artifact = ttube.core.orbit.propagateWalkerConstellation_legacyStage03(walker, t_s, cfg);
    otherwise
        error('ttube:orbit:BackendNotImplemented', ...
            'Unsupported Walker propagation backend: %s', backend);
end
end

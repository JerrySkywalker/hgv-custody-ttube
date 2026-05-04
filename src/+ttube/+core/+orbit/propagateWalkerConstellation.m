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
    case 'native'
        artifact = ttube.core.orbit.propagateWalkerConstellationNative(walker, t_s, cfg);
    case 'legacy_stage03'
        artifact = ttube.legacy.propagateWalkerConstellationLegacyStage03(walker, t_s, cfg);
    otherwise
        error('ttube:orbit:BackendNotImplemented', ...
            'Unsupported Walker propagation backend: %s', backend);
end
end

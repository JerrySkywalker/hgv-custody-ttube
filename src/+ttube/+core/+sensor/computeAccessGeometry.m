function artifact = computeAccessGeometry(trajectory, constellation, cfg)
%COMPUTEACCESSGEOMETRY Dispatch access geometry backends.

backend = 'native';
if nargin >= 3 && isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
end
switch backend
    case 'native'
        artifact = ttube.core.sensor.computeAccessGeometryNative(trajectory, constellation, cfg);
    case 'legacy_stage03'
        artifact = ttube.legacy.computeAccessGeometryLegacyStage03(trajectory, constellation, cfg);
    otherwise
        error('ttube:sensor:BackendNotImplemented', ...
            'Unsupported access geometry backend: %s', backend);
end
end

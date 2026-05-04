function artifact = computeAccessGeometry(trajectory, constellation, cfg)
%COMPUTEACCESSGEOMETRY Dispatch access geometry backends.

backend = 'legacy_stage03';
if nargin >= 3 && isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
end
switch backend
    case 'legacy_stage03'
        artifact = ttube.core.sensor.computeAccessGeometry_legacyStage03(trajectory, constellation, cfg);
    otherwise
        error('ttube:sensor:BackendNotImplemented', ...
            'Unsupported access geometry backend: %s', backend);
end
end

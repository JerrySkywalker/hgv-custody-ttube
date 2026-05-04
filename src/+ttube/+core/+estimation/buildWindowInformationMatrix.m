function result = buildWindowInformationMatrix(accessArtifact, constellation, windowArtifact, cfg)
%BUILDWINDOWINFORMATIONMATRIX Dispatch window information matrix backends.

backend = 'native';
if nargin >= 4 && isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
end
switch backend
    case 'native'
        result = ttube.core.estimation.buildWindowInformationMatrixNative( ...
            accessArtifact, constellation, windowArtifact, cfg);
    case 'legacy_stage04'
        result = ttube.legacy.buildWindowInformationMatrixLegacyStage04( ...
            accessArtifact, constellation, windowArtifact, cfg);
    otherwise
        error('ttube:estimation:BackendNotImplemented', ...
            'Unsupported information matrix backend: %s', backend);
end
end

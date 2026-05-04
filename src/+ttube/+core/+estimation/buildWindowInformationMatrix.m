function result = buildWindowInformationMatrix(accessArtifact, constellation, windowArtifact, cfg)
%BUILDWINDOWINFORMATIONMATRIX Dispatch window information matrix backends.

backend = 'legacy_stage04';
if nargin >= 4 && isfield(cfg, 'backend')
    backend = char(string(cfg.backend));
end
switch backend
    case 'legacy_stage04'
        result = ttube.core.estimation.buildWindowInformationMatrix_legacyStage04( ...
            accessArtifact, constellation, windowArtifact, cfg);
    otherwise
        error('ttube:estimation:BackendNotImplemented', ...
            'Unsupported information matrix backend: %s', backend);
end
end

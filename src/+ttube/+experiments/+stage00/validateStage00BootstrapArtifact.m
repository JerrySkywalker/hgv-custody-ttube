function validateStage00BootstrapArtifact(artifact)
%VALIDATESTAGE00BOOTSTRAPARTIFACT Validate Stage00 bootstrap artifact.

assert(isstruct(artifact), 'ttube:stage00:InvalidArtifact', 'Artifact must be a struct.');
assert(strcmp(artifact.schema_version, 'stage00_bootstrap.v0'), ...
    'ttube:stage00:InvalidArtifact', 'Invalid Stage00 schema.');
requiredPaths = {'runDir','outputDir','logs','cache','tables','figs'};
for k = 1:numel(requiredPaths)
    assert(isfield(artifact.paths, requiredPaths{k}) && isfolder(artifact.paths.(requiredPaths{k})), ...
        'ttube:stage00:InvalidArtifact', 'Missing Stage00 path: %s', requiredPaths{k});
end
assert(strcmp(artifact.startup_status, 'ok'), 'ttube:stage00:InvalidArtifact', 'Startup failed.');
end

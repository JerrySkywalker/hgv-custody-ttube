function artifact = loadStage05SearchArtifact(outputDir)
%LOADSTAGE05SEARCHARTIFACT Load saved Stage05 search artifact.

S = load(fullfile(outputDir, 'stage05_search_result.mat'), 'artifact');
artifact = S.artifact;
assert(isfield(artifact, 'schema_version') && strcmp(artifact.schema_version, 'stage05_search_result.v0'), ...
    'ttube:stage05:InvalidSearchArtifact', 'Invalid Stage05 search artifact.');
end

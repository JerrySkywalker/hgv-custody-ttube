function tests = test_stage0103GoldenArtifacts
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
addpath(repoRoot);
startup('force', true);
end

function testGoldenArtifactsPresentOrClearlyPending(testCase)
repoRoot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
artifactDir = fullfile(repoRoot, 'legacy_reference', 'golden_small', 'stage01_03_minimal');
manifestFile = fullfile(artifactDir, 'manifest.json');
exampleManifestFile = fullfile(artifactDir, 'manifest.example.json');

verifyTrue(testCase, isfolder(artifactDir));
verifyTrue(testCase, isfile(exampleManifestFile));

if ~isfile(manifestFile)
    assumeTrue(testCase, false, ...
        'Stage01-03 golden artifacts have not been generated yet; manifest.json is pending.');
end

txt = fileread(manifestFile);
manifest = jsondecode(txt);
verifyTrue(testCase, isfield(manifest, 'artifact_id'));
verifyTrue(testCase, isfield(manifest, 'files'));
end

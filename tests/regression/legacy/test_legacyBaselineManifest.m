function tests = test_legacyBaselineManifest
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
testCase.TestData.manifestPath = fullfile(repoRoot, 'legacy_reference', ...
    'golden_small', 'stage01_03_minimal', 'manifest.example.json');
end

function testRequiredFields(testCase)
manifest = local_read_manifest(testCase);
requiredFields = [
    "schema_version"
    "baseline_id"
    "legacy_repo"
    "legacy_branch"
    "legacy_commit"
    "created_utc"
    "matlab_version"
    "stages"
    "artifacts"
    "notes"
    ];

for k = 1:numel(requiredFields)
    verifyTrue(testCase, isfield(manifest, requiredFields(k)), ...
        "Missing required manifest field: " + requiredFields(k));
end
end

function testStages(testCase)
manifest = local_read_manifest(testCase);
stages = string(manifest.stages);
verifyTrue(testCase, any(stages == "stage01"));
verifyTrue(testCase, any(stages == "stage02"));
verifyTrue(testCase, any(stages == "stage03"));
end

function testArtifacts(testCase)
manifest = local_read_manifest(testCase);
verifyTrue(testCase, isstruct(manifest.artifacts));

artifactFields = [
    "stage01_casebank"
    "stage02_trajbank"
    "stage03_satbank"
    "stage03_visbank"
    ];

for k = 1:numel(artifactFields)
    verifyTrue(testCase, isfield(manifest.artifacts, artifactFields(k)), ...
        "Missing required artifact field: " + artifactFields(k));
end
end

function manifest = local_read_manifest(testCase)
manifestPath = testCase.TestData.manifestPath;
verifyTrue(testCase, isfile(manifestPath), ...
    "Manifest example does not exist: " + string(manifestPath));
manifest = jsondecode(fileread(manifestPath));
end

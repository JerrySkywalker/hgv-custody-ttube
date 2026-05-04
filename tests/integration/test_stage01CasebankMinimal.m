function tests = test_stage01CasebankMinimal
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testBuildN01FromLegacyFunction(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
caseArtifact = ttube.experiments.stage05.buildStage01CasebankMinimal(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'mode', 'legacy_function'));
verifyEqual(testCase, caseArtifact.case_id, 'N01');
verifyEqual(testCase, caseArtifact.family, 'nominal');
verifyTrue(testCase, isfield(caseArtifact, 'entry_point_eci_km_t0'));
verifyTrue(testCase, isfield(caseArtifact, 'heading_unit_eci_t0'));
end

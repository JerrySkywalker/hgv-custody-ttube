function tests = test_stage01NativeVsLegacy
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testN01NativeGeodeticCloseToLegacy(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
if ~isfolder(legacyRoot)
    verifyFail(testCase, sprintf('Legacy root missing: %s', legacyRoot));
end

nativeCase = ttube.experiments.stage05.buildStage01CasebankNative(struct());
legacyCase = ttube.legacy.buildStage01CasebankMinimal(struct( ...
    'legacyRoot', legacyRoot, ...
    'caseId', 'N01', ...
    'mode', 'legacy_function'));
legacyRaw = legacyCase.legacy_case;

verifyEqual(testCase, nativeCase.case_id, legacyCase.case_id);
verifyEqual(testCase, nativeCase.family, legacyCase.family);
verifyEqual(testCase, nativeCase.subfamily, legacyCase.subfamily);
verifyEqual(testCase, nativeCase.entry_theta_deg, legacyRaw.entry_theta_deg, 'AbsTol', 1e-12);
verifyEqual(testCase, nativeCase.heading_deg, legacyRaw.heading_deg, 'AbsTol', 1e-12);
verifyEqual(testCase, norm(nativeCase.heading_unit_eci_t0), 1, 'AbsTol', 1e-12);

legacyR = legacyRaw.entry_point_eci_km_t0(:);
nativeR = nativeCase.entry_point_eci_km_t0(:);
relativePositionError = norm(nativeR - legacyR) / norm(legacyR);
verifyLessThan(testCase, relativePositionError, 1e-9);

headingDot = dot(nativeCase.heading_unit_eci_t0(:), legacyRaw.heading_unit_eci_t0(:));
verifyGreaterThan(testCase, headingDot, 1 - 1e-10);
end

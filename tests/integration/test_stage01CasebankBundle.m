function tests = test_stage01CasebankBundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testTinyCasebankBundle(testCase)
b = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile','tiny'));
verifyEqual(testCase, b.schema_version, 'stage01_casebank_bundle.v0');
verifyEqual(testCase, b.summary.nominal_count, 3);
verifyEqual(testCase, b.summary.heading_count, 3);
verifyEqual(testCase, b.summary.critical_count, 1);
verifyEqual(testCase, norm(b.nominal(1).heading_unit_eci_t0), 1, 'AbsTol', 1e-12);
end

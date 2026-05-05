function tests = test_stage06HeadingScope
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testScope(testCase)
scope = ttube.experiments.stage06.defineHeadingScope(struct('profile','smoke','heading_offsets_deg',[-5 0 5]));
verifyEqual(testCase, scope.schema_version, 'stage06_heading_scope.v0');
verifyEqual(testCase, scope.num_headings, 3);
verifyEqual(testCase, scope.heading_offsets_deg, [-5 0 5]);
end

function testFamilyHeadingNorm(testCase)
fam = ttube.experiments.stage06.buildHeadingFamily(struct('profile','smoke','heading_offsets_deg',[-5 0 5]));
verifyEqual(testCase, numel(fam.cases), 3);
for k = 1:numel(fam.cases)
    verifyEqual(testCase, norm(fam.cases(k).heading_unit_eci_t0), 1, 'AbsTol', 1e-12);
end
end

function tests = test_buildStage01CasebankNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testN01Fields(testCase)
c = ttube.experiments.stage05.buildStage01CasebankNative(struct());
verifyEqual(testCase, c.case_id, 'N01');
verifyEqual(testCase, c.family, 'nominal');
verifyEqual(testCase, c.subfamily, 'nominal');
verifyNotEmpty(testCase, c.epoch_utc);
verifySize(testCase, c.entry_point_enu_km, [3 1]);
verifySize(testCase, c.entry_point_eci_km_t0, [3 1]);
verifySize(testCase, c.heading_unit_enu, [3 1]);
verifySize(testCase, c.heading_unit_eci_t0, [3 1]);
verifyEqual(testCase, norm(c.heading_unit_enu), 1, 'AbsTol', 1e-12);
end

function testDeterministic(testCase)
a = ttube.experiments.stage05.buildStage01CasebankNative(struct());
b = ttube.experiments.stage05.buildStage01CasebankNative(struct());
verifyEqual(testCase, a.entry_point_eci_km_t0, b.entry_point_eci_km_t0);
verifyEqual(testCase, a.heading_unit_eci_t0, b.heading_unit_eci_t0);
end

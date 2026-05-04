function tests = test_buildWalkerConstellationNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testWalkerFields(testCase)
w = ttube.core.orbit.buildWalkerConstellation(struct('backend','native', ...
    'h_km', 1000, 'i_deg', 70, 'P', 2, 'T', 3, 'F', 1));
verifyEqual(testCase, w.Ns, 6);
verifyEqual(testCase, numel(w.sat), 6);
verifyEqual(testCase, [w.sat.plane_id], [1 1 1 2 2 2]);
verifyEqual(testCase, [w.sat.sat_id_in_plane], [1 2 3 1 2 3]);
end

function testKeplerCircularRadius(testCase)
[r, v] = ttube.core.orbit.keplerCircularToEci(7378.137, 70, 0, 0, 398600.4418);
verifyEqual(testCase, norm(r), 7378.137, 'AbsTol', 1e-9);
verifyGreaterThan(testCase, norm(v), 0);
end

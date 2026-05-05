function tests = test_frameTransforms
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testGeodeticEquator(testCase)
r = ttube.core.frames.geodeticToEcef(0, 0, 0);
verifySize(testCase, r, [3 1]);
verifyEqual(testCase, r, [6378.137; 0; 0], 'AbsTol', 1e-9);
end

function testEnuBasisNorms(testCase)
lat = 30;
lon = -160;
east = ttube.core.frames.enuToEcefDirection([1; 0; 0], lat, lon);
north = ttube.core.frames.enuToEcefDirection([0; 1; 0], lat, lon);
up = ttube.core.frames.enuToEcefDirection([0; 0; 1], lat, lon);
verifyEqual(testCase, norm(east), 1, 'AbsTol', 1e-12);
verifyEqual(testCase, norm(north), 1, 'AbsTol', 1e-12);
verifyEqual(testCase, norm(up), 1, 'AbsTol', 1e-12);
verifyEqual(testCase, dot(east, north), 0, 'AbsTol', 1e-12);
end

function testEciRotationFiniteAndDeterministic(testCase)
rEcef = ttube.core.frames.geodeticToEcef(30, -160, 0);
a = ttube.core.frames.ecefToEciSimple(rEcef, '2026-01-01 00:00:00', 0);
b = ttube.core.frames.ecefToEciSimple(rEcef, '2026-01-01 00:00:00', 0);
verifySize(testCase, a, [3 1]);
verifyTrue(testCase, all(isfinite(a)));
verifyEqual(testCase, a, b);
verifyEqual(testCase, norm(a), norm(rEcef), 'RelTol', 1e-12);
end

function testPositionUnits(testCase)
anchor = ttube.core.frames.geodeticToEcef(0, 0, 0);
p = ttube.core.frames.enuToEcefPosition(anchor, [1; 0; 0], 0, 0);
verifyEqual(testCase, norm(p - anchor), 1, 'AbsTol', 1e-12);
verifyTrue(testCase, all(isfinite(p)));
end

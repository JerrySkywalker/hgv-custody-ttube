function tests = test_hgvModelComponents
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testControlProfileFields(testCase)
profile = ttube.core.traj.makeHgvControlProfile(struct(), struct('family', 'nominal'));
verifyTrue(testCase, isfield(profile, 'controlFcn'));
verifyEqual(testCase, profile.alpha_deg, 11.0);
verifyEqual(testCase, profile.bank_deg, 0.0);
u = profile.controlFcn(0, zeros(6, 1), struct());
verifyTrue(testCase, isfield(u, 'alpha_rad'));
verifyTrue(testCase, isfield(u, 'bank_rad'));
end

function testAeroFinite(testCase)
atm = ttube.core.traj.makeHgvAtmosphereModel(struct());
aero = ttube.core.traj.makeHgvAeroModel(struct());
params = struct('atmosphereFcn', atm.atmosphereFcn);
control = struct('alpha_rad', deg2rad(11), 'bank_rad', 0);
[CL, CD] = aero.aeroFcn(5500, 50000, control, params);
verifyTrue(testCase, isfinite(CL));
verifyTrue(testCase, isfinite(CD));
verifyGreaterThan(testCase, CD, 0);
end

function testAtmosphereFiniteNonnegative(testCase)
atm = ttube.core.traj.makeHgvAtmosphereModel(struct());
[rho, a] = atm.atmosphereFcn([0; 50000], struct());
verifyTrue(testCase, all(isfinite(rho)));
verifyTrue(testCase, all(rho >= 0));
verifyTrue(testCase, all(a > 0));
end

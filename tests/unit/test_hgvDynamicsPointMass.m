function tests = test_hgvDynamicsPointMass
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDynamicsFinite(testCase)
params = struct();
params.mass_kg = 907.2;
params.ref_area_m2 = 0.4839;
params.g0_mps2 = 9.80665;
params.controlFcn = @(~,~,~) struct('alpha_rad', deg2rad(11), 'bank_rad', 0);
params.atmosphereFcn = @(~,~) 1e-3;
params.aeroFcn = @(~,~,~,~) deal(0.4, 0.2);
x = [0; 0; 50; 5; 0; -0.2];
dx = ttube.core.traj.hgvDynamicsPointMass(0, x, params);
verifySize(testCase, dx, [6 1]);
verifyTrue(testCase, all(isfinite(dx)));
verifyLessThan(testCase, dx(6), 0);
end

function testRk4Step(testCase)
f = @(~,x,~) -x;
xNext = ttube.core.traj.rk4Step(f, 0, 1, 0.1, struct());
verifyEqual(testCase, xNext, exp(-0.1), 'AbsTol', 1e-5);
end

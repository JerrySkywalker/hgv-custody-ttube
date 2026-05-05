function tests = test_hgvDynamicsVtc
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDerivativeFinite(testCase)
params = local_params();
X = [5500; 0; pi/2; deg2rad(30); deg2rad(-120); 6428137];
dX = ttube.core.traj.hgvDynamicsVtc(0, X, params);
verifySize(testCase, dX, [6 1]);
verifyTrue(testCase, all(isfinite(dX)));
verifyEqual(testCase, dX(6), 0, 'AbsTol', 1e-12);
end

function params = local_params()
atm = ttube.core.traj.makeHgvAtmosphereModel(struct());
aero = ttube.core.traj.makeHgvAeroModel(struct());
control = ttube.core.traj.makeHgvControlProfile(struct(), struct('family', 'nominal'));
params = struct();
params.Re_m = 6378137;
params.mu_m3_s2 = 3.986e14;
params.g0_mps2 = 9.80665;
params.mass_kg = 907.2;
params.ref_area_m2 = 0.4839;
params.controlFcn = control.controlFcn;
params.atmosphereFcn = atm.atmosphereFcn;
params.aeroFcn = aero.aeroFcn;
end

function tests = test_metricBackendInterfaces
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDGProductionFromLambda(testCase)
dg = ttube.core.metrics.computeDGProduction([0.5; 2.0], 1.0);
verifyEqual(testCase, dg.margin, [0.5; 2.0]);
verifyEqual(testCase, dg.feasible, [false; true]);
verifyEqual(testCase, dg.metric_name, 'DG');
end

function testDGProductionFromInfoMatrix(testCase)
info = zeros(3,3,2);
info(:,:,1) = eye(3);
info(:,:,2) = 2 * eye(3);
dg = ttube.core.metrics.computeDGProduction(struct('info_matrix', info), 1.0);
verifyEqual(testCase, dg.margin, [1; 2], 'AbsTol', 1e-12);
end

function testDAIsExplicitlyNotImplemented(testCase)
verifyError(testCase, @() ttube.core.metrics.computeDAProduction(), ...
    'ttube:metrics:BackendNotImplemented');
end

function testOpenDInterface(testCase)
artifact = ttube.core.metrics.computeOpenDInterface();
verifyEqual(testCase, artifact.metric_family, 'OpenD');
verifyFalse(testCase, artifact.production_aligned);
end

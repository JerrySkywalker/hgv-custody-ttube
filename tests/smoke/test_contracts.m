function tests = test_contracts
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
addpath(fullfile(repoRoot, 'tests', 'fixtures'));
testCase.TestData.fixtures = make_minimal_contract_fixtures();
end

function testTrajectoryContract(testCase)
f = testCase.TestData.fixtures;
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(f.trajectory));
bad = rmfield(f.trajectory, 'r_eci_km');
verifyError(testCase, @() ttube.core.traj.validateTrajectoryArtifact(bad), ...
    'ttube:traj:MissingField');
end

function testConstellationContract(testCase)
f = testCase.TestData.fixtures;
verifyTrue(testCase, ttube.core.orbit.validateConstellationStateArtifact(f.constellation));
end

function testAccessContract(testCase)
f = testCase.TestData.fixtures;
verifyTrue(testCase, ttube.core.visibility.validateAccessArtifact(f.access));
end

function testWindowContract(testCase)
f = testCase.TestData.fixtures;
verifyTrue(testCase, ttube.core.visibility.validateWindowArtifact(f.window));
end

function testMetricContract(testCase)
f = testCase.TestData.fixtures;
verifyTrue(testCase, ttube.core.metrics.validateMetricArtifact(f.metric));
bad = f.metric;
bad.pass_ratio = 1.5;
verifyError(testCase, @() ttube.core.metrics.validateMetricArtifact(bad), ...
    'ttube:metrics:InvalidPassRatio');
end

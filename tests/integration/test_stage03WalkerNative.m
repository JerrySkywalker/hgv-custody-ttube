function tests = test_stage03WalkerNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeWalkerArtifact(testCase)
w = ttube.core.orbit.buildWalkerConstellation(struct('backend','native', ...
    'h_km', 1000, 'i_deg', 70, 'P', 2, 'T', 3, 'F', 1));
artifact = ttube.core.orbit.propagateWalkerConstellation(w, (0:10:20).', ...
    struct('backend','native'));
verifyTrue(testCase, ttube.core.orbit.validateConstellationStateArtifact(artifact));
verifySize(testCase, artifact.r_eci_km, [3, 6, 3]);
verifySize(testCase, artifact.v_eci_kmps, [3, 6, 3]);
rnorm = sqrt(sum(artifact.r_eci_km.^2, 3));
verifyEqual(testCase, rnorm, 7378.137 * ones(size(rnorm)), 'AbsTol', 1e-9);
end

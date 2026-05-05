function tests = test_stage02TrajbankBundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testTrajbankBundle(testCase)
s1 = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile','tiny'));
s2 = ttube.experiments.stage02.runStage02HgvTrajbank(s1, struct('profile','tiny','Tmax_s',30,'Ts_s',5));
verifyEqual(testCase, s2.schema_version, 'stage02_trajbank_bundle.v0');
verifyEqual(testCase, s2.summary.nominal_count, 3);
verifyEqual(testCase, s2.summary.heading_count, 3);
verifyEqual(testCase, s2.summary.critical_count, 1);
ttube.core.traj.validateTrajectoryArtifact(s2.trajbank.nominal{1});
end

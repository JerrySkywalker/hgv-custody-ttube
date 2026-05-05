function tests = test_stage03AccessBundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testAccessBundle(testCase)
s1 = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile','tiny'));
s2 = ttube.experiments.stage02.runStage02HgvTrajbank(s1, struct('profile','tiny','Tmax_s',30,'Ts_s',5));
s3 = ttube.experiments.stage03.runStage03VisibilityPipeline(s2, struct('profile','tiny'));
verifyEqual(testCase, s3.schema_version, 'stage03_access_bundle.v0');
verifyEqual(testCase, numel(s3.visbank.nominal), 3);
ttube.core.visibility.validateAccessArtifact(s3.visbank.nominal{1});
end

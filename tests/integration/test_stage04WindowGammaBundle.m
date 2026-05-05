function tests = test_stage04WindowGammaBundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testWindowGammaBundle(testCase)
s1 = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile','tiny'));
s2 = ttube.experiments.stage02.runStage02HgvTrajbank(s1, struct('profile','tiny','Tmax_s',30,'Ts_s',5));
s3 = ttube.experiments.stage03.runStage03VisibilityPipeline(s2, struct('profile','tiny'));
s4 = ttube.experiments.stage04.runStage04WindowWorstcase(s3, struct('profile','tiny','Tw_s',20,'window_step_s',10,'gamma_req',1));
verifyEqual(testCase, s4.schema_version, 'stage04_window_gamma_bundle.v0');
verifyEqual(testCase, s4.gamma_req, 1);
verifyTrue(testCase, isfield(s4.per_family_summary, 'nominal'));
verifyTrue(testCase, isfinite(s4.per_family_summary.nominal.D_G_min));
end

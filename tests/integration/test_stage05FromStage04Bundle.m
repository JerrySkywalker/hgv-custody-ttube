function tests = test_stage05FromStage04Bundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testStage05FromStage04(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
s1 = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile','smoke'));
s2 = ttube.experiments.stage02.runStage02HgvTrajbank(s1, struct('profile','smoke','Tmax_s',30,'Ts_s',5));
s3 = ttube.experiments.stage03.runStage03VisibilityPipeline(s2, struct('profile','smoke'));
s4 = ttube.experiments.stage04.runStage04WindowWorstcase(s3, struct('profile','smoke','Tw_s',20,'window_step_s',10,'gamma_req',1));
s5 = ttube.experiments.stage05.runStage05FromStage04Bundle(s4, struct('profile','smoke','outputDir',outDir,'saveOutputs',false,'makePlots',false,'Tmax_s',30));
verifyEqual(testCase, s5.schema_version, 'stage05_search_bundle.v0');
verifyEqual(testCase, s5.cfg.gamma_req, s4.gamma_req);
verifyEqual(testCase, s5.cfg.Tw_s, s4.Tw_s);
verifyGreaterThan(testCase, height(s5.search.result_table), 0);
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

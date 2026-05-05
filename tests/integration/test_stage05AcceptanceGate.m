function tests = test_stage05AcceptanceGate
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testAcceptanceGateSmoke(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
acc = ttube.experiments.stage05.runStage05AcceptanceGate(struct( ...
    'profile','smoke','outputDir',outDir,'makePlots',true,'saveOutputs',true));
verifyEqual(testCase, acc.status, 'pass');
verifyGreaterThan(testCase, acc.num_designs, 0);
verifyGreaterThanOrEqual(testCase, acc.feasible_count, 0);
verifyTrue(testCase, isfile(acc.artifact_paths.search_mat));
verifyTrue(testCase, isfile(acc.artifact_paths.result_csv));
verifyTrue(testCase, isfield(acc.bundle, 'plot_bundle'));
clear cleanup
end

function testGoldenSafeProfileGuard(testCase)
cfg = ttube.experiments.stage05.makeStage05Profile('golden_safe', struct('saveOutputs',false));
verifyLessThanOrEqual(testCase, cfg.maxDesignsGuard, 300);
verifyLessThanOrEqual(testCase, cfg.Tmax_s, 180);
verifyGreaterThanOrEqual(testCase, cfg.Ts_s, 5);
ttube.experiments.stage05.validateStage05Config(ttube.experiments.stage05.makeStage05Config(cfg));
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

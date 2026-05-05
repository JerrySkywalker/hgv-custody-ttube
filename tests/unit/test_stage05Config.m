function tests = test_stage05Config
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testDefaults(testCase)
cfg = ttube.experiments.stage05.makeStage05Config(struct());
verifyEqual(testCase, cfg.trajectoryBackend, 'native_vtc');
verifyFalse(testCase, cfg.useParallel);
verifyTrue(testCase, ttube.experiments.stage05.validateStage05Config(cfg));
end

function testGridGuard(testCase)
verifyError(testCase, @() ttube.experiments.stage05.makeStage05Config(struct( ...
    'h_grid_km', [800 1000], 'i_grid_deg', 1:20, 'P_grid', 1:10, ...
    'T_grid', 1:10, 'maxDesignsGuard', 10)), 'ttube:stage05:GridTooLarge');
end

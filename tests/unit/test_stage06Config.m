function tests = test_stage06Config
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testDefaults(testCase)
cfg = ttube.experiments.stage06.makeStage06Config(struct('profile','smoke','saveOutputs',false));
verifyEqual(testCase, cfg.caseId, 'N01');
verifyEqual(testCase, cfg.trajectoryBackend, 'native_vtc');
verifyEqual(testCase, numel(cfg.heading_offsets_deg), 3);
verifyFalse(testCase, cfg.useParallel);
end

function testHeadingGuard(testCase)
f = @() ttube.experiments.stage06.makeStage06Config(struct( ...
    'profile','smoke','heading_offsets_deg',-10:10,'maxHeadingsGuard',3));
verifyError(testCase, f, 'ttube:stage06:InvalidHeadingScope');
end

function testGridGuard(testCase)
f = @() ttube.experiments.stage06.makeStage06Config(struct( ...
    'h_grid_km',1:10,'i_grid_deg',1:10,'P_grid',1:5,'T_grid',1:5, ...
    'maxDesignsGuard',10));
verifyError(testCase, f, 'ttube:stage06:GridTooLarge');
end

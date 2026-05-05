function cfg = makeStage05Config(input)
%MAKESTAGE05CONFIG Build normalized Stage05 native config.

if nargin < 1
    input = struct();
end
cfg = struct();
cfg.caseId = local_field(input, 'caseId', 'N01');
cfg.trajectoryBackend = local_field(input, 'trajectoryBackend', 'native_vtc');
cfg.h_grid_km = local_field(input, 'h_grid_km', 1000);
cfg.i_grid_deg = local_field(input, 'i_grid_deg', [60 70]);
cfg.P_grid = local_field(input, 'P_grid', [2 4]);
cfg.T_grid = local_field(input, 'T_grid', [2 3]);
cfg.F_fixed = local_field(input, 'F_fixed', 1);
cfg.Tw_s = local_field(input, 'Tw_s', 30);
cfg.window_step_s = local_field(input, 'window_step_s', 10);
cfg.gamma_req = local_field(input, 'gamma_req', 1.0);
cfg.Tmax_s = local_field(input, 'Tmax_s', 80);
cfg.Ts_s = local_field(input, 'Ts_s', 5);
cfg.outputDir = local_field(input, 'outputDir', fullfile(pwd, 'outputs', 'stage05_native'));
cfg.runDir = local_field(input, 'runDir', '');
cfg.saveOutputs = local_field(input, 'saveOutputs', true);
cfg.makePlots = local_field(input, 'makePlots', false);
cfg.useParallel = local_field(input, 'useParallel', false);
cfg.maxDesignsGuard = local_field(input, 'maxDesignsGuard', 200);
cfg.saveEvalBank = local_field(input, 'saveEvalBank', false);
cfg.resume = local_field(input, 'resume', false);
cfg.profile = local_field(input, 'profile', 'custom');
cfg.sensor = local_field(input, 'sensor', struct());
cfg.stage04 = local_field(input, 'stage04', struct());
cfg.stage04.Tw_s = cfg.Tw_s;
cfg.stage04.window_step_s = cfg.window_step_s;
cfg.caseCfg = local_field(input, 'caseCfg', struct());
cfg.caseCfg.caseId = cfg.caseId;
ttube.experiments.stage05.validateStage05Config(cfg);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

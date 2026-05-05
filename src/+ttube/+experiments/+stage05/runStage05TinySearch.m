function out = runStage05TinySearch(cfg)
%RUNSTAGE05TINYSEARCH Backward-compatible tiny wrapper for nominal search.

if nargin < 1
    cfg = struct();
end
cfg.saveEvalBank = true;
out = ttube.experiments.stage05.runStage05NominalSearch(cfg);
out.schema_version = 'stage05_result_table.v0';
end

function cfg = local_defaults(cfg)
if nargin < 1
    cfg = struct();
end
cfg.caseId = local_field(cfg, 'caseId', 'N01');
cfg.h_grid_km = local_field(cfg, 'h_grid_km', 1000);
cfg.i_grid_deg = local_field(cfg, 'i_grid_deg', [60 70]);
cfg.P_grid = local_field(cfg, 'P_grid', [2 4]);
cfg.T_grid = local_field(cfg, 'T_grid', [2 3]);
cfg.F_fixed = local_field(cfg, 'F_fixed', 1);
cfg.Tw_s = local_field(cfg, 'Tw_s', 30);
cfg.window_step_s = local_field(cfg, 'window_step_s', 10);
cfg.gamma_req = local_field(cfg, 'gamma_req', 1.0);
cfg.outputDir = local_field(cfg, 'outputDir', fullfile(pwd, 'outputs', 'cleanroom_stage01_05_native'));
cfg.runDir = local_field(cfg, 'runDir', '');
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 120);
cfg.Ts_s = local_field(cfg, 'Ts_s', 2);
cfg.trajectoryBackend = local_field(cfg, 'trajectoryBackend', 'native_vtc');
cfg.caseCfg = local_field(cfg, 'caseCfg', struct());
cfg.caseCfg.caseId = cfg.caseId;
cfg.stage04 = local_field(cfg, 'stage04', struct());
cfg.stage04.Tw_s = cfg.Tw_s;
cfg.stage04.window_step_s = cfg.window_step_s;
cfg.sensor = local_field(cfg, 'sensor', struct());
end

function summary = local_summary(T)
summary = struct();
summary.num_designs = height(T);
summary.num_feasible = sum(T.feasible);
summary.pass_ratio = mean(T.feasible);
if any(T.feasible)
    feasibleRows = T(T.feasible, :);
    feasibleRows = sortrows(feasibleRows, {'Ns','D_G'}, {'ascend','descend'});
    summary.best = feasibleRows(1,:);
    summary.best_Ns = feasibleRows.Ns(1);
else
    summary.best = table();
    summary.best_Ns = NaN;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

function out = runStage05TinySearch(cfg)
%RUNSTAGE05TINYSEARCH Run a small Stage01-05 DG pipeline.

cfg = local_defaults(cfg);
if ~isfolder(cfg.outputDir)
    mkdir(cfg.outputDir);
end
if ~isempty(cfg.runDir) && isfolder(cfg.runDir)
    ttube.pipeline.updateRunStepStatus(cfg.runDir, 'run_new_stage01_05_pipeline', 'running', ...
        'Running new Stage01-05 tiny DG pipeline.');
end

caseArtifact = ttube.experiments.stage05.buildStage01CasebankMinimal(struct( ...
    'legacyRoot', cfg.legacyRoot, 'caseId', cfg.caseId, 'mode', 'legacy_function', ...
    'legacyOverrides', cfg.legacyOverrides));
trajectory = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'legacyRoot', cfg.legacyRoot, 'caseId', cfg.caseId, 'backend', cfg.trajBackend, ...
    'legacyOverrides', cfg.legacyOverrides));

grid = ttube.experiments.stage05.buildTinySearchGrid(cfg);
n = height(grid);
lambda_worst = nan(n, 1);
D_G = nan(n, 1);
feasible = false(n, 1);
mean_visible = nan(n, 1);
dual_ratio = nan(n, 1);
eval_bank = cell(n, 1);

for r = 1:n
    res = ttube.experiments.stage05.evaluateWalkerDesignTiny(grid(r,:), trajectory, cfg.gamma_req, cfg);
    eval_bank{r} = res;
    lambda_worst(r) = res.lambda_worst;
    D_G(r) = res.D_G;
    feasible(r) = res.feasible;
    mean_visible(r) = res.num_visible_mean;
    dual_ratio(r) = res.dual_ratio;
end

resultTable = grid;
resultTable.lambda_worst = lambda_worst;
resultTable.D_G = D_G;
resultTable.feasible = feasible;
resultTable.mean_visible = mean_visible;
resultTable.dual_ratio = dual_ratio;
resultTable.gamma_req(:) = cfg.gamma_req;

out = struct();
out.schema_version = 'stage05_tiny_search.v0';
out.case = caseArtifact;
out.trajectory = trajectory;
out.result_table = resultTable;
out.eval_bank = eval_bank;
out.summary = local_summary(resultTable);
out.cfg = cfg;

save(fullfile(cfg.outputDir, 'stage05_tiny_search.mat'), 'out');
writetable(resultTable, fullfile(cfg.outputDir, 'stage05_tiny_search.csv'));

if ~isempty(cfg.runDir) && isfolder(cfg.runDir)
    ttube.pipeline.updateRunStepStatus(cfg.runDir, 'run_new_stage01_05_pipeline', 'done', ...
        'New Stage01-05 tiny DG pipeline completed.');
end
end

function cfg = local_defaults(cfg)
if nargin < 1
    cfg = struct();
end
cfg.legacyRoot = local_field(cfg, 'legacyRoot', ttube.legacy.defaultLegacyRoot());
cfg.caseId = local_field(cfg, 'caseId', 'N01');
cfg.trajBackend = local_field(cfg, 'trajBackend', 'legacy_stage02');
cfg.h_grid_km = local_field(cfg, 'h_grid_km', 1000);
cfg.i_grid_deg = local_field(cfg, 'i_grid_deg', [60 70]);
cfg.P_grid = local_field(cfg, 'P_grid', [2 4]);
cfg.T_grid = local_field(cfg, 'T_grid', [2 3]);
cfg.F_fixed = local_field(cfg, 'F_fixed', 1);
cfg.Tw_s = local_field(cfg, 'Tw_s', 30);
cfg.window_step_s = local_field(cfg, 'window_step_s', 10);
cfg.gamma_req = local_field(cfg, 'gamma_req', 1.0);
cfg.outputDir = local_field(cfg, 'outputDir', fullfile(pwd, 'outputs', 'overnight_stage01_05_alignment'));
cfg.runDir = local_field(cfg, 'runDir', '');
cfg.legacyOverrides = local_field(cfg, 'legacyOverrides', struct());
cfg.legacyOverrides.stage02 = local_merge(local_field(cfg.legacyOverrides, 'stage02', struct()), ...
    struct('Tmax_s', 120, 'Ts_s', 2, 'make_plot', false, 'make_plot_3d', false));
cfg.stage04 = local_field(cfg, 'stage04', struct());
cfg.stage04.Tw_s = cfg.Tw_s;
cfg.stage04.window_step_s = cfg.window_step_s;
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

function s = local_merge(a, b)
s = a;
names = fieldnames(b);
for k = 1:numel(names)
    s.(names{k}) = b.(names{k});
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

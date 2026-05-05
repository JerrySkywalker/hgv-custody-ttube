function oracle = runStage05TinyOracle(cfg)
%RUNSTAGE05TINYORACLE Guarded legacy/helper-level Stage05 tiny oracle.

cfg = local_defaults(cfg);
ttube.legacy.runStage05TinyOracleGuard(cfg);

grid = ttube.experiments.stage05.buildTinySearchGrid(cfg);
n = height(grid);
lambda_worst = nan(n, 1);
D_G = nan(n, 1);
feasible = false(n, 1);
mean_visible = nan(n, 1);
dual_ratio = nan(n, 1);

caseArtifact = ttube.legacy.buildStage01CasebankMinimal(struct( ...
    'legacyRoot', cfg.legacyRoot, 'caseId', cfg.caseId, 'mode', 'legacy_function'));
legacyCase = caseArtifact.legacy_case;
trajectory = ttube.legacy.propagateHgvTrajectoryLegacyStage02(struct( ...
    'legacyRoot', cfg.legacyRoot, 'caseId', cfg.caseId, ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', cfg.Tmax_s, 'Ts_s', cfg.Ts_s))));
trajectory.case_params = legacyCase;

for r = 1:n
    res = ttube.legacy.evaluateStage05TinyDesignLegacy(grid(r,:), trajectory, cfg.gamma_req, cfg);
    lambda_worst(r) = res.lambda_worst;
    D_G(r) = res.D_G;
    feasible(r) = res.feasible;
    mean_visible(r) = res.mean_visible;
    dual_ratio(r) = res.dual_ratio;
end

resultTable = grid;
resultTable.lambda_worst = lambda_worst;
resultTable.D_G = D_G;
resultTable.feasible = feasible;
resultTable.mean_visible = mean_visible;
resultTable.dual_ratio = dual_ratio;
resultTable.gamma_req(:) = cfg.gamma_req;
resultTable = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable, ...
    struct('backend', 'legacy_helper_oracle', 'notes', 'old full Stage05 runner not used'));

oracle = struct();
oracle.schema_version = 'stage05_tiny_oracle.v0';
oracle.oracle_type = 'helper-level';
oracle.used_old_full_stage05_runner = false;
oracle.case = caseArtifact;
oracle.trajectory = trajectory;
oracle.result_table = resultTable;
oracle.cfg = cfg;
oracle.notes = 'Guarded helper-level oracle; no old full Stage05 runner, plotting, or large grid.';
end

function cfg = local_defaults(cfg)
if nargin < 1
    cfg = struct();
end
cfg.legacyRoot = local_field(cfg, 'legacyRoot', ttube.legacy.defaultLegacyRoot());
cfg.caseId = local_field(cfg, 'caseId', 'N01');
cfg.h_grid_km = local_field(cfg, 'h_grid_km', 1000);
cfg.i_grid_deg = local_field(cfg, 'i_grid_deg', [60 70]);
cfg.P_grid = local_field(cfg, 'P_grid', [2 4]);
cfg.T_grid = local_field(cfg, 'T_grid', [2 3]);
cfg.F_fixed = local_field(cfg, 'F_fixed', 1);
cfg.Tw_s = local_field(cfg, 'Tw_s', 30);
cfg.window_step_s = local_field(cfg, 'window_step_s', 10);
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 80);
cfg.Ts_s = local_field(cfg, 'Ts_s', 5);
cfg.gamma_req = local_field(cfg, 'gamma_req', 1.0);
cfg.make_plot = local_field(cfg, 'make_plot', false);
cfg.save_fig = local_field(cfg, 'save_fig', false);
cfg.use_parallel = local_field(cfg, 'use_parallel', false);
cfg.stage04 = local_field(cfg, 'stage04', struct());
cfg.stage04.Tw_s = cfg.Tw_s;
cfg.stage04.window_step_s = cfg.window_step_s;
cfg.sensor = local_field(cfg, 'sensor', struct());
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

function comparison = compareStage05TinyWithLegacy(cfg)
%COMPARESTAGE05TINYWITHLEGACY Compare native tiny search to legacy helpers.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);

native = ttube.experiments.stage05.runStage05TinySearch(cfg);
legacy = local_run_legacy_helper_grid(cfg);

comparison = struct();
comparison.schema_version = 'stage05_tiny_comparison.v0';
comparison.native = native;
comparison.legacy = legacy;
comparison.rows_match = height(native.result_table) == height(legacy.result_table);
comparison.Ns_match = isequal(native.result_table.Ns, legacy.result_table.Ns);
comparison.D_G_abs_diff = abs(native.result_table.D_G - legacy.result_table.D_G);
comparison.D_G_max_abs_diff = max(comparison.D_G_abs_diff);
comparison.feasible_match_fraction = mean(native.result_table.feasible == legacy.result_table.feasible);
comparison.blocked = false;
comparison.notes = ['Legacy comparison uses helper adapters only. It does not run ' ...
    'the old Stage05 runner or any full cache-backed scan.'];
end

function legacy = local_run_legacy_helper_grid(cfg)
legacyRoot = cfg.legacyRoot;
caseArtifact = ttube.legacy.buildStage01CasebankMinimal(struct( ...
    'legacyRoot', legacyRoot, 'caseId', cfg.caseId, 'mode', 'legacy_function'));
legacyCase = caseArtifact.legacy_case;
trajectory = ttube.legacy.propagateHgvTrajectoryLegacyStage02(struct( ...
    'legacyRoot', legacyRoot, 'caseId', cfg.caseId, ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', cfg.Tmax_s, 'Ts_s', cfg.Ts_s))));
trajectory.case_params = legacyCase;

grid = ttube.experiments.stage05.buildTinySearchGrid(cfg);
n = height(grid);
lambda_worst = nan(n, 1);
D_G = nan(n, 1);
feasible = false(n, 1);
for r = 1:n
    res = ttube.experiments.stage05.evaluateWalkerDesignTiny(grid(r,:), trajectory, cfg.gamma_req, cfg);
    lambda_worst(r) = res.lambda_worst;
    D_G(r) = res.D_G;
    feasible(r) = res.feasible;
end
resultTable = grid;
resultTable.lambda_worst = lambda_worst;
resultTable.D_G = D_G;
resultTable.feasible = feasible;
legacy = struct('result_table', resultTable, 'case', caseArtifact, 'trajectory', trajectory);
end

function cfg = local_defaults(cfg)
cfg.legacyRoot = local_field(cfg, 'legacyRoot', ttube.legacy.defaultLegacyRoot());
cfg.caseId = local_field(cfg, 'caseId', 'N01');
cfg.outputDir = local_field(cfg, 'outputDir', tempname);
cfg.h_grid_km = local_field(cfg, 'h_grid_km', 1000);
cfg.i_grid_deg = local_field(cfg, 'i_grid_deg', [60 70]);
cfg.P_grid = local_field(cfg, 'P_grid', [2 4]);
cfg.T_grid = local_field(cfg, 'T_grid', [2 3]);
cfg.F_fixed = local_field(cfg, 'F_fixed', 1);
cfg.Tw_s = local_field(cfg, 'Tw_s', 20);
cfg.window_step_s = local_field(cfg, 'window_step_s', 10);
cfg.Tmax_s = local_field(cfg, 'Tmax_s', 40);
cfg.Ts_s = local_field(cfg, 'Ts_s', 5);
cfg.gamma_req = local_field(cfg, 'gamma_req', 1.0);
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

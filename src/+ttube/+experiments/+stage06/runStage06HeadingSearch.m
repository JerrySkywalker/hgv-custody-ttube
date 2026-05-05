function out = runStage06HeadingSearch(input)
%RUNSTAGE06HEADINGSEARCH Run native Stage06 heading-family Walker search.

cfg = ttube.experiments.stage06.makeStage06Config(input);
if ~isfolder(cfg.outputDir), mkdir(cfg.outputDir); end
scope = ttube.experiments.stage06.defineHeadingScope(cfg);
family = ttube.experiments.stage06.buildHeadingFamily(cfg, scope);
bank = ttube.experiments.stage06.generateHeadingTrajectoryBank(cfg, family);
grid = ttube.experiments.stage05.buildStage05SearchGrid(cfg);
n = height(grid);

DgMin = nan(n, 1); DgMean = nan(n, 1);
lambdaMin = nan(n, 1); passRatio = nan(n, 1);
worstOffset = nan(n, 1); feasible = false(n, 1);
meanVisible = nan(n, 1); dualRatio = nan(n, 1);
evalBank = cell(n, 1);
for r = 1:n
    ev = ttube.experiments.stage06.evaluateHeadingWalkerDesignNative(grid(r,:), bank, cfg.gamma_req, cfg);
    evalBank{r} = ev;
    DgMin(r) = ev.D_G_min;
    DgMean(r) = ev.D_G_mean;
    lambdaMin(r) = ev.lambda_worst_min;
    passRatio(r) = ev.pass_ratio;
    worstOffset(r) = ev.worst_heading_offset_deg;
    feasible(r) = ev.feasible;
    meanVisible(r) = ev.mean_visible;
    dualRatio(r) = ev.dual_ratio;
end

rt = grid;
rt.design_id = strings(n, 1);
for r = 1:n
    rt.design_id(r) = sprintf('h%.0f_i%.0f_P%d_T%d_F%d', rt.h_km(r), rt.i_deg(r), rt.P(r), rt.T(r), rt.F(r));
end
rt.gamma_req(:) = cfg.gamma_req;
rt.lambda_worst = lambdaMin;
rt.lambda_worst_min = lambdaMin;
rt.D_G = DgMin;
rt.D_G_min = DgMin;
rt.D_G_mean = DgMean;
rt.pass_ratio = passRatio;
rt.worst_heading_offset_deg = worstOffset;
rt.feasible = feasible;
rt.mean_visible = meanVisible;
rt.dual_ratio = dualRatio;
rt.backend = repmat("native", n, 1);
out = ttube.experiments.stage06.packageStage06SearchResult(cfg, scope, bank, grid, rt, evalBank);
end

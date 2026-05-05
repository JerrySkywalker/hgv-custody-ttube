function out = runStage05NominalSearch(input)
%RUNSTAGE05NOMINALSEARCH Run native Stage05 nominal Walker search.

cfg = ttube.experiments.stage05.makeStage05Config(input);
if cfg.resume && isfolder(cfg.outputDir)
    try
        out = ttube.experiments.stage05.loadStage05SearchArtifact(cfg.outputDir);
        return;
    catch
        % Fall through to recompute if artifact is incomplete or incompatible.
    end
end
if ~isfolder(cfg.outputDir)
    mkdir(cfg.outputDir);
end

caseArtifact = ttube.experiments.stage05.buildStage01CasebankNative(cfg.caseCfg);
trajectory = ttube.core.traj.propagateHgvTrajectory(struct( ...
    'backend', cfg.trajectoryBackend, 'case', caseArtifact, ...
    'Tmax_s', cfg.Tmax_s, 'Ts_s', cfg.Ts_s));
grid = ttube.experiments.stage05.buildStage05SearchGrid(cfg);
n = height(grid);
lambdaWorst = nan(n, 1);
Dg = nan(n, 1);
feasible = false(n, 1);
meanVisible = nan(n, 1);
dualRatio = nan(n, 1);
if cfg.saveEvalBank
    evalBank = cell(n, 1);
else
    evalBank = {};
end

for r = 1:n
    res = ttube.experiments.stage05.evaluateStage05DesignNative(grid(r,:), trajectory, cfg.gamma_req, cfg);
    if cfg.saveEvalBank
        evalBank{r} = res;
    end
    lambdaWorst(r) = res.lambda_worst;
    Dg(r) = res.D_G;
    feasible(r) = res.feasible;
    meanVisible(r) = res.num_visible_mean;
    dualRatio(r) = res.dual_ratio;
end

resultTable = grid;
resultTable.lambda_worst = lambdaWorst;
resultTable.D_G = Dg;
resultTable.feasible = feasible;
resultTable.mean_visible = meanVisible;
resultTable.dual_ratio = dualRatio;
resultTable.gamma_req(:) = cfg.gamma_req;
out = ttube.experiments.stage05.packageStage05SearchResult(cfg, grid, resultTable, evalBank, caseArtifact, trajectory);
if cfg.saveOutputs
    ttube.experiments.stage05.saveStage05SearchArtifact(out, cfg.outputDir);
end
end

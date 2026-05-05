function result = evaluateHeadingWalkerDesignNative(row, trajectoryBank, gammaReq, cfg)
%EVALUATEHEADINGWALKERDESIGNNATIVE Evaluate one design across heading family.

n = numel(trajectoryBank.trajectories);
Dg = nan(n, 1);
lambda = nan(n, 1);
feasible = false(n, 1);
meanVisible = nan(n, 1);
dualRatio = nan(n, 1);
for k = 1:n
    r = ttube.experiments.stage05.evaluateStage05DesignNative(row, trajectoryBank.trajectories{k}, gammaReq, cfg);
    Dg(k) = r.D_G;
    lambda(k) = r.lambda_worst;
    feasible(k) = r.feasible;
    meanVisible(k) = r.num_visible_mean;
    dualRatio(k) = r.dual_ratio;
end
[DgMin, worstIdx] = min(Dg);
result = struct();
result.schema_version = 'stage06_design_eval.v0';
result.D_G_by_heading = Dg;
result.lambda_worst_by_heading = lambda;
result.feasible_by_heading = feasible;
result.D_G_min = DgMin;
result.D_G_mean = mean(Dg, 'omitnan');
result.lambda_worst_min = min(lambda, [], 'omitnan');
result.lambda_worst_mean = mean(lambda, 'omitnan');
result.pass_ratio = mean(feasible);
result.worst_heading_offset_deg = trajectoryBank.family.heading_offsets_deg(worstIdx);
result.feasible = result.pass_ratio >= 1 && result.D_G_min >= 1;
result.mean_visible = mean(meanVisible, 'omitnan');
result.dual_ratio = mean(dualRatio, 'omitnan');
result.backend = 'native';
end

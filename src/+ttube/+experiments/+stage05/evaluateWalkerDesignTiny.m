function result = evaluateWalkerDesignTiny(row, trajectory, gamma_req, cfg)
%EVALUATEWALKERDESIGNTINY Evaluate one tiny Walker design using DG only.

walkerCfg = struct('legacyRoot', cfg.legacyRoot, 'backend', 'legacy_stage03', ...
    'h_km', row.h_km, 'i_deg', row.i_deg, 'P', row.P, 'T', row.T, 'F', row.F);
walker = ttube.core.orbit.buildWalkerConstellation(walkerCfg);
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, trajectory.t_s, ...
    struct('legacyRoot', cfg.legacyRoot, 'backend', 'legacy_stage03', ...
    'epoch_utc', trajectory.epoch_utc));

access = ttube.core.sensor.computeAccessGeometry(trajectory, constellation, ...
    struct('legacyRoot', cfg.legacyRoot, 'backend', 'legacy_stage03'));
window = ttube.core.visibility.buildWindowGrid(access, cfg.Tw_s, cfg.window_step_s);
info = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, ...
    struct('legacyRoot', cfg.legacyRoot, 'backend', 'legacy_stage04', 'stage04', cfg.stage04));
dg = ttube.core.metrics.computeDGProduction(info.lambda_worst, gamma_req);

result = struct();
result.walker = walker;
result.constellation = constellation;
result.access = access;
result.window = window;
result.info = info;
result.dg = dg;
result.lambda_worst = info.lambda_worst;
result.D_G = dg.margin;
result.feasible = dg.feasible;
result.num_visible_mean = mean(access.num_visible, 'omitnan');
result.dual_ratio = mean(access.dual_coverage_mask, 'omitnan');
end

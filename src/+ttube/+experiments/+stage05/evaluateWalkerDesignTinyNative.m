function result = evaluateWalkerDesignTinyNative(row, trajectory, gamma_req, cfg)
%EVALUATEWALKERDESIGNTINYNATIVE Evaluate one tiny Walker design using native backends.

walkerCfg = struct('backend', 'native', 'h_km', row.h_km, 'i_deg', row.i_deg, ...
    'P', row.P, 'T', row.T, 'F', row.F);
walker = ttube.core.orbit.buildWalkerConstellation(walkerCfg);
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, trajectory.t_s, ...
    struct('backend', 'native', 'epoch_utc', trajectory.epoch_utc));
access = ttube.core.sensor.computeAccessGeometry(trajectory, constellation, ...
    local_sensor_cfg(cfg));
window = ttube.core.visibility.buildWindowGrid(access, cfg.Tw_s, cfg.window_step_s);
info = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, ...
    struct('backend', 'native', 'stage04', cfg.stage04));
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

function sensorCfg = local_sensor_cfg(cfg)
sensorCfg = struct('backend', 'native');
if isfield(cfg, 'sensor')
    names = fieldnames(cfg.sensor);
    for k = 1:numel(names)
        sensorCfg.(names{k}) = cfg.sensor.(names{k});
    end
end
end

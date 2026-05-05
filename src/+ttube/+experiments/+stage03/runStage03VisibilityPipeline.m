function bundle = runStage03VisibilityPipeline(stage02Bundle, cfg)
%RUNSTAGE03VISIBILITYPIPELINE Build native Stage03 constellation/access bundle.

if nargin < 2, cfg = struct(); end
walkerCfg = struct('backend','native','h_km',local_field(cfg,'h_km',1000), ...
    'i_deg',local_field(cfg,'i_deg',60),'P',local_field(cfg,'P',2), ...
    'T',local_field(cfg,'T',2),'F',local_field(cfg,'F',1));
walker = ttube.core.orbit.buildWalkerConstellation(walkerCfg);
sampleTraj = stage02Bundle.trajbank.nominal{1};
constellation = ttube.core.orbit.propagateWalkerConstellation(walker, sampleTraj.t_s, ...
    struct('backend','native','epoch_utc',sampleTraj.epoch_utc));
visbank = struct();
visbank.nominal = local_access(stage02Bundle.trajbank.nominal, constellation, cfg);
visbank.heading = local_access(stage02Bundle.trajbank.heading, constellation, cfg);
visbank.critical = local_access(stage02Bundle.trajbank.critical, constellation, cfg);
summary = ttube.experiments.stage03.summarizeStage03AccessBundle(visbank);
bundle = ttube.experiments.stage03.packageStage03AccessBundle(cfg, walker, constellation, visbank, summary);
end

function out = local_access(trajs, constellation, cfg)
out = cell(numel(trajs), 1);
sensor = local_field(cfg, 'sensor', struct('backend','native','max_range_km',10000, ...
    'require_earth_occlusion_check',false,'enable_offnadir_constraint',false));
for k = 1:numel(trajs)
    access = ttube.core.sensor.computeAccessGeometry(trajs{k}, constellation, sensor);
    ttube.core.visibility.validateAccessArtifact(access);
    out{k} = access;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

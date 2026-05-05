function bundle = runStage05FullNative(input)
%RUNSTAGE05FULLNATIVE Run full native Stage05 module pipeline.

if nargin < 1, input = struct(); end
profile = local_field(input, 'profile', 'tiny');
cfgInput = local_apply_profile(input, profile);
cfg = ttube.experiments.stage05.makeStage05Config(cfgInput);
if ~isfolder(cfg.outputDir), mkdir(cfg.outputDir); end

search = ttube.experiments.stage05.runStage05NominalSearch(cfg);
summary = ttube.experiments.stage05.summarizeStage05Results(search.result_table);
frontier = ttube.experiments.stage05.extractStage05Frontier(search.result_table);
pareto = ttube.experiments.stage05.analyzeStage05ParetoTransition(search.result_table);
plotBundle = struct('schema_version','stage05_plot_bundle.v0','files',struct(),'outputDir',cfg.outputDir,'notes','plots disabled');
if cfg.makePlots
    plotBundle = ttube.viz.stage05.exportStage05PlotBundle(search, frontier, pareto, cfg.outputDir, struct('visible',false));
end

bundle = struct();
bundle.schema_version = 'stage05_full_native_bundle.v0';
bundle.cfg = cfg;
bundle.search = search;
bundle.summary = summary;
bundle.frontier = frontier;
bundle.pareto = pareto;
bundle.plot_bundle = plotBundle;
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
bundle.producer = 'ttube.experiments.stage05.runStage05FullNative';

if cfg.saveOutputs
    ttube.experiments.stage05.saveStage05SearchArtifact(search, cfg.outputDir);
    save(fullfile(cfg.outputDir, 'stage05_full_native_bundle.mat'), 'bundle');
end
end

function cfg = local_apply_profile(input, profile)
cfg = input;
cfg.profile = profile;
switch char(string(profile))
    case 'smoke'
        cfg.h_grid_km = local_field(cfg,'h_grid_km',1000);
        cfg.i_grid_deg = local_field(cfg,'i_grid_deg',60);
        cfg.P_grid = local_field(cfg,'P_grid',2);
        cfg.T_grid = local_field(cfg,'T_grid',2);
        cfg.Tmax_s = local_field(cfg,'Tmax_s',30);
        cfg.maxDesignsGuard = local_field(cfg,'maxDesignsGuard',20);
    case 'tiny'
        cfg.h_grid_km = local_field(cfg,'h_grid_km',1000);
        cfg.i_grid_deg = local_field(cfg,'i_grid_deg',[60 70]);
        cfg.P_grid = local_field(cfg,'P_grid',[2 4]);
        cfg.T_grid = local_field(cfg,'T_grid',[2 3]);
        cfg.Tmax_s = local_field(cfg,'Tmax_s',80);
        cfg.maxDesignsGuard = local_field(cfg,'maxDesignsGuard',50);
    case 'medium_safe'
        cfg.h_grid_km = local_field(cfg,'h_grid_km',[800 1000]);
        cfg.i_grid_deg = local_field(cfg,'i_grid_deg',[40 50 60 70]);
        cfg.P_grid = local_field(cfg,'P_grid',[2 4 6]);
        cfg.T_grid = local_field(cfg,'T_grid',[2 3 4]);
        cfg.Tmax_s = local_field(cfg,'Tmax_s',120);
        cfg.maxDesignsGuard = local_field(cfg,'maxDesignsGuard',200);
end
cfg.trajectoryBackend = local_field(cfg,'trajectoryBackend','native_vtc');
cfg.Ts_s = local_field(cfg,'Ts_s',5);
cfg.Tw_s = local_field(cfg,'Tw_s',30);
cfg.window_step_s = local_field(cfg,'window_step_s',10);
cfg.F_fixed = local_field(cfg,'F_fixed',1);
cfg.gamma_req = local_field(cfg,'gamma_req',1.0);
cfg.saveOutputs = local_field(cfg,'saveOutputs',true);
cfg.makePlots = local_field(cfg,'makePlots',false);
cfg.sensor = local_field(cfg,'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

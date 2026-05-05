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
cfg = ttube.experiments.stage05.makeStage05Profile(profile, input);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

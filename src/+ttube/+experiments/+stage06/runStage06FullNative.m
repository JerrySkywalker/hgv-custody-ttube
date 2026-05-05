function bundle = runStage06FullNative(input)
%RUNSTAGE06FULLNATIVE Run full native Stage06 heading-family pipeline.

if nargin < 1, input = struct(); end
profile = local_field(input, 'profile', 'tiny');
cfg = ttube.experiments.stage06.makeStage06Config(input);
if ~isfolder(cfg.outputDir), mkdir(cfg.outputDir); end

stage05Input = cfg;
stage05Input.profile = cfg.stage05Profile;
stage05Input.outputDir = fullfile(cfg.outputDir, 'stage05_baseline');
stage05Input.makePlots = false;
stage05Input.saveOutputs = cfg.saveOutputs;
stage05 = ttube.experiments.stage05.runStage05AcceptanceGate(stage05Input);

search = ttube.experiments.stage06.runStage06HeadingSearch(cfg);
summary = ttube.experiments.stage06.summarizeStage06Results(search.result_table);
frontier = ttube.experiments.stage06.extractStage06Frontier(search.result_table);
comparison = ttube.experiments.stage06.compareStage06WithStage05(stage05.bundle.search, search);
plotBundle = struct('schema_version','stage06_plot_bundle.v0','files',struct(),'outputDir',cfg.outputDir,'notes','plots disabled');
if cfg.makePlots
    plotBundle = ttube.viz.stage06.exportStage06PlotBundle(search, frontier, comparison, cfg.outputDir, struct('visible',false));
end

bundle = struct();
bundle.schema_version = 'stage06_full_native_bundle.v0';
bundle.profile = char(string(profile));
bundle.cfg = cfg;
bundle.stage05_acceptance = rmfield(stage05, 'bundle');
bundle.stage05_search = stage05.bundle.search;
bundle.search = search;
bundle.summary = summary;
bundle.frontier = frontier;
bundle.comparison = comparison;
bundle.plot_bundle = plotBundle;
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
bundle.producer = 'ttube.experiments.stage06.runStage06FullNative';

if cfg.saveOutputs
    save(fullfile(cfg.outputDir, 'stage06_full_native_bundle.mat'), 'bundle');
    writetable(search.result_table, fullfile(cfg.outputDir, 'stage06_result_table.csv'));
    local_write_json(fullfile(cfg.outputDir, 'stage06_summary.json'), summary);
end
end

function local_write_json(path, data)
fid = fopen(path, 'w');
assert(fid > 0, 'ttube:stage06:WriteFailed', 'Failed to write %s', path);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', jsonencode(data, 'PrettyPrint', true));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

function bundle = exportStage05PlotBundle(searchArtifact, frontier, pareto, outputDir, opts)
%EXPORTSTAGE05PLOTBUNDLE Export Stage05 native plot bundle.
if nargin < 5, opts = struct(); end
if ~isfolder(outputDir), mkdir(outputDir); end
files = struct();
fig = ttube.viz.stage05.plotFeasibleScatter(searchArtifact.result_table, opts);
files.feasible_scatter = local_export(fig, fullfile(outputDir, 'stage05_feasible_scatter.png'));
fig = ttube.viz.stage05.plotInclinationFrontier(frontier, opts);
files.inclination_frontier = local_export(fig, fullfile(outputDir, 'stage05_inclination_frontier.png'));
fig = ttube.viz.stage05.plotPassRatioHeatmap(searchArtifact.summary, opts);
files.pass_ratio = local_export(fig, fullfile(outputDir, 'stage05_pass_ratio.png'));
fig = ttube.viz.stage05.plotParetoFront(pareto, opts);
files.pareto_front = local_export(fig, fullfile(outputDir, 'stage05_pareto_front.png'));
bundle = struct('schema_version','stage05_plot_bundle.v0','files',files, ...
    'outputDir',outputDir,'created_utc',char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss")), ...
    'notes','Native plots consume artifacts and do not recompute metrics.');
end

function path = local_export(fig, path)
set(fig, 'PaperPositionMode', 'auto');
print(fig, path, '-dpng', '-r80');
close(fig);
end

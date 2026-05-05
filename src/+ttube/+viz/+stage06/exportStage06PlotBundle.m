function bundle = exportStage06PlotBundle(stage06Artifact, frontier, comparison, outputDir, opts)
%EXPORTSTAGE06PLOTBUNDLE Export native Stage06 plot bundle.

if nargin < 5, opts = struct(); end
if ~isfolder(outputDir), mkdir(outputDir); end
files = struct();
fig = ttube.viz.stage06.plotHeadingRobustness(stage06Artifact, opts);
files.robustness_png = local_print(fig, fullfile(outputDir, 'stage06_heading_robustness.png'));
fig = ttube.viz.stage06.plotHeadingFrontier(frontier, opts);
files.frontier_png = local_print(fig, fullfile(outputDir, 'stage06_heading_frontier.png'));
fig = ttube.viz.stage06.plotStage05VsStage06Comparison(comparison, opts);
files.comparison_png = local_print(fig, fullfile(outputDir, 'stage06_vs_stage05_comparison.png'));
bundle = struct('schema_version','stage06_plot_bundle.v0', ...
    'files',files,'outputDir',outputDir, ...
    'notes','Native Stage06 plots consume artifacts and do not recompute metrics.');
end

function path = local_print(fig, path)
set(fig, 'PaperPositionMode', 'auto');
print(fig, path, '-dpng', '-r80');
close(fig);
end

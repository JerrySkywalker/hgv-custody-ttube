function fig = plotFeasibleScatter(resultTable, opts)
%PLOTFEASIBLESCATTER Plot feasible Ns vs D_G scatter.
if nargin < 2, opts = struct(); end
T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
fig = figure('Visible', local_visible(opts));
hold on; grid on;
scatter(T.Ns, T.D_G, 36, double(T.feasible), 'filled');
xlabel('Ns'); ylabel('D_G'); title('Stage05 feasible scatter');
end

function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v='on'; else, v='off'; end
end

function fig = plotParetoFront(pareto, opts)
%PLOTPARETOFRONT Plot Pareto front in Ns-D_G.
if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts)); hold on; grid on;
T = pareto.pareto_table;
if ~isempty(T)
    plot(T.Ns, T.D_G, '-o');
end
xlabel('Ns'); ylabel('D_G'); title('Stage05 Pareto front');
end
function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v='on'; else, v='off'; end
end

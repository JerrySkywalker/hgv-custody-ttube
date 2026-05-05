function fig = plotInclinationFrontier(frontier, opts)
%PLOTINCLINATIONFRONTIER Plot inclination frontier rows.
if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts)); hold on; grid on;
T = frontier.inclination_frontier;
if ~isempty(T)
    plot(T.i_deg, T.Ns, '-o');
end
xlabel('Inclination deg'); ylabel('Frontier Ns'); title('Stage05 inclination frontier');
end
function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v='on'; else, v='off'; end
end

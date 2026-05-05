function fig = plotHeadingFrontier(frontier, opts)
%PLOTHEADINGFRONTIER Plot Stage06 inclination frontier.

if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts));
t = frontier.by_inclination;
plot(t.i_deg, t.min_Ns, '-o', 'LineWidth', 1.2);
xlabel('Inclination deg'); ylabel('Minimum feasible Ns'); grid on;
title('Stage06 heading-family frontier');
end

function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v = 'on'; else, v = 'off'; end
end

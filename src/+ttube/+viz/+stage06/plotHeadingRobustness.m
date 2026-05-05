function fig = plotHeadingRobustness(stage06Artifact, opts)
%PLOTHEADINGROBUSTNESS Plot robust D_G by satellite count.

if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts));
t = stage06Artifact.result_table;
scatter(t.Ns, t.D_G_min, 32, t.worst_heading_offset_deg, 'filled');
xlabel('Ns'); ylabel('D_G min over headings'); grid on; colorbar;
title('Stage06 heading robustness');
end

function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v = 'on'; else, v = 'off'; end
end

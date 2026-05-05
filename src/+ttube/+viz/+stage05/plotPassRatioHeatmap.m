function fig = plotPassRatioHeatmap(summary, opts)
%PLOTPASSRATIOHEATMAP Plot pass ratio by Ns.
if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts));
T = summary.per_Ns_table;
if isempty(T)
    plot(nan, nan);
else
    bar(T.Ns, T.pass_ratio);
end
xlabel('Ns'); ylabel('Pass ratio'); title('Stage05 pass ratio');
grid on;
end
function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v='on'; else, v='off'; end
end

function fig = plotStage05VsStage06Comparison(comparison, opts)
%PLOTSTAGE05VSSTAGE06COMPARISON Plot nominal vs heading robust D_G.

if nargin < 2, opts = struct(); end
fig = figure('Visible', local_visible(opts));
t = comparison.joined_table;
plot(t.Ns, t.D_G_05, 'o', t.Ns, t.D_G_06, 'x', 'LineWidth', 1.2);
xlabel('Ns'); ylabel('D_G'); legend({'Stage05 nominal','Stage06 robust'}, 'Location','best');
grid on; title('Stage05 vs Stage06 robust comparison');
end

function v = local_visible(opts)
if isfield(opts,'visible') && opts.visible, v = 'on'; else, v = 'off'; end
end

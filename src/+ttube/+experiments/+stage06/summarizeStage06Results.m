function summary = summarizeStage06Results(resultTable)
%SUMMARIZESTAGE06RESULTS Build robust heading-family summary.

rt = resultTable;
feas = rt(rt.feasible, :);
summary = struct();
summary.schema_version = 'stage06_summary.v0';
summary.num_designs = height(rt);
summary.feasible_count = height(feas);
summary.robust_pass_ratio = summary.feasible_count / max(summary.num_designs, 1);
if isempty(feas)
    summary.best_Ns = NaN;
    summary.best_design_id = "";
    summary.ranking_table = feas;
else
    ranking = sortrows(feas, {'Ns','D_G_min'}, {'ascend','descend'});
    summary.best_Ns = ranking.Ns(1);
    summary.best_design_id = ranking.design_id(1);
    summary.ranking_table = ranking;
end
summary.feasible_table = feas;
summary.worst_heading_distribution = local_group_count(rt.worst_heading_offset_deg);
summary.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function t = local_group_count(values)
u = unique(values);
n = zeros(numel(u), 1);
for k = 1:numel(u)
    n(k) = sum(values == u(k));
end
t = table(u(:), n, 'VariableNames', {'worst_heading_offset_deg','design_count'});
end

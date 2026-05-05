function comparison = compareStage06WithStage05(stage05Artifact, stage06Artifact)
%COMPARESTAGE06WITHSTAGE05 Compare nominal and heading-family artifacts.

t05 = stage05Artifact.result_table;
t06 = stage06Artifact.result_table;
key = {'h_km','i_deg','P','T','F','Ns'};
t05 = renamevars(t05(:, [key {'D_G','feasible'}]), {'D_G','feasible'}, {'D_G_05','feasible_05'});
t06 = renamevars(t06(:, [key {'D_G_min','feasible','pass_ratio','worst_heading_offset_deg'}]), ...
    {'D_G_min','feasible','pass_ratio','worst_heading_offset_deg'}, ...
    {'D_G_06','feasible_06','pass_ratio_06','worst_heading_offset_deg'});
joined = innerjoin(t05, t06, 'Keys', key);
comparison = struct();
comparison.schema_version = 'stage06_vs_stage05_comparison.v0';
comparison.joined_table = joined;
comparison.stage05_summary = stage05Artifact.summary;
comparison.stage06_summary = stage06Artifact.summary;
comparison.feasible_count_change = sum(joined.feasible_06) - sum(joined.feasible_05);
comparison.best_Ns_change = local_best_ns(joined, 'feasible_06') - local_best_ns(joined, 'feasible_05');
comparison.pass_ratio_drop = 1 - mean(joined.pass_ratio_06, 'omitnan');
comparison.DG_robustness_drop = mean(joined.D_G_05 - joined.D_G_06, 'omitnan');
comparison.heading_risk_summary = local_heading_risk(joined);
comparison.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function ns = local_best_ns(t, feasField)
sub = t(t.(feasField), :);
if isempty(sub), ns = NaN; else, ns = min(sub.Ns); end
end

function risk = local_heading_risk(t)
u = unique(t.worst_heading_offset_deg);
meanDg = nan(numel(u), 1);
count = zeros(numel(u), 1);
for k = 1:numel(u)
    mask = t.worst_heading_offset_deg == u(k);
    meanDg(k) = mean(t.D_G_06(mask), 'omitnan');
    count(k) = sum(mask);
end
risk = table(u(:), count, meanDg, 'VariableNames', {'worst_heading_offset_deg','design_count','mean_D_G_06'});
end

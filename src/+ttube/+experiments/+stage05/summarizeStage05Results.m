function summary = summarizeStage05Results(resultTable)
%SUMMARIZESTAGE05RESULTS Build Stage05 summary artifact.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
ranking = ttube.experiments.stage05.rankStage05FeasibleDesigns(T);
summary = struct();
summary.schema_version = 'stage05_summary.v0';
summary.num_designs = height(T);
summary.num_feasible = height(ranking);
summary.pass_ratio = summary.num_feasible / max(summary.num_designs, 1);
summary.feasible_table = ranking;
summary.ranking_table = ranking;
if isempty(ranking)
    summary.best = table();
    summary.best_Ns = NaN;
else
    summary.best = ranking(1,:);
    summary.best_Ns = ranking.Ns(1);
end
summary.per_Ns_table = local_per_ns(T);
summary.heatmap_minNs = local_heatmap_min_ns(T);
summary.heatmap_bestDG = local_heatmap_best_dg(T);
end

function out = local_per_ns(T)
Ns = unique(T.Ns);
count = zeros(numel(Ns),1);
feasible_count = zeros(numel(Ns),1);
pass_ratio = zeros(numel(Ns),1);
for k=1:numel(Ns)
    idx = T.Ns == Ns(k);
    count(k) = nnz(idx);
    feasible_count(k) = nnz(T.feasible(idx));
    pass_ratio(k) = feasible_count(k) / max(count(k),1);
end
out = table(Ns, count, feasible_count, pass_ratio);
end

function out = local_heatmap_min_ns(T)
groups = unique(T(:, {'h_km','i_deg','P'}));
min_Ns = nan(height(groups),1);
for r=1:height(groups)
    idx = T.h_km == groups.h_km(r) & T.i_deg == groups.i_deg(r) & T.P == groups.P(r) & T.feasible;
    if any(idx), min_Ns(r) = min(T.Ns(idx)); end
end
out = groups; out.min_Ns = min_Ns;
end

function out = local_heatmap_best_dg(T)
groups = unique(T(:, {'h_km','i_deg','P'}));
best_D_G = nan(height(groups),1);
for r=1:height(groups)
    idx = T.h_km == groups.h_km(r) & T.i_deg == groups.i_deg(r) & T.P == groups.P(r);
    if any(idx), best_D_G(r) = max(T.D_G(idx)); end
end
out = groups; out.best_D_G = best_D_G;
end

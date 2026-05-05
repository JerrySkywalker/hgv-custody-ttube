function pareto = extractParetoFront(resultTable)
%EXTRACTPARETOFRONT Extract nondominated feasible rows minimizing Ns and maximizing D_G.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
T = T(T.feasible, :);
if isempty(T)
    pareto = T;
    return;
end
keep = true(height(T),1);
for a = 1:height(T)
    for b = 1:height(T)
        if b == a, continue; end
        dominates = T.Ns(b) <= T.Ns(a) && T.D_G(b) >= T.D_G(a) && ...
            (T.Ns(b) < T.Ns(a) || T.D_G(b) > T.D_G(a));
        if dominates
            keep(a) = false;
            break;
        end
    end
end
pareto = sortrows(T(keep,:), {'Ns','D_G'}, {'ascend','descend'});
end

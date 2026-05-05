function ranking = rankStage05FeasibleDesigns(resultTable)
%RANKSTAGE05FEASIBLEDESIGNS Sort feasible designs by Ns then descending D_G.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
ranking = T(T.feasible, :);
if ~isempty(ranking)
    ranking = sortrows(ranking, {'Ns','D_G'}, {'ascend','descend'});
end
end

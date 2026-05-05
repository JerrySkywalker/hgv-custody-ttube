function frontier = extractStage05Frontier(resultTable)
%EXTRACTSTAGE05FRONTIER Build inclination frontier artifact.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
feasible = T(T.feasible, :);
frontier = struct();
frontier.schema_version = 'stage05_frontier.v0';
frontier.has_feasible = ~isempty(feasible);
if isempty(feasible)
    frontier.frontier_table = table();
    frontier.inclination_frontier = table();
    return;
end
iVals = unique(feasible.i_deg);
rows = table();
for k=1:numel(iVals)
    cand = feasible(feasible.i_deg == iVals(k), :);
    cand = sortrows(cand, {'Ns','D_G'}, {'ascend','descend'});
    rows = [rows; cand(1,:)]; %#ok<AGROW>
end
frontier.inclination_frontier = rows;
frontier.frontier_table = ttube.experiments.stage05.extractParetoFront(feasible);
end

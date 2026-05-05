function transition = analyzeInclinationTransition(resultTable)
%ANALYZEINCLINATIONTRANSITION Build inclination transition summary.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
iVals = unique(T.i_deg);
rows = table();
for k=1:numel(iVals)
    Ti = T(T.i_deg == iVals(k), :);
    feas = Ti(Ti.feasible, :);
    if isempty(feas)
        firstNs = NaN; bestDG = NaN; bestP = NaN; bestT = NaN;
    else
        ranked = sortrows(feas, {'Ns','D_G'}, {'ascend','descend'});
        firstNs = ranked.Ns(1); bestDG = ranked.D_G(1); bestP = ranked.P(1); bestT = ranked.T(1);
    end
    maxPass = max(Ti.pass_ratio);
    rows = [rows; table(iVals(k), firstNs, maxPass, bestDG, bestP, bestT, ...
        'VariableNames', {'i_deg','first_Ns_feasible','max_pass_ratio','frontier_D_G','frontier_P','frontier_T'})]; %#ok<AGROW>
end
transition = rows;
end

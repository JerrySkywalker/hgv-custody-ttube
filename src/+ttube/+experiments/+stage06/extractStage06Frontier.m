function frontier = extractStage06Frontier(resultTable)
%EXTRACTSTAGE06FRONTIER Extract inclination robust frontier.

rt = resultTable;
iVals = unique(rt.i_deg);
rows = table();
for k = 1:numel(iVals)
    sub = rt(rt.i_deg == iVals(k) & rt.feasible, :);
    if isempty(sub)
        row = table(iVals(k), NaN, NaN, NaN, NaN, false, ...
            'VariableNames', {'i_deg','min_Ns','best_D_G_min','P','T','has_feasible'});
    else
        sub = sortrows(sub, {'Ns','D_G_min'}, {'ascend','descend'});
        row = table(iVals(k), sub.Ns(1), sub.D_G_min(1), sub.P(1), sub.T(1), true, ...
            'VariableNames', {'i_deg','min_Ns','best_D_G_min','P','T','has_feasible'});
    end
    rows = [rows; row]; %#ok<AGROW>
end
frontier = struct();
frontier.schema_version = 'stage06_frontier.v0';
frontier.by_inclination = rows;
frontier.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

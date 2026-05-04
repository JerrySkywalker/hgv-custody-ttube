function grid = buildTinySearchGrid(cfg)
%BUILDTINYSEARCHGRID Build a small Walker design table for Stage05 smoke.

h_grid_km = local_field(cfg, 'h_grid_km', 1000);
i_grid_deg = local_field(cfg, 'i_grid_deg', [60 70]);
P_grid = local_field(cfg, 'P_grid', [2 4]);
T_grid = local_field(cfg, 'T_grid', [2 3]);
F_fixed = local_field(cfg, 'F_fixed', 1);

rows = {};
for ih = 1:numel(h_grid_km)
    for ii = 1:numel(i_grid_deg)
        for ip = 1:numel(P_grid)
            for it = 1:numel(T_grid)
                h = h_grid_km(ih);
                inc = i_grid_deg(ii);
                P = P_grid(ip);
                T = T_grid(it);
                rows(end+1,:) = {h, inc, P, T, F_fixed, P*T}; %#ok<AGROW>
            end
        end
    end
end
grid = cell2table(rows, 'VariableNames', {'h_km','i_deg','P','T','F','Ns'});
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

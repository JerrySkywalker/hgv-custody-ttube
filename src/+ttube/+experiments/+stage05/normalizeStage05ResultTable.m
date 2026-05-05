function T = normalizeStage05ResultTable(input, opts)
%NORMALIZESTAGE05RESULTTABLE Normalize Stage05 result table columns.

if nargin < 2
    opts = struct();
end
backend = char(string(local_field(opts, 'backend', 'unknown')));
notesDefault = string(local_field(opts, 'notes', ''));

if istable(input)
    T = input;
elseif isstruct(input)
    T = struct2table(input);
else
    error('ttube:stage05:InvalidResultTable', 'Input must be a table or struct.');
end

T = local_alias(T, 'lambda_worst', {'lambda_worst_min','lambda_min'});
T = local_alias(T, 'D_G', {'D_G_min','DG','Dg'});
T = local_alias(T, 'feasible', {'feasible_flag','is_feasible'});
T = local_alias(T, 'pass_ratio', {'case_pass_ratio'});

required = {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst','D_G','feasible'};
for k = 1:numel(required)
    if ~ismember(required{k}, T.Properties.VariableNames)
        error('ttube:stage05:MissingRequiredField', ...
            'Missing required Stage05 result field: %s', required{k});
    end
end

n = height(T);
if ~ismember('design_id', T.Properties.VariableNames)
    T.design_id = strings(n, 1);
    for r = 1:n
        T.design_id(r) = sprintf('h%g_i%g_P%d_T%d_F%d_Ns%d', ...
            T.h_km(r), T.i_deg(r), T.P(r), T.T(r), T.F(r), T.Ns(r));
    end
end
if ~ismember('pass_ratio', T.Properties.VariableNames)
    T.pass_ratio = double(T.feasible);
end
if ~ismember('mean_visible', T.Properties.VariableNames)
    T.mean_visible = nan(n, 1);
end
if ~ismember('dual_ratio', T.Properties.VariableNames)
    T.dual_ratio = nan(n, 1);
end
if ~ismember('backend', T.Properties.VariableNames)
    T.backend = repmat(string(backend), n, 1);
end
if ~ismember('notes', T.Properties.VariableNames)
    T.notes = repmat(notesDefault, n, 1);
end

T.design_id = string(T.design_id);
T.h_km = double(T.h_km);
T.i_deg = double(T.i_deg);
T.P = double(T.P);
T.T = double(T.T);
T.F = double(T.F);
T.Ns = double(T.Ns);
T.gamma_req = double(T.gamma_req);
T.lambda_worst = double(T.lambda_worst);
T.D_G = double(T.D_G);
T.feasible = logical(T.feasible);
T.pass_ratio = double(T.pass_ratio);
T.mean_visible = double(T.mean_visible);
T.dual_ratio = double(T.dual_ratio);
T.backend = string(T.backend);
T.notes = string(T.notes);

if any(T.Ns ~= T.P .* T.T)
    error('ttube:stage05:InvalidResultTable', 'Ns must equal P*T.');
end
if any(~isfinite(T.D_G))
    error('ttube:stage05:InvalidResultTable', 'D_G must be finite.');
end

ordered = {'design_id','h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst', ...
    'D_G','feasible','pass_ratio','mean_visible','dual_ratio','backend','notes'};
T = T(:, ordered);
T.Properties.UserData.schema_version = 'stage05_result_table.v0';
end

function T = local_alias(T, canonical, aliases)
if ismember(canonical, T.Properties.VariableNames)
    return;
end
for k = 1:numel(aliases)
    if ismember(aliases{k}, T.Properties.VariableNames)
        T.(canonical) = T.(aliases{k});
        return;
    end
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

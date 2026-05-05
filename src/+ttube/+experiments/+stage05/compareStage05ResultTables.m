function comparison = compareStage05ResultTables(nativeTable, legacyTable, toleranceCfg)
%COMPARESTAGE05RESULTTABLES Compare normalized Stage05 result tables.

if nargin < 3
    toleranceCfg = struct();
end
absTol = local_field(toleranceCfg, 'D_G_abs_tol', 1e-9);
relTol = local_field(toleranceCfg, 'D_G_rel_tol', 1e-9);
passTol = local_field(toleranceCfg, 'pass_ratio_abs_tol', 1e-12);

nativeTable = ttube.experiments.stage05.normalizeStage05ResultTable(nativeTable, struct('backend','native'));
legacyTable = ttube.experiments.stage05.normalizeStage05ResultTable(legacyTable, struct('backend','legacy'));

nativeKeys = local_keys(nativeTable);
legacyKeys = local_keys(legacyTable);
[commonKeys, iNative, iLegacy] = intersect(nativeKeys, legacyKeys, 'stable');
nativeOnly = setdiff(nativeKeys, legacyKeys, 'stable');
legacyOnly = setdiff(legacyKeys, nativeKeys, 'stable');

DgErr = abs(nativeTable.D_G(iNative) - legacyTable.D_G(iLegacy));
DgRel = DgErr ./ max(abs(legacyTable.D_G(iLegacy)), eps);
passErr = abs(nativeTable.pass_ratio(iNative) - legacyTable.pass_ratio(iLegacy));
feasibleMatch = nativeTable.feasible(iNative) == legacyTable.feasible(iLegacy);

comparison = struct();
comparison.schema_version = 'stage05_result_table_comparison.v0';
comparison.row_count_match = height(nativeTable) == height(legacyTable);
comparison.design_key_match = isempty(nativeOnly) && isempty(legacyOnly);
comparison.Ns_match = isequal(nativeTable.Ns(iNative), legacyTable.Ns(iLegacy));
comparison.max_abs_D_G_error = local_max_or_nan(DgErr);
comparison.max_rel_D_G_error = local_max_or_nan(DgRel);
comparison.feasible_match_ratio = mean(feasibleMatch);
comparison.pass_ratio_error = local_max_or_nan(passErr);
comparison.native_only_designs = nativeOnly(:);
comparison.legacy_only_designs = legacyOnly(:);
comparison.common_design_count = numel(commonKeys);
comparison.status = local_status(comparison, absTol, relTol, passTol);
comparison.notes = '';
end

function keys = local_keys(T)
keys = strings(height(T), 1);
for r = 1:height(T)
    keys(r) = sprintf('h%g_i%g_P%d_T%d_F%d_Ns%d', ...
        T.h_km(r), T.i_deg(r), T.P(r), T.T(r), T.F(r), T.Ns(r));
end
end

function status = local_status(c, absTol, relTol, passTol)
ok = c.row_count_match && c.design_key_match && c.Ns_match && ...
    (isnan(c.max_abs_D_G_error) || c.max_abs_D_G_error <= absTol || c.max_rel_D_G_error <= relTol) && ...
    (isnan(c.pass_ratio_error) || c.pass_ratio_error <= passTol) && ...
    (isnan(c.feasible_match_ratio) || c.feasible_match_ratio == 1);
if ok
    status = 'pass';
else
    status = 'fail';
end
end

function y = local_max_or_nan(x)
if isempty(x)
    y = NaN;
else
    y = max(x);
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

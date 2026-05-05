function out = runStage06TinyOracle(cfg)
%RUNSTAGE06TINYORACLE Guarded Stage06 legacy oracle facade.
%
% This function intentionally does not call the old full Stage06 runner.

if nargin < 1, cfg = struct(); end
local_guard(cfg);
out = struct();
out.schema_version = 'stage06_legacy_tiny_oracle.v0';
out.status = 'blocked';
out.oracle_type = 'blocked';
out.result_table = table();
out.blocked_reason = ['No safe standalone legacy Stage06 helper-level evaluator was confirmed. ' ...
    'The old Stage06 path depends on Stage02/04/05 caches and the Stage06 full runner chain, ' ...
    'which is prohibited for this sprint.'];
out.notes = 'No old full Stage06 runner was executed.';
end

function local_guard(cfg)
offsets = local_field(cfg, 'heading_offsets_deg', [-10 0 10]);
designs = numel(local_field(cfg,'h_grid_km',1000)) * numel(local_field(cfg,'i_grid_deg',[60 70])) * ...
    numel(local_field(cfg,'P_grid',[2 4])) * numel(local_field(cfg,'T_grid',[2 3]));
assert(numel(offsets) <= 3, 'ttube:legacy:Stage06GuardRejected', 'heading offsets exceed tiny guard.');
assert(designs <= 12, 'ttube:legacy:Stage06GuardRejected', 'design count exceeds tiny guard.');
assert(strcmp(char(string(local_field(cfg,'caseId','N01'))), 'N01'), ...
    'ttube:legacy:Stage06GuardRejected', 'only N01 is allowed.');
assert(local_field(cfg,'Tmax_s',120) <= 120, 'ttube:legacy:Stage06GuardRejected', 'Tmax_s exceeds guard.');
assert(local_field(cfg,'Ts_s',5) >= 5, 'ttube:legacy:Stage06GuardRejected', 'Ts_s below guard.');
assert(~local_field(cfg,'make_plot',false) && ~local_field(cfg,'save_fig',false) && ~local_field(cfg,'parallel',false), ...
    'ttube:legacy:Stage06GuardRejected', 'plot/save/parallel are prohibited.');
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

function runStage05TinyOracleGuard(cfg)
%RUNSTAGE05TINYORACLEGUARD Reject unsafe legacy Stage05 oracle configs.

assert(strcmp(char(string(cfg.caseId)), 'N01'), 'ttube:legacy:Stage05TinyGuard', ...
    'Legacy Stage05 tiny oracle is restricted to N01.');
assert(numel(cfg.h_grid_km) <= 1, 'ttube:legacy:Stage05TinyGuard', 'h_grid_km must have <= 1 value.');
assert(numel(cfg.i_grid_deg) <= 2, 'ttube:legacy:Stage05TinyGuard', 'i_grid_deg must have <= 2 values.');
assert(numel(cfg.P_grid) <= 2, 'ttube:legacy:Stage05TinyGuard', 'P_grid must have <= 2 values.');
assert(numel(cfg.T_grid) <= 2, 'ttube:legacy:Stage05TinyGuard', 'T_grid must have <= 2 values.');
assert(isscalar(cfg.F_fixed), 'ttube:legacy:Stage05TinyGuard', 'F_fixed must be scalar.');
assert(cfg.Tmax_s <= 120, 'ttube:legacy:Stage05TinyGuard', 'Tmax_s must be <= 120.');
assert(cfg.Ts_s >= 5, 'ttube:legacy:Stage05TinyGuard', 'Ts_s must be >= 5.');
assert(cfg.Tw_s <= 60, 'ttube:legacy:Stage05TinyGuard', 'Tw_s must be <= 60.');
assert(~isfield(cfg, 'callFullRunner') || ~cfg.callFullRunner, 'ttube:legacy:Stage05TinyGuard', ...
    'Old full Stage05 runner is prohibited.');
assert(~isfield(cfg, 'make_plot') || ~cfg.make_plot, 'ttube:legacy:Stage05TinyGuard', 'Plotting is prohibited.');
assert(~isfield(cfg, 'save_fig') || ~cfg.save_fig, 'ttube:legacy:Stage05TinyGuard', 'Figure saving is prohibited.');
assert(~isfield(cfg, 'use_parallel') || ~cfg.use_parallel, 'ttube:legacy:Stage05TinyGuard', 'Parallel execution is prohibited.');
end

function cfg = loadDefaultParams(legacyRoot, overrides)
%LOADDEFAULTPARAMS Load legacy default_params with conservative overrides.

if nargin < 2
    overrides = struct();
end

cleanupObj = ttube.legacy.withLegacyPath(legacyRoot); %#ok<NASGU>
cfg = default_params();
cfg.stage01.make_plot = false;
cfg.stage02.make_plot = false;
cfg.stage02.make_plot_3d = false;
cfg.stage03.make_plot = false;
cfg.stage04.make_plot = false;
if isfield(cfg, 'stage05')
    cfg.stage05.make_plot = false;
    cfg.stage05.use_parallel = false;
    cfg.stage05.use_live_progress = false;
    cfg.stage05.save_eval_bank = false;
end
cfg = local_apply_overrides(cfg, overrides);
end

function s = local_apply_overrides(s, overrides)
names = fieldnames(overrides);
for k = 1:numel(names)
    name = names{k};
    value = overrides.(name);
    if isstruct(value) && isfield(s, name) && isstruct(s.(name))
        s.(name) = local_apply_overrides(s.(name), value);
    else
        s.(name) = value;
    end
end
end

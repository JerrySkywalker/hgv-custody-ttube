function cfg = makeStage06Config(input)
%MAKESTAGE06CONFIG Build normalized native Stage06 config.

if nargin < 1, input = struct(); end
profile = local_field(input, 'profile', 'tiny');
base = ttube.experiments.stage05.makeStage05Profile(profile, input);
cfg = base;
cfg.schema_version = 'stage06_config.v0';
cfg.stage05Profile = local_field(input, 'stage05Profile', profile);
cfg.caseId = local_field(input, 'caseId', 'N01');
cfg.heading_offsets_deg = local_field(input, 'heading_offsets_deg', [-10 0 10]);
cfg.heading_mode = local_field(input, 'heading_mode', 'small');
cfg.maxHeadingsGuard = local_field(input, 'maxHeadingsGuard', 5);
cfg.maxDesignsGuard = local_field(input, 'maxDesignsGuard', base.maxDesignsGuard);
cfg.maxDesignHeadingEvalsGuard = local_field(input, 'maxDesignHeadingEvalsGuard', 600);
cfg.outputDir = local_field(input, 'outputDir', fullfile(pwd, 'outputs', 'stage06_native'));
cfg.runDir = local_field(input, 'runDir', '');
cfg.saveOutputs = local_field(input, 'saveOutputs', true);
cfg.makePlots = local_field(input, 'makePlots', false);
cfg.useParallel = false;
cfg.stage05Baseline = local_field(input, 'stage05Baseline', []);
cfg.caseCfg = local_field(input, 'caseCfg', struct());
cfg.caseCfg.caseId = cfg.caseId;
cfg.stage04 = local_field(input, 'stage04', struct());
cfg.stage04.Tw_s = cfg.Tw_s;
cfg.stage04.window_step_s = cfg.window_step_s;
ttube.experiments.stage06.validateStage06Config(cfg);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

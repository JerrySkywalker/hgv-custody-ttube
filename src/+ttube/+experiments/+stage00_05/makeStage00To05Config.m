function cfg = makeStage00To05Config(input)
%MAKESTAGE00TO05CONFIG Build Stage00-05 E2E config.

if nargin < 1, input = struct(); end
profile = char(string(local_field(input,'profile','smoke')));
cfg = struct();
cfg.profile = profile;
cfg.runDir = local_field(input,'runDir',fullfile(pwd,'runs',['stage00_05_native_' profile]));
cfg.outputDir = local_field(input,'outputDir',fullfile(cfg.runDir,'outputs'));
cfg.random_seed = local_field(input,'random_seed',42);
switch profile
    case 'smoke'
        cfg.Tmax_s = local_field(input,'Tmax_s',30); cfg.Ts_s = 5; cfg.makePlots = false;
    case 'medium_safe'
        cfg.Tmax_s = local_field(input,'Tmax_s',80); cfg.Ts_s = 5; cfg.makePlots = false;
    otherwise
        cfg.Tmax_s = local_field(input,'Tmax_s',60); cfg.Ts_s = 5; cfg.makePlots = false;
end
cfg.Tw_s = local_field(input,'Tw_s',30);
cfg.window_step_s = local_field(input,'window_step_s',10);
cfg.gamma_req = local_field(input,'gamma_req',1);
cfg.stage05Profile = local_field(input,'stage05Profile',profile);
cfg.saveOutputs = local_field(input,'saveOutputs',true);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

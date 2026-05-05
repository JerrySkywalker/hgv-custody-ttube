function cfg = makeStage05Profile(profile, overrides)
%MAKESTAGE05PROFILE Return guarded native Stage05 profile defaults.

if nargin < 1 || isempty(profile), profile = 'tiny'; end
if nargin < 2, overrides = struct(); end
cfg = struct();
cfg.profile = char(string(profile));
switch cfg.profile
    case 'smoke'
        cfg.h_grid_km = 1000;
        cfg.i_grid_deg = 60;
        cfg.P_grid = 2;
        cfg.T_grid = 2;
        cfg.Tmax_s = 30;
        cfg.maxDesignsGuard = 20;
    case 'tiny'
        cfg.h_grid_km = 1000;
        cfg.i_grid_deg = [60 70];
        cfg.P_grid = [2 4];
        cfg.T_grid = [2 3];
        cfg.Tmax_s = 80;
        cfg.maxDesignsGuard = 50;
    case 'medium_safe'
        cfg.h_grid_km = [800 1000];
        cfg.i_grid_deg = [40 50 60 70];
        cfg.P_grid = [2 4 6];
        cfg.T_grid = [2 3 4];
        cfg.Tmax_s = 120;
        cfg.maxDesignsGuard = 200;
    case 'golden_safe'
        cfg.h_grid_km = [800 1000];
        cfg.i_grid_deg = [50 60 70];
        cfg.P_grid = [2 4 6];
        cfg.T_grid = [2 3 4];
        cfg.Tmax_s = 180;
        cfg.maxDesignsGuard = 300;
    otherwise
        error('ttube:stage05:InvalidProfile', 'Unknown Stage05 profile: %s', cfg.profile);
end
cfg.trajectoryBackend = 'native_vtc';
cfg.Ts_s = 5;
cfg.Tw_s = 30;
cfg.window_step_s = 10;
cfg.F_fixed = 1;
cfg.gamma_req = 1.0;
cfg.saveOutputs = true;
cfg.makePlots = false;
cfg.useParallel = false;
cfg.sensor = struct('max_range_km',10000, ...
    'require_earth_occlusion_check',false, ...
    'enable_offnadir_constraint',false);

names = fieldnames(overrides);
for k = 1:numel(names)
    cfg.(names{k}) = overrides.(names{k});
end
end

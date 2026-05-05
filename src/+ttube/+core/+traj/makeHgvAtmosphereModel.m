function model = makeHgvAtmosphereModel(cfg)
%MAKEHGVATMOSPHEREMODEL Build a simple US76-like HGV atmosphere model.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end

model = struct();
model.rho0_kgm3 = local_field(cfg, 'rho0_kgm3', 1.225);
model.scale_height_m = local_field(cfg, 'scale_height_m', 7200.0);
model.sound_speed_mps = local_field(cfg, 'sound_speed_mps', 295.0);
model.atmosphereFcn = @(altM, params) local_atmosphere(altM, params, model);
end

function [rho, soundSpeedMps] = local_atmosphere(altM, ~, model)
h = max(altM, 0);
rho = model.rho0_kgm3 * exp(-h ./ model.scale_height_m);
soundSpeedMps = model.sound_speed_mps + zeros(size(rho));
end

function v = local_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

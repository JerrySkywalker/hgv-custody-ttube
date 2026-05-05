function model = makeHgvAeroModel(cfg)
%MAKEHGVAEROMODEL Build VTC-inspired HGV aerodynamic coefficient model.
%
% Coefficients mirror the public legacy Stage02 polynomial form but the
% function remains a native, replaceable model component.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end

model = struct();
model.coef_L = local_field(cfg, 'coef_L', [0.0301, 2.2992, 1.2287, -1.3001e-4, 0.2047, -6.1460e-2]);
model.coef_D = local_field(cfg, 'coef_D', [0.0100, -0.1748, 2.7247, 4.5781e-4, 0.3591, -6.9440e-2]);
model.aeroFcn = @(speedMps, altM, control, params) local_aero(speedMps, altM, control, params, model);
end

function [CL, CD] = local_aero(speedMps, altM, control, params, model)
if isfield(params, 'atmosphereFcn')
    [~, soundSpeedMps] = params.atmosphereFcn(altM, params);
else
    soundSpeedMps = 295;
end
mach = max(speedMps ./ max(soundSpeedMps, eps), 0);
alpha = control.alpha_rad;

cL = model.coef_L;
cD = model.coef_D;
CL = cL(1) + cL(2) * alpha + cL(3) * alpha^2 + cL(4) * mach + cL(5) * exp(cL(6) * mach);
CD = cD(1) + cD(2) * alpha + cD(3) * alpha^2 + cD(4) * mach + cD(5) * exp(cD(6) * mach);
end

function v = local_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

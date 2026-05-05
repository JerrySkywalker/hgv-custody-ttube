function profile = makeHgvControlProfile(cfg, caseInfo)
%MAKEHGVCONTROLPROFILE Build a replaceable open-loop HGV control profile.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end
if nargin < 2 || isempty(caseInfo)
    caseInfo = struct('family', 'nominal', 'subfamily', 'nominal');
end

family = local_char_field(caseInfo, 'family', 'nominal');
subfamily = local_char_field(caseInfo, 'subfamily', 'nominal');

switch family
    case 'heading'
        alphaDeg = local_field(cfg, 'alpha_heading_deg', local_field(cfg, 'alpha_nominal_deg', 11.0));
        bankDeg = local_field(cfg, 'bank_heading_deg', local_field(cfg, 'bank_nominal_deg', 0.0));
    case 'critical'
        if strcmp(subfamily, 'small_crossing_angle')
            alphaDeg = local_field(cfg, 'alpha_c2_deg', local_field(cfg, 'alpha_nominal_deg', 11.0));
            bankDeg = local_field(cfg, 'bank_c2_deg', local_field(cfg, 'bank_nominal_deg', 0.0));
        elseif strcmp(subfamily, 'track_plane_aligned')
            alphaDeg = local_field(cfg, 'alpha_c1_deg', local_field(cfg, 'alpha_nominal_deg', 11.0));
            bankDeg = local_field(cfg, 'bank_c1_deg', local_field(cfg, 'bank_nominal_deg', 0.0));
        else
            alphaDeg = local_field(cfg, 'alpha_nominal_deg', 11.0);
            bankDeg = local_field(cfg, 'bank_nominal_deg', 0.0);
        end
    otherwise
        alphaDeg = local_field(cfg, 'alpha_nominal_deg', 11.0);
        bankDeg = local_field(cfg, 'bank_nominal_deg', 0.0);
end

profile = struct();
profile.alpha_deg = alphaDeg;
profile.bank_deg = bankDeg;
profile.alpha_rad = deg2rad(alphaDeg);
profile.bank_rad = deg2rad(bankDeg);
profile.controlFcn = @(t, x, params) local_constant_control(t, x, params, profile.alpha_rad, profile.bank_rad);
end

function control = local_constant_control(~, ~, ~, alphaRad, bankRad)
control = struct();
control.alpha_rad = alphaRad;
control.bank_rad = bankRad;
end

function v = local_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

function v = local_char_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = char(string(s.(name)));
else
    v = defaultValue;
end
end

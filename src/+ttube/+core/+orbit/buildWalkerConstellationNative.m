function walker = buildWalkerConstellationNative(cfg)
%BUILDWALKERCONSTELLATIONNATIVE Build a native single-layer Walker design.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);

walker = struct();
walker.h_km = cfg.h_km;
walker.i_deg = cfg.i_deg;
walker.P = cfg.P;
walker.T = cfg.T;
walker.F = cfg.F;
walker.RAAN0_deg = cfg.RAAN0_deg;
walker.Ns = walker.P * walker.T;

sat = repmat(struct('sat_id', '', 'plane_id', 0, 'sat_id_in_plane', 0, ...
    'raan_deg', 0, 'M0_deg', 0, 'h_km', 0, 'i_deg', 0), walker.Ns, 1);
idx = 0;
for p = 1:walker.P
    raanDeg = cfg.RAAN0_deg + (p - 1) * 360 / walker.P;
    for t = 1:walker.T
        idx = idx + 1;
        phaseDeg = mod((t - 1) * 360 / walker.T + ...
            (p - 1) * walker.F * 360 / walker.Ns, 360);
        sat(idx).sat_id = sprintf('S%03d', idx);
        sat(idx).plane_id = p;
        sat(idx).sat_id_in_plane = t;
        sat(idx).raan_deg = mod(raanDeg, 360);
        sat(idx).M0_deg = phaseDeg;
        sat(idx).h_km = walker.h_km;
        sat(idx).i_deg = walker.i_deg;
    end
end
walker.sat = sat;
walker.backend = 'native_walker_delta';
end

function cfg = local_defaults(cfg)
if isfield(cfg, 'walker')
    w = cfg.walker;
else
    w = cfg;
end
cfg.h_km = local_field(w, 'h_km', 1000);
cfg.i_deg = local_field(w, 'i_deg', 70);
cfg.P = local_field(w, 'P', 2);
cfg.T = local_field(w, 'T', 2);
cfg.F = local_field(w, 'F', 1);
cfg.RAAN0_deg = local_field(w, 'RAAN0_deg', 0);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

function artifact = propagateWalkerConstellationNative(walker, t_s, cfg)
%PROPAGATEWALKERCONSTELLATIONNATIVE Native circular two-body propagation.

if nargin < 3
    cfg = struct();
end
mu = local_field(cfg, 'mu_km3_s2', 398600.4418);
earthRadius = local_field(cfg, 'earth_radius_km', 6378.137);
epoch = local_field(cfg, 'epoch_utc', '2026-01-01 00:00:00');

t_s = t_s(:);
nt = numel(t_s);
ns = walker.Ns;
r = zeros(nt, ns, 3);
v = zeros(nt, ns, 3);
a = earthRadius + walker.h_km;
n = sqrt(mu / a^3);

sat_id = strings(ns, 1);
plane_index = zeros(ns, 1);
sat_index = zeros(ns, 1);
for s = 1:ns
    sat = walker.sat(s);
    u = deg2rad(sat.M0_deg) + n * t_s;
    [rs, vs] = ttube.core.orbit.keplerCircularToEci(a, sat.i_deg, sat.raan_deg, u, mu);
    r(:, s, :) = reshape(rs, nt, 1, 3);
    v(:, s, :) = reshape(vs, nt, 1, 3);
    sat_id(s) = string(sat.sat_id);
    plane_index(s) = sat.plane_id;
    sat_index(s) = sat.sat_id_in_plane;
end

artifact = struct();
artifact.schema_version = 'constellation_state.v0';
artifact.constellation_id = sprintf('walker_h%.0f_i%.0f_P%d_T%d_F%d', ...
    walker.h_km, walker.i_deg, walker.P, walker.T, walker.F);
artifact.epoch_utc = char(string(epoch));
artifact.t_s = t_s;
artifact.sat_id = sat_id;
artifact.plane_index = plane_index;
artifact.sat_index_in_plane = sat_index;
artifact.r_eci_km = r;
artifact.v_eci_kmps = v;
artifact.walker = walker;
artifact.frame_primary = 'ECI';
artifact.backend = 'native_circular_two_body';
artifact.producer = 'ttube.core.orbit.propagateWalkerConstellationNative';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'native_cleanroom_stage03_walker';
ttube.core.orbit.validateConstellationStateArtifact(artifact);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

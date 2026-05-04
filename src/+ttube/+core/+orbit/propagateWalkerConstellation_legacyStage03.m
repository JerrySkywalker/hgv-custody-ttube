function artifact = propagateWalkerConstellation_legacyStage03(walker, t_s, cfg)
%PROPAGATEWALKERCONSTELLATION_LEGACYSTAGE03 Adapt legacy circular propagator.

cleanupObj = ttube.legacy.withLegacyPath(cfg.legacyRoot); %#ok<NASGU>
satbank = propagate_constellation_stage03(walker, t_s(:));
artifact = local_convert(satbank, cfg);
ttube.core.orbit.validateConstellationStateArtifact(artifact);
end

function artifact = local_convert(satbank, cfg)
t_s = satbank.t_s(:);
r_old = satbank.r_eci_km;             % Nt x 3 x Ns
r_eci_km = permute(r_old, [1 3 2]);   % Nt x Ns x 3
[~, ns, ~] = size(r_eci_km);
v_eci_kmps = zeros(size(r_eci_km));
for s = 1:ns
    v_eci_kmps(:, s, :) = ttube.legacy.finiteDifferenceVelocity(t_s, squeeze(r_eci_km(:, s, :)));
end

sat_id = strings(ns, 1);
plane_index = zeros(ns, 1);
sat_index_in_plane = zeros(ns, 1);
for s = 1:ns
    sat_id(s) = "S" + s;
    if isfield(satbank.walker, 'sat') && numel(satbank.walker.sat) >= s
        plane_index(s) = satbank.walker.sat(s).plane_id;
        sat_index_in_plane(s) = satbank.walker.sat(s).sat_id_in_plane;
    end
end

artifact = struct();
artifact.schema_version = 'constellation_state.v0';
artifact.constellation_id = local_constellation_id(satbank.walker);
artifact.epoch_utc = local_epoch(cfg);
artifact.t_s = t_s;
artifact.sat_id = sat_id;
artifact.plane_index = plane_index;
artifact.sat_index_in_plane = sat_index_in_plane;
artifact.r_eci_km = r_eci_km;
artifact.v_eci_kmps = v_eci_kmps;
artifact.walker = satbank.walker;
artifact.frame_primary = 'ECI';
artifact.backend = 'legacy_stage03';
artifact.producer = 'ttube.core.orbit.propagateWalkerConstellation_legacyStage03';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'legacy_function:propagate_constellation_stage03';
end

function id = local_constellation_id(w)
id = sprintf('walker_h%.0f_i%.0f_P%d_T%d_F%d', w.h_km, w.i_deg, w.P, w.T, w.F);
end

function epoch = local_epoch(cfg)
epoch = 'unknown';
if isfield(cfg, 'epoch_utc')
    epoch = char(string(cfg.epoch_utc));
end
end

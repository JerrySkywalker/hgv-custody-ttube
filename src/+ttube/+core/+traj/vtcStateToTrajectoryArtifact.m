function artifact = vtcStateToTrajectoryArtifact(vtc, opts)
%VTCSTATETOTRAJECTORYARTIFACT Convert VTC state series to trajectory.v0.

if nargin < 2
    opts = struct();
end
ttube.core.traj.validateVtcStateSeries(vtc);

ellipsoid = local_field(opts, 'ellipsoid', struct('a_m', 6378137.0, ...
    'f', 1 / 298.257223563, 'e2', 2 * (1 / 298.257223563) - (1 / 298.257223563)^2));
rEcefKm = ttube.core.traj.vtcStateToEcef(vtc, ellipsoid);
rEciKm = ttube.core.frames.ecefToEciSimple(rEcefKm, vtc.epoch_utc, vtc.t_s);
vEciKmps = local_finite_difference_velocity(rEciKm, vtc.t_s);

artifact = struct();
artifact.schema_version = 'trajectory.v0';
artifact.trajectory_id = char(string(vtc.trajectory_id));
artifact.family = char(string(local_field(vtc, 'family', 'nominal')));
artifact.subfamily = char(string(local_field(vtc, 'subfamily', 'nominal')));
artifact.epoch_utc = char(string(vtc.epoch_utc));
artifact.t_s = vtc.t_s(:);
artifact.r_eci_km = rEciKm;
artifact.v_eci_kmps = vEciKmps;
artifact.frame_primary = 'ECI';
artifact.valid_mask = all(isfinite(rEciKm), 2) & all(isfinite(vEciKmps), 2);
artifact.r_ecef_km = rEcefKm;
artifact.lat_deg = rad2deg(vtc.phi_rad(:));
artifact.lon_deg = rad2deg(vtc.lambda_rad(:));
artifact.h_m = vtc.h_m(:);
artifact.h_km = vtc.h_km(:);
artifact.v_mps = vtc.v_mps(:);
artifact.vtc_state = vtc;
artifact.backend = char(string(local_field(opts, 'backend', 'native_vtc')));
artifact.producer = 'ttube.core.traj.vtcStateToTrajectoryArtifact';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'native_vtc_state';
artifact.meta = struct();
artifact.meta.velocity_method = 'finite_difference_r_eci_km';
artifact.meta.notes = 'ECI velocity is finite-differenced from native ECI positions.';

ttube.core.traj.validateTrajectoryArtifact(artifact);
end

function v = local_finite_difference_velocity(rKm, tS)
n = size(rKm, 1);
v = zeros(n, 3);
if n == 1
    return;
end
for k = 1:n
    if k == 1
        dt = tS(2) - tS(1);
        v(k,:) = (rKm(2,:) - rKm(1,:)) / dt;
    elseif k == n
        dt = tS(n) - tS(n-1);
        v(k,:) = (rKm(n,:) - rKm(n-1,:)) / dt;
    else
        dt = tS(k+1) - tS(k-1);
        v(k,:) = (rKm(k+1,:) - rKm(k-1,:)) / dt;
    end
end
end

function v = local_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

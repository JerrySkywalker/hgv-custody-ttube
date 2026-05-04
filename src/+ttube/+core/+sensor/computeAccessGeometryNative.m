function artifact = computeAccessGeometryNative(trajectory, constellation, cfg)
%COMPUTEACCESSGEOMETRYNATIVE Compute native range/occlusion/off-nadir access.

if nargin < 3
    cfg = struct();
end
cfg = local_defaults(cfg);

t_s = trajectory.t_s(:);
nt = numel(t_s);
ns = numel(constellation.sat_id);
assert(numel(constellation.t_s) >= nt, 'ttube:sensor:InvalidTime', ...
    'Constellation time grid must cover the trajectory time grid.');

rTgt = reshape(trajectory.r_eci_km, nt, 1, 3);
rSat = constellation.r_eci_km(1:nt, :, :);
losSatToTgt = rTgt - rSat;
range_km = sqrt(sum(losSatToTgt.^2, 3));

rangeMask = ttube.core.sensor.checkRange(range_km, cfg.max_range_km);
visible = rangeMask;

occlusionMask = true(nt, ns);
if cfg.require_earth_occlusion_check
    occlusionMask = ttube.core.sensor.checkEarthOcclusion(rSat, losSatToTgt, cfg.earth_radius_km);
    visible = visible & occlusionMask;
end

offnadirMask = true(nt, ns);
offnadir_deg = nan(nt, ns);
if cfg.enable_offnadir_constraint
    [offnadirMask, offnadir_deg] = ttube.core.sensor.checkOffNadir( ...
        rSat, losSatToTgt, cfg.max_offnadir_deg);
    visible = visible & offnadirMask;
end

numVisible = sum(visible, 2);

artifact = struct();
artifact.schema_version = 'access.v0';
artifact.access_id = sprintf('%s__%s__native', ...
    char(string(trajectory.trajectory_id)), char(string(constellation.constellation_id)));
artifact.trajectory_id = char(string(trajectory.trajectory_id));
artifact.constellation_id = char(string(constellation.constellation_id));
artifact.sensor_model_id = 'native_range_occlusion_offnadir';
artifact.epoch_utc = trajectory.epoch_utc;
artifact.t_s = t_s;
artifact.access_mask = logical(visible);
artifact.num_visible = numVisible;
artifact.dual_coverage_mask = numVisible >= 2;
artifact.range_km = range_km;
artifact.offnadir_deg = offnadir_deg;
artifact.constraint_flags = struct('range', rangeMask, ...
    'earth_occlusion', occlusionMask, 'offnadir', offnadirMask);
artifact.r_tgt_eci_km = trajectory.r_eci_km;
artifact.backend = 'native_range_occlusion_offnadir';
artifact.producer = 'ttube.core.sensor.computeAccessGeometryNative';
artifact.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.source_fingerprint = 'native_cleanroom_stage03_access';
ttube.core.visibility.validateAccessArtifact(artifact);
end

function cfg = local_defaults(cfg)
cfg.max_range_km = local_field(cfg, 'max_range_km', 3500);
cfg.earth_radius_km = local_field(cfg, 'earth_radius_km', 6378.137);
cfg.require_earth_occlusion_check = local_field(cfg, 'require_earth_occlusion_check', true);
cfg.enable_offnadir_constraint = local_field(cfg, 'enable_offnadir_constraint', true);
cfg.max_offnadir_deg = local_field(cfg, 'max_offnadir_deg', 65);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

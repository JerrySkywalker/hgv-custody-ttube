function caseArtifact = buildStage01CasebankNative(cfg)
%BUILDSTAGE01CASEBANKNATIVE Build a minimal native geodetic Stage01 N01 case.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);

entryPointEnuKm = cfg.R_in_km * [cosd(cfg.entry_theta_deg); sind(cfg.entry_theta_deg); 0];
headingUnitEnu = [cosd(cfg.heading_deg); sind(cfg.heading_deg); 0];
headingUnitEnu = ttube.core.frames.normalizeVector(headingUnitEnu, 1);

azDeg = mod(90 - cfg.entry_theta_deg, 360);
[entryLatDeg, entryLonDeg] = local_direct_geodesic_sphere( ...
    cfg.anchor_lat_deg, cfg.anchor_lon_deg, azDeg, cfg.R_in_km * 1000, cfg.a_m);

ellipsoid = struct('a_m', cfg.a_m, 'f', cfg.f, 'e2', cfg.e2);
entryPointEcefKm = ttube.core.frames.geodeticToEcef( ...
    entryLatDeg, entryLonDeg, cfg.anchor_h_m, ellipsoid);
entryPointEciKm = ttube.core.frames.ecefToEciSimple( ...
    entryPointEcefKm, cfg.epoch_utc, 0);

headingUnitEcef = ttube.core.frames.enuToEcefDirection( ...
    headingUnitEnu, cfg.anchor_lat_deg, cfg.anchor_lon_deg);
headingUnitEcef = ttube.core.frames.normalizeVector(headingUnitEcef, 1);
headingUnitEci = ttube.core.frames.ecefToEciSimple(headingUnitEcef, cfg.epoch_utc, 0);
headingUnitEci = ttube.core.frames.normalizeVector(headingUnitEci, 1);

caseArtifact = struct();
caseArtifact.schema_version = 'case.v0';
caseArtifact.case_id = char(string(cfg.caseId));
caseArtifact.family = 'nominal';
caseArtifact.subfamily = 'nominal';
caseArtifact.epoch_utc = char(string(cfg.epoch_utc));
caseArtifact.entry_theta_deg = cfg.entry_theta_deg;
caseArtifact.heading_deg = cfg.heading_deg;
caseArtifact.heading_offset_deg = 0;
caseArtifact.R_D_km = cfg.R_D_km;
caseArtifact.R_in_km = cfg.R_in_km;
caseArtifact.anchor_lat_deg = cfg.anchor_lat_deg;
caseArtifact.anchor_lon_deg = cfg.anchor_lon_deg;
caseArtifact.anchor_h_m = cfg.anchor_h_m;
caseArtifact.scene_mode = 'geodetic';
caseArtifact.entry_lat_deg = entryLatDeg;
caseArtifact.entry_lon_deg = entryLonDeg;
caseArtifact.entry_surface_dist_km = cfg.R_in_km;
caseArtifact.entry_point_enu_km = entryPointEnuKm;
caseArtifact.entry_point_ecef_km = entryPointEcefKm;
caseArtifact.entry_point_eci_km_t0 = entryPointEciKm;
caseArtifact.heading_unit_enu = headingUnitEnu;
caseArtifact.heading_unit_ecef_t0 = headingUnitEcef;
caseArtifact.heading_unit_eci_t0 = headingUnitEci;
caseArtifact.backend = 'native_geodetic_wgs84_simple_eci';
caseArtifact.meta = struct();
caseArtifact.meta.notes = ['Native Stage01 uses WGS84 geodetic-to-ECEF, ' ...
    'spherical direct geodesic boundary placement, and a simple GMST ECEF-to-ECI rotation.'];
end

function cfg = local_defaults(cfg)
cfg.caseId = local_field(cfg, 'caseId', 'N01');
cfg.epoch_utc = local_field(cfg, 'epoch_utc', '2026-01-01 00:00:00');
cfg.anchor_lat_deg = local_field(cfg, 'anchor_lat_deg', 30.0);
cfg.anchor_lon_deg = local_field(cfg, 'anchor_lon_deg', -160.0);
cfg.anchor_h_m = local_field(cfg, 'anchor_h_m', 0.0);
cfg.entry_theta_deg = local_field(cfg, 'entry_theta_deg', 0.0);
cfg.heading_deg = local_field(cfg, 'heading_deg', 180.0);
cfg.R_D_km = local_field(cfg, 'R_D_km', 1000.0);
cfg.R_in_km = local_field(cfg, 'R_in_km', 3000.0);
cfg.a_m = local_field(cfg, 'a_m', 6378137.0);
cfg.f = local_field(cfg, 'f', 1 / 298.257223563);
cfg.e2 = local_field(cfg, 'e2', 2 * cfg.f - cfg.f^2);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

function [lat2Deg, lon2Deg] = local_direct_geodesic_sphere(lat1Deg, lon1Deg, azDeg, sM, radiusM)
lat1 = deg2rad(lat1Deg);
lon1 = deg2rad(lon1Deg);
az = deg2rad(azDeg);
delta = sM / radiusM;

sinLat1 = sin(lat1);
cosLat1 = cos(lat1);
sinDelta = sin(delta);
cosDelta = cos(delta);

sinLat2 = sinLat1 .* cosDelta + cosLat1 .* sinDelta .* cos(az);
lat2 = asin(max(min(sinLat2, 1), -1));

y = sin(az) .* sinDelta .* cosLat1;
x = cosDelta - sinLat1 .* sin(lat2);
lon2 = lon1 + atan2(y, x);
lon2 = mod(lon2 + pi, 2 * pi) - pi;

lat2Deg = rad2deg(lat2);
lon2Deg = rad2deg(lon2);
end

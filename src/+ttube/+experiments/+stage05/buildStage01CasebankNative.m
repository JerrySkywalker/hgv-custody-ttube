function caseArtifact = buildStage01CasebankNative(cfg)
%BUILDSTAGE01CASEBANKNATIVE Build a minimal native Stage01 N01 case.

if nargin < 1
    cfg = struct();
end
cfg = local_defaults(cfg);

entryPointEnuKm = cfg.R_in_km * [cosd(cfg.entry_theta_deg); sind(cfg.entry_theta_deg); 0];
headingUnitEnu = [cosd(cfg.heading_deg); sind(cfg.heading_deg); 0];
headingUnitEnu = headingUnitEnu / norm(headingUnitEnu);

anchorEciKm = [(cfg.earth_radius_km + cfg.anchor_h_m / 1000), 0, 0];
entryPointEciKm = anchorEciKm(:) + entryPointEnuKm(:);
headingUnitEci = headingUnitEnu(:);

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
caseArtifact.entry_point_enu_km = entryPointEnuKm;
caseArtifact.entry_point_ecef_km = entryPointEciKm;
caseArtifact.entry_point_eci_km_t0 = entryPointEciKm;
caseArtifact.heading_unit_enu = headingUnitEnu;
caseArtifact.heading_unit_eci_t0 = headingUnitEci;
caseArtifact.backend = 'native_flat_enu_pseudo_eci';
caseArtifact.meta = struct();
caseArtifact.meta.notes = ['Native Stage01 uses a deterministic flat-ENU case ' ...
    'mapped to pseudo-ECI. Full geodetic parity is pending.'];
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
cfg.earth_radius_km = local_field(cfg, 'earth_radius_km', 6378.137);
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f))
    v = s.(f);
else
    v = defaultValue;
end
end

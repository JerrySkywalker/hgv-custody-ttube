function rEcefKm = vtcStateToEcef(vtc, ellipsoid)
%VTCSTATETOECEF Convert VTC latitude/longitude/radius state to ECEF [km].

if nargin < 2
    ellipsoid = struct();
end
if isfield(vtc, 'h_m')
    hM = vtc.h_m(:);
else
    ReM = local_field(ellipsoid, 'a_m', 6378137.0);
    hM = vtc.r_m(:) - ReM;
end
latDeg = rad2deg(vtc.phi_rad(:));
lonDeg = rad2deg(vtc.lambda_rad(:));
rEcefKm = ttube.core.frames.geodeticToEcef(latDeg, lonDeg, hM, ellipsoid);
end

function v = local_field(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

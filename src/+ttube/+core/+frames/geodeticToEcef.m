function rEcefKm = geodeticToEcef(latDeg, lonDeg, hM, ellipsoid)
%GEODETICTOECEF Convert geodetic latitude/longitude/height to ECEF [km].
%
% The default ellipsoid is WGS84. Inputs may be scalar or matching arrays.
% The output is N-by-3 in kilometers; scalar inputs return a 3-by-1 column
% vector for convenient Stage01 case fields.

if nargin < 4 || isempty(ellipsoid)
    ellipsoid = local_wgs84();
end

lat = deg2rad(latDeg);
lon = deg2rad(lonDeg);
hM = hM + zeros(size(lat));

aM = local_getfield(ellipsoid, 'a_m', 6378137.0);
f = local_getfield(ellipsoid, 'f', 1 / 298.257223563);
e2 = local_getfield(ellipsoid, 'e2', 2 * f - f^2);

sinLat = sin(lat);
cosLat = cos(lat);
sinLon = sin(lon);
cosLon = cos(lon);

N = aM ./ sqrt(1 - e2 .* sinLat.^2);
x = (N + hM) .* cosLat .* cosLon;
y = (N + hM) .* cosLat .* sinLon;
z = (N .* (1 - e2) + hM) .* sinLat;

rEcefKm = [x(:), y(:), z(:)] / 1000;
if isscalar(latDeg)
    rEcefKm = rEcefKm.';
end
end

function ellipsoid = local_wgs84()
ellipsoid = struct();
ellipsoid.a_m = 6378137.0;
ellipsoid.f = 1 / 298.257223563;
ellipsoid.e2 = 2 * ellipsoid.f - ellipsoid.f^2;
end

function v = local_getfield(s, name, defaultValue)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

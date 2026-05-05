function uEcef = enuToEcefDirection(uEnu, latDeg, lonDeg)
%ENUTOECEFDIRECTION Rotate ENU direction vector(s) into ECEF.
%
% ENU columns are east, north, up. Input vectors are 3-by-N or N-by-3.

[uMat, wasRowMajor] = local_as_3_by_n(uEnu);
R = local_enu_to_ecef_matrix(latDeg, lonDeg);
uEcef = R * uMat;
if wasRowMajor
    uEcef = uEcef.';
end
end

function [v, wasRowMajor] = local_as_3_by_n(v)
wasRowMajor = false;
if size(v, 1) ~= 3 && size(v, 2) == 3
    v = v.';
    wasRowMajor = true;
end
assert(size(v, 1) == 3, 'ttube:frames:InvalidVectorShape', ...
    'Input must be 3-by-N or N-by-3.');
end

function R = local_enu_to_ecef_matrix(latDeg, lonDeg)
lat = deg2rad(latDeg);
lon = deg2rad(lonDeg);
east = [-sin(lon); cos(lon); 0];
north = [-sin(lat) * cos(lon); -sin(lat) * sin(lon); cos(lat)];
up = [cos(lat) * cos(lon); cos(lat) * sin(lon); sin(lat)];
R = [east, north, up];
end

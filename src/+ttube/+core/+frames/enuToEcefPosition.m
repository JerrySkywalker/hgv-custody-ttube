function rEcefKm = enuToEcefPosition(anchorEcefKm, rEnuKm, latDeg, lonDeg)
%ENUTOECEFPOSITION Convert local ENU offsets to ECEF position(s) [km].

[offsets, wasRowMajor] = local_as_3_by_n(rEnuKm);
anchor = anchorEcefKm(:);
assert(numel(anchor) == 3, 'ttube:frames:InvalidAnchor', ...
    'anchorEcefKm must contain three elements.');

offsetEcefKm = ttube.core.frames.enuToEcefDirection(offsets, latDeg, lonDeg);
rEcefKm = anchor + offsetEcefKm;
if wasRowMajor
    rEcefKm = rEcefKm.';
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

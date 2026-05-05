function rEciKm = ecefToEciSimple(rEcefKm, epochUtc, tS)
%ECEFTOECISIMPLE Rotate ECEF vector(s) to ECI using a simple GMST model.
%
% Inputs are in kilometers. The same rotation can be used for positions and
% directions; directions should be passed with the same units consistently.
% tS may be scalar or one value per vector.

if nargin < 3 || isempty(tS)
    tS = 0;
end

[rMat, wasRowMajor] = local_as_3_by_n(rEcefKm);
n = size(rMat, 2);
if isscalar(tS)
    tS = repmat(tS, 1, n);
else
    tS = reshape(tS, 1, []);
    assert(numel(tS) == n, 'ttube:frames:InvalidTimeGrid', ...
        'tS must be scalar or match the number of ECEF vectors.');
end

theta = local_gmst_from_utc(epochUtc) + 7.2921150e-5 * tS;
c = cos(theta);
s = sin(theta);

x = rMat(1, :);
y = rMat(2, :);
z = rMat(3, :);
rEciKm = [c .* x - s .* y; s .* x + c .* y; z];

if wasRowMajor
    rEciKm = rEciKm.';
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

function gmstRad = local_gmst_from_utc(epochUtc)
dt = local_to_datetime(epochUtc);
jd = juliandate(dt);
T = (jd - 2451545.0) / 36525.0;
gmstDeg = 280.46061837 + 360.98564736629 * (jd - 2451545.0) + ...
    0.000387933 * T^2 - (T^3) / 38710000.0;
gmstRad = deg2rad(mod(gmstDeg, 360));
end

function dt = local_to_datetime(epochUtc)
if isa(epochUtc, 'datetime')
    dt = epochUtc;
elseif ischar(epochUtc) || isstring(epochUtc)
    txt = char(string(epochUtc));
    try
        dt = datetime(txt, 'InputFormat', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', 'UTC');
    catch
        dt = datetime(txt, 'TimeZone', 'UTC');
    end
else
    error('ttube:frames:InvalidEpoch', 'epochUtc must be datetime, char, or string.');
end
if isempty(dt.TimeZone)
    dt.TimeZone = 'UTC';
end
end

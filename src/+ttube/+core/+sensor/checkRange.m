function mask = checkRange(range_km, max_range_km)
%CHECKRANGE True when slant range is within limit.

mask = isfinite(range_km) & range_km <= max_range_km;
end

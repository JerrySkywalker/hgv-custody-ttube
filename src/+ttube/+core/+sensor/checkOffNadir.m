function [mask, offnadir_deg] = checkOffNadir(r_sat_eci_km, los_sat_to_tgt_km, max_offnadir_deg)
%CHECKOFFNADIR True when LOS is within the satellite off-nadir cone.

range_km = sqrt(sum(los_sat_to_tgt_km.^2, 3));
safeRange = max(range_km, eps);
satNorm = max(sqrt(sum(r_sat_eci_km.^2, 3)), eps);
nadirDir = -r_sat_eci_km ./ satNorm;
losDir = los_sat_to_tgt_km ./ safeRange;
cval = sum(nadirDir .* losDir, 3);
cval = min(max(cval, -1), 1);
offnadir_deg = acosd(cval);
mask = offnadir_deg <= max_offnadir_deg;
end

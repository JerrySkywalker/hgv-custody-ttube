function mask = checkEarthOcclusion(r_sat_eci_km, los_sat_to_tgt_km, earth_radius_km)
%CHECKEARTHOCCLUSION True when the LOS segment does not intersect Earth.

range_km = sqrt(sum(los_sat_to_tgt_km.^2, 3));
safeRange = max(range_km, eps);
losDir = los_sat_to_tgt_km ./ safeRange;
tCa = -sum(r_sat_eci_km .* losDir, 3);
tCa = min(max(tCa, 0), range_km);
pCa = r_sat_eci_km + losDir .* tCa;
mask = sqrt(sum(pCa.^2, 3)) >= earth_radius_km;
end

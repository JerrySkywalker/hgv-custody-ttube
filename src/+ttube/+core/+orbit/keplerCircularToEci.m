function [r_eci_km, v_eci_kmps] = keplerCircularToEci(a_km, i_deg, raan_deg, u_rad, mu_km3_s2)
%KEPLERCIRCULARTOECI Circular orbit state in ECI for argument of latitude u.

i = deg2rad(i_deg);
Omega = deg2rad(raan_deg);
n = sqrt(mu_km3_s2 / a_km^3);

cu = cos(u_rad);
su = sin(u_rad);
cO = cos(Omega);
sO = sin(Omega);
ci = cos(i);
si = sin(i);

r_eci_km = [
    a_km * (cO .* cu - sO * ci .* su), ...
    a_km * (sO .* cu + cO * ci .* su), ...
    a_km * (si .* su)];

du = n;
v_eci_kmps = [
    a_km * du * (-cO .* su - sO * ci .* cu), ...
    a_km * du * (-sO .* su + cO * ci .* cu), ...
    a_km * du * (si .* cu)];
end

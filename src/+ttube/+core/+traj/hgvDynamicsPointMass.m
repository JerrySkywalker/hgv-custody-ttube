function dx = hgvDynamicsPointMass(t, x, params)
%HGVDYNAMICSPOINTMASS Native spherical ECI HGV point-mass dynamics.
%
% State: [r_eci_km(3); v_eci_kmps(3)].

control = params.controlFcn(t, x, params);
r = x(1:3);
v = x(4:6);
rNorm = max(norm(r), 1e-9);
speed = max(norm(v), 1e-9);
radial = r / rNorm;
alt_m = max((rNorm - params.earth_radius_km) * 1000, 0);

[rho, ~] = params.atmosphereFcn(alt_m, params);
[CL, CD] = params.aeroFcn(speed * 1000, alt_m, control, params);

vhat = v / speed;
q = 0.5 * rho * (speed * 1000)^2;
drag_acc_mps2 = q * params.ref_area_m2 * CD / params.mass_kg;
lift_acc_mps2 = q * params.ref_area_m2 * CL / params.mass_kg;

lift_dir = local_lift_direction(vhat, radial, control.bank_rad);
gravity_kmps2 = -params.mu_km3_s2 / rNorm^2 * radial;

acc_kmps2 = -(drag_acc_mps2 / 1000) * vhat + ...
    (lift_acc_mps2 / 1000) * lift_dir + gravity_kmps2;

dx = zeros(6,1);
dx(1:3) = v;
dx(4:6) = acc_kmps2;
end

function liftDir = local_lift_direction(vhat, radial, bankRad)
normal = radial - dot(radial, vhat) * vhat;
if norm(normal) < 1e-9
    normal = local_perpendicular(vhat);
else
    normal = normal / norm(normal);
end
side = cross(vhat, normal);
if norm(side) > 0
    side = side / norm(side);
end
liftDir = cos(bankRad) * normal + sin(bankRad) * side;
liftDir = liftDir / max(norm(liftDir), eps);
end

function u = local_perpendicular(v)
candidate = [0; 0; 1];
if abs(dot(candidate, v)) > 0.9
    candidate = [0; 1; 0];
end
u = candidate - dot(candidate, v) * v;
u = u / max(norm(u), eps);
end

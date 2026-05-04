function dx = hgvDynamicsPointMass(t, x, params)
%HGVDYNAMICSPOINTMASS Simplified flat-ENU HGV point-mass dynamics.
%
% State: [east_km; north_km; altitude_km; ve_kmps; vn_kmps; vu_kmps].

control = params.controlFcn(t, x, params);
speed = max(norm(x(4:6)), 1e-9);
alt_m = max(x(3) * 1000, 0);

rho = params.atmosphereFcn(alt_m, params);
[CL, CD] = params.aeroFcn(speed * 1000, alt_m, control, params);

vhat = x(4:6) / speed;
q = 0.5 * rho * (speed * 1000)^2;
drag_acc_mps2 = q * params.ref_area_m2 * CD / params.mass_kg;
lift_acc_mps2 = q * params.ref_area_m2 * CL / params.mass_kg;

lift_dir = local_lift_direction(vhat);
g_kmps2 = params.g0_mps2 / 1000;

acc_kmps2 = -(drag_acc_mps2 / 1000) * vhat + ...
    (lift_acc_mps2 / 1000) * lift_dir + [0; 0; -g_kmps2];

dx = zeros(6,1);
dx(1:3) = x(4:6);
dx(4:6) = acc_kmps2;
end

function liftDir = local_lift_direction(vhat)
up = [0; 0; 1];
normal = up - dot(up, vhat) * vhat;
if norm(normal) < 1e-9
    liftDir = [0; 1; 0];
else
    liftDir = normal / norm(normal);
end
end

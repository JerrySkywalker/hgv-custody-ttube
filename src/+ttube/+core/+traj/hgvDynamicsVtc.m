function dX = hgvDynamicsVtc(t, X, params)
%HGVDYNAMICSVTC Native VTC-style HGV state dynamics.
%
% State X = [v_mps; theta_rad; sigma_rad; phi_rad; lambda_rad; r_m].

v = max(X(1), 1e-9);
theta = X(2);
sigma = X(3);
phi = X(4);
r = max(X(6), 1e-9);

h = r - params.Re_m;
if h <= 0
    dX = zeros(6, 1);
    return;
end

control = params.controlFcn(t, X, params);
[rho, ~] = params.atmosphereFcn(h, params);
[CL, CD] = params.aeroFcn(v, h, control, params);

q = 0.5 * rho * v^2;
L = q * params.ref_area_m2 * CL;
D = q * params.ref_area_m2 * CD;

cosTheta = cos(theta);
sinTheta = sin(theta);
cosPhi = max(cos(phi), 1e-9);
cosThetaSafe = max(abs(cosTheta), 1e-9) * sign_with_default(cosTheta);

dv = -D / params.mass_kg - params.mu_m3_s2 / r^2 * sinTheta;
dtheta = (L * cos(control.bank_rad) - params.mass_kg * params.g0_mps2 * cosTheta + ...
    params.mass_kg * v^2 / r * cosTheta) / (params.mass_kg * v);
dsigma = -(L * sin(control.bank_rad)) / (params.mass_kg * v * cosThetaSafe) + ...
    (v / r) * cosTheta * sin(sigma) * tan(phi);
dphi = v * cosTheta * cos(sigma) / r;
dlambda = -v * cosTheta * sin(sigma) / (r * cosPhi);
dr = v * sinTheta;

dX = [dv; dtheta; dsigma; dphi; dlambda; dr];
assert(all(isfinite(dX)), 'ttube:traj:InvalidVtcDerivative', ...
    'Native VTC derivative produced non-finite values.');
end

function s = sign_with_default(x)
if x < 0
    s = -1;
else
    s = 1;
end
end

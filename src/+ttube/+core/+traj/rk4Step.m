function xNext = rk4Step(dynamicsFcn, t, x, dt, params)
%RK4STEP Advance one fixed-step Runge-Kutta sample.

k1 = dynamicsFcn(t, x, params);
k2 = dynamicsFcn(t + 0.5 * dt, x + 0.5 * dt * k1, params);
k3 = dynamicsFcn(t + 0.5 * dt, x + 0.5 * dt * k2, params);
k4 = dynamicsFcn(t + dt, x + dt * k3, params);
xNext = x + (dt / 6) * (k1 + 2*k2 + 2*k3 + k4);
end

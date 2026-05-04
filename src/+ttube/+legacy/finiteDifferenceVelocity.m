function v = finiteDifferenceVelocity(t_s, r_km)
%FINITEDIFFERENCEVELOCITY Derive km/s velocity samples from positions.

t_s = t_s(:);
assert(size(r_km, 1) == numel(t_s) && size(r_km, 2) == 3, ...
    'ttube:legacy:InvalidState', 'Position must be Nt-by-3.');
if numel(t_s) == 1
    v = zeros(1, 3);
    return;
end
v = zeros(size(r_km));
for d = 1:3
    v(:, d) = gradient(r_km(:, d), t_s);
end
end

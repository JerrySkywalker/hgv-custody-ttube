function u = normalizeVector(v, dim)
%NORMALIZEVECTOR Normalize vectors along a dimension.
%
% u = normalizeVector(v) normalizes a vector or the rows of a matrix.
% u = normalizeVector(v, dim) normalizes along the requested dimension.

if nargin < 2 || isempty(dim)
    if isvector(v)
        dim = find(size(v) ~= 1, 1, 'first');
        if isempty(dim)
            dim = 1;
        end
    else
        dim = 2;
    end
end

n = sqrt(sum(v.^2, dim));
assert(all(n(:) > 0), 'ttube:frames:ZeroNorm', 'Cannot normalize a zero vector.');
u = v ./ n;
end

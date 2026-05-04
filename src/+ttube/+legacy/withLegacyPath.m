function cleanupObj = withLegacyPath(legacyRoot)
%WITHLEGACYPATH Temporarily add the read-only legacy project to MATLAB path.

legacyRoot = char(string(legacyRoot));
assert(isfolder(legacyRoot), 'ttube:legacy:InvalidRoot', ...
    'Legacy root does not exist: %s', legacyRoot);

oldPath = path;
addpath(genpath(legacyRoot));
cleanupObj = onCleanup(@() path(oldPath));
end

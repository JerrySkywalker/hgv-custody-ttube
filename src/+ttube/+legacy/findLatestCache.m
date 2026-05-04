function cacheFile = findLatestCache(legacyRoot, pattern)
%FINDLATESTCACHE Find latest legacy stage cache by filename pattern.

cleanupObj = ttube.legacy.withLegacyPath(legacyRoot); %#ok<NASGU>
cfg = default_params();
d = find_stage_cache_files(cfg.paths.stage_outputs, pattern);
if isempty(d)
    cacheFile = '';
    return;
end
[~, idx] = max([d.datenum]);
cacheFile = fullfile(d(idx).folder, d(idx).name);
end

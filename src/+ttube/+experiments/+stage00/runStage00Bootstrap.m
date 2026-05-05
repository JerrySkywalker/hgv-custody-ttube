function artifact = runStage00Bootstrap(cfg)
%RUNSTAGE00BOOTSTRAP Create native Stage00 bootstrap artifact.

if nargin < 1, cfg = struct(); end
projectRoot = local_field(cfg, 'projectRoot', pwd);
runDir = local_field(cfg, 'runDir', fullfile(projectRoot, 'runs', 'stage00_native'));
outputDir = local_field(cfg, 'outputDir', fullfile(projectRoot, 'outputs', 'stage00_05_native'));
seed = local_field(cfg, 'random_seed', 42);
paths = struct();
paths.runDir = runDir;
paths.outputDir = outputDir;
paths.logs = fullfile(runDir, 'logs');
paths.cache = fullfile(runDir, 'cache');
paths.tables = fullfile(runDir, 'tables');
paths.figs = fullfile(runDir, 'figs');
names = fieldnames(paths);
for k = 1:numel(names)
    if ~isfolder(paths.(names{k})), mkdir(paths.(names{k})); end
end
rng(seed);

artifact = struct();
artifact.schema_version = 'stage00_bootstrap.v0';
artifact.project_root = projectRoot;
artifact.matlab_version = version;
artifact.timestamp = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
artifact.random_seed = seed;
artifact.paths = paths;
artifact.startup_status = 'ok';
artifact.test_status = local_field(cfg, 'test_status', 'not_run');
artifact.backend = 'native';

local_write_json(fullfile(runDir, 'stage00_bootstrap_summary.json'), artifact);
end

function local_write_json(path, data)
fid = fopen(path, 'w');
assert(fid > 0, 'ttube:stage00:WriteFailed', 'Failed to write %s', path);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', jsonencode(data, 'PrettyPrint', true));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

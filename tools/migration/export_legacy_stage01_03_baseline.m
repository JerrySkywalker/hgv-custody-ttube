function out = export_legacy_stage01_03_baseline(varargin)
%EXPORT_LEGACY_STAGE01_03_BASELINE Dry-run scaffold for Stage01-03 baseline.
%
% This tool is intentionally conservative. By default it does not run
% legacy stage runners and does not copy legacy outputs. It writes a small
% manifest dry-run file under the new repository baseline directory.

opts = local_parse_inputs(varargin{:});
legacy_root = local_require_dir(opts.LegacyRoot, 'LegacyRoot');
new_root = local_require_dir(opts.NewRoot, 'NewRoot');

baseline_dir = fullfile(new_root, 'legacy_reference', 'golden_small', opts.BaselineId);
if ~isfolder(baseline_dir)
    mkdir(baseline_dir);
end

local_assert_not_inside_old_repo(baseline_dir, legacy_root);

legacy_info = local_git_info(legacy_root);
risk = local_scan_output_size_risk(legacy_root);
if risk.has_large_file
    warning('ttube:migration:LargeLegacyOutput', ...
        'Legacy Stage01-03 outputs include files over %.1f MB. No files were copied.', ...
        opts.MaxFileSizeMB);
end

if opts.AllowLegacyRun
    error('ttube:migration:LegacyRunNotImplemented', ...
        ['AllowLegacyRun=true was requested, but this scaffold does not yet run ', ...
         'legacy Stage01-03. Review and implement an explicit safe runner first.']);
end

manifest = struct();
manifest.schema_version = 'legacy_baseline_manifest.v0';
manifest.baseline_id = opts.BaselineId;
manifest.legacy_repo = local_to_forward_slash(legacy_root);
manifest.legacy_branch = legacy_info.branch;
manifest.legacy_commit = legacy_info.commit;
manifest.created_utc = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyy-MM-dd''T''HH:mm:ss''Z'''));
manifest.matlab_version = version();
manifest.stages = {'stage01', 'stage02', 'stage03'};
manifest.artifacts = struct( ...
    'stage01_casebank', '', ...
    'stage02_trajbank', '', ...
    'stage03_satbank', '', ...
    'stage03_visbank', '');
manifest.dry_run = true;
manifest.allow_legacy_run = false;
manifest.notes = ['Dry-run manifest only. No legacy runner was executed ', ...
    'and no legacy outputs were copied.'];
manifest.output_size_scan = risk;

manifest_path = fullfile(baseline_dir, 'manifest.dryrun.json');
fid = fopen(manifest_path, 'w');
assert(fid > 0, 'ttube:migration:ManifestOpenFailed', ...
    'Failed to open manifest for writing: %s', manifest_path);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', jsonencode(manifest, PrettyPrint=true));
clear cleanup;

out = struct();
out.status = 'DRY_RUN';
out.manifest_path = manifest_path;
out.baseline_dir = baseline_dir;
out.legacy = legacy_info;
out.output_size_scan = risk;
end

function opts = local_parse_inputs(varargin)
p = inputParser;
p.addParameter('LegacyRoot', 'C:/Dev/src/hgv-custody-inversion-scheduling', @(x) ischar(x) || isstring(x));
p.addParameter('NewRoot', 'C:/Dev/src/hgv-custody-ttube', @(x) ischar(x) || isstring(x));
p.addParameter('BaselineId', 'stage01_03_minimal', @(x) ischar(x) || isstring(x));
p.addParameter('AllowLegacyRun', false, @(x) islogical(x) || isnumeric(x));
p.addParameter('MaxFileSizeMB', 5, @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x > 0);
p.parse(varargin{:});
opts = p.Results;
opts.LegacyRoot = char(string(opts.LegacyRoot));
opts.NewRoot = char(string(opts.NewRoot));
opts.BaselineId = char(string(opts.BaselineId));
opts.AllowLegacyRun = logical(opts.AllowLegacyRun);
end

function path_out = local_require_dir(path_in, label)
path_out = char(string(path_in));
assert(isfolder(path_out), 'ttube:migration:MissingDirectory', ...
    '%s must be an existing directory: %s', label, path_out);
path_out = char(java.io.File(path_out).getCanonicalPath());
end

function local_assert_not_inside_old_repo(candidate_dir, legacy_root)
candidate = lower(char(java.io.File(candidate_dir).getCanonicalPath()));
legacy = lower(char(java.io.File(legacy_root).getCanonicalPath()));
assert(~startsWith(candidate, legacy), 'ttube:migration:InvalidOutputRoot', ...
    'Output directory must not be inside the legacy repository.');
end

function info = local_git_info(repo_root)
[status_commit, commit_text] = system(sprintf('git -C "%s" rev-parse HEAD', repo_root));
[status_branch, branch_text] = system(sprintf('git -C "%s" branch --show-current', repo_root));
info = struct();
if status_commit == 0
    info.commit = strtrim(commit_text);
else
    info.commit = '';
end
if status_branch == 0
    info.branch = strtrim(branch_text);
else
    info.branch = '';
end
end

function risk = local_scan_output_size_risk(legacy_root)
max_file_size_mb = 5;
stage_root = fullfile(legacy_root, 'outputs', 'stage');
patterns = {
    fullfile(stage_root, 'stage01', 'cache', '*.mat')
    fullfile(stage_root, 'stage02', 'cache', '*.mat')
    fullfile(stage_root, 'stage03', 'cache', '*.mat')
    };

files = struct('path', {}, 'size_mb', {});
for k = 1:numel(patterns)
    d = dir(patterns{k});
    for j = 1:numel(d)
        files(end + 1).path = local_to_forward_slash(fullfile(d(j).folder, d(j).name)); %#ok<AGROW>
        files(end).size_mb = d(j).bytes / 1024 / 1024;
    end
end

sizes = [files.size_mb];
risk = struct();
risk.stage_output_root = local_to_forward_slash(stage_root);
risk.file_count = numel(files);
if isempty(sizes)
    risk.max_size_mb = 0;
else
    risk.max_size_mb = max(sizes);
end
risk.max_allowed_git_file_mb = max_file_size_mb;
risk.has_large_file = risk.max_size_mb > max_file_size_mb;
risk.files = files;
end

function s = local_to_forward_slash(path_in)
s = strrep(char(string(path_in)), '\', '/');
end

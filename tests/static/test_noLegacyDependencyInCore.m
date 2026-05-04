function tests = test_noLegacyDependencyInCore
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testCoreHasNoLegacyHelperDependencies(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
coreRoot = fullfile(repoRoot, 'src', '+ttube', '+core');
files = local_find_m_files(coreRoot);
local_verify_no_forbidden_tokens(testCase, files);
end

function testNativeStage05DefaultPathHasNoLegacyHelperDependencies(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
stage05Root = fullfile(repoRoot, 'src', '+ttube', '+experiments', '+stage05');
files = local_find_m_files(stage05Root);
files = files(~contains(files, 'Legacy') & ~contains(files, 'legacy'));
local_verify_no_forbidden_tokens(testCase, files);
end

function local_verify_no_forbidden_tokens(testCase, files)
forbidden = [
    "hgv-custody-inversion-scheduling"
    "build_casebank_stage01"
    "propagate_hgv_case_stage02"
    "build_single_layer_walker_stage03"
    "propagate_constellation_stage03"
    "compute_visibility_matrix_stage03"
    "build_window_info_matrix_stage04"
    "stage05_nominal_walker_search"
    ];

hits = strings(0, 1);
for k = 1:numel(files)
    txt = string(fileread(files(k)));
    for j = 1:numel(forbidden)
        if contains(txt, forbidden(j))
            hits(end+1, 1) = string(files(k)) + " contains " + forbidden(j); %#ok<AGROW>
        end
    end
end
verifyEmpty(testCase, hits, strjoin(hits, newline));
end

function files = local_find_m_files(rootDir)
d = dir(fullfile(rootDir, '**', '*.m'));
files = strings(numel(d), 1);
for k = 1:numel(d)
    files(k) = string(fullfile(d(k).folder, d(k).name));
end
end

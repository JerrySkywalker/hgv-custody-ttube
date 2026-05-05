function tests = test_stage05SearchArtifactIO
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testSaveLoadResume(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir)); %#ok<NASGU>
cfg = struct('outputDir',outDir,'saveOutputs',true,'h_grid_km',1000,'i_grid_deg',60, ...
    'P_grid',2,'T_grid',2,'Tmax_s',30,'Ts_s',5, ...
    'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false));
out = ttube.experiments.stage05.runStage05NominalSearch(cfg);
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_search_result.mat')));
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_result_table.csv')));
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_summary.json')));
verifyTrue(testCase, isfile(fullfile(outDir,'stage05_run_index.json')));
loaded = ttube.experiments.stage05.loadStage05SearchArtifact(outDir);
verifyEqual(testCase, loaded.schema_version, 'stage05_search_result.v0');
verifyEqual(testCase, loaded.result_table.D_G, out.result_table.D_G);
resumed = ttube.experiments.stage05.runStage05NominalSearch(setfield(cfg, 'resume', true)); %#ok<SFLD>
verifyEqual(testCase, resumed.result_table.D_G, out.result_table.D_G);
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

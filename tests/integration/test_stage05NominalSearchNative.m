function tests = test_stage05NominalSearchNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testSmallGrid(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir)); %#ok<NASGU>
out = ttube.experiments.stage05.runStage05NominalSearch(struct('outputDir',outDir, ...
    'saveOutputs', false, 'h_grid_km',1000,'i_grid_deg',[60 70], ...
    'P_grid',[2 4],'T_grid',[2 3],'Tmax_s',40,'Ts_s',5, ...
    'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false)));
verifyEqual(testCase, out.schema_version, 'stage05_search_result.v0');
verifyEqual(testCase, height(out.result_table), 8);
verifyTrue(testCase, isfield(out.summary, 'feasible_table'));
verifyTrue(testCase, all(isfinite(out.result_table.D_G)));
end

function testGuardRejectsLarge(testCase)
verifyError(testCase, @() ttube.experiments.stage05.runStage05NominalSearch(struct( ...
    'h_grid_km',[800 1000], 'i_grid_deg',1:20, 'P_grid',1:10, 'T_grid',1:10, ...
    'maxDesignsGuard', 20)), 'ttube:stage05:GridTooLarge');
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

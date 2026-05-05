function tests = test_legacyStage05TinyGuard
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testGuardRejectsLargeGrid(testCase)
cfg = local_cfg();
cfg.h_grid_km = [800 1000];
verifyError(testCase, @() ttube.legacy.runStage05TinyOracle(cfg), 'ttube:legacy:Stage05TinyGuard');
end

function testGuardRejectsPlot(testCase)
cfg = local_cfg();
cfg.make_plot = true;
verifyError(testCase, @() ttube.legacy.runStage05TinyOracle(cfg), 'ttube:legacy:Stage05TinyGuard');
end

function testTinyOracleRuns(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
oracle = ttube.legacy.runStage05TinyOracle(local_cfg());
verifyEqual(testCase, oracle.used_old_full_stage05_runner, false);
verifyEqual(testCase, oracle.oracle_type, 'helper-level');
verifyEqual(testCase, height(oracle.result_table), 8);
verifyTrue(testCase, all(isfinite(oracle.result_table.D_G)));
end

function cfg = local_cfg()
cfg = struct('caseId','N01','h_grid_km',1000,'i_grid_deg',[60 70], ...
    'P_grid',[2 4],'T_grid',[2 3],'F_fixed',1,'Tmax_s',80,'Ts_s',5, ...
    'Tw_s',30,'window_step_s',10,'gamma_req',1.0, ...
    'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false, ...
    'enable_offnadir_constraint',false));
end

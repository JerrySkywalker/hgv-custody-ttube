function tests = test_stage01To05Alignment
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNewPipelineStage01To05Smoke(testCase)
legacyRoot = ttube.legacy.defaultLegacyRoot();
assumeTrue(testCase, isfolder(legacyRoot), 'Legacy root unavailable.');
outDir = tempname;
cleanupObj = onCleanup(@() local_remove_dir(outDir)); %#ok<NASGU>
out = ttube.experiments.stage05.runStage05TinySearch(struct( ...
    'legacyRoot', legacyRoot, 'caseId', 'N01', 'h_grid_km', 1000, ...
    'i_grid_deg', 70, 'P_grid', 2, 'T_grid', 2, 'F_fixed', 1, ...
    'Tw_s', 20, 'window_step_s', 10, 'gamma_req', 1.0, ...
    'outputDir', outDir, ...
    'legacyOverrides', struct('stage02', struct('Tmax_s', 40, 'Ts_s', 5))));
verifyEqual(testCase, out.case.case_id, 'N01');
verifyTrue(testCase, ttube.core.traj.validateTrajectoryArtifact(out.trajectory));
verifyTrue(testCase, all(isfinite(out.result_table.D_G)));
end

function local_remove_dir(pathToRemove)
if isfolder(pathToRemove)
    rmdir(pathToRemove, 's');
end
end

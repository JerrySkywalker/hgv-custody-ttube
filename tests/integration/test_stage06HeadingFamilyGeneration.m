function tests = test_stage06HeadingFamilyGeneration
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testTrajectoryBank(testCase)
cfg = struct('profile','smoke','heading_offsets_deg',[-5 0 5], 'Tmax_s',30, 'Ts_s',5, 'saveOutputs',false);
fam = ttube.experiments.stage06.buildHeadingFamily(cfg);
bank1 = ttube.experiments.stage06.generateHeadingTrajectoryBank(cfg, fam);
bank2 = ttube.experiments.stage06.generateHeadingTrajectoryBank(cfg, fam);
verifyEqual(testCase, numel(bank1.trajectories), 3);
for k = 1:numel(bank1.trajectories)
    ttube.core.traj.validateTrajectoryArtifact(bank1.trajectories{k});
    verifyEqual(testCase, bank1.trajectories{k}.r_eci_km, bank2.trajectories{k}.r_eci_km, 'AbsTol', 1e-12);
end
end

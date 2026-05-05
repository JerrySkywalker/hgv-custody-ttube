function bundle = runStage01ScenarioDisk(cfg)
%RUNSTAGE01SCENARIODISK Build native Stage01 scenario/casebank bundle.

if nargin < 1, cfg = struct(); end
nominal = ttube.experiments.stage01.buildNominalCasebank(cfg);
heading = ttube.experiments.stage01.buildHeadingCasebank(cfg);
critical = ttube.experiments.stage01.buildCriticalCasebank(cfg);
bundle = ttube.experiments.stage01.packageStage01CasebankBundle(cfg, nominal, heading, critical);
end

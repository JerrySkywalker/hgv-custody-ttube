function out = runStage00To05Native(input)
%RUNSTAGE00TO05NATIVE Run native Stage00-05 E2E pipeline.

cfg = ttube.experiments.stage00_05.makeStage00To05Config(input);
if ~isfolder(cfg.runDir), mkdir(cfg.runDir); end
stage00 = ttube.experiments.stage00.runStage00Bootstrap(cfg);
stage01 = ttube.experiments.stage01.runStage01ScenarioDisk(struct('profile',cfg.profile));
stage02 = ttube.experiments.stage02.runStage02HgvTrajbank(stage01, cfg);
stage03 = ttube.experiments.stage03.runStage03VisibilityPipeline(stage02, cfg);
stage04 = ttube.experiments.stage04.runStage04WindowWorstcase(stage03, cfg);
stage05 = ttube.experiments.stage05.runStage05FromStage04Bundle(stage04, struct( ...
    'profile',cfg.stage05Profile,'outputDir',fullfile(cfg.outputDir,'stage05'), ...
    'saveOutputs',cfg.saveOutputs,'makePlots',cfg.makePlots,'Tmax_s',cfg.Tmax_s, ...
    'Ts_s',cfg.Ts_s));

out = struct('schema_version','stage00_05_reproduction_report.v0','cfg',cfg, ...
    'stage00',stage00,'stage01',stage01,'stage02',stage02,'stage03',stage03, ...
    'stage04',stage04,'stage05',stage05);
out.validation = ttube.experiments.stage00_05.validateStage00To05Outputs(out);
out.manifest = ttube.experiments.stage00_05.writeStage00To05Manifest(out, fullfile(cfg.runDir,'stage00_05_manifest.json'));
end

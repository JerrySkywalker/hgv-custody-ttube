function grid = buildStage05SearchGrid(cfg)
%BUILDSTAGE05SEARCHGRID Build native Stage05 Walker design grid.

cfg = ttube.experiments.stage05.makeStage05Config(cfg);
grid = ttube.experiments.stage05.buildTinySearchGrid(cfg);
end

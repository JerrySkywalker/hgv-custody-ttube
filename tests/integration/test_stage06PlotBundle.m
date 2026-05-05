function tests = test_stage06PlotBundle
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testPlotBundle(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir));
s5 = ttube.experiments.stage05.runStage05NominalSearch(struct('profile','smoke','outputDir',fullfile(outDir,'s5'),'saveOutputs',false,'Tmax_s',30));
s6 = ttube.experiments.stage06.runStage06HeadingSearch(struct('profile','smoke','outputDir',fullfile(outDir,'s6'),'saveOutputs',false,'Tmax_s',30,'heading_offsets_deg',[-5 0 5]));
frontier = ttube.experiments.stage06.extractStage06Frontier(s6.result_table);
cmp = ttube.experiments.stage06.compareStage06WithStage05(s5, s6);
b = ttube.viz.stage06.exportStage06PlotBundle(s6, frontier, cmp, fullfile(outDir,'plots'), struct('visible',false));
verifyEqual(testCase, b.schema_version, 'stage06_plot_bundle.v0');
verifyTrue(testCase, isfile(b.files.robustness_png));
verifyGreaterThan(testCase, dir(b.files.robustness_png).bytes, 0);
clear cleanup
end

function local_rm(path)
if isfolder(path), rmdir(path, 's'); end
end

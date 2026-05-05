function tests = test_stage05PlotBundle
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testPlotBundle(testCase)
outDir = tempname; cleanup = onCleanup(@() local_rm(outDir)); %#ok<NASGU>
search = ttube.experiments.stage05.runStage05NominalSearch(struct('outputDir',outDir,'saveOutputs',false, ...
    'h_grid_km',1000,'i_grid_deg',[60 70],'P_grid',2,'T_grid',[2 3], ...
    'Tmax_s',30,'Ts_s',5,'sensor',struct('max_range_km',10000,'require_earth_occlusion_check',false,'enable_offnadir_constraint',false)));
frontier = ttube.experiments.stage05.extractStage05Frontier(search.result_table);
pareto = ttube.experiments.stage05.analyzeStage05ParetoTransition(search.result_table);
bundle = ttube.viz.stage05.exportStage05PlotBundle(search, frontier, pareto, outDir, struct('visible',false));
verifyEqual(testCase, bundle.schema_version, 'stage05_plot_bundle.v0');
names = fieldnames(bundle.files);
for k=1:numel(names)
    verifyTrue(testCase, isfile(bundle.files.(names{k})));
    verifyGreaterThan(testCase, dir(bundle.files.(names{k})).bytes, 0);
end
end

function local_rm(p)
if isfolder(p), rmdir(p,'s'); end
end

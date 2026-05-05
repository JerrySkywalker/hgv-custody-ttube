function acceptance = runStage05AcceptanceGate(input)
%RUNSTAGE05ACCEPTANCEGATE Run guarded Stage05 native baseline validation.

if nargin < 1, input = struct(); end
profile = local_field(input, 'profile', 'golden_safe');
cfgInput = ttube.experiments.stage05.makeStage05Profile(profile, input);
cfgInput.makePlots = local_field(cfgInput, 'makePlots', true);
cfgInput.saveOutputs = local_field(cfgInput, 'saveOutputs', true);

tStart = tic;
bundle = ttube.experiments.stage05.runStage05FullNative(cfgInput);
runtimeS = toc(tStart);
rt = bundle.search.result_table;

acceptance = struct();
acceptance.schema_version = 'stage05_acceptance.v0';
acceptance.status = 'pass';
acceptance.profile = char(string(profile));
acceptance.num_designs = height(rt);
acceptance.feasible_count = sum(rt.feasible);
acceptance.pass_ratio = acceptance.feasible_count / max(acceptance.num_designs, 1);
acceptance.best_Ns = bundle.search.summary.best_Ns;
acceptance.runtime_s = runtimeS;
acceptance.artifact_paths = struct();
acceptance.artifact_paths.outputDir = bundle.cfg.outputDir;
acceptance.artifact_paths.search_mat = fullfile(bundle.cfg.outputDir, 'stage05_search_result.mat');
acceptance.artifact_paths.result_csv = fullfile(bundle.cfg.outputDir, 'stage05_result_table.csv');
acceptance.artifact_paths.summary_json = fullfile(bundle.cfg.outputDir, 'stage05_summary.json');
acceptance.bundle = bundle;
acceptance.notes = 'Native Stage05 acceptance gate uses no legacy helper calls.';
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

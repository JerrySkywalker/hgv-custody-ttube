function tests = test_stage06HeadingSearchNative
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testHeadingSearchSmoke(testCase)
out = ttube.experiments.stage06.runStage06HeadingSearch(struct( ...
    'profile','smoke','heading_offsets_deg',[-5 0 5], 'Tmax_s',30, 'Ts_s',5, ...
    'saveOutputs',false));
verifyEqual(testCase, out.schema_version, 'stage06_heading_search_result.v0');
verifyEqual(testCase, height(out.result_table), 1);
verifyTrue(testCase, ismember('D_G_min', out.result_table.Properties.VariableNames));
verifyTrue(testCase, ismember('worst_heading_offset_deg', out.result_table.Properties.VariableNames));
verifyTrue(testCase, islogical(out.result_table.feasible));
verifyTrue(testCase, isfinite(out.result_table.D_G_min(1)));
end

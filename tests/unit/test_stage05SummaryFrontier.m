function tests = test_stage05SummaryFrontier
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testSummaryAndFrontier(testCase)
T = local_table();
s = ttube.experiments.stage05.summarizeStage05Results(T);
f = ttube.experiments.stage05.extractStage05Frontier(T);
verifyEqual(testCase, s.schema_version, 'stage05_summary.v0');
verifyEqual(testCase, s.num_designs, 3);
verifyEqual(testCase, s.num_feasible, 2);
verifyEqual(testCase, s.best_Ns, 4);
verifyEqual(testCase, f.schema_version, 'stage05_frontier.v0');
verifyTrue(testCase, f.has_feasible);
verifyEqual(testCase, height(f.inclination_frontier), 2);
end

function testNoFeasible(testCase)
T = local_table(); T.feasible(:) = false;
s = ttube.experiments.stage05.summarizeStage05Results(T);
f = ttube.experiments.stage05.extractStage05Frontier(T);
verifyTrue(testCase, isnan(s.best_Ns));
verifyFalse(testCase, f.has_feasible);
end

function T = local_table()
T = table([1000;1000;1000],[60;60;70],[2;4;2],[2;2;3],[1;1;1],[4;8;6], ...
    [1;1;1],[2;3;4],[2;3;4],[true;false;true],[1;0;1],[5;6;7],[0.5;0.6;0.7], ...
    'VariableNames', {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst','D_G','feasible','pass_ratio','mean_visible','dual_ratio'});
end

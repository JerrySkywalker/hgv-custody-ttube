function tests = test_stage05ParetoTransition
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testParetoTransition(testCase)
T = local_table();
p = ttube.experiments.stage05.extractParetoFront(T);
a = ttube.experiments.stage05.analyzeStage05ParetoTransition(T);
verifyGreaterThan(testCase, height(p), 0);
verifyEqual(testCase, a.schema_version, 'stage05_pareto_transition.v0');
verifyTrue(testCase, ismember('max_pass_ratio', a.transition_envelope.Properties.VariableNames));
end

function testNoFeasible(testCase)
T = local_table(); T.feasible(:)=false;
p = ttube.experiments.stage05.extractParetoFront(T);
a = ttube.experiments.stage05.analyzeStage05ParetoTransition(T);
verifyEqual(testCase, height(p), 0);
verifyEqual(testCase, a.status, 'ok');
end

function T = local_table()
T = table([1000;1000;1000],[60;60;70],[2;4;2],[2;2;3],[1;1;1],[4;8;6], ...
    [1;1;1],[2;4;3],[2;4;3],[true;true;false],[1;1;0],[5;6;7],[0.5;0.6;0.7], ...
    'VariableNames', {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst','D_G','feasible','pass_ratio','mean_visible','dual_ratio'});
end

function tests = test_stage06SummaryFrontier
tests = functiontests(localfunctions);
end

function testSummaryFrontier(testCase)
t = table(["a";"b"], [1000;1000], [60;70], [2;2], [2;3], [1;1], [4;6], ...
    [1;1], [1.2;0.8], [1.3;0.9], [1;0.5], [-5;5], [true;false], ...
    'VariableNames', {'design_id','h_km','i_deg','P','T','F','Ns','gamma_req','D_G_min','D_G_mean','pass_ratio','worst_heading_offset_deg','feasible'});
s = ttube.experiments.stage06.summarizeStage06Results(t);
f = ttube.experiments.stage06.extractStage06Frontier(t);
verifyEqual(testCase, s.feasible_count, 1);
verifyEqual(testCase, s.best_Ns, 4);
verifyEqual(testCase, height(f.by_inclination), 2);
end

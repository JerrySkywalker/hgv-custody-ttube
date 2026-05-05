function tests = test_stage05ResultTableParity
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testIdenticalTables(testCase)
T = local_table();
c = ttube.experiments.stage05.compareStage05ResultTables(T, T);
verifyEqual(testCase, c.status, 'pass');
verifyEqual(testCase, c.row_count_match, true);
end

function testSmallDgDifference(testCase)
A = local_table();
B = A;
B.D_G = B.D_G + 1e-10;
c = ttube.experiments.stage05.compareStage05ResultTables(A, B, struct('D_G_abs_tol',1e-9));
verifyEqual(testCase, c.status, 'pass');
end

function testFeasibleMismatch(testCase)
A = local_table();
B = A;
B.feasible = ~B.feasible;
c = ttube.experiments.stage05.compareStage05ResultTables(A, B);
verifyEqual(testCase, c.status, 'fail');
verifyLessThan(testCase, c.feasible_match_ratio, 1);
end

function testMissingDesign(testCase)
A = local_table();
B = A(1,:);
c = ttube.experiments.stage05.compareStage05ResultTables(A, B);
verifyEqual(testCase, c.status, 'fail');
verifyFalse(testCase, c.design_key_match);
end

function testToleranceFail(testCase)
A = local_table();
B = A;
B.D_G = B.D_G + 10;
c = ttube.experiments.stage05.compareStage05ResultTables(A, B);
verifyEqual(testCase, c.status, 'fail');
end

function T = local_table()
T = table([1000;1000], [60;70], [2;4], [3;2], [1;1], [6;8], [1;1], ...
    [0.5;0.6], [0.5;0.6], [true;false], [1;0], [2;3], [0.5;0.6], ...
    'VariableNames', {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst','D_G','feasible','pass_ratio','mean_visible','dual_ratio'});
end

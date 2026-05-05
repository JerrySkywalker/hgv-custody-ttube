function tests = test_normalizeStage05ResultTable
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testNativeTable(testCase)
T = local_table();
N = ttube.experiments.stage05.normalizeStage05ResultTable(T, struct('backend','native'));
verifyEqual(testCase, width(N), 16);
verifyEqual(testCase, N.backend(1), "native");
verifyEqual(testCase, N.Ns, N.P .* N.T);
end

function testLegacyLikeAliases(testCase)
S = table(1000, 60, 2, 3, 1, 6, 1, 0.5, 0.5, true, ...
    'VariableNames', {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst_min','D_G_min','feasible_flag'});
N = ttube.experiments.stage05.normalizeStage05ResultTable(S, struct('backend','legacy'));
verifyEqual(testCase, N.D_G, 0.5);
verifyEqual(testCase, N.feasible, true);
verifyTrue(testCase, isnan(N.mean_visible));
end

function testMissingRequired(testCase)
T = removevars(local_table(), 'D_G');
verifyError(testCase, @() ttube.experiments.stage05.normalizeStage05ResultTable(T), ...
    'ttube:stage05:MissingRequiredField');
end

function testInvalidNs(testCase)
T = local_table();
T.Ns(1) = 99;
verifyError(testCase, @() ttube.experiments.stage05.normalizeStage05ResultTable(T), ...
    'ttube:stage05:InvalidResultTable');
end

function testInvalidDg(testCase)
T = local_table();
T.D_G(1) = NaN;
verifyError(testCase, @() ttube.experiments.stage05.normalizeStage05ResultTable(T), ...
    'ttube:stage05:InvalidResultTable');
end

function T = local_table()
T = table(1000, 60, 2, 3, 1, 6, 1, 0.5, 0.5, true, 1.2, 0.8, ...
    'VariableNames', {'h_km','i_deg','P','T','F','Ns','gamma_req','lambda_worst','D_G','feasible','mean_visible','dual_ratio'});
end

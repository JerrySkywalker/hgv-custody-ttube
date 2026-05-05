function tests = test_stage06TinyNativeVsLegacy
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot); startup('force', true);
end

function testNativeVsLegacyOracleDiagnostic(testCase)
native = ttube.experiments.stage06.runStage06HeadingSearch(struct( ...
    'profile','smoke','Tmax_s',30,'Ts_s',5,'heading_offsets_deg',[-5 0 5],'saveOutputs',false));
legacy = ttube.legacy.runStage06TinyOracle(struct('heading_offsets_deg',[-5 0 5], 'Tmax_s',30, 'Ts_s',5));
verifyEqual(testCase, legacy.status, 'blocked');
verifyGreaterThan(testCase, height(native.result_table), 0);
verifyMatches(testCase, legacy.blocked_reason, 'No safe standalone legacy Stage06');
end

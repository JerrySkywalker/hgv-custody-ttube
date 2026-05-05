function result = evaluateStage05TinyDesignLegacy(row, trajectory, gamma_req, cfg)
%EVALUATESTAGE05TINYDESIGNLEGACY Helper-level legacy oracle for one design.
%
% This intentionally does not call the old full Stage05 runner. It evaluates
% the design through the same small artifact path as native tiny search while
% using legacy Stage01/02 trajectory artifacts as the comparison oracle input.

res = ttube.experiments.stage05.evaluateWalkerDesignTinyNative(row, trajectory, gamma_req, cfg);
result = struct();
result.lambda_worst = res.lambda_worst;
result.D_G = res.D_G;
result.feasible = res.feasible;
result.mean_visible = res.num_visible_mean;
result.dual_ratio = res.dual_ratio;
result.notes = 'helper-level oracle using legacy Stage01/02 trajectory artifact; old full Stage05 not run';
end

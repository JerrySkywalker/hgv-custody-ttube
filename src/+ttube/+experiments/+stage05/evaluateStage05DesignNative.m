function result = evaluateStage05DesignNative(row, trajectory, gammaReq, cfg)
%EVALUATESTAGE05DESIGNNATIVE Evaluate one Stage05 native design row.

result = ttube.experiments.stage05.evaluateWalkerDesignTinyNative(row, trajectory, gammaReq, cfg);
result.backend = 'native';
end

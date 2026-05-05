function artifact = analyzeStage05ParetoTransition(resultTable)
%ANALYZESTAGE05PARETOTRANSITION Build Pareto/transition artifact.

T = ttube.experiments.stage05.normalizeStage05ResultTable(resultTable);
artifact = struct();
artifact.schema_version = 'stage05_pareto_transition.v0';
artifact.pareto_table = ttube.experiments.stage05.extractParetoFront(T);
artifact.transition_table = ttube.experiments.stage05.analyzeInclinationTransition(T);
artifact.transition_envelope = local_envelope(T);
artifact.status = 'ok';
end

function env = local_envelope(T)
groups = unique(T(:, {'i_deg','Ns'}));
max_pass_ratio = nan(height(groups),1);
max_D_G = nan(height(groups),1);
for r=1:height(groups)
    idx = T.i_deg == groups.i_deg(r) & T.Ns == groups.Ns(r);
    max_pass_ratio(r) = max(T.pass_ratio(idx));
    max_D_G(r) = max(T.D_G(idx));
end
env = groups; env.max_pass_ratio = max_pass_ratio; env.max_D_G = max_D_G;
end

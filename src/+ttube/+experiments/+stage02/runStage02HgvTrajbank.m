function bundle = runStage02HgvTrajbank(stage01Bundle, cfg)
%RUNSTAGE02HGVTRAJBANK Build native Stage02 trajectory bank bundle.

if nargin < 2, cfg = struct(); end
backend = local_field(cfg, 'trajectoryBackend', 'native_vtc');
Tmax = local_field(cfg, 'Tmax_s', 60);
Ts = local_field(cfg, 'Ts_s', 5);
trajbank = struct();
trajbank.nominal = local_propagate(stage01Bundle.nominal, backend, Tmax, Ts);
trajbank.heading = local_propagate(stage01Bundle.heading, backend, Tmax, Ts);
trajbank.critical = local_propagate(stage01Bundle.critical, backend, Tmax, Ts);
summary = ttube.experiments.stage02.summarizeStage02Trajbank(trajbank);
bundle = ttube.experiments.stage02.packageStage02TrajbankBundle(cfg, trajbank, summary, backend);
end

function out = local_propagate(cases, backend, Tmax, Ts)
out = cell(numel(cases), 1);
for k = 1:numel(cases)
    traj = ttube.core.traj.propagateHgvTrajectory(struct('backend',backend,'case',cases(k),'Tmax_s',Tmax,'Ts_s',Ts));
    ttube.core.traj.validateTrajectoryArtifact(traj);
    out{k} = traj;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

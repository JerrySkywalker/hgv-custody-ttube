function bundle = runStage04WindowWorstcase(stage03Bundle, cfg)
%RUNSTAGE04WINDOWWORSTCASE Build native Stage04 window/gamma bundle.

if nargin < 2, cfg = struct(); end
Tw = local_field(cfg, 'Tw_s', 30);
step = local_field(cfg, 'window_step_s', 10);
gammaReq = local_field(cfg, 'gamma_req', 1.0);
families = {'nominal','heading','critical'};
familySummary = struct();
smallMetrics = struct();
for i = 1:numel(families)
    fam = families{i};
    bank = stage03Bundle.visbank.(fam);
    [familySummary.(fam), smallMetrics.(fam)] = local_family(bank, stage03Bundle.constellation, Tw, step, gammaReq);
end
gammaMeta = struct('gamma_req',gammaReq,'source','manual_or_native_default','notes','Native E2E uses manual/default gamma unless configured.');
summary = ttube.experiments.stage04.summarizeStage04WindowGamma(familySummary, gammaMeta);
bundle = ttube.experiments.stage04.packageStage04WindowGammaBundle(cfg, Tw, step, gammaReq, gammaMeta, familySummary, summary, smallMetrics);
end

function [summary, metrics] = local_family(bank, constellation, Tw, step, gammaReq)
lambda = nan(numel(bank),1); dg = nan(numel(bank),1); nWin = zeros(numel(bank),1);
metrics = cell(numel(bank),1);
for k = 1:numel(bank)
    access = bank{k};
    window = ttube.core.visibility.buildWindowGrid(access, Tw, step);
    info = ttube.core.estimation.buildWindowInformationMatrix(access, constellation, window, struct('backend','native'));
    d = ttube.core.metrics.computeDGProduction(info.lambda_worst, gammaReq);
    lambda(k) = info.lambda_worst;
    dg(k) = d.margin;
    nWin(k) = window.num_windows;
    metrics{k} = struct('access_id',access.access_id,'lambda_worst',info.lambda_worst,'D_G',d.margin,'num_windows',nWin(k));
end
summary = struct('case_count',numel(bank),'lambda_worst_min',min(lambda,[],'omitnan'), ...
    'D_G_min',min(dg,[],'omitnan'),'D_G_mean',mean(dg,'omitnan'),'num_windows_mean',mean(nWin,'omitnan'));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

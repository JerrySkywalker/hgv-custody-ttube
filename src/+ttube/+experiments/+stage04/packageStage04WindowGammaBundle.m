function bundle = packageStage04WindowGammaBundle(cfg, Tw, step, gammaReq, gammaMeta, familySummary, summary, smallMetrics)
%PACKAGESTAGE04WINDOWGAMMABUNDLE Package native Stage04 bundle.

bundle = struct();
bundle.schema_version = 'stage04_window_gamma_bundle.v0';
bundle.Tw_s = Tw;
bundle.window_step_s = step;
bundle.gamma_req = gammaReq;
bundle.gamma_meta = gammaMeta;
bundle.per_family_summary = familySummary;
bundle.worst_window_summary = summary.worst_window_summary;
bundle.summary = summary;
bundle.small_window_metrics = smallMetrics;
bundle.backend = 'native';
bundle.profile = char(string(local_field(cfg,'profile','tiny')));
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

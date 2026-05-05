function bundle = runStage05FromStage04Bundle(stage04Bundle, cfg)
%RUNSTAGE05FROMSTAGE04BUNDLE Run Stage05 using Stage04 gamma/window settings.

if nargin < 2, cfg = struct(); end
input = cfg;
input.gamma_req = stage04Bundle.gamma_req;
input.Tw_s = stage04Bundle.Tw_s;
input.window_step_s = stage04Bundle.window_step_s;
input.profile = local_field(cfg, 'profile', 'smoke');
full = ttube.experiments.stage05.runStage05FullNative(input);
bundle = struct();
bundle.schema_version = 'stage05_search_bundle.v0';
bundle.stage04_source_schema = stage04Bundle.schema_version;
bundle.search = full.search;
bundle.summary = full.summary;
bundle.frontier = full.frontier;
bundle.pareto = full.pareto;
bundle.plot_bundle = full.plot_bundle;
bundle.cfg = full.cfg;
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

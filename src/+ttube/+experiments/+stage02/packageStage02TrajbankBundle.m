function bundle = packageStage02TrajbankBundle(cfg, trajbank, summary, backend)
%PACKAGESTAGE02TRAJBANKBUNDLE Package native Stage02 trajectory bundle.

bundle = struct();
bundle.schema_version = 'stage02_trajbank_bundle.v0';
bundle.trajbank = trajbank;
bundle.summary = summary;
bundle.validation = 'passed';
bundle.backend = backend;
bundle.profile = char(string(local_field(cfg,'profile','tiny')));
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

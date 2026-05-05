function bundle = packageStage03AccessBundle(cfg, walker, constellation, visbank, summary)
%PACKAGESTAGE03ACCESSBUNDLE Package native Stage03 access bundle.

bundle = struct();
bundle.schema_version = 'stage03_access_bundle.v0';
bundle.walker = walker;
bundle.constellation = constellation;
bundle.visbank = visbank;
bundle.summary = summary;
bundle.backend = 'native';
bundle.profile = char(string(local_field(cfg,'profile','tiny')));
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

function bundle = packageStage01CasebankBundle(cfg, nominal, heading, critical)
%PACKAGESTAGE01CASEBANKBUNDLE Package Stage01 casebank bundle.

bundle = struct();
bundle.schema_version = 'stage01_casebank_bundle.v0';
bundle.nominal = nominal;
bundle.heading = heading;
bundle.critical = critical;
bundle.summary = struct('nominal_count',numel(nominal),'heading_count',numel(heading), ...
    'critical_count',numel(critical),'profile',char(string(local_field(cfg,'profile','tiny'))));
bundle.backend = 'native_geodetic';
bundle.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

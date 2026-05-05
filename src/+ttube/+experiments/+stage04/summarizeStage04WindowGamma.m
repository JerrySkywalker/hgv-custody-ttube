function summary = summarizeStage04WindowGamma(familySummary, gammaMeta)
%SUMMARIZESTAGE04WINDOWGAMMA Summarize Stage04 window/gamma outputs.

summary = struct();
summary.schema_version = 'stage04_summary.v0';
summary.gamma_meta = gammaMeta;
summary.per_family = familySummary;
summary.worst_window_summary = struct('nominal_D_G_min',familySummary.nominal.D_G_min, ...
    'heading_D_G_min',familySummary.heading.D_G_min,'critical_D_G_min',familySummary.critical.D_G_min);
summary.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

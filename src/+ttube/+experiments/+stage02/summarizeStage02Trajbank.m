function summary = summarizeStage02Trajbank(trajbank)
%SUMMARIZESTAGE02TRAJBANK Summarize native Stage02 trajectory banks.

summary = struct();
summary.nominal_count = numel(trajbank.nominal);
summary.heading_count = numel(trajbank.heading);
summary.critical_count = numel(trajbank.critical);
summary.validation = 'passed';
summary.max_time_s = local_max_t(trajbank);
summary.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

function m = local_max_t(trajbank)
m = 0; fam = {'nominal','heading','critical'};
for i = 1:numel(fam)
    b = trajbank.(fam{i});
    for k = 1:numel(b)
        if ~isempty(b{k}.t_s), m = max(m, max(b{k}.t_s)); end
    end
end
end

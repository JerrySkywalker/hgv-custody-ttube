function summary = summarizeStage03AccessBundle(visbank)
%SUMMARIZESTAGE03ACCESSBUNDLE Summarize native Stage03 access bundle.

summary = struct();
families = {'nominal','heading','critical'};
for i = 1:numel(families)
    fam = families{i};
    bank = visbank.(fam);
    values = nan(numel(bank),1);
    dual = nan(numel(bank),1);
    for k = 1:numel(bank)
        values(k) = mean(bank{k}.num_visible, 'omitnan');
        dual(k) = mean(bank{k}.dual_coverage_mask, 'omitnan');
    end
    summary.(fam) = struct('count',numel(bank),'mean_visible',mean(values,'omitnan'), ...
        'dual_ratio',mean(dual,'omitnan'));
end
summary.created_utc = char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss"));
end

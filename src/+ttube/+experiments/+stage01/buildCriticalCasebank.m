function cases = buildCriticalCasebank(cfg)
%BUILDCRITICALCASEBANK Build native critical Stage01 cases.

profile = char(string(local_field(cfg,'profile','tiny')));
switch profile
    case 'smoke', n = 0; theta = [];
    case 'medium_safe', n = 2; theta = [90 270];
    otherwise, n = 1; theta = 180;
end
if n == 0, cases = struct([]); return; end
cases = repmat(ttube.experiments.stage05.buildStage01CasebankNative(struct()), n, 1);
for k = 1:n
    c = cfg; c.entry_theta_deg = theta(k); c.heading_deg = 180; c.caseId = sprintf('C%02d', k);
    cases(k) = ttube.experiments.stage05.buildStage01CasebankNative(c);
    cases(k).family = 'critical'; cases(k).subfamily = 'critical'; cases(k).case_id = c.caseId;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

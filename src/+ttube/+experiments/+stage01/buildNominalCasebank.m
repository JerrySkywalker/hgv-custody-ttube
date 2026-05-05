function cases = buildNominalCasebank(cfg)
%BUILDNOMINALCASEBANK Build native nominal Stage01 cases.

n = local_count(cfg, 'nominal');
theta = linspace(0, 360, n + 1); theta(end) = [];
cases = local_cases(cfg, theta, zeros(1, n), 'nominal');
end

function n = local_count(cfg, family)
profile = char(string(local_field(cfg,'profile','tiny')));
switch profile
    case 'smoke', counts = struct('nominal',1,'heading',0,'critical',0);
    case 'medium_safe', counts = struct('nominal',6,'heading',6,'critical',2);
    otherwise, counts = struct('nominal',3,'heading',3,'critical',1);
end
n = counts.(family);
end

function cases = local_cases(cfg, theta, headingOffset, family)
cases = repmat(ttube.experiments.stage05.buildStage01CasebankNative(struct()), numel(theta), 1);
for k = 1:numel(theta)
    c = cfg; c.entry_theta_deg = theta(k); c.heading_deg = 180 + headingOffset(k); c.caseId = sprintf('%s%02d', upper(family(1)), k);
    cases(k) = ttube.experiments.stage05.buildStage01CasebankNative(c);
    cases(k).family = family; cases(k).subfamily = family; cases(k).case_id = c.caseId;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

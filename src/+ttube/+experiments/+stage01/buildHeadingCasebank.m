function cases = buildHeadingCasebank(cfg)
%BUILDHEADINGCASEBANK Build native heading-perturbed Stage01 cases.

profile = char(string(local_field(cfg,'profile','tiny')));
switch profile
    case 'smoke', n = 0;
    case 'medium_safe', offsets = [-15 -10 -5 5 10 15]; n = 6;
    otherwise, offsets = [-10 0 10]; n = 3;
end
if n == 0, cases = struct([]); return; end
theta = zeros(1, n);
cases = repmat(ttube.experiments.stage05.buildStage01CasebankNative(struct()), n, 1);
for k = 1:n
    c = cfg; c.entry_theta_deg = theta(k); c.heading_deg = 180 + offsets(k); c.caseId = sprintf('H%02d', k);
    cases(k) = ttube.experiments.stage05.buildStage01CasebankNative(c);
    cases(k).family = 'heading'; cases(k).subfamily = 'heading'; cases(k).heading_offset_deg = offsets(k); cases(k).case_id = c.caseId;
end
end

function v = local_field(s, f, defaultValue)
if isstruct(s) && isfield(s, f) && ~isempty(s.(f)), v = s.(f); else, v = defaultValue; end
end

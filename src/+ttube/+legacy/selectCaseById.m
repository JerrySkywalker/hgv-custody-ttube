function item = selectCaseById(bank, caseId)
%SELECTCASEBYID Select a struct record by case_id across common bank shapes.

caseId = char(string(caseId));
families = {'nominal','heading','critical'};
for i = 1:numel(families)
    fam = families{i};
    if ~isfield(bank, fam)
        continue;
    end
    arr = bank.(fam);
    for k = 1:numel(arr)
        candidate = arr(k);
        id = '';
        if isfield(candidate, 'case_id')
            id = candidate.case_id;
        elseif isfield(candidate, 'case') && isfield(candidate.case, 'case_id')
            id = candidate.case.case_id;
        elseif isfield(candidate, 'vis_case') && isfield(candidate.vis_case, 'case_id')
            id = candidate.vis_case.case_id;
        end
        if strcmp(char(string(id)), caseId)
            item = candidate;
            return;
        end
    end
end
error('ttube:legacy:CaseNotFound', 'Case not found in legacy bank: %s', caseId);
end

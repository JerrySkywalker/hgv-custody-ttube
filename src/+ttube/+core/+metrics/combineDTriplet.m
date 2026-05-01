function joint = combineDTriplet(DG_margin, DA_margin, DT_margin)
%COMBINEDTRIPLET Combine normalized synthetic DG/DA/DT margins.
%
% This Batch 2 primitive combines already-normalized toy margins. It does
% not compute production DG, DA, DT, ClosedD, or OpenD.

local_validate_margin(DG_margin);
local_validate_margin(DA_margin);
local_validate_margin(DT_margin);
local_validate_compatible_sizes(DG_margin, DA_margin, DT_margin);

DG = DG_margin;
DA = DA_margin;
DT = DT_margin;

joint_margin = min(min(DG, DA), DT);
joint_feasible = DG >= 1 & DA >= 1 & DT >= 1;

dominant_fail_tag = strings(size(joint_margin));
dominant_fail_tag(:) = "OK";

needs_tag = ~joint_feasible;
dominant_fail_tag(needs_tag & DG <= DA & DG <= DT) = "G";
dominant_fail_tag(needs_tag & DA < DG & DA <= DT) = "A";
dominant_fail_tag(needs_tag & DT < DG & DT < DA) = "T";

joint = struct();
joint.DG_margin = DG;
joint.DA_margin = DA;
joint.DT_margin = DT;
joint.joint_margin = joint_margin;
joint.joint_feasible = joint_feasible;
joint.dominant_fail_tag = dominant_fail_tag;
end

function local_validate_margin(x)
assert(isnumeric(x) && ~isempty(x) && all(isfinite(x(:))), ...
    'ttube:metrics:InvalidDMargin', ...
    'D margins must be non-empty finite numeric scalars or arrays.');
end

function local_validate_compatible_sizes(DG_margin, DA_margin, DT_margin)
sz = size(DG_margin);
if ~isequal(size(DA_margin), sz) || ~isequal(size(DT_margin), sz)
    error('ttube:metrics:IncompatibleDMarginSize', ...
        'DG_margin, DA_margin, and DT_margin must have the same size.');
end
end

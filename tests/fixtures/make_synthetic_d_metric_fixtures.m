function fixtures = make_synthetic_d_metric_fixtures()
%MAKE_SYNTHETIC_D_METRIC_FIXTURES Build Batch 2 toy D-metric margins.
%
% These fixtures are synthetic only. They do not contain Stage09 data or
% any legacy-project outputs.

fixtures = struct();
fixtures.all_pass = local_case(1.2, 1.1, 1.3, 1.1, true, "OK");
fixtures.fail_G = local_case(0.8, 1.2, 1.3, 0.8, false, "G");
fixtures.fail_A = local_case(1.2, 0.7, 1.3, 0.7, false, "A");
fixtures.fail_T = local_case(1.2, 1.3, 0.6, 0.6, false, "T");
fixtures.fail_multiple = local_case(0.9, 0.7, 0.8, 0.7, false, "A");
fixtures.tie_case = local_case(0.8, 0.8, 0.9, 0.8, false, "G");
end

function c = local_case(DG_margin, DA_margin, DT_margin, joint_margin, ...
    joint_feasible, dominant_fail_tag)
c = struct();
c.DG_margin = DG_margin;
c.DA_margin = DA_margin;
c.DT_margin = DT_margin;
c.joint_margin = joint_margin;
c.joint_feasible = joint_feasible;
c.dominant_fail_tag = dominant_fail_tag;
end

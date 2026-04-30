function fixtures = make_minimal_contract_fixtures()
%MAKE_MINIMAL_CONTRACT_FIXTURES Build synthetic contract fixtures.

t = (0:2).';
nt = numel(t);
ns = 2;

traj = struct();
traj.schema_version = 'trajectory.v0';
traj.trajectory_id = 'N_SYNTH_001';
traj.family = 'nominal';
traj.subfamily = 'synthetic';
traj.epoch_utc = '2026-01-01 00:00:00';
traj.t_s = t;
traj.r_eci_km = [7000 0 0; 7001 1 0; 7002 2 0];
traj.v_eci_kmps = repmat([0 7.5 0], nt, 1);
traj.frame_primary = 'ECI';
traj.valid_mask = true(nt, 1);

constellation = struct();
constellation.schema_version = 'constellation_state.v0';
constellation.constellation_id = 'W_SYNTH_001';
constellation.epoch_utc = traj.epoch_utc;
constellation.t_s = t;
constellation.sat_id = ["S01"; "S02"];
constellation.plane_index = [1; 1];
constellation.sat_index_in_plane = [1; 2];
constellation.r_eci_km = zeros(nt, ns, 3);
constellation.v_eci_kmps = zeros(nt, ns, 3);
constellation.r_eci_km(:,:,1) = [7100 7200; 7101 7201; 7102 7202];
constellation.r_eci_km(:,:,2) = [0 10; 1 11; 2 12];
constellation.v_eci_kmps(:,:,2) = 7.4;
constellation.walker = struct('h_km', 1000, 'i_deg', 70, 'P', 1, 'T', 2, 'F', 0);

access = struct();
access.schema_version = 'access.v0';
access.access_id = 'A_SYNTH_001';
access.trajectory_id = traj.trajectory_id;
access.constellation_id = constellation.constellation_id;
access.sensor_model_id = 'SENSOR_SYNTH_001';
access.epoch_utc = traj.epoch_utc;
access.t_s = t;
access.access_mask = [true false; true true; false true];
access.num_visible = sum(access.access_mask, 2);
access.dual_coverage_mask = access.num_visible >= 2;

window = struct();
window.schema_version = 'window.v0';
window.window_id = 'WIND_SYNTH_001';
window.access_id = access.access_id;
window.Tw_s = 1;
window.step_s = 1;
window.start_idx = [1; 2];
window.end_idx = [2; 3];
window.t0_s = [0; 1];
window.t1_s = [1; 2];

metric = struct();
metric.schema_version = 'metric.v0';
metric.metric_id = 'M_SYNTH_001';
metric.source_artifact_ids = {traj.trajectory_id, constellation.constellation_id, access.access_id};
metric.thresholds = struct('gamma_req', 1, 'sigma_A_req', 1, 'dt_crit_s', 60);
metric.case_metrics = struct('case_id', traj.trajectory_id, 'DG', 1.2, 'DA', 1.1, 'DT', 1.0);
metric.robust_metrics = struct('DG_rob', 1.2, 'DA_rob', 1.1, 'DT_rob', 1.0);
metric.pass_ratio = 1.0;
metric.failure_tags = strings(0, 1);

fixtures = struct();
fixtures.trajectory = traj;
fixtures.constellation = constellation;
fixtures.access = access;
fixtures.window = window;
fixtures.metric = metric;
end

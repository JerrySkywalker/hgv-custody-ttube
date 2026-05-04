function tests = test_accessGeometryNative
tests = functiontests(localfunctions);
end

function setupOnce(~)
repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(repoRoot);
startup('force', true);
end

function testRangeMask(testCase)
verifyEqual(testCase, ttube.core.sensor.checkRange([1 5 10], 5), [true true false]);
end

function testAllVisibleTrivial(testCase)
traj = local_traj([6378.137 0 0]);
const = local_const([6578.137 0 0]);
access = ttube.core.sensor.computeAccessGeometry(traj, const, struct( ...
    'backend','native', 'max_range_km', 500, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false));
verifyTrue(testCase, access.access_mask(1,1));
verifyEqual(testCase, access.num_visible, 1);
end

function testAllInvisibleByRange(testCase)
traj = local_traj([6378.137 0 0]);
const = local_const([10000 0 0]);
access = ttube.core.sensor.computeAccessGeometry(traj, const, struct( ...
    'backend','native', 'max_range_km', 100, ...
    'require_earth_occlusion_check', false, 'enable_offnadir_constraint', false));
verifyFalse(testCase, access.access_mask(1,1));
verifyEqual(testCase, access.num_visible, 0);
end

function traj = local_traj(r)
traj = struct('schema_version','trajectory.v0','trajectory_id','T', ...
    'family','synthetic','subfamily','synthetic','epoch_utc','2026-01-01', ...
    't_s',0,'r_eci_km',r,'v_eci_kmps',[0 0 0],'frame_primary','ECI', ...
    'valid_mask',true);
end

function const = local_const(r)
const = struct('schema_version','constellation_state.v0','constellation_id','C', ...
    'epoch_utc','2026-01-01','t_s',0,'sat_id',"S1",'plane_index',1, ...
    'sat_index_in_plane',1,'r_eci_km',reshape(r,1,1,3), ...
    'v_eci_kmps',zeros(1,1,3),'walker',struct());
end

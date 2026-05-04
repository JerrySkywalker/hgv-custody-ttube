function windowArtifact = buildWindowGrid(accessArtifact, Tw_s, step_s)
%BUILDWINDOWGRID Build a window artifact from an access artifact time grid.

[start_idx, end_idx, t0_s, t1_s] = ttube.core.visibility.extractWindowIndices( ...
    accessArtifact.t_s(:), Tw_s, step_s);

windowArtifact = struct();
windowArtifact.schema_version = 'window.v0';
windowArtifact.window_id = sprintf('%s__Tw%.0f_step%.0f', accessArtifact.access_id, Tw_s, step_s);
windowArtifact.access_id = accessArtifact.access_id;
windowArtifact.Tw_s = Tw_s;
windowArtifact.step_s = step_s;
windowArtifact.start_idx = start_idx;
windowArtifact.end_idx = end_idx;
windowArtifact.t0_s = t0_s;
windowArtifact.t1_s = t1_s;
windowArtifact.num_windows = numel(start_idx);
ttube.core.visibility.validateWindowArtifact(windowArtifact);
end

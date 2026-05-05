function writeStage05RunIndex(artifact, indexPath)
%WRITESTAGE05RUNINDEX Write lightweight Stage05 run index JSON.

idx = struct();
idx.schema_version = 'stage05_run_index.v0';
idx.created_utc = artifact.created_utc;
idx.schema = artifact.schema_version;
idx.num_designs = height(artifact.result_table);
idx.num_feasible = artifact.summary.num_feasible;
idx.trajectoryBackend = artifact.trajectoryBackend;
idx.producer = artifact.producer;
fid = fopen(indexPath, 'w');
assert(fid > 0, 'ttube:stage05:IndexWriteFailed', 'Failed to write Stage05 run index.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', jsonencode(idx, 'PrettyPrint', true));
end

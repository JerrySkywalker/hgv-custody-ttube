function files = saveStage05SearchArtifact(artifact, outputDir)
%SAVESTAGE05SEARCHARTIFACT Save Stage05 search artifact files.

if ~isfolder(outputDir), mkdir(outputDir); end
files = struct();
files.mat = fullfile(outputDir, 'stage05_search_result.mat');
files.csv = fullfile(outputDir, 'stage05_result_table.csv');
files.summary_json = fullfile(outputDir, 'stage05_summary.json');
files.index_json = fullfile(outputDir, 'stage05_run_index.json');
save(files.mat, 'artifact');
writetable(artifact.result_table, files.csv);
fid = fopen(files.summary_json, 'w'); cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '%s', jsonencode(artifact.summary, 'PrettyPrint', true));
ttube.experiments.stage05.writeStage05RunIndex(artifact, files.index_json);
end

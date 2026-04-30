function info = check_environment()
%CHECK_ENVIRONMENT Return a small summary of the active MATLAB environment.

repoRoot = fileparts(fileparts(mfilename('fullpath')));

info = struct();
info.repoRoot = repoRoot;
info.currentFolder = pwd;
info.matlabVersion = version;
info.hasStartup = exist(fullfile(repoRoot, 'startup.m'), 'file') == 2;
info.hasSrc = isfolder(fullfile(repoRoot, 'src'));
info.hasScripts = isfolder(fullfile(repoRoot, 'scripts'));
info.hasTests = isfolder(fullfile(repoRoot, 'tests'));

fprintf('Repository root: %s\n', info.repoRoot);
fprintf('Current folder:  %s\n', info.currentFolder);
fprintf('MATLAB version:  %s\n', info.matlabVersion);
end

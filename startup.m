function projectRoot = startup(varargin)
%STARTUP Configure the MATLAB path for this project.

projectRoot = fileparts(mfilename('fullpath'));

srcDir = fullfile(projectRoot, 'src');
scriptsDir = fullfile(projectRoot, 'scripts');
testsDir = fullfile(projectRoot, 'tests');

if isfolder(srcDir)
    addpath(genpath(srcDir));
end

if isfolder(scriptsDir)
    addpath(scriptsDir);
end

if isfolder(testsDir)
    addpath(testsDir);
end

if nargin > 0 && isequal(varargin{1}, 'force')
    % Reserved for future explicit reinitialization hooks.
end
end

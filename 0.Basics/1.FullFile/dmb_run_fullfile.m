function out = dmb_run_fullfile(in)

%%%%
%% Process input variables
%%%%
dir = in.dir;
subDirs = in.subdirs;

%% Copy inputs


%% Check inputs

%%%%
%% Perform main code
%%%%

if iscell(dir)
    dir = dir{1};
end

%% Call fullfile function
for nrSubDir = 1: length(subDirs)
    combDirs.subdirs{nrSubDir} = {fullfile(dir, subDirs{nrSubDir})};
    if ~exist(combDirs.subdirs{nrSubDir}{1}, 'dir')
        mkdir(combDirs.subdirs{nrSubDir}{1});
    end
end
    

%% Set output variables
out = combDirs;
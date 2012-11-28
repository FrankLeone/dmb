function out = cfg_donders_run_remove_SPMs(job)

out(1).SPM_dir = job.multiple_dirs;

dirs = job.multiple_dirs;
if iscell(dirs)
    dirs = fileCells2Mat(dirs);
end

for nr_dir = 1: size(dirs, 1)
    dir = dirs(nr_dir, 1:(max(find(dirs(nr_dir, :) ~= ' '))));
    [files new_dirs] = spm_select('List', dir, '^SPM.mat');
    if ~isempty(files)
        for nr_file = 1: size(files, 1)
            movefile(fullfile(dir, files(nr_file, :)), fullfile(dir, ['old_' files(nr_file, :)]));
        end
    end
    if ~isempty(new_dirs)
        job.multiple_dirs = [repmat([dir filesep], size(new_dirs, 1),  1) new_dirs];
        
        cfg_donders_run_remove_SPMs(job);
    end
end
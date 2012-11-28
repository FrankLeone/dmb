function out = dmb_run_spm_run_smooth(job)


%% Call original function
out = spm_run_smooth(job);

%% Move files to appropriate location
%% Move combined scans to new directory

if ~isempty(job.targetDir{1})
    outSplit.sess = copy_files_to_relative_directory(out.files, job.targetDir{1});
end
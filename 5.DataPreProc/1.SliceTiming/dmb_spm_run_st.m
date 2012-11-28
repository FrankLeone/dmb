function out = dmb_spm_run_st(job)

%% Split sessions
expected_n_sessions = job.expected_n_sessions;
job.scans = dmb_run_split_sessions_inline(job.data, expected_n_sessions);

%% Call original function
outPreSplit = spm_run_st(job);

%% Combine sessions again
for nrFile = 1: length(outPreSplit)
    outSplit.sess{nrFile} = outPreSplit(nrFile).files;
end

%% Move files to appropriate location
%% Move combined scans to new directory
if ~isempty(job.targetDir)
    outSplit.sess = copy_files_to_relative_directory(outSplit.sess, job.targetDir{1});
end

%% Combine sessions again
[out.files no_sessions] = dmb_run_combine_sessions_inline(outSplit.sess);

%% Check whether same number of sessions came in and out
assert (no_sessions == job.expected_n_sessions);
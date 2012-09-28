function out = dmb_spm_run_realign_estimate(job)

%% Split sessions
job.data = dmb_run_split_sessions_inline(job);

%% Call original function
outSplit = spm_run_realign_estimate(job);

%% Combine sessions again
[out no_sessions] = dmb_run_combine_sessions_inline(outSplit);

%% Check whether same number of sessions came in and out
assert (no_session == job.expected_n_sessions);
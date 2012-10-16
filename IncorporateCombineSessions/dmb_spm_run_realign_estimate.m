function out = dmb_spm_run_realign_estimate(job)

%% Split sessions
job.data = dmb_run_split_sessions_inline(job);

%% Call original function
outSplit = spm_run_realign_estimate(job);

%% Check whether we should move the files
if ~isempty(job.targetDir)
    for nrSess = 1: length(outSplit.sess)
        if job.relativeDir
        else
            [succes msg id] = movefile(outSplit.sess(nrSess).rpfile{1}, job.targetDir{1});
            if ~succes
                warning(id, msg);
            else
                [path, filename, ext] = fileparts(outSplit.sess(nrSess).rpfile{1});
                outSplit.sess(nrSess).rpfile = {fullfile(job.targetDir{1}, [filename ext])};
                assert(exist(fullfile(job.targetDir{1}, [filename ext]), 'file')>0);
            end
        end
    end
end
%% Combine sessions again
[out no_sessions] = dmb_run_combine_sessions_inline(outSplit);


%% Check whether same number of sessions came in and out
assert (no_sessions == job.expected_n_sessions);
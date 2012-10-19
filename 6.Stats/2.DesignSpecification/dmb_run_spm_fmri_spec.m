function out = dmb_run_spm_fmri_spec(job)

%% First split sessions
expected_no_sessions = job.expected_n_sessions;
scans = dmb_run_split_sessions_inline(job.sess.scans, expected_no_sessions);
conditions = dmb_run_split_sessions_inline(job.sess.multi, expected_no_sessions);
regressors = dmb_run_split_sessions_inline(job.sess.multi_reg, expected_no_sessions);

for nrSess = 1:expected_no_sessions
    job.sess(nrSess).scans = scans{nrSess};
    job.sess(nrSess).multi = conditions{nrSess};
    job.sess(nrSess).multi_reg = regressors{nrSess};
    job.sess(nrSess).cond = job.sess(1).cond;
    job.sess(nrSess).regress = job.sess(1).regress;
    job.sess(nrSess).hpf = job.sess(1).hpf;
end
%% Then run script
out = spm_run_fmri_spec(job);

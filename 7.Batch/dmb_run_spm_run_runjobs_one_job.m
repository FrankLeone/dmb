function jout = dmb_run_spm_run_runjobs_one_job(hjobs)

cjob = cfg_util('initjob', hjobs);
cfg_util('run', cjob);
jout = cfg_util('getalloutputs', cjob);
%    if isfield(job.save, 'savejobs')
%        [p n e] = fileparts(job.save.savejobs.outstub);
%        out.jobrun{1} = fullfile(p, [n '_run.m']);
%        cfg_util('saverun', cjob, out.jobrun{1});
%    end;
cfg_util('deljob', cjob);
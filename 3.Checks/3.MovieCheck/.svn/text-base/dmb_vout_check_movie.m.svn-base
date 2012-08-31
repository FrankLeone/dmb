function dep = dmb_vout_check_movie (job)

for k=1: numel(job.files)
    dep(k)            = cfg_dep;
    dep(k).sname      =  ['Data sess' num2str(k)];
    dep(k).src_output = substruct('()',{k}, '.','files');
    dep(k).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end
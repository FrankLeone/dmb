function dep = dmb_vout_segment_regressors(job)

for k=1:numel(job.files)
    dep(k)            = cfg_dep;
    dep(k).sname      = sprintf('Average segment activity (Sess %d)', k);
    dep(k).src_output = substruct('()',{k}, '.','average_intensity');
    dep(k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
end
function dep = dmb_vout_segment_regressors(job)

k = 1;
dep(k)            = cfg_dep;
dep(k).sname      = sprintf('Average segment activity all sessions');
dep(k).src_output = substruct('.','average_intensity');
dep(k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});

function dep = dmb_vout_check_movie (job)

dep            = cfg_dep;
dep.sname      = 'Data all sessions';
dep.src_output = substruct('.','data');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

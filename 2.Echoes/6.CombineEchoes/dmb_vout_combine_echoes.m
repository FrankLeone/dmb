function dep = dmb_vout_combine_echoes (job)

dep            = cfg_dep;
dep.sname      =  'All combines data';
dep.src_output = substruct('.','data');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

dep(2)            = cfg_dep;
dep(2).sname      = 'Number of sessions';
dep(2).src_output = substruct('.','no_sessions');
dep(2).tgt_spec   = cfg_findspec({{'strtype','n'}});

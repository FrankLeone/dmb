function dep = cfg_donders_vout_general (job)

dep            = cfg_dep;
dep.sname      =  ['All combines data'];
dep.src_output = substruct('.','data');
dep.tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});

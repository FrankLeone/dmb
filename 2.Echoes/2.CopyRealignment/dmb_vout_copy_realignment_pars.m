function dep = dmb_vout_copy_realignment_pars(job)
q = 1;
dep(q)            = cfg_dep;
dep(q).sname      =  ['All echoes for all sessions'];
dep(q).src_output = substruct('()',{q}, '.','data');
dep(q).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
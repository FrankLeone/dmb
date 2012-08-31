function dep = dmb_vout_combine_sessions(job)

dep(1)              = cfg_dep;
dep(1).sname        = 'Combined data';
dep(1).src_output   = substruct('()',{1}, '.','total_data');
dep(1).tgt_spec     = cfg_findspec({{'filter', 'image', 'strtype', 'e'}});

dep(2)              = cfg_dep;
dep(2).sname        = 'Number of sessions';
dep(2).src_output   = substruct('.', {2}, '.', 'no_sessions');
dep(2).tgt_spec     = cfg_findspec({{'strtype', 'n'}});

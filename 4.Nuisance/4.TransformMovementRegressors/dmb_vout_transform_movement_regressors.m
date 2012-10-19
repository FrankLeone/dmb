function dep = dmb_vout_transform_movement_regressors(job)

k = 1;
dep(k)            = cfg_dep;
dep(k).sname      = sprintf('Derivative movements');
dep(k).src_output = substruct('.','R');
dep(k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});

k = 2;
dep(k)            = cfg_dep;
dep(k).sname      = sprintf('Original movement file');
dep(k).src_output = substruct('.','orig');
dep(k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});

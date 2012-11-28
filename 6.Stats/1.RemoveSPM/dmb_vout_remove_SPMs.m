function dep = cfg_donders_vout_remove_SPMs (job)

dep(1)                  = cfg_dep;
dep(1).sname            = sprintf('Base SPM dir');
dep(1).src_output       = substruct('()', {1}, '.', 'SPM_dir');
dep(1).tgt_spec         = cfg_findspec({{'filter', 'dir', 'strtype', 'e'}});
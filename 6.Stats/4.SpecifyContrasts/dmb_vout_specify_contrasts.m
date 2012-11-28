function dep = dmb_vout_specify_contrasts (job)

for k = 1: length (job.SPMs)
    dep(k)              = cfg_dep;
    dep(k).sname        = sprintf('SPM %d', k);
    dep(k).src_output   = substruct('()', {k}, '.', 'SPMs');
    dep(k).tgt_spec     = cfg_findspec({{'filter', 'mat', 'strtype', 'e'}});
end
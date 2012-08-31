function dep = dmb_vout_combine_nuisance_regressors(job)

for k=1:numel(job.regressor)
    dep(1)            = cfg_dep;
    dep(1).sname      = sprintf('Combined regressors for (Sess %d)', k);
    dep(1).src_output = substruct('()',{k}, '.','R');
    dep(1).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
end
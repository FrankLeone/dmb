function dep = dmb_vout_transform_movement_regressors(job)

for k=1:numel(job.regressor)
    dep(k)            = cfg_dep;
    dep(k).sname      = sprintf('Derivative movements (Sess %d)', k);
    dep(k).src_output = substruct('()',{k}, '.','R');
    dep(k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
end

l = length(dep);
for k=1:numel(job.regressor)
    dep(l+k)            = cfg_dep;
    dep(l+k).sname      = sprintf('Original movement file (Sess %d)', k);
    dep(l+k).src_output = substruct('()',{k}, '.','orig');
    dep(l+k).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
end
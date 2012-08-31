function dep = dmb_vout_copy_realignment_pars(job)
nechoes = donders_get_defaults('nechoes');
q = 1;
for k=1: size(job.files, 2)
    for l = 1: nechoes 
        dep(q)            = cfg_dep;
        dep(q).sname      =  ['Niis with copied vars sess ' num2str(k) ' echo ' num2str(l)];
        dep(q).src_output = substruct('()',{q}, '.','files');
        dep(q).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
        q = q + 1;
    end
    dep(q)            = cfg_dep;
    dep(q).sname      =  ['All data sess ' num2str(k)];
    dep(q).src_output = substruct('()',{q}, '.','files');
    dep(q).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    q = q +1;
end 
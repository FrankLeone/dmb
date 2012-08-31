function dep = dmb_vout_order_converted_dicoms(job)
nechoes = donders_get_defaults('nechoes');
for k=1: (job.expected_n_sessions)
    for l = 1: nechoes 
        dep((k-1) * nechoes + l)            = cfg_dep;
        dep((k-1) * nechoes + l).sname      =  ['Ordered niis sess' num2str(k) ' echo ' num2str(l)];
        dep((k-1) * nechoes + l).src_output = substruct('()',{(k-1) * nechoes + l}, '.','files');
        dep((k-1) * nechoes + l).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    end
end

dep(length(dep)+1)        = cfg_dep;
dep(length(dep)).sname  = ['Subject name'];
dep(length(dep)).src_output = substruct('()', {1}, '.', 'subject');
dep(length(dep)).tgt_spec   = cfg_findspec({{'strtype', 's'}});
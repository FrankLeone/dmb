function dep = dmb_vout_split_sessions(job)

no_sessions = job.expected_n_sessions;

if ~strcmp(no_sessions, '<UNDEFINED>')
    for k=1: no_sessions
        dep(k)            = cfg_dep;
        dep(k).sname      =  ['Data session ' num2str(k)];
        dep(k).src_output = substruct('()',{k}, '.','data');
        dep(k).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});    
    end 
else
    dep = [];
end
function out = dmb_vout_fullfile(in)

%%%%
%% Process input variables
%%%%

%% Copy inputs


%% Check inputs

%%%%
%% Perform main code
%%%%
if ~isempty(in.subdirs) %~strcmp(in.subdirs, '<UNDEFINED>')
    for nrIn = 1: length(in.subdirs)
        dep(nrIn)            = cfg_dep; 
        if isstr(in.subdirs{nrIn})
            dep(nrIn).sname      = in.subdirs{nrIn};            
        else
            dep(nrIn).sname     = in.subdirs{nrIn}.sname;
        end
        dep(nrIn).src_output = substruct('.','subdirs','{}',{nrIn});
        dep(nrIn).tgt_spec   = cfg_findspec({{'filter','dir','strtype','e'}});        
    end
else
    dep = [];
end
   
%% Set output variables
out = dep;
function dmb_item_fullfile = dmb_item_fullfile

internal_dir_files = cfg_files;
internal_dir_files.tag = 'dir';
internal_dir_files.name = 'Directory';
internal_dir_files.help = {'The base directory.'};
internal_dir_files.filter     = 'dir';
internal_dir_files.ufilter    = '.*';
internal_dir_files.num = [1 1]; 

internal_subdirs_entry = cfg_entry;
internal_subdirs_entry.tag = 'subdirs';
internal_subdirs_entry.name = 'Subdirectory';
internal_subdirs_entry.help = {'The subdirectories to be fullfiled to.'};
internal_subdirs_entry.strtype = 's';
internal_subdirs_entry.num = [1 inf]; 

generic         = cfg_repeat;
generic.tag     = 'generic';
generic.name    = 'Subdirectories';
generic.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
generic.values  = {internal_subdirs_entry };
generic.num     = [1 Inf];

% ---------------------------------------------------------------------
%
% ---------------------------------------------------------------------  
dmb_item_fullfile              = cfg_exbranch;
dmb_item_fullfile.name         = 'Fullfile';
dmb_item_fullfile.tag          = 'fullfile';
dmb_item_fullfile.val          = {internal_dir_files, generic};
dmb_item_fullfile.help         = {'Combine a dir and subdirs'};
dmb_item_fullfile.prog         = @dmb_run_fullfile;
dmb_item_fullfile.vout         = @dmb_vout_fullfile;
function file_fplist = dmb_item_spm_file_selector
% ---------------------------------------------------------------------
% dir Directory
% ---------------------------------------------------------------------
dir         = cfg_files;
dir.tag     = 'dir';
dir.name    = 'Directory';
dir.help    = {'Directory to select files from.'};
dir.filter = 'dir';
dir.ufilter = '.*';
dir.num     = [1 Inf];
% ---------------------------------------------------------------------
% filter Filter
% ---------------------------------------------------------------------
filter         = cfg_entry;
filter.tag     = 'filter';
filter.name    = 'Filter';
filter.help    = {'A regular expression to filter files.'};
filter.strtype = 's';
filter.num     = [1  Inf];
% ---------------------------------------------------------------------
% rec Descend into subdirectories
% ---------------------------------------------------------------------
rec         = cfg_menu;
rec.tag     = 'rec';
rec.name    = 'Descend into subdirectories';
rec.help    = {'Files can be selected from the specified directory only or from the specified directory and all its subdirectories.'};
rec.labels = {
              'Yes'
              'No'
              }';
rec.values = {
              'FPListRec'
              'FPList'
              }';
% ---------------------------------------------------------------------
% file_fplist File Selector (Batch Mode)
% ---------------------------------------------------------------------
file_fplist         = cfg_exbranch;
file_fplist.tag     = 'file_fplist';
file_fplist.name    = 'File Selector (Batch Mode)(SPM)';
file_fplist.val     = {dir filter rec };
file_fplist.help    = {'Select files from a directory using cfg_getfile(''FPList'',...).'};
file_fplist.prog = @cfg_run_file_fplist;
file_fplist.vout = @cfg_vout_file_fplist;
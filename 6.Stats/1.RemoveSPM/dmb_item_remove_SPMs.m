function dmb_item_remove_SPMs = dmb_item_remove_SPMs

multiple_dirs         = cfg_files;
multiple_dirs.tag     = 'multiple_dirs';
multiple_dirs.name    = 'Dirs';
multiple_dirs.help    = {'Select the target directories'};
multiple_dirs.filter = 'dir';
multiple_dirs.ufilter = '.*';
multiple_dirs.num     = [0 inf];

dmb_item_remove_SPMs             = cfg_exbranch;
dmb_item_remove_SPMs.name        = 'Remove SPMs';
dmb_item_remove_SPMs.tag         = 'dmb_item_remove_SPMs';
dmb_item_remove_SPMs.val         = {multiple_dirs};
dmb_item_remove_SPMs.help        = {'Removes the SPM.mat''s in a dir and its subdirectories, saving you the trouble of clicking through the dialogs'};
dmb_item_remove_SPMs.prog        = @dmb_run_remove_SPMs;
dmb_item_remove_SPMs.vout        = @dmb_vout_remove_SPMs;
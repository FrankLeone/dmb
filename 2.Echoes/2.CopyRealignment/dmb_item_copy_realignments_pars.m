function dmb_menu_copy_realignments_pars = dmb_menu_copy_realignments_pars
% ---------------------------------------------------------------------
% files Session
% ---------------------------------------------------------------------
files         = cfg_files;
files.tag     = 'files';
files.name    = 'Session';
files.help    = {'Select images.'};
files.filter = 'image';
files.ufilter = '.*';
files.num     = [1 Inf];

% ---------------------------------------------------------------------
% generic Data
% ---------------------------------------------------------------------
sessions         = cfg_repeat;
sessions.tag     = 'sessions';
sessions.name    = 'Sessions';
sessions.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
sessions.values  = {files };
sessions.num     = [1 Inf];

% ---------------------------------------------------------------------
% dmb_menu_copy_movement_vars
% ---------------------------------------------------------------------
dmb_menu_copy_realignments_pars           = cfg_exbranch;
dmb_menu_copy_realignments_pars.tag       = 'copy_realignment_parameters';
dmb_menu_copy_realignments_pars.name      = 'Copy realignment parameters';
dmb_menu_copy_realignments_pars.val       = {sessions};
dmb_menu_copy_realignments_pars.help      = {'Copies movement vars from one echo to the others. Only select the scan which already has the movement vars, other echos will be found automatically.'};
dmb_menu_copy_realignments_pars.prog      = @dmb_run_copy_realignment_pars;
dmb_menu_copy_realignments_pars.vout      = @dmb_vout_copy_realignment_pars;
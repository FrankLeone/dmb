function dmb_item_copy_realignment_pars = dmb_item_copy_realignment_pars
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

nechoes              = cfg_entry;
nechoes.tag          = 'nechoes';
nechoes.name         = 'Number of echoes';
nechoes.help         = {'How many echoes were aquired per scan?'};
nechoes.strtype      = 'n';
nechoes.num          = [0 1];
nechoes.def          = @(val)dmb_cfg_get_defaults('combine_echoes.nechoes', val{:});

% ---------------------------------------------------------------------
% dmb_menu_copy_movement_vars
% ---------------------------------------------------------------------
dmb_item_copy_realignment_pars           = cfg_exbranch;
dmb_item_copy_realignment_pars.tag       = 'copy_realignment_parameters';
dmb_item_copy_realignment_pars.name      = 'Copy realignment parameters';
dmb_item_copy_realignment_pars.val       = {sessions, nechoes};
dmb_item_copy_realignment_pars.help      = {'Copies movement vars from one echo to the others. Only select the scan which already has the movement vars, other echos will be found automatically.'};
dmb_item_copy_realignment_pars.prog      = @dmb_run_copy_realignment_pars;
dmb_item_copy_realignment_pars.vout      = @dmb_vout_copy_realignment_pars;
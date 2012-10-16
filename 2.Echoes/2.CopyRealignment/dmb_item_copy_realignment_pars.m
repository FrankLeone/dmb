function dmb_item_copy_realignment_pars = dmb_item_copy_realignment_pars
% ---------------------------------------------------------------------
% files Session
% ---------------------------------------------------------------------
data         = cfg_files;
data.tag     = 'data';
data.name    = 'Data';
data.help    = {'Select images.'};
data.filter = 'image';
data.ufilter = '.*';
data.num     = [1 Inf];

nechoes              = cfg_entry;
nechoes.tag          = 'nechoes';
nechoes.name         = 'Number of echoes';
nechoes.help         = {'How many echoes were aquired per scan?'};
nechoes.strtype      = 'n';
nechoes.num          = [0 1];
nechoes.def          = @(val)dmb_cfg_get_defaults('combine_echoes.nechoes', val{:});

% ---------------------------------------------------------------------
% expected_n_sessions Number of sessions to be expected
% ---------------------------------------------------------------------
expected_n_sessions         = cfg_entry;
expected_n_sessions.tag     = 'expected_n_sessions';
expected_n_sessions.name    = 'Number of sessions';
expected_n_sessions.help    = {'Expected number of sessions.'};
expected_n_sessions.strtype = 'n';
expected_n_sessions.num     = [1  inf];
expected_n_sessions.def     = @(val)dmb_cfg_get_defaults('order_niis.expected_n_sessions', val{:});

% ---------------------------------------------------------------------
% dmb_menu_copy_movement_vars
% ---------------------------------------------------------------------
dmb_item_copy_realignment_pars           = cfg_exbranch;
dmb_item_copy_realignment_pars.tag       = 'copy_realignment_parameters';
dmb_item_copy_realignment_pars.name      = 'Copy realignment parameters';
dmb_item_copy_realignment_pars.val       = {data, nechoes, expected_n_sessions};
dmb_item_copy_realignment_pars.help      = {'Copies movement vars from one echo to the others. Only select the scan which already has the movement vars, other echos will be found automatically.'};
dmb_item_copy_realignment_pars.prog      = @dmb_run_copy_realignment_pars;
dmb_item_copy_realignment_pars.vout      = @dmb_vout_copy_realignment_pars;
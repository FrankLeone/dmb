function dmb_menu_split_sessions = dmb_menu_split_sessions
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
% expected_n_sessions Number of sessions to be expected
% ---------------------------------------------------------------------
dmb_menu_split_sessions              = cfg_exbranch;
dmb_menu_split_sessions.name         = 'Split sessions';
dmb_menu_split_sessions.tag          = 'split_sessions';
dmb_menu_split_sessions.val          = {data, expected_n_sessions};
dmb_menu_split_sessions.help         = {'Splits the sessions on the basis of their directory structure. Useful in combination with combine sessions, with for example a reslicing in-between.'};
dmb_menu_split_sessions.prog         = @dmb_run_split_sessions;
dmb_menu_split_sessions.vout         = @dmb_vout_split_sessions;
function dmb_menu_combine_echoes = dmb_menu_combine_echoes
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
% sessions Data
% ---------------------------------------------------------------------
sessions         = cfg_repeat;
sessions.tag     = 'generic';
sessions.name    = 'Data';
sessions.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
sessions.values  = {data };
sessions.num     = [1 Inf];

% ---------------------------------------------------------------------
% combine_method How to combine the echoes?
% ---------------------------------------------------------------------
combine_method         = cfg_menu;
combine_method.tag     = 'combine_method';
combine_method.name    = 'Combine method';
combine_method.help    = {'How should the echoes be combined? Pick the method of choice.'};
combine_method.labels  = {'sum' 'paid-v1' 'paid-v2' 'paid-v3' 'pre-paid'};
combine_method.values  = {'sum' 'paid-v1' 'paid-v2' 'paid-v3' 'pre-paid'};
combine_method.def     = @(val)dmb_cfg_get_defaults('combine_echoes.combine_method', val{:});

echo_times              = cfg_entry;
echo_times.tag          = 'echo_times';
echo_times.name         = 'Echo times';
echo_times.help         = {'When were the different echoes taken (in ms)? Make sure you enter as many numbers as there are echoes.'};
echo_times.strtype      = 'r';
echo_times.num          = [1 inf];

n_pre_vols              = cfg_entry;
n_pre_vols.tag          = 'n_pre_vols';
n_pre_vols.name         = 'Number of pre volumes';
n_pre_vols.help         = {'How many scans should be used to determine the weights? If you select specific scans in the Pre volumes field, this value will be ignored.'};
n_pre_vols.strtype      = 'n';
n_pre_vols.num          = [0 1];
n_pre_vols.def          = @(val)dmb_cfg_get_defaults('combine_echoes.n_pre_vols', val{:});

% pre_vols         = cfg_files;
% pre_vols.tag     = 'pre_vols';
% pre_vols.name    = 'Pre volumes';
% pre_vols.help    = {'Select images to use for estimating paid weights. This setting has priority over the number of pre_vols set below. '};
% pre_vols.filter = 'image';
% pre_vols.ufilter = '.*';
% pre_vols.num     = [0 Inf];

pre_vols         = cfg_entry;
pre_vols.tag     = 'pre_vols';
pre_vols.name    = 'Pre volumes';
pre_vols.help    = {'How to recognize the pre_volumes?'};
pre_vols.strtype = 's';
pre_vols.num     = [0 Inf];



dir_PAIDweight          = cfg_entry;
dir_PAIDweight.tag      = 'dir_PAIDweight';
dir_PAIDweight.name     = 'PAIDweight dir';
dir_PAIDweight.help     = {'Directory name in which the weights will be stored. Note, this is a subdirectory of the directory of where your dummy scans are located. If you want it to be at a different location/level, use ../'};
dir_PAIDweight.strtype  = 's';
dir_PAIDweight.num      = [1 inf];
dir_PAIDweight.def      = @(val)dmb_cfg_get_defaults('combine_echoes.dir_PAIDweight', val{:});


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
% cfg_combine_echos
% ---------------------------------------------------------------------
dmb_menu_combine_echoes           = cfg_exbranch;
dmb_menu_combine_echoes.tag       = 'cfg_combine_echos';
dmb_menu_combine_echoes.name      = 'Combine echos';
dmb_menu_combine_echoes.val       = {data combine_method echo_times pre_vols n_pre_vols dir_PAIDweight, expected_n_sessions};
dmb_menu_combine_echoes.help      = {'Combines multiple echos into single scans.'};
dmb_menu_combine_echoes.prog      = @dmb_run_combine_echoes;
dmb_menu_combine_echoes.vout      = @dmb_vout_combine_echoes;
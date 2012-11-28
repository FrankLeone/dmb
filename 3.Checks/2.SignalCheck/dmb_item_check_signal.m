function dmb_item_check_signal = dmb_item_check_signal
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
% generic Data
% ---------------------------------------------------------------------
generic         = cfg_repeat;
generic.tag     = 'generic';
generic.name    = 'Data';
generic.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
generic.values  = {data };
generic.num     = [1 Inf];

% ---------------------------------------------------------------------
% subject Subject name
% ---------------------------------------------------------------------
subject         = cfg_entry;
subject.tag     = 'subject';
subject.name    = 'Name of the subject';
subject.help    = {'The subject name.'};
subject.strtype = 's';
subject.num     = [1  Inf];

% ---------------------------------------------------------------------
% multiecho Multiecho switch
% ---------------------------------------------------------------------
multiecho         = cfg_menu;
multiecho.tag     = 'multiecho';
multiecho.name    = 'multiecho';
multiecho.help    = {'Multiecho switch: use multiecho or not?'};
multiecho.labels  = {'Off', 'On'};
multiecho.values  = {0, 1};
multiecho.def     = @(val)donders_get_defaults('multiecho', val{:});

% ---------------------------------------------------------------------
% output_dir Directory for the movie file
% ---------------------------------------------------------------------

output_dir         = cfg_files;
output_dir.tag     = 'output_dir';
output_dir.name    = 'Output directory';
output_dir.help    = {'Select output directory for the movie'};
output_dir.filter = 'dir';
output_dir.ufilter = '.*';
output_dir.num     = [1 inf];

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
% dmb_item_check_signal
% ---------------------------------------------------------------------
dmb_item_check_signal  = cfg_exbranch;
dmb_item_check_signal.tag     = 'cfg_check_signal';
dmb_item_check_signal.name    = 'Check signal';
dmb_item_check_signal.val     = {data, multiecho, output_dir, expected_n_sessions};
dmb_item_check_signal.help    = {'Calculates the global and slice signals and plots vectors - useful for signal stability checks!'};
dmb_item_check_signal.prog = @dmb_run_check_signal;
dmb_item_check_signal.vout = @dmb_vout_check_signal;
function dmb_item_check_spikes = dmb_item_check_spikes
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
% mode mode switch
% ---------------------------------------------------------------------
mode         = cfg_menu;
mode.tag     = 'mode';
mode.name    = 'Mode';
mode.help    = {'Only check or also remove the spikes?'};
mode.labels  = {'Check', 'Remove'};
mode.values  = {'check', 'remove'};
mode.def     = @(val)donders_get_defaults('check_spikes.mode', val{:});

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
multiecho.name    = 'Look for other echoes?';
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
% dmb_item_check_spikes
% ---------------------------------------------------------------------
dmb_item_check_spikes  = cfg_exbranch;
dmb_item_check_spikes.tag     = 'cfg_check_spikes';
dmb_item_check_spikes.name    = 'Check spikes';
dmb_item_check_spikes.val     = {data, subject, mode, multiecho, output_dir, expected_n_sessions};
dmb_item_check_spikes.help    = {'Checks for (and removes) spikes.'};
dmb_item_check_spikes.prog = @dmb_run_check_spikes;
dmb_item_check_spikes.vout = @dmb_vout_check_spikes;
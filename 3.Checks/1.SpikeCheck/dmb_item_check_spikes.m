function dmb_item_check_spikes = dmb_item_check_spikes
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
generic         = cfg_repeat;
generic.tag     = 'generic';
generic.name    = 'Data';
generic.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
generic.values  = {files };
generic.num     = [1 Inf];

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
% dmb_item_check_spikes
% ---------------------------------------------------------------------
dmb_item_check_spikes  = cfg_exbranch;
dmb_item_check_spikes.tag     = 'cfg_check_spikes';
dmb_item_check_spikes.name    = 'Check spikes';
dmb_item_check_spikes.val     = {generic, subject, mode, multiecho, output_dir};
dmb_item_check_spikes.help    = {'Checks for (and removes) spikes.'};
dmb_item_check_spikes.prog = @dmb_run_check_spikes;
dmb_item_check_spikes.vout = @dmb_vout_check_spikes;
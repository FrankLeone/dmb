function dmb_item_check_signal = dmb_item_check_signal
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
% func_dir Name of the directory for the functional scans
% ---------------------------------------------------------------------
func_dir         = cfg_entry;
func_dir.tag     = 'func_dir';
func_dir.name    = 'Func';
func_dir.help    = {'Prefix for the name of the directory for the functional scans'};
func_dir.strtype = 's';
func_dir.num     = [1  Inf];
func_dir.def     = @(val)donders_get_defaults('order_niis.func_dir', val{:});

% ---------------------------------------------------------------------
% struc_dir Name of the directory for the structural scans
% ---------------------------------------------------------------------
struc_dir         = cfg_entry;
struc_dir.tag     = 'struc_dir';
struc_dir.name    = 'Struc';
struc_dir.help    = {'Prefix for the name of the directory for the structural scans'};
struc_dir.strtype = 's';
struc_dir.num     = [1  Inf];
struc_dir.def     = @(val)donders_get_defaults('order_niis.struc_dir', val{:});

% ---------------------------------------------------------------------
% echo_dir Name of the directory for the echoes
% ---------------------------------------------------------------------
echo_dir         = cfg_entry;
echo_dir.tag     = 'echo_dir';
echo_dir.name    = 'Echoes';
echo_dir.help    = {'Prefix used for the echoes dirs'};
echo_dir.strtype = 's';
echo_dir.num     = [1  Inf];
echo_dir.def     = @(val)donders_get_defaults('order_niis.echo_dir', val{:});

% ---------------------------------------------------------------------
% sess_dir Name of the directory for the sessions
% ---------------------------------------------------------------------
sess_dir         = cfg_entry;
sess_dir.tag     = 'sess_dir';
sess_dir.name    = 'Session';
sess_dir.help    = {'Prefix used for the session dirs'};
sess_dir.strtype = 's';
sess_dir.num     = [1  Inf];
sess_dir.def     = @(val)donders_get_defaults('order_niis.sess_dir', val{:});

% ---------------------------------------------------------------------
% type_dir Name of the directory for the echoes
% ---------------------------------------------------------------------
type_dir         = cfg_entry;
type_dir.tag     = 'type_dir';
type_dir.name    = 'Type';
type_dir.help    = {'Prefix used for the type dirs, used in the structural directory'};
type_dir.strtype = 's';
type_dir.def     = @(val)donders_get_defaults('order_niis.type_dir', val{:});
type_dir.num     = [1  Inf];

% ---------------------------------------------------------------------
% dir_branch Directory settings
% ---------------------------------------------------------------------
dir_branch      = cfg_branch;
dir_branch.tag  = 'dir_branch';
dir_branch.name = 'Directory prefixes';
dir_branch.val  = {func_dir struc_dir sess_dir type_dir echo_dir};
dir_branch.help = {'What should the directory structure look like? Can leave these to their default values.'};

% ---------------------------------------------------------------------
% dmb_item_check_signal
% ---------------------------------------------------------------------
dmb_item_check_signal  = cfg_exbranch;
dmb_item_check_signal.tag     = 'cfg_check_signal';
dmb_item_check_signal.name    = 'Check signal';
dmb_item_check_signal.val     = {generic, subject, multiecho, dir_branch};
dmb_item_check_signal.help    = {'Calculates the global and slice signals and plots vectors - useful for signal stability checks!'};
dmb_item_check_signal.prog = @dmb_run_check_signal;
dmb_item_check_signal.vout = @dmb_vout_check_signal;
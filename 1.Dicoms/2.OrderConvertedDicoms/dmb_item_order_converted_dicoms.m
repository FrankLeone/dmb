function dmb_item_order_converted_dicoms = dmb_item_order_converted_dicoms
% DMB_ITEM_ORDER_CONVERTED_DICOMS - This file descibes a menu item to sort
% converted Dicoms
%
% Other m-files required: Donders Matlab Batch package
% Subfunctions: All other function of the Matlab Batch package
% MAT-files required: none
%
% See also: 

% Author: Frank Leone
% Donders Institute for Brain, Cognition and Behavior
% email: f.leone@donders.ru.nl
% Website: http://frank.leone.nl
% August 2012; Last revision: 09-10-2012

% TODO:
% - Fill the function
%------------- BEGIN CODE --------------

% ---------------------------------------------------------------------
% files Session
% ---------------------------------------------------------------------
files         = cfg_files;
files.tag     = 'files';
files.name    = 'Session';
files.help    = {'Select images.'};
files.ufilter = '.*';
files.num     = [1 Inf];

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
% move Move switch
% ---------------------------------------------------------------------
move         = cfg_menu;
move.tag     = 'move';
move.name    = 'Move or copy files?';
move.help    = {'Move switch: actually move the file, or rather copy?'};
move.labels  = {
                'Copy'
                'Move'
                };
move.values  = {0 1};
move.def     = @(val)dmb_cfg_get_defaults('order_niis.move', val{:});

% ---------------------------------------------------------------------
% func_dir Name of the directory for the functional scans
% ---------------------------------------------------------------------
func_dir         = cfg_entry;
func_dir.tag     = 'func_dir';
func_dir.name    = 'Func';
func_dir.help    = {'Prefix for the name of the directory for the functional scans'};
func_dir.strtype = 's';
func_dir.num     = [1  Inf];
func_dir.def     = @(val)dmb_cfg_get_defaults('order_niis.func_dir', val{:});

% ---------------------------------------------------------------------
% struc_dir Name of the directory for the structural scans
% ---------------------------------------------------------------------
struc_dir         = cfg_entry;
struc_dir.tag     = 'struc_dir';
struc_dir.name    = 'Struc';
struc_dir.help    = {'Prefix for the name of the directory for the structural scans'};
struc_dir.strtype = 's';
struc_dir.num     = [1  Inf];
struc_dir.def     = @(val)dmb_cfg_get_defaults('order_niis.struc_dir', val{:});

% ---------------------------------------------------------------------
% echo_dir Name of the directory for the echoes
% ---------------------------------------------------------------------
echo_dir         = cfg_entry;
echo_dir.tag     = 'echo_dir';
echo_dir.name    = 'Echoes';
echo_dir.help    = {'Prefix used for the echoes dirs'};
echo_dir.strtype = 's';
echo_dir.num     = [1  Inf];
echo_dir.def     = @(val)dmb_cfg_get_defaults('order_niis.echo_dir', val{:});

% ---------------------------------------------------------------------
% sess_dir Name of the directory for the sessions
% ---------------------------------------------------------------------
sess_dir         = cfg_entry;
sess_dir.tag     = 'sess_dir';
sess_dir.name    = 'Session';
sess_dir.help    = {'Prefix used for the session dirs'};
sess_dir.strtype = 's';
sess_dir.num     = [1  Inf];
sess_dir.def     = @(val)dmb_cfg_get_defaults('order_niis.sess_dir', val{:});

% ---------------------------------------------------------------------
% type_dir Name of the directory for the echoes
% ---------------------------------------------------------------------
type_dir         = cfg_entry;
type_dir.tag     = 'type_dir';
type_dir.name    = 'Type';
type_dir.help    = {'Prefix used for the type dirs, used in the structural directory'};
type_dir.strtype = 's';
type_dir.def     = @(val)dmb_cfg_get_defaults('order_niis.type_dir', val{:});
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
% Number of echoes
% ---------------------------------------------------------------------
nechoes              = cfg_entry;
nechoes.tag          = 'nechoes';
nechoes.name         = 'Number of echoes';
nechoes.help         = {'How many echoes were acquired per scan?'};
nechoes.strtype      = 'n';
nechoes.num          = [0 1];
nechoes.def          = @(val)dmb_cfg_get_defaults('combine_echoes.nechoes', val{:});

% ---------------------------------------------------------------------
% sess_dir Name of the directory for the sessions
% ---------------------------------------------------------------------
rename_table         = cfg_entry;
rename_table.tag     = 'rename_table';
rename_table.name    = 'Rename table';
rename_table.help    = {'How to rename the numbered sessions? E.g., if there is a sess01, sess02 ..., sess10, sess11, etc., you can specify in a cell matrix whatever old name should be mapped to new name of your choice. E.g. {''sess01'', ''prescans''; ''sess02'', ''sess01''} will rename sess01 to prescans and sess02 to sess01. To ignore a session (meaning it is not copied/moved by the script, but left to keep its old naming), leave the second column empty. Note, this assumes you what the order was of your sessions, which you want to include and which not.'};
rename_table.strtype = 'e';
rename_table.num     = [0  Inf];

% ---------------------------------------------------------------------
% Main menu item object
% ---------------------------------------------------------------------
dmb_item_order_converted_dicoms           = cfg_exbranch;
dmb_item_order_converted_dicoms.tag       = 'order_converted_dicoms';
dmb_item_order_converted_dicoms.name      = 'Order converted dicoms';
dmb_item_order_converted_dicoms.val       = {files subject move expected_n_sessions nechoes dir_branch rename_table};
dmb_item_order_converted_dicoms.help      = {'Orders the niis in interpretable directories. NOTE I: This module is at the moment restricted to a certain structure and not as dynamic as it should be. Specifically, it converts the ICED filenames to a tree-structure: func-sess#-E and struc-type#, where in struc all non-functional scans end up (so also AA scout, etc). NOTE: This crucially depends on the DICOMs being converted using "ICED" filenames, see options of the DICOM conversion module.'};
dmb_item_order_converted_dicoms.prog      = @dmb_run_order_converted_dicoms;
dmb_item_order_converted_dicoms.vout      = @dmb_vout_order_converted_dicoms;
function dmb_menu_combine_sessions = dmb_menu_combine_sessions
% ---------------------------------------------------------------------
% files Session
% ---------------------------------------------------------------------
data         = cfg_files;
data.tag     = 'files';
data.name    = 'Session';
data.help    = {'Select images.'};
data.filter = 'image';
data.ufilter = '.*';
data.num     = [1 Inf];

% ---------------------------------------------------------------------
% generic Data
% ---------------------------------------------------------------------
sessions         = cfg_repeat;
sessions.tag     = 'generic';
sessions.name    = 'Data';
sessions.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
sessions.values  = {data };
sessions.num     = [1 Inf];

% ---------------------------------------------------------------------
% dmb_menu_combine_sessions
% ---------------------------------------------------------------------
dmb_menu_combine_sessions              = cfg_exbranch;
dmb_menu_combine_sessions.name         = 'Combine sessions';
dmb_menu_combine_sessions.tag          = 'combine_sessions';
dmb_menu_combine_sessions.val          = {sessions};
dmb_menu_combine_sessions.help         = {'Combines the separate sessions into one data object, which can be split again afterwards. This is for example needed to cope with the reslice function only accepting single sessions.'};
dmb_menu_combine_sessions.prog         = @dmb_run_combine_sessions;
dmb_menu_combine_sessions.vout         = @dmb_vout_combine_sessions;
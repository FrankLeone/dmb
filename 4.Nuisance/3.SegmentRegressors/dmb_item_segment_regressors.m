function dmb_item_segment_regressors = dmb_item_segment_regressors
% ---------------------------------------------------------------------
% segment Session
% ---------------------------------------------------------------------
segment         = cfg_files;
segment.tag     = 'segment';
segment.name    = 'Segment';
segment.help    = {'Select images.'};
segment.filter = 'image';
segment.ufilter = '.*';
segment.num     = [1 inf];


% ---------------------------------------------------------------------
% segments
% ---------------------------------------------------------------------
segments         = cfg_repeat;
segments.tag     = 'segments';
segments.name    = 'Segments';
segments.help    = {'Segments: the different segments files for which regressors will be made.'};
segments.values  = {segment};
segments.num     = [1 Inf];


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

% % ---------------------------------------------------------------------
% % generic Data
% % ---------------------------------------------------------------------
% data         = cfg_repeat;
% data.tag     = 'data';
% data.name    = 'Data';
% data.help    = {'Subjects or sessions. The same parameters specified below will be applied to all sessions.'};
% data.values  = {files };
% data.num     = [1 Inf];

% ---------------------------------------------------------------------
% dir
% ---------------------------------------------------------------------
dir         = cfg_files;
dir.tag     = 'directory';
dir.name    = 'Directory';
dir.help    = {'Select directory.'};
dir.filter = 'dir';
dir.ufilter = '.*';
dir.num     = [1 1];

% ---------------------------------------------------------------------
% dirs
% ---------------------------------------------------------------------
dirs         = cfg_repeat;
dirs.tag     = 'output_directories';
dirs.name    = 'Output directories';
dirs.help    = {'Output directories: select one for each session, or just one to be used for all sessions.'};
dirs.values  = {dir};
dirs.num     = [1 Inf];

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
% dmb_item_segment_regressors
% ---------------------------------------------------------------------
dmb_item_segment_regressors      = cfg_exbranch;
dmb_item_segment_regressors.name = 'Regressors for segments';
dmb_item_segment_regressors.tag  = 'segment_regressors';
dmb_item_segment_regressors.help = {'Calculates average intensity over the different segments and converts these to regressors. NOTE: the segments should be in the space (e.g.: coregistrated) as the functional data. NOTE2: If you use new segment, this is the order of segments coming out:\n *Gray matter\n *White matter\n *CSF\n *Fat \n *Skull\n *Out of brain\n To get the latter, put the last segment (",6") to "native" in the New Segment settings. Also note you probably don´t want a Gray matter regressor.'};
dmb_item_segment_regressors.val  = {segments, data, dirs, expected_n_sessions};
dmb_item_segment_regressors.prog = @dmb_run_segment_regressors;
dmb_item_segment_regressors.vout = @dmb_vout_segment_regressors;

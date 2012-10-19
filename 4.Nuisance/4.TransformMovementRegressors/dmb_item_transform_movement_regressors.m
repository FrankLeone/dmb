function dmb_item_transform_movement_regressors = dmb_item_transform_movement_regressors

regressor                  = cfg_files;
regressor.name             = 'Regressors';
regressor.tag              = 'regressors';
regressor.help             = {'Specifies the regressors for which the derivatives have to be calculated'};
regressor.filter           = 'mat';
regressor.ufilter          = '.*';
regressor.num              = [1 inf];

% ---------------------------------------------------------------------
% regressors Data
% ---------------------------------------------------------------------
% regressors         = cfg_repeat;
% regressors.tag     = 'regressors';
% regressors.name    = 'Regressors';
% regressors.help    = {'The regressor files over which the derivatives should be calculates'};
% regressors.values  = {regressor };
% regressors.num     = [1 Inf];

order                       = cfg_entry;
order.name                  = 'Order';
order.tag                   = 'order';
order.strtype               = 'n';
order.num                   = [1 1];
order.help                  = {'Specifies the maximum order of the derivatives to be determined.'};

% nechoes                     = cfg_entry;
% nechoes.tag                 = 'nechoes';
% nechoes.name                = 'Number of echoes';
% nechoes.help                = {'Specify the number of echoes in the movement file.'};
% nechoes.strtype             = 'n';
% nechoes.num                 = [1 1];

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

dmb_item_transform_movement_regressors          = cfg_exbranch;
dmb_item_transform_movement_regressors.name     = 'Derivative regressors';
dmb_item_transform_movement_regressors.tag      = 'deriv_mov_pars';
dmb_item_transform_movement_regressors.val      = {regressor order expected_n_sessions};
dmb_item_transform_movement_regressors.help     = {'Calculates the derivatives of the regressors sent in. TODO: extend to other operations, like square.'};
dmb_item_transform_movement_regressors.prog     = @dmb_run_transform_movement_regressors;
dmb_item_transform_movement_regressors.vout     = @dmb_vout_transform_movement_regressors;
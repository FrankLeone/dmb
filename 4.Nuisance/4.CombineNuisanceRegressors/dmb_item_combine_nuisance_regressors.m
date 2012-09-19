function dmb_item_combine_nuisance_regressors = dmb_item_combine_nuisance_regressors

regressor                  = cfg_files;
regressor.name             = 'Regressor';
regressor.tag              = 'regressor';
regressor.help             = {'Specifies the regressors for which the derivatives have to be calculated'};
regressor.filter           = 'mat';
regressor.ufilter          = '.*';
regressor.num              = [1 1];

dir                  = cfg_files;
dir.name             = 'Target dir';
dir.tag              = 'target_dir';
dir.help             = {'Where should the regressors be written?'};
dir.filter           = 'dir';
dir.ufilter          = '.*';
dir.num              = [1 1];

% ---------------------------------------------------------------------
% regressors
% ---------------------------------------------------------------------
regressors         = cfg_repeat;
regressors.tag     = 'regressors';
regressors.name    = 'Regressors';
regressors.help    = {'The regressor files over which the derivatives should be calculates'};
regressors.values  = {regressor };
regressors.num     = [1 Inf];

% ---------------------------------------------------------------------
% name New Directory Name
% ---------------------------------------------------------------------
filename_regr         = cfg_entry;
filename_regr.tag     = 'filename';
filename_regr.name    = 'Output regr filename';
filename_regr.help    = {'Name for the new combined regr file.'};
filename_regr.strtype = 's';
filename_regr.num     = [1  inf];
filename_regr.def     = @(val)dmb_cfg_get_defaults('combine_regressors.filename_regr', val{:});

dmb_item_combine_nuisance_regressors          = cfg_exbranch;
dmb_item_combine_nuisance_regressors.name     = 'Combine regressors';
dmb_item_combine_nuisance_regressors.tag      = 'combine_regressors';
dmb_item_combine_nuisance_regressors.help     = {'Combine multiple regressor files into one'};
dmb_item_combine_nuisance_regressors.val      = {regressors, dir, filename_regr};
dmb_item_combine_nuisance_regressors.prog     = @dmb_run_combine_nuisance_regressors;
dmb_item_combine_nuisance_regressors.vout     = @dmb_vout_combine_nuisance_regressors;
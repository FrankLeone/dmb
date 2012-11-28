function dmb_menu_stats = dmb_menu_stats
% DMB_MENU_STATS - This files contains menu items to create nuisance regressors and is part of the Donders Matlab Batch
%
% Other m-files required: Donders Matlab Batch package
% Subfunctions: All other function of the Matlab Batch package
% MAT-files required: none
%
% See also: dmb_cfg

% Author: Frank Leone
% Donders Institute for Brain, Cognition and Behavior
% email: f.leone@donders.ru.nl
% Website: http://frank.leone.nl
% August 2012; Last revision: 28-08-2012

% TODO:
% - Fill the function
%------------- BEGIN CODE --------------

dmb_menu_stats             = cfg_repeat;
dmb_menu_stats.name        = 'Statistics';
dmb_menu_stats.tag         = 'statistics';
dmb_menu_stats.values      = {dmb_item_remove_SPMs, dmb_item_spm_cfg_fmri_spec, dmb_item_spm_fmri_estimate, dmb_item_specify_contrasts, dmb_item_estimate_contrasts};
dmb_menu_stats.forcestruct = true;
dmb_menu_stats.help        = {'Functions to do fMRI GLM stats'};

%------------- END OF CODE --------------
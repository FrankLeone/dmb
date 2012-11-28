function dmb_menu_data_preproc = dmb_menu_data_preproc
% DMB_MENU_NUISANCE_REGRESSORS - This files contains menu items to preprocess fMRI data and is part of the Donders Matlab Batch
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

dmb_menu_data_preproc             = cfg_repeat;
dmb_menu_data_preproc.name        = 'Data preprocessing';
dmb_menu_data_preproc.tag         = 'data_preprocessing';
dmb_menu_data_preproc.values      = {dmb_spm_cfg_st, dmb_item_spm_cfg_smooth};
dmb_menu_data_preproc.forcestruct = true;
dmb_menu_data_preproc.help        = {'Function to create nuisance regressors.'};

%------------- END OF CODE --------------
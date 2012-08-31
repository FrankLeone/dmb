function dmb_menu_check_data = dmb_menu_check_data
% DMB_MENU_DATA_CHECKS - This files contains menu items to check data quality and is part of the Donders Matlab Batch
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

dmb_menu_check_data             = cfg_repeat;
dmb_menu_check_data.name        = 'Check data quality';
dmb_menu_check_data.tag         = 'check_data_quality';
dmb_menu_check_data.values      = {dmb_item_check_signal, dmb_item_check_spikes, dmb_item_check_movie};
dmb_menu_check_data.forcestruct = true;
dmb_menu_check_data.help        = {'Functions to check the quality of the fMRI data.'};

%------------- END OF CODE --------------
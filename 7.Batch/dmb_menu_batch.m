function dmb_menu_batch = dmb_menu_batch
% DMB_MENU_BATCH - This file contains menu items to setup the batch
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

dmb_menu_batch             = cfg_repeat;
dmb_menu_batch.name        = 'Batch';
dmb_menu_batch.tag         = 'Batch';
dmb_menu_batch.values      = {dmb_item_spm_cfg_runjobs};
dmb_menu_batch.forcestruct = true;
dmb_menu_batch.help        = {'Functions to perform batch operations'};

%------------- END OF CODE --------------
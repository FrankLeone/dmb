function dmb_menu_general = dmb_menu_general
% dmb_menu_general - This files contains menu items to setup the general
% structure of a batch.
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
% August 2012; Last revision: 31-08-2012

% TODO:
% - Fill the function
%------------- BEGIN CODE --------------

dmb_menu_general             = cfg_repeat;
dmb_menu_general.name        = 'General';
dmb_menu_general.tag         = 'general';
dmb_menu_general.values      = {dmb_item_fullfile, dmb_item_spm_named_input, dmb_item_spm_file_selector};
dmb_menu_general.forcestruct = true;
dmb_menu_general.help        = {'Functions to setup the general framework of batches'};

%------------- END OF CODE --------------
function dmb_menu_combine_echoes = dmb_menu_combine_echoes
% DMB_MENU_ORDER_FILES - This files contains menu items to combine echoes from a multiecho scanning sessions and is part of the Donders Matlab Batch
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

dmb_menu_combine_echoes             = cfg_repeat;
dmb_menu_combine_echoes.name        = 'Echo combination';
dmb_menu_combine_echoes.tag         = 'echo_combination';
dmb_menu_combine_echoes.values      = {dmb_item_spm_realign_estimate, dmb_item_copy_realignment_pars, dmb_item_combine_sessions, dmb_item_spm_realignment_write, dmb_item_split_sessions, dmb_item_combine_echoes};
dmb_menu_combine_echoes.forcestruct = true;
dmb_menu_combine_echoes.help        = {'Function to perform the steps required for echo combination.'};

%------------- END OF CODE --------------
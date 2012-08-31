function dmb_cfg = dmb_cfg
% CFG_DMB - This is the main function of the Donders Matlab Batch, which can be used
% to add the menu to the matlab batch interface. This can be done like
% this:
% 
% >> cfg_util('addapp', dmb_cfg);
%
% Other m-files required: Donders Matlab Batch package
% Subfunctions: All other function of the Matlab Batch package
% MAT-files required: none
%
% See also: cfg_cfg_basicio, spm_cfg (similar type of files)

% Author: Frank Leone
% Donders Institute for Brain, Cognition and Behavior
% email: f.leone@donders.ru.nl
% Website: http://frank.leone.nl
% August 2012; Last revision: 28-08-2012

% TODO:
% - Fill the function
%------------- BEGIN CODE --------------

dmb_cfg             = cfg_repeat;
dmb_cfg.name        = 'DMB';
dmb_cfg.tag         = 'dmb';
dmb_cfg.values      = {dmb_menu_order_files, dmb_menu_combine_echoes, dmb_menu_check_data, dmb_menu_nuisance_regressors};
dmb_cfg.forcestruct = true;
dmb_cfg.help        = {'The Donders Matlab Batch, which extend the standard SPM Matlab batch with functions of particular interest to members of the Donders Institute for Brain, Cognition and Behavior. Made by Frank Leone, please send questions and comments to f.leone@donders.ru.nl'};

%------------- END OF CODE --------------
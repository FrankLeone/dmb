function dmb_item_spm_realignment_write = dmb_item_spm_realignment_write
% DMB_MENU_SPM_REALIGNMENT_WRITE - Menu item to reslice scans, directly
% calls appropriate SPM 8 function. Part of Donders Matlab Batch
%
% Other m-files required: spm_cfg_dicom (and other spm8 functions)
% Subfunctions: spm_cfg_dicom
% MAT-files required: none
%
% See also: dmb_cfg

% Author: Frank Leone
% Donders Institute for Brain, Cognition and Behavior
% Radboud University Nijmegen
% email: f.leone@donders.ru.nl
% Website: http://www.frank.leone.nl
% August 2012; Last revision: 31-08-2012

%------------- BEGIN CODE --------------
dmb_item_spm_realignment_write = spm_cfg_realign;

% Only take the realign part
dmb_item_spm_realignment_write = dmb_item_spm_realignment_write.values{2};

% And signify in the name that I link to the SPM function
dmb_item_spm_realignment_write.name = [dmb_item_spm_realignment_write.name ' (SPM)'];
%------------- END OF CODE --------------
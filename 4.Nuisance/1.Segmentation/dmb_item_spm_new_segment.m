function dmb_item_spm_new_segment = dmb_item_spm_new_segment
% DMB_ITEM_SPM_NEW_SEGMENT - Menu item to segment a scan, directly
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
dmb_item_spm_new_segment = tbx_cfg_preproc8;
dmb_item_spm_new_segment.name = [dmb_item_spm_new_segment.name ' (SPM)'];
dmb_item_spm_new_segment.val{2}.val{6}.val{3}.def = @(val)dmb_cfg_get_defaults('segment.oob', val{:});
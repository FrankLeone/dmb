function dmb_item_spm_dicom_conversion = dmb_item_spm_dicom_conversion
% DMB_ITEM_SPM_DICOM_CONVERSION - Menu item to convert dicoms, directly
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
dmb_item_spm_dicom_conversion = dmb_item_spm_cfg_dicom;

% Signify in name that it is a call to an SPM function
dmb_item_spm_dicom_conversion.name = [dmb_item_spm_dicom_conversion.name ' (SPM)'];

% Set the defaults to the Donders Matlab Batch version
dmb_item_spm_dicom_conversion.val{4}.val{1}.def = @(val)dmb_cfg_get_defaults('dicoms.conversion.format',val{:});
dmb_item_spm_dicom_conversion.val{4}.val{2}.def = @(val)dmb_cfg_get_defaults('dicoms.conversion.ICED',val{:});
%------------- END OF CODE --------------
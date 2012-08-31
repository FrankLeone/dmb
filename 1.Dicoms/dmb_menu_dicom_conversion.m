function dmb_menu_dicom_conversion = dmb_menu_dicom_conversion
% DMB_MENU_ORDER_FILES - This files contains menu items to convert dicoms and sort your files and is part of the Donders Matlab Batch
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

dmb_menu_dicom_conversion             = cfg_repeat;
dmb_menu_dicom_conversion.name        = 'Dicom conversion';
dmb_menu_dicom_conversion.tag         = 'dicom_conversion';
dmb_menu_dicom_conversion.values      = {dmb_item_spm_dicom_conversion, dmb_item_order_converted_dicoms};
dmb_menu_dicom_conversion.forcestruct = true;
dmb_menu_dicom_conversion.help        = {'Functions to convert DICOMS to NII and then order your files.'};

%------------- END OF CODE --------------
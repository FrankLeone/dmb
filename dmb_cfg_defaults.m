function dmb_cfg_defaults
% DMB_CFG_DEFAULTS - Contains the default settings of the Donders Matlab
% Batch. To use, call:
%
% >> dmb_cfg_get_defaults
%
% Other m-files required: Donders Matlab Batch package
% Subfunctions: none
% MAT-files required: none
%
% See also: spm_cfg_defs

% Author: Frank Leone
% Donders Institute for Brain, Cognition and Behavior
% Radboud University Nijmegen
% email: f.leone@donders.ru.nl
% Website: http://www.frank.leone.nl
% August 2012; Last revision: 28-08-2012

%------------- BEGIN CODE --------------
global dmb_defaults

%% Defaults for dmb_item_spm_dicom_conversion
dmb_defaults.dicoms.conversion.format = 'nii';
dmb_defaults.dicoms.conversion.ICED = 0;

%% Defaults for dmb_item_order_converted_dicoms
dmb_defaults.order_niis.func_dir   = 'func';
dmb_defaults.order_niis.struc_dir  = 'struc';
dmb_defaults.order_niis.echo_dir   = 'E';
dmb_defaults.order_niis.sess_dir   = 'sess';
dmb_defaults.order_niis.type_dir   = 'type';
dmb_defaults.order_niis.move       = 0;
dmb_defaults.order_niis.expected_n_sessions       = 1;

dmb_defaults.combine_echoes.combine_method     = 'paid-v1';
dmb_defaults.combine_echoes.n_pre_vols         = 30;
dmb_defaults.combine_echoes.dir_PAIDweight     = '../PAIDweight';
dmb_defaults.combine_echoes.nechoes            = 5;

dmb_defaults.combine_regressors.filename_regr = 'nuisanceRegressors';

dmb_defaults.segment.oob =  [1 0];
%------------- END OF CODE --------------
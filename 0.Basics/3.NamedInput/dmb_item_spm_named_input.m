function cfg_named_input = dmb_cfg_spm_named_input
% ---------------------------------------------------------------------
% name Input Name
% ---------------------------------------------------------------------
name         = cfg_entry;
name.tag     = 'name';
name.name    = 'Input Name';
name.help    = {'Enter a name for this variable. This name will be displayed in the ''Dependency'' listing as output name.'};
name.strtype = 's';
name.num     = [1  Inf];
% ---------------------------------------------------------------------
% input Input Variable
% ---------------------------------------------------------------------
input         = cfg_entry;
input.tag     = 'input';
input.name    = 'Input Variable';
input.help    = {'Enter a MATLAB variable. This can be a variable in the MATLAB workspace, or any other valid MATLAB statement which evaluates to a single variable.'};
input.strtype = 'e';
input.num     = [];
% ---------------------------------------------------------------------
% cfg_named_input Named Input
% ---------------------------------------------------------------------
cfg_named_input         = cfg_exbranch;
cfg_named_input.tag     = 'cfg_named_input';
cfg_named_input.name    = 'Named Input (SPM)';
cfg_named_input.val     = {name input };
cfg_named_input.help    = {'Named Input allows to enter any kind of MATLAB variable. This variable can be referenced as common input by other modules.'};
cfg_named_input.prog = @cfg_run_named_input;
cfg_named_input.vout = @cfg_vout_named_input;
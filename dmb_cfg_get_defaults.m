function varargout = dmb_cfg_get_defaults(defstr, varargin)
% DMB_CFG_GET_DEFAULTS - Get/set the default values associated with an
% identifier for the Donders Matlab Batch.
%
% Syntax: 
%    [defaults] = dmb_cfg_get_defaults - Get all defaults values
%    [defval]   = dmb_cfg_get_defaults(defstr) - Get a specific defaults
%    value, as specified by defstr. Currently, this is a '.' subscript reference into the global  
%    "dmb_defaults" variable defined in dmb_cfg_defaults.m.%
%    []         = dmb_cfg_get_defaults(defstr, defval) - Sets the defaults value associated with identifier "defstr". The new
%    defaults value applies immediately to:
%    * new modules in batch jobs
%    * modules in batch jobs that have not been saved yet
%    This value will not be saved for future sessions of SPM. To make
%    persistent changes, edit spm_defaults.m.
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
global dmb_defaults;
% if isempty(dmb_defaults)
    dmb_cfg_defaults;
% end

if nargin == 0
    varargout{1} = dmb_defaults;
    return
end

% construct subscript reference struct from dot delimited tag string
tags = textscan(defstr,'%s', 'delimiter','.');
subs = struct('type','.','subs',tags{1}');

if nargin == 1
    varargout{1} = subsref(dmb_defaults, subs);
else
    dmb_defaults = subsasgn(dmb_defaults, subs, varargin{1});
end
%------------- END OF CODE --------------
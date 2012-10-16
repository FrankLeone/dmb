function estimate = dmb_spm_cfg_realign_estimate

rev = '$Rev: 4152 $';
% ---------------------------------------------------------------------
% data Session
% ---------------------------------------------------------------------
data         = cfg_files;
data.tag     = 'data';
data.name    = 'Session';
data.help    = {'Select scans for this session. In the coregistration step, the sessions are first realigned to each other, by aligning the first scan from each session to the first scan of the first session.  Then the images within each session are aligned to the first image of the session. The parameter estimation is performed this way because it is assumed (rightly or not) that there may be systematic differences in the images between sessions.'};
data.filter = 'image';
data.ufilter = '.*';
data.num     = [1 Inf];
% ---------------------------------------------------------------------
% generic Data
% ---------------------------------------------------------------------
generic         = cfg_repeat;
generic.tag     = 'generic';
generic.name    = 'Data';
generic.help    = {'Add new sessions for this subject. In the coregistration step, the sessions are first realigned to each other, by aligning the first scan from each session to the first scan of the first session.  Then the images within each session are aligned to the first image of the session. The parameter estimation is performed this way because it is assumed (rightly or not) that there may be systematic differences in the images between sessions.'};
generic.values  = {data };
generic.num     = [1 Inf];
% ---------------------------------------------------------------------
% quality Quality
% ---------------------------------------------------------------------
quality         = cfg_entry;
quality.tag     = 'quality';
quality.name    = 'Quality';
quality.help    = {'Quality versus speed trade-off.  Highest quality (1) gives most precise results, whereas lower qualities gives faster realignment. The idea is that some voxels contribute little to the estimation of the realignment parameters. This parameter is involved in selecting the number of voxels that are used.'};
quality.strtype = 'r';
quality.num     = [1 1];
quality.extras  = [0 1];
quality.def     = @(val)spm_get_defaults('realign.estimate.quality', val{:});
% ---------------------------------------------------------------------
% sep Separation
% ---------------------------------------------------------------------
sep         = cfg_entry;
sep.tag     = 'sep';
sep.name    = 'Separation';
sep.help    = {'The separation (in mm) between the points sampled in the reference image.  Smaller sampling distances gives more accurate results, but will be slower.'};
sep.strtype = 'e';
sep.num     = [1 1];
sep.def     = @(val)spm_get_defaults('realign.estimate.sep', val{:});
% ---------------------------------------------------------------------
% fwhm Smoothing (FWHM)
% ---------------------------------------------------------------------
fwhm         = cfg_entry;
fwhm.tag     = 'fwhm';
fwhm.name    = 'Smoothing (FWHM)';
fwhm.help    = {
                'The FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating the realignment parameters.'
                ''
                '    * PET images typically use a 7 mm kernel.'
                ''
                '    * MRI images typically use a 5 mm kernel.'
}';
fwhm.strtype = 'e';
fwhm.num     = [1 1];
fwhm.def     = @(val)spm_get_defaults('realign.estimate.fwhm', val{:});
% ---------------------------------------------------------------------
% rtm Num Passes
% ---------------------------------------------------------------------
rtm         = cfg_menu;
rtm.tag     = 'rtm';
rtm.name    = 'Num Passes';
rtm.help    = {
               'Register to first: Images are registered to the first image in the series. Register to mean:   A two pass procedure is used in order to register the images to the mean of the images after the first realignment.'
               ''
               'PET images are typically registered to the mean. This is because PET data are more noisy than fMRI and there are fewer of them, so time is less of an issue.'
               ''
               'MRI images are typically registered to the first image.  The more accurate way would be to use a two pass procedure, but this probably wouldn''t improve the results so much and would take twice as long to run.'
}';
rtm.labels = {
              'Register to first'
              'Register to mean'
}';
rtm.values = {0 1};
rtm.def    = @(val)spm_get_defaults('realign.estimate.rtm', val{:});
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.help    = {'The method by which the images are sampled when estimating the optimum transformation. Higher degree interpolation methods provide the better interpolation, but they are slower because they use more neighbouring voxels /* \cite{thevenaz00a,unser93a,unser93b}*/. '};
interp.labels = {
                 'Trilinear (1st Degree)'
                 '2nd Degree B-Spline'
                 '3rd Degree B-Spline '
                 '4th Degree B-Spline'
                 '5th Degree B-Spline'
                 '6th Degree B-Spline'
                 '7th Degree B-Spline'
}';
interp.values = {1 2 3 4 5 6 7};
interp.def    = @(val)spm_get_defaults('realign.estimate.interp', val{:});
% ---------------------------------------------------------------------
% wrap Wrapping
% ---------------------------------------------------------------------
wrap         = cfg_menu;
wrap.tag     = 'wrap';
wrap.name    = 'Wrapping';
wrap.help    = {
                'This indicates which directions in the volumes the values should wrap around in.  For example, in MRI scans, the images wrap around in the phase encode direction, so (e.g.) the subject''s nose may poke into the back of the subject''s head. These are typically:'
                '    No wrapping - for PET or images that have already                   been spatially transformed. Also the recommended option if                   you are not really sure.'
                '    Wrap in  Y  - for (un-resliced) MRI where phase encoding                   is in the Y direction (voxel space).'
}';
wrap.labels = {
               'No wrap'
               'Wrap X'
               'Wrap Y'
               'Wrap X & Y'
               'Wrap Z'
               'Wrap X & Z'
               'Wrap Y & Z'
               'Wrap X, Y & Z'
}';
wrap.values = {[0 0 0] [1 0 0] [0 1 0] [1 1 0] [0 0 1] [1 0 1] [0 1 1] ...
               [1 1 1]};
wrap.def    = @(val)spm_get_defaults('realign.estimate.wrap', val{:});
% ---------------------------------------------------------------------
% weight Weighting
% ---------------------------------------------------------------------
weight         = cfg_files;
weight.tag     = 'weight';
weight.name    = 'Weighting';
weight.val     = {''};
weight.help    = {'The option of providing a weighting image to weight each voxel of the reference image differently when estimating the realignment parameters.  The weights are proportional to the inverses of the standard deviations. This would be used, for example, when there is a lot of extra-brain motion - e.g., during speech, or when there are serious artifacts in a particular region of the images.'};
weight.filter  = 'image';
weight.ufilter = '.*';
weight.num     = [0 1];
% ---------------------------------------------------------------------
% eoptions Estimation Options
% ---------------------------------------------------------------------
eoptions         = cfg_branch;
eoptions.tag     = 'eoptions';
eoptions.name    = 'Estimation Options';
eoptions.val     = {quality sep fwhm rtm interp wrap weight };
eoptions.help    = {'Various registration options. If in doubt, simply keep the default values.'};

% ---------------------------------------------------------------------
% expected_n_sessions Number of sessions to be expected
% ---------------------------------------------------------------------
expected_n_sessions         = cfg_entry;
expected_n_sessions.tag     = 'expected_n_sessions';
expected_n_sessions.name    = 'Number of sessions';
expected_n_sessions.help    = {'Expected number of sessions.'};
expected_n_sessions.strtype = 'n';
expected_n_sessions.num     = [1  inf];
expected_n_sessions.def     = @(val)dmb_cfg_get_defaults('order_niis.expected_n_sessions', val{:});

% ---------------------------------------------------------------------
% data Session
% ---------------------------------------------------------------------
targetDir         = cfg_files;
targetDir.tag     = 'targetDir';
targetDir.name    = 'Target Dir movement parameters';
targetDir.help    = {'Select scans for this session. In the coregistration step, the sessions are first realigned to each other, by aligning the first scan from each session to the first scan of the first session.  Then the images within each session are aligned to the first image of the session. The parameter estimation is performed this way because it is assumed (rightly or not) that there may be systematic differences in the images between sessions.'};
targetDir.filter = 'dir';
targetDir.ufilter = '.*';
targetDir.num     = [0 1];

% ---------------------------------------------------------------------
% wrap Wrapping
% ---------------------------------------------------------------------
relativeDir         = cfg_menu;
relativeDir.tag     = 'relativeDir';
relativeDir.name    = 'Retain separate session dirs?';
relativeDir.help    = {
                
}';
relativeDir.labels = {
               'Move all to one folder'
               'Retain session directories'
}';
relativeDir.values = {false, true};

% ---------------------------------------------------------------------
% estimate Realign: Estimate
% ---------------------------------------------------------------------
estimate         = cfg_exbranch;
estimate.tag     = 'estimate';
estimate.name    = 'Realign: Estimate';
estimate.val     = {data eoptions expected_n_sessions targetDir relativeDir};
estimate.help    = {
                    'This routine realigns a time-series of images acquired from the same subject using a least squares approach and a 6 parameter (rigid body) spatial transformation/* \cite{friston95a}*/.  The first image in the list specified by the user is used as a reference to which all subsequent scans are realigned. The reference scan does not have to the the first chronologically and it may be wise to chose a "representative scan" in this role.'
                    ''
                    'The aim is primarily to remove movement artefact in fMRI and PET time-series (or more generally longitudinal studies). The headers are modified for each of the input images, such that. they reflect the relative orientations of the data. The details of the transformation are displayed in the results window as plots of translation and rotation. A set of realignment parameters are saved for each session, named rp_*.txt. These can be modelled as confounds within the general linear model/* \cite{friston95a}*/.'
}';
estimate.prog = @dmb_spm_run_realign_estimate;
estimate.vout = @vout_estimate;


%------------------------------------------------------------------------
function dep = vout_estimate(job)
cdep(1)            = cfg_dep;
cdep(1).sname      = sprintf('Realignment Param File');
cdep(1).src_output = substruct('.','rpfile');
cdep(1).tgt_spec   = cfg_findspec({{'filter','mat','strtype','e'}});
cdep(2)            = cfg_dep;
cdep(2).sname      = sprintf('Realigned Images');
cdep(2).src_output = substruct('.','cfiles');
cdep(2).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
dep = cdep;



%------------------------------------------------------------------------
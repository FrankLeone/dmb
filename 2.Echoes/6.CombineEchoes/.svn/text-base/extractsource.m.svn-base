function [src w] = extractsource(dat,cfg)

% EXTRACTSOURCE
%
% Usage:
%   src = extractsource(dat,cfg)
%
% Input:
%   dat is a structure containing the data (multi-echo fMRI data represented as
%   a multichannel signal) from which to extract the target source signal
%   dat.signal = Necho x Nsamp matrix with time-series of each echo in one row
%   dat.echo_t = Necho element (col) vector of echo times (in seconds)
%   dat.samp_t = Nsamp element (row) vector of sample times
%
%   cfg is a structure whose fields specify configuration options, e.g.:
%   cfg.dmorig = (matrix) specifying the original design matrix
%   cfg.dmnorm = (matrix) zero mean, unit L2-norm columns of cfg.dmorig
%   cfg.dmorth = (matrix) orthonormal basis for column space of cfg.dmnorm
%   cfg.method = (string) specifies the source extraction method
%   cfg.target = (vector) contains the 'spatial' projection or time course of
%                the source signal to be extracted, depending on methof used
%   cfg.tinsel = (matrix) contains the spatial projection of known interference
%                source signals
%   cfg.output = (string) 'all' or 'src' (default)
%
% Output:
%   src is a matrix [1,nt] containing the extracted source signal
%
% See also:

% References:
% [1] S. Posse, S. Wiese, D. Gembris, K. Mathiak, C. Kessler, M.L. Grosse-Ruyken
%     B. Elghahwagi, T. Richards, S.R. Dager, and V.G. Kiselev, "Enhancement of
%     BOLD-contrast sensitivity by single-shot mulit-echo functional MR imaging,"
%     Magnetic Resonance in Medicine, vol. 42, pp. 87-97, 1999.
%
% [2] B.A. Poser, M.J. Versluis, J.M. Hoogduin, and D.G. Norris, "BOLD contrast
%     sensitivity enhancement and artifact reduction with multiecho EPI:
%     Parallel-acquired inhomogeneity-desensitized fMRI," Magnetic Resonance in
%     Medicine, vol. 55, pp. 1227-1235, 2006.
%

% Copyright (C) 2007-2008, Christian Hesse
% F.C. Donders Centre for Cognitive Neuroimaging, Radboud University Nijmegen,
% Kapittelweg 29, 6525 EN Nijmegen, The Netherlands
%
% $Log: extractsource.m,v $
% Revision 1.26 2008/04/01 piebuu
% removed need to specify dat.samp_t
% 
% Revision 1.25  2008/03/27 09:35:26  chrhes
% added some references to the code header
%
% Revision 1.24  2008/03/27 09:23:51  chrhes
% fixed a few typos in documentation and (finally) implemented the option of
% returning a specific echo time-series, i.e., linear combination using unit
% vector for specific echo.
%
% Revision 1.23  2008/03/27 08:32:18  chrhes
% put the computation of PAID weights in a try-catch statement to handle the
% case where the SNR calculations are not well behaved, e.g., voxels ouside
% the head. On error, the weight vector contains an equal weighting for each
% of the selected echos, which means that the PAID weights will effectively be
% equivalent to those used in the "mean" method for combining echoes.
%
% Revision 1.22  2008/03/25 14:01:02  chrhes
% implemented three versions of the "PAID" source extraction method, which is
% based on a weighted combination of the echoes (simple subspace projection)
% where the weights reflect a combination of the echo times and the contrast-
% to-noise ratio (measured using the standardized 2nd moment mu/sigma) which
% is computed from a subset of data points during a baseline period.
%
% Revision 1.21  2008/03/25 09:18:35  chrhes
% several small changes in relation to making the calls to the ICA algorithm
% more robust
%
% Revision 1.20  2008/02/29 17:07:14  chrhes
% disabled the automatic signal inversion for the time being; also changed
% the default setting of cfg.pstproc to cfg.preproc (this was already done in
% the previous revision)
%
% Revision 1.19  2008/02/29 17:03:43  chrhes
% changed the name of the field for passing the design matrix from cfg.design
% to cfg.dmorig (design matrix original), added the fields cfg.dmnorm (which
% contains the columns of cfg.dmorig transformed to have zero mean and unit
% L2-norm) and cfg.dmorth (which contains an othonormal basis for the column
% space of cfg.dmnorm), and ensured their consistent initialization and use
% by appropriate methods, especially Wiener filtering, PCA and ICA
%
% Revision 1.18  2008/02/29 12:17:33  chrhes
% implemented a check for whether the target source waveform is inverted
% w.r.t. the original signals and correct the sign if necessary (so far this
% is only done for a subset of relevant methods).
%
% Revision 1.17  2008/02/27 16:12:56  chrhes
% fixed a small ijk-bug in the 'wiener-svd' method
%
% Revision 1.16  2008/02/27 13:32:34  chrhes
% fixed a couple of small typo-bugs and added an early return of zeros in the
% no pre-processing condition
%
% Revision 1.15  2008/02/27 13:11:54  chrhes
% extended the Wiener filtering options to allow extraction of source signals
% which have maximum correlation with the signal subspace spanned by the design
% matrix columns (reference waveforms): one method averages individual source
% estimates and another involves singular value decomposition of the signal
% design matrix cross-corrleation matrix to select the steering vector for
% computation of the wiener filter weights.
%
% Revision 1.14  2008/02/27 09:52:19  chrhes
% added extra checks to ensure that cfg.design contains an orthonormal basis
% for the column space of the design matrix, changed correspondence measure
% between design matrix and sources extracted using PCA and ICA to subsace
% correlation.
%
% Revision 1.13  2008/02/27 09:21:59  chrhes
% added field cfg.design to the configuration options where the design matrix
% - or preferably an orthonormal basis for the columns of the design matrix -
% should be passed and changed implementation of the (simple) Wiener filter
% method to use cfg.design as a reference instead of cfg.target.sig
%
% Revision 1.11  2008/02/26 10:59:11  chrhes
% added option to decompose the data using ICA and return the source waveform
% which has the highest absolute correlation with the target signal (i.e. the
% design matrix). Changed a few default settings for the spatially constained
% ICA option.
%
% Revision 1.10  2008/02/26 10:34:33  chrhes
% added option to use semi-blind source separation with "spatial" constraints
% to extract sources with known projection weights. This implementation uses
% the spatially constrained FastICA algorithm with a "hard" constraint.
%
% Revision 1.9  2008/02/25 17:06:25  chrhes
% added some detailed comments about how to deal with scaling of the output
% (intended as reminders for further development)
%
% Revision 1.8  2008/02/25 14:49:00  chrhes
% implemented most post-processing options; changed implementation of slope
% method to use pseudo-inverse of a projection matrix containing echo times
% and ones when data was pre-processed by taking the logarithm
%
% Revision 1.7  2008/02/25 14:20:59  chrhes
% added signal pre-processing options, e.g., taking logarithm or subtracting
% the mean and dividing by the mean, which include checking the data for any
% zeros and return early. Pratially implemented post-processing options which
% transform source estimates back into original format (the current default
% is to do no post-processing).
%
% Revision 1.6  2008/02/19 14:36:22  chrhes
% implemented more sophisticated testing for method 'slope' to avoid division
% by zero
%
% Revision 1.5  2008/02/06 16:30:03  chrhes
% corrected some typos in documentation and added the option to also return
% the intercept parameter for the linear least-squares regression method
%
% Revision 1.4  2008/02/04 11:16:01  chrhes
% fixed a small typo-bug, added a source extraction method using principal
% component analysis which returns the pc waveform that has the higheest
% correlation with the target signal
%
% Revision 1.3  2008/02/04 10:37:47  chrhes
% modified the data representation to include echo times and a time axis,
% added some documentation
%
% Revision 1.2  2008/02/04 08:40:03  chrhes
% added several simple methods for extracting a source signal, including sum,
% slope of a linear regression and wiener filtering
%
% Revision 1.1  2007/11/02 14:50:45  chrhes
% initial version added to CVS repository
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse the input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin<1) || (nargin>2), error('incorrect number of input arguments'); end;
if (nargin==1), cfg = []; end;

% check structure continaing the data
if ~isstruct(dat) || any(~isfield(dat,{'signal','echo_t'}))
  error('argument dat must be a structure');
end
if ~isnumeric(dat.signal) || (ndims(dat.signal)~=2) || ~isreal(dat.signal) ...
    || (diff(size(dat.signal))<=0) || any(any(~isfinite(dat.signal)))
  error('field dat.signal must be a matrix with fewer rows then columns');
end
[ne,nt] = size(dat.signal);
if ~isvector(dat.echo_t) || (size(dat.echo_t,1)~=ne) || (size(dat.echo_t,2)~=1)
  error('field dat.echo_t must be a column vector');
end
% make sure that the echo times are all negative
if all(dat.echo_t>0), dat.echo_t = dat.echo_t.*(-1); end;
if ~all(dat.echo_t<0)
  error('field dat.echo_t should contain all positive or all negative numbers');
end
if ~isfield(dat,'samp_t'), dat.samp_t = (1:nt); end
if ~isvector(dat.samp_t) || (size(dat.samp_t,1)~=1) || (size(dat.samp_t,2)~=nt)
  error('field dat.samp_t must be a row vector');
end

% check structure contaning configuration options
if ~isstruct(cfg), cfg = []; end;
% set/check field cfg.method
if ~isfield(cfg,'method'), cfg.method = 'sum'; end;
if ~ischar(cfg.method), error('cfg.method must be a string'); end;


% set/check field cfg.design (for backwards compatibility)
if ~isfield(cfg,'design'), cfg.design = []; end;
if ~isempty(cfg.design) && ( ~isnumeric(cfg.design) || (size(cfg.design,1)~=nt) )
  error('cfg.design must be a matrix, empty or omitted');
else
  % copy cfg.design to cfg.dmorig if not specified
  if ~isfield(cfg,'dmorig'), cfg.dmorig = cfg.design; cfg.design = []; end
end
% set/check field cfg.dmorig (replacement for cfg.design)
if ~isfield(cfg,'dmorig'), cfg.dmorig = []; end;
if ~isempty(cfg.dmorig) && ( ~isnumeric(cfg.dmorig) || (size(cfg.dmorig,1)~=nt) )
  error('cfg.dmorig must be a matrix, empty or omitted');
end
% transpose cfg.dmorig if required
if ~isempty(cfg.dmorig)
  [r,c] = size(cfg.dmorig);
  if (c==nt) && (r<c)
    cfg.dmorig = cfg.dmorig';
    [r,c] = size(cfg.dmorig);
  end
end
% set/check field cfg.dmnorm (zero mean, unit l2-norm columns of cfg.dmorig)
if ~isfield(cfg,'dmnorm'), cfg.dmnorm = []; end;
if ~isempty(cfg.dmnorm) && ( ~isnumeric(cfg.dmnorm) || (size(cfg.dmnorm,1)~=nt) )
  error('cfg.dmnorm must be a matrix, empty or omitted');
end
if ~isempty(cfg.dmorig) && ( isempty(cfg.dmnorm) || (sum(abs(diag(cfg.dmnorm'*cfg.dmnorm)-1))<eps) )
  % centre and normalize columns of cfg.dm(important!)
  cfg.dmnorm = cfg.dmorig -  ones(nt,1)*mean(cfg.dmorig,1);
  for i=1:size(cfg.dmnorm,2)
    cfg.dmnorm(:,i) = cfg.dmnorm(:,i)./norm(cfg.dmnorm(:,i),2);
  end
end
% set/check field cfg.dmorth (orthonormal basis for column space of cfg.dmnorm)
if ~isfield(cfg,'dmorth'), cfg.dmorth = []; end;
if ~isempty(cfg.dmorth) && ( ~isnumeric(cfg.dmorth) || (size(cfg.dmorth,1)~=nt) )
  error('cfg.dmorth must be a matrix, empty or omitted');
end
if ~isempty(cfg.dmnorm) && ( isempty(cfg.dmorth) || ... % cfg.dmorth not orthonormal
    any(any(abs((cfg.dmnorm'*cfg.dmnorm)-eye(size(cfg.dmorth,2)))>eps)) )
  % construct an orthonormal basis for column space of cfg.dmnorm, which must
  % exist if cfg.dmorig has been specified
  [U,S,V] = svd(cfg.dmnorm,0);
  cfg.dmorth = U(:,1:size(cfg.dmnorm,2));
  clear U S V
end

if ~any(strcmp(cfg.method, {'paid-v1','paid-v2','paid-v3','pre-paid'})) % pfb - not checking cfg.target when method is *paid*
% set/check field cfg.target
if ~isfield(cfg,'target') || ~isstruct(cfg.target)
  error('field cfg.target must be a structure');
end
% set/check field cfg.target.sig
if ~isfield(cfg.target,'sig'), cfg.target.sig = []; end;
if ~isempty(cfg.target.sig)
  if ~isnumeric(cfg.target.sig) || (ndims(cfg.target.sig)~=2) || ~isreal(cfg.target.sig) ...
      || (size(cfg.target.sig,2)~=nt) || (size(cfg.target.sig,1)~=1)
    error('field cfg.target.sig must be a row vector');
  end
end
% set/check field cfg.target.mix
if ~isfield(cfg.target,'mix'), cfg.target.mix = []; end;
if ~isempty(cfg.target.mix)
  if ~isnumeric(cfg.target.mix) || (ndims(cfg.target.mix)~=2) || ~isreal(cfg.target.mix) ...
      || (size(cfg.target.mix,1)~=ne)
    error('field cfg.target.mix must be a matrix');
  end
end
end

% set/check field cfg.tinsel
if ~isfield(cfg,'tinsel'), cfg.tinsel = []; end;
if ~isempty(cfg.tinsel) && ( ~isnumeric(cfg.tinsel) || (size(cfg.tinsel,1)~=ne) )
  error('cfg.tinsel must be a matrix, empty or omitted');
end
% set/check field cfg.output
if ~isfield(cfg,'output'), cfg.output = 'src'; end;
if ~ischar(cfg.output), error('cfg.output must be a string'); end;
% set/check field cfg.preproc
if ~isfield(cfg,'preproc'), cfg.preproc = 'none'; end;
if ~ischar(cfg.preproc), error('cfg.preproc must be a string'); end;
% set/check field cfg.pstproc
if ~isfield(cfg,'pstproc'), cfg.pstproc = 'none'; end;
if ~ischar(cfg.pstproc), error('cfg.pstproc must be a string'); end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apply specified pre-processing to the observed signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag = false;
dat.rmeans = mean(dat.signal,2);
% check for zero or negative means
if ~isempty(find(dat.rmeans(:)<eps))
  flag = true;
else
  % preprocess the signals
  switch lower(cfg.preproc)
    case {'none'}
      % check for zeros
%       if ~isempty(find(dat.signal(:)<eps))
%         warning('dat.signal contains zero or negative elements: returning zeros');
%         flag = true;
%       end
    case {'log';'log10'}
      % check for zeros
      if isempty(find(dat.signal(:)<eps))
        eval(['dat.signal = ',lower(cfg.preproc),'(dat.signal);']);
      else
        warning('dat.signal contains zero or negative elements: cannot take log');
        flag = true;
      end % if any zeros
    case {'-/mean';'smdm'}
      % the means are OK
      dat.scales = dat.rmeans*ones(1,nt);
      dat.signal = (dat.signal - dat.scales)./(dat.scales);
    otherwise
      error(['unknown option cfg.preproc = ',cfg.preproc]);
  end % switch cfg.preproc
end % if zero mean
% Default value for weights: zeroes

w = zeros(1,length(dat.echo_t));
% return if necessary
if flag
  switch cfg.output
    case 'src', src = zeros(1,nt); w = zeros(1,length(dat.echo_t));
    case 'all'
      switch cfg.method
        case {'pinv';'sbss'}
          nr  = size([cfg.target.mix,cfg.tinsel],2);
          src = zeros(nr,nt);
        case {'slope','line[LS]','line[TLS]','line[DLS]','line[L1-norm]','line[Loo-norm]'}
          src = zeros(2,nt);
        otherwise
          src = zeros(1,nt);
      end % switch cfg.method
    otherwise
      error(['unknown/unexpected option cfg.output = ',cfg.output]);
  end % switch cfg.output
  return;
end
% reset the flag
flag = false;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract the source signal using specified method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(cfg.method)

  case {'echo1','echo2','echo3','echo4','echo5','echo6','echo7','echo8','echo9'}
    % return individal echo time series
    i = str2num(cfg.method(end));
    if (i<1) || (i>ne)
      error('specified echo number exceeds number of echoes');
    else
      src = dat.signal(i,:);
    end

  case {'sum','mean','median','prod'}
    % simple transforms which do not use any prior knowledge about the design
    % matrix or the echo times
    eval(['src = ',cfg.method,'(dat.signal,1);']);

  case {'paid-v1','paid-v2','paid-v3','pre-paid'}
    % ensure that default settings reflect the specific instance of the method
    switch lower(cfg.method)
      case 'paid-v1'
        cfg.paidedx = (1:ne)';
        cfg.paidsdx = [1 30];
      case 'paid-v2'
        if ~isfield(cfg,'paidedx'), cfg.paidedx = (1:ne)'; end;
        if ~isfield(cfg,'paidsdx'), cfg.paidsdx = [1 30];  end;
      case {'paid-v3','pre-paid'}
        cfg.paidedx = (2:ne)';
        if ~isfield(cfg,'paidsdx'), cfg.paidsdx = [1 30];  end;
      otherwise
        % this does not happen
    end % switch lower(cfg.method)

    % compute cnr sensitivity profile over echos using subsample of time points
    % (e.g., from the baseline period)
    w = calc_paid_weights(dat,cfg.paidsdx,cfg.paidedx);
%     w = [0 0.25 0.25 0.25 0.25]';
    % extract the signal using the weights as a steering vector
    tmpcfg = cfg;
    tmpcfg.method  = 'tran';
    tmpcfg.preproc = 'none';
    tmpcfg.pstproc = 'none';
    tmpcfg.target.mix = w;
    src = extractsource(dat,tmpcfg);

    % postprocessing required for 'pre-paid': regress extracted signal onto the
    % frist echo and return the residuals (i.e. this assumes that echo1 contains
    % mainly artefacts)
    if ~isempty(strmatch(lower(cfg.method),{'paid-v3';'pre-paid'},'exact'))
      reg = cat(2,ones(nt,1),dat.signal(1,:)');
      cof = pinv(reg)*src(1,:)';
      mu1 = mean(src,2);
      src = (src - cof'*reg') + mu1;
      clear mu1 reg cof
    end

  case {'wiener','wiener-one'}
    % extract the source signal which best matches a single target signal using
    % a Wiener filtering approach
    if isempty(cfg.dmorig) || isempty(cfg.dmnorm) || isempty(cfg.dmorth)
      error('required field cfg.dmorig [formerly: cfg.design] not specified');
    end
    % compute signal cross-correlation matrix (and the inverse)
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    Rxx = (x*x');
    iRxx = inv(Rxx);
    % collapse the design matrix into a single target "signal"
    z = sum(cfg.dmorig,2);
    z = z - mean(z,1);
    nrm = norm(z(:),2);
    if (nrm>eps)
      z = z./nrm; % z is a column vector!
    end
    % compute cross-correlation vector of target with signal
    Rzx = (x*z);
    % compute wiener filter coefficients
    w = iRxx*Rzx;
    % extract the source signal
    src = w'*dat.signal;
    % set flag to ensure subsequent check whether the source waveform is
    % inverted relative to the original signal
    flag = true;

  case {'wiener-sum','wiener-avg'}
    % extract the source signal which is the average waveform of the set of
    % sources each of which corresponds to the best match with one design matrix
    % column (waveform), where the waveform is estimated using a Wiener filter
    if isempty(cfg.dmorig) || isempty(cfg.dmnorm) || isempty(cfg.dmorth)
      error('required field cfg.dmorig [formerly: cfg.design] not specified');
    end
    % compute signal cross-correlation matrix (and the inverse)
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    Rxx = (x*x');
    iRxx = inv(Rxx);
    % compute cross-correlation matrix of signal and design matrix
    Rzx = (x*cfg.dmnorm);
    dmc = size(cfg.dmnorm,2); % number design matrix columns
    % loop over design matrix columns
    src = zeros(1,nt);
    for i=1:dmc
      % compute wiener filter coefficients
      w = iRxx*Rzx(:,i);
      % extract the source signal
      src = src + w'*dat.signal;
    end
    % divide by number of design matrix columns on the case of 'wiener-avg'
    if strncmp(lower(cfg.method(end-3:end)),'-avg',4)
      src = src./dmc;
    end
    % set flag to ensure subsequent check whether the source waveform is
    % inverted relative to the original signal
    flag = true;

  case {'wiener-svd'}
    % extract the source signal which has the highest subspace correlation with
    % the signal space spanned by the columns (waveforms) of the design matrix,
    % using a "subspace" wiener filter approach. Here we take the spatial filter
    % derived from the SVD of the signal-design cross-correlation matrix
    if isempty(cfg.dmorig) || isempty(cfg.dmnorm) || isempty(cfg.dmorth)
      error('required field cfg.dmorig [formerly: cfg.design] not specified');
    end
    % compute signal cross-correlation matrix (and the inverse)
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    Rxx = (x*x');
    iRxx = pinv(Rxx);
    % compute cross-correlation matrix of signal and orthonrmal basis for the
    % column space of the design matrix
    Rzx = (x*cfg.dmorth);
    % compute the SVD of the cross-correlations
    [U,S,V] = svd(Rzx,0);
    % compute the wiener filter coefficients from the first left singular vector
    w = iRxx*U(:,1);
    % extract the source signal
    src = w'*dat.signal;
    % set flag to ensure subsequent check whether the source waveform is
    % inverted relative to the original signal
    flag = true;
    % NOTE 1: at present the code assumes that there are more echo times
    % than design matrix columns
    % NOTE 2: what about doing separate extractions and then taking the first
    % component of the SVD (PCA) of the multiple estimates? (this is probably
    % equivalent to the above and computationally more expensive.)

  case 'pca'
    % apply principal component analysis (PCA) to the signal and return the PC
    % whose waveform has the highest subspace correlation with the column space
    % of the design matrix (i.e., cfg.dmorth)
    if isempty(cfg.dmorig) || isempty(cfg.dmnorm) || isempty(cfg.dmorth)
      error('required field cfg.dmorig [formerly: cfg.design] not specified');
    end
    % compute sample cross-covariance matrix of signal
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    C = (x*x')./(nt-1);
    for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    % eigenvalue decomposition
    [E,D] = eig(C);
    z = E'*x;
    % compute subspace correlation of PCs with design matrix
    r = sqrt(sum((z*cfg.dmorth).^2));
    % find PC with maximum subspace correlation
    [v,i] = max(r);
    % re-extract the source signal from the data (correct scaling and offest)
    src = E(:,i)'*dat.signal;
    % set flag to ensure subsequent check whether the source waveform is
    % inverted relative to the original signal
    flag = true;
    % FIXME: add the option to do PCA of the echo cross-correlation matrix
    % rather tan the cross-covariance matrix

  case {'ica','fastica'}
    % apply independent component analysis (ICA) to the signal and return the
    % IC whose waveform has the highest subspace correlation with the column
    % space of the design matrix (i.e., cfg.dmorth)
    if isempty(cfg.dmorig) || isempty(cfg.dmnorm) || isempty(cfg.dmorth)
      error('required field cfg.dmorig [formerly: cfg.design] not specified');
    end
    % zero mean signals and normalize rows to unit length
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    % for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    % apply ICA
    try
      % use spatially constrained FastICA code without any constraints
      [A,W,S] = scfast2(x,ne,'approach','symm','epsilon',1.0e-4,'maxiter',100);
      % ensure columns of mixing matrix are scaled to unit length
      for i=1:size(A ,2), A(:,i) = A(:,i)./norm(A(:,i), 2); end;
      % re-compute mixing matrix inverse
      W = inv(A);
      % unmix the normalized signals and re-normalize (just to be safe!)
      z = W*x;
      z = z - mean(z,2)*ones(1,nt);
      for i=1:ne, z(i,:) = z(i,:)./norm(z(i,:),2); end;
      % compute subspace correlation of all ICs with the column space of design
      % matrix (i.e, cfg.dmorth) and sort ICs in descending order of subspace
      % correlation
      r = cat(2,zeros(ne,1),(1:ne)');
      for i=1:ne
        r(i,1) = sqrt(sum((z(i,:)*cfg.dmorth).^2));
      end
      r = sortrows(r,[-1]);
      % re-extract signals to ensure correct scaling and offset
      if strncmp(cfg.output,'src',3)
        src = W(r(1,2),:)*dat.signal;
      else
        src = W(r(:,2),:)*dat.signal;
      end
      % given the sign ambiguity in ICA it is essential here to check whether
      % the target source waveform is inverted relative to the original signal
      flag = true;

    catch
      warning('call function scfast2 faield: returning zeros');
      disp(lasterr);
      if strncmp(cfg.output,'src',3)
        src = zeros(1,nt);
      else
        src = zeros(ne,nt);
      end
    end
    % FIXME: add infomax and other ICA algoorithms in the future?

  case {'slope','line[LS]','line[TLS]','line[DLS]','line[L1-norm]','line[Loo-norm]'}
    % use simple pseudo-inverse method in the case of 'slope' or 'line[LS]'
    %     str1 = lower(cfg.method);
    %     str2 = lower(cfg.preproc);
    %     if ( strncmp(str1,'slope',length(str1)) || strncmp(str1,'line[LS]',length(str1)) ) ...
    %         && ( strncmp(str2,'log',length(str2)) || strncmp(str2,'log10',length(str2)) )
    %       A = cat(2,dat.echo_t(:),ones(ne,1));
    %       W = inv(A'*A)*A';
    %       if strncmp(lower(cfg.output),'src',3)
    %         src = W(1,:)*dat.signal;
    %       else
    %         src = W*dat.signal;
    %       end
    %
    %     else
    % compute linear (least-squares) regression coefficients for each time slice
    % and return the slope estimates in src
    tmp = zeros(4,nt);
    tmp(1,:) = sum(dat.signal,1);            % sum(y)
    tmp(2,:) = tmp(1,:).*tmp(1,:);           % sum(y)^2
    tmp(3,:) = ne.*sum((dat.signal.^2),1);   % N*sum(y^2)
    tmp(4,:) = ne.*(dat.echo_t'*dat.signal); % N*sum(x*y)
    % return the slope estimates
    src = zeros(1,nt);
    %if all( (tmp(3,:)>0) & (tmp(2,:)>0) & (tmp(3,:)~=tmp(2,:)) )
    ii = find( (tmp(3,:)>0) & (tmp(2,:)>0) & (tmp(3,:)~=tmp(2,:)) );
    if ~isempty(ii)
      src(1,ii) = (tmp(4,ii)-(sum(dat.echo_t).*tmp(1,ii)))./(tmp(3,ii)-tmp(2,ii));
    end
    % return the intercept estimate if required
    if strncmp(cfg.output,'all',3)
      src = cat(1,src,zeros(1,nt))
      src(2,ii) = (tmp(1,ii) - src(1,ii).*sum(dat.echo_t))./ne;
    end
    clear tmp;
    % FIXME: add further methods for estimating slope and intercept using other
    % error measures, e.g., data least-squares, total least-squares, L1-norm and
    % Loo-norm ('oo' means 'infinity' !)
    % end

  case 'tran'
    % extract source signal with known projection weights using the transpose
    if isempty(cfg.target.mix), error('field cfg.target.mix not specified'); end;
    src = cfg.target.mix'*dat.signal;
    % NOTE: should src be checked for inversion? This can only happen if an
    % "inappropriate" target vector is used ...
    flag = true;

  case 'pinv'
    % unmix all source signals with known projection vectors using the (Moore-
    % Penrose) pseudo-inverse
    if isempty(cfg.target.mix), error('field cfg.target.mix not specified'); end;
    % cfg.target.mix = cfg.target.mix./dat.rmeans;
    A = [cfg.target.mix,cfg.tinsel];
    [nc,nr] = size(A);
    % compute the pseudo-inverse
    if (nc>nr)
      W = inv(A'*A)*A';
    elseif (nc<nr)
      W = A'*inv(A*A');
    else % (nc==nr)
      W = inv(A);
    end
    % extract the source signal(s)
    if strcmp(cfg.output,'src')
      src = W(1:size(cfg.target.mix,2),:)*dat.signal;
    else
      src = W*dat.signal;
    end
    flag = true;

  case 'mmse'
    % extract a source signal with known projection weights using the MMSE
    % beamformer method
    if isempty(cfg.target.mix), error('field cfg.target.mix not specified'); end;
    % compute sample cross-covariance matrix of signal
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    C = (x*x')./(nt-1);
    % normalize row vectors to unit length for calculations later
    for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    % compute the beamformer: w = (inv(C)*a)./(a'*inv(C)*a)
    % NOTE: we use the Cholseky decomposition of the covariance matrix and solve
    % the system of linear equations C*w = a, which is much quicker given the
    % fact that C is square and symmetric
    [R,p] = chol(C);
    if (p>0) && (p<ne)
      error('sample covariance matrix is not positive definite');
    end
    v = R\(R'\cfg.target.mix);               % solve: C*v  = a
    w = v.*diag(1./diag(cfg.target.mix'*v)); % scale: a'*v = 1
    % extract the source signal(s)
    src = w'*dat.signal;
    % set flag to ensure subsequent check whether the source waveform is
    % inverted relative to the original signal
    flag = true;
    % NOTE: check whether this is really neccessary

  case {'sbss','scfast2'}
    % use semi-blind source separation (sbss) with cfg.target as a constraint
    % to extract the target source signals
    if isempty(cfg.target.mix), error('field cfg.target.mix not specified'); end;
    % specify mixing matrix column constraint (use a hard constraint only)
    Ac = [cfg.target.mix];
    % zero mean signals and normalize rows to unit length
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    % for i=1:ne, x(i,:) = x(i,:)./norm(x(i,:),2); end;
    % call spatially constrained fastica
    try
      % use spatially constrained FastICA
      [A,W,S] = scfast2(x,ne,'hard',Ac,'approach','symm','epsilon',1.0e-4,'maxiter',100);
      % rescale the constraint columns of A to have the norms of columns in Ac
      for i=1:size(A ,2), A(:,i) = A(:,i)./norm(A(:,i), 2); end;
      for i=1:size(Ac,2), A(:,i) = A(:,i).*norm(Ac(:,i),2); end;
      W = inv(A);
      if strncmp(cfg.output,'src',3)
        src = W(1:size(Ac,2),:)*dat.signal;
      else
        src = W*dat.signal;
      end
      % set flag to ensure subsequent check whether the source waveforms are
      % inverted relative to the original signal
      flag = true;
    catch
      warning('call function scfast2 faield: returning zeros');
      disp(lasterr);
      if strncmp(cfg.output,'src',3)
        src = zeros(size(Ac,2),nt);
      else
        src = zeros(ne,nt);
      end
    end

  otherwise
    error(['incorrect specification of cfg.method = ',method]);

end % switch cfg.method


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check whether the extracted source is inverted w.r.t. the original signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x has previously been calculated and contains the zero mean, unit L2-norm
% signals; field cfg.dmnorm contains the zero mean, unit norm columns of the
% original design matrix (cfg.dmorig)
flag = false;
if flag
  if ~exist('x')
    x = dat.signal - mean(dat.signal,2)*ones(1,nt);
    for i=1:ne
      x(i,:) = x(i,:)./norm(x(i,:),2);
    end
  end
  % check whether the extracted signal is sign inverted w.r.t. the orignial
  % data by looking at the sign of the maximum correlation coefficient over
  % (preproc'ed) echo time series
  z = src - mean(src,2);
  z = z ./ norm(z(:),2);
  r = x*z';
  [v,i] = max(abs(r));
  if r(i)<0
    src = src.*(-1);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apply post-processing appropriate to pre-processing and desired source format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: for the time being we assume that we want to return a "cleaned" signal
% rather than R2*
switch cfg.pstproc
  case 'none'
    % do nothing
  case 'log'
    % exponentiate source signals
    src = exp(src);
    % add the mean of the first raw echo
    src = src + dat.rmeans(1);
  case 'log10'
    % exponentiate source signals
    src = 10.^src;
    % add the mean of the first raw echo
    src = src + dat.rmeans(1);
  case {'-/mean';'smdm'}
    % multiply by, then add mean of first raw echo
    src = src.*dat.rmeans(1);
    src = src+dat.rmeans(1);
  otherwise
    error(['unknown option cfg.pstproc = ',cfg.pstproc]);
end % switch cfg.pstproc





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w] = calc_paid_weights(dat,sdx,edx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate a set of weights reflecting the contrast-to-noise ratio (CNR) based
% on a selection of samples from the multi-echo time-series
%
% Usage:
%   w = calc_paid_weights(dat,sdx,edx);
%
% Input:
%   dat is a structure containing the data
%   dat.signal
%   dat.echo_t
%
%   sdx is a vector specifying [beginsample endsample] of the segment over
%   which to compute the weights
%
%   edx is a vector of indices specifying for which echoes to compute the
%   weight
%
%
% Output:
%   w is the set of weights for all echoes, containing a zero for those
%   echoes that were not included in idx
%

% check input arguments
if ~isstruct(dat) || ~any(isfield(dat,{'signal';'echo_t'}))
  error('invalid data structure');
end
[ne,nt] = size(dat.signal);

if (nargin<3), sdx = [1 min([30,max([1,fix(nt/10)])])]; end;
if (prod(size(sdx))~=2), error('sdx must be a 2 element vector'); end;
if (sdx(1)>sdx(2)), error('first element of sdx must be smaller than second'); end;
if any(sdx(:)<=0) || any(sdx(:)>nt), error('elements of sdx out of bounds'); end;

if (nargin<2), edx = (1:ne)'; end;
if ~isempty(edx) && ( ~isvector(edx) || length(edx)>ne || any(edx(:)<=0) || any(edx(:)>ne))
  error(' must be a vector with maximally ne elements');
end;
edx = unique(edx(:));

% compute weights: contrast to noise ratio (standrdized 2nd-moment mu/sigma)
w = zeros(ne,1);
try
    if ~isfield(dat, 'prevols')   
        m = mean(dat.signal(:,sdx(1):sdx(2)),2);
        s = std(dat.signal(:,sdx(1):sdx(2)),1,2);
    else
        m = mean(dat.prevols, 2);
        s = std(dat.prevols, 1, 2);
    end
  snr = m./s;
  w(edx) = snr(edx).*abs(dat.echo_t(edx));
catch
  w(edx) = 1.0;
end
w = w./sum(w);
return;

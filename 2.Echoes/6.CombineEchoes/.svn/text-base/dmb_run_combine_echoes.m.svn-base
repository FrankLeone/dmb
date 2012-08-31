function out = cfg_donders_run_combine_echos (job)

% Created by Pieter Buur, April 2008
%
% 20080421 - pre-allocated memory for data object
%

sessions      = job.files;
if ~iscell(sessions)
    sessions = {sessions};cs
end

INFO.me.combine_method     = job.combine_method;
INFO.me.echotimes          = job.echo_times';
INFO.me.pre_vols           = job.n_pre_vols;
INFO.me.dir.PAIDweight     = job.dir_PAIDweight;
INFO.me.actual_pre_vols     = job.pre_vols;

if isempty(INFO.me.pre_vols) && ~isempty(INFO.me.actual_pre_vols)
    INFO.me.pre_vols = size(INFO.me.actual_pre_vols,1);
end

nosessions = length(sessions);
disp('************ COMBINING ECHOES ************')


%% Just reduce it to the first echo for now, if it isn't only the echo
%% already;

  
for sess = 1: nosessions
    dirs = cellfun(@(x)x(1:max(find(x==filesep))), sessions{sess}, 'UniformOutput', false);
    unique_dirs = unique(dirs);
    nrs = find(strcmp(dirs, unique_dirs{1}));
    files = sessions{sess}(nrs);
    files = find_other_echoes(files);
        
    nechoes = length(files); 
    INFO.me.nechoes = nechoes;
    
    nii_info = struct();
    
    %% Fill nii_info
    tmp = spm_vol(files{1}{1});
    nii_info.mat         = tmp.private.mat;
    nii_info.mat0        = tmp.private.mat0;
    nii_info.mat_intent  = tmp.private.mat_intent;
    nii_info.mat0_intent = tmp.private.mat0_intent;
    nii_info.Intercept   = tmp.private.dat.scl_inter;
    nii_info.Slope       = tmp.private.dat.scl_slope;
    nii_info.dim         = tmp.private.dat.dim;
    
    tmp_data = spm_read_vols(tmp);
    n_scans = min(cellfun(@(X)size(X, 1), files));
    dims_data = [size(tmp_data) n_scans];
    warning off;
    data = zeros(nechoes, prod(dims_data(1:3)), dims_data(4), 'uint16');
    
    for echo = 1: nechoes
        fn = files{echo};
        if iscell(fn)
            max_length = max(cellfun(@length, fn));
            fn = cell2mat(cellfun(@(x, max_length)[x repmat(' ', 1, max_length - length(x))], fn, repmat({max_length}, size(fn)), 'UniformOutput', false));
        end
        
        for nr = 1:dims_data(4)
            vol = spm_read_vols(spm_vol(fn(nr, :)));
            data(echo, :, nr) = vol(:)';        
        end
       
        disp(sprintf('volumes for echo %d (of %d) loaded',echo,INFO.me.nechoes));
    end
    
    warning on;
    
    [nech,nv,nt] = size(data);
    dt  = [spm_type('uint16') spm_platform('bigend')];

     disp(sprintf('Loaded data for session %s', num2str(sess)));
    % create mask
%     mask = make_brainmask(data);
    
    % initialize configuration options
    cfg = [];
    cfg.method  = INFO.me.combine_method;
    cfg.paidsdx = [1 INFO.me.pre_vols];
    cfg.prevols = INFO.me.actual_pre_vols;
    % initialize the data structure
    dat = [];
    dat.signal = [];
    dat.echo_t = INFO.me.echotimes;
    
    clear files;
    
    % allocate space for extracted bold time-series
    src = zeros(nv,nt, 'single');
    avg = zeros(nv,1, 'single');
  
    % preprocess prevols
    if ~isempty(cfg.prevols{1})
        files = find_other_echoes(cfg.prevols);
        for echo = 1: length(files)
            tmp = spm_read_vols(spm_vol(fileCells2Mat(files{echo})));
            size_tmp = size(tmp);
            prevols(echo, :, :) = reshape(tmp, 1, prod(size_tmp(1:3)), size_tmp(4));
        end
        
    end
        
    % loop over voxels  
    weights = zeros(nv, nechoes);
    for vv=1:nv
      % select part of the data
      dat.signal = double(squeeze(data(:,vv,:)));
      if exist('prevols', 'var')
        dat.prevols = double(squeeze(prevols(:, vv, :)));
      end
%       if (mask(vv)==1)
        % extract the source
        %disp(vv)
        [src(vv,:) weights(vv, :)] = extractsource(dat,cfg);
%       else
        % crude hack because who knows what kind of data comes out of
        % extractsource but in this case at least the voxels OUTSIDE
        % the mask will look something like a brain ;-)
%         src(vv,:) = mean(dat.signal);
        % src(vv,:) = dat.signal(1,:);
%       end
    end
    
    %% Save weights to disk
    weights = reshape(weights, [dims_data(1:3), length(dat.echo_t)]);
    refFile = cfg.prevols{1};
    dir = refFile(1:max(find(refFile == filesep)));
    dir = fullfile(dir, INFO.me.dir.PAIDweight);
    
    baseVol = spm_vol(cfg.prevols{1});
    baseVol(1).fname = dir;    
    baseVol(1).descrip = 'paid-weights used for echo combination';
    baseVol = rmfield(baseVol(1), 'pinfo');
    
    if ~exist(dir, 'dir')
        mkdir(dir);
    end
    for nrEcho = 1: nechoes
        copyVol = baseVol;
        copyVol.fname = [copyVol.fname '/weights_' num2str(nrEcho) '_' num2str(dat.echo_t(nrEcho)) '.nii'];
        spm_write_vol(copyVol, squeeze(weights(:, :, :, nrEcho)));
    end
    
    %%%%%
    clear data;
    disp(sprintf('Done combining data for session %s', num2str(sess)));
%     disp(sprintf('done combining echoes for subject %s / session %s', ...
%                   INFO.subjects{s}, INFO.dir.sessions{sess}))
    % write combined echo data
    
    for vv=1:size(fn,1)
      
      N = nifti;
      full_file = fn(vv,:);
      
      file = full_file((max(find(full_file == filesep)+1) : end));
      echo_dir = full_file (1:(max(find(full_file == filesep))-1));      
      session_dir = echo_dir (1:(max(find(echo_dir == filesep))-1));
      
      echo_name = echo_dir(max(find(echo_dir == filesep))+1 : end);
      
      i_echo_in_name = strfind(file, echo_name);
      file = [file(1:(i_echo_in_name-1)) 'comb' file((i_echo_in_name+length(echo_name)) : end)];
      
      fname = fullfile(session_dir,file);
      N.dat = file_array(fname,nii_info.dim,dt,0,nii_info.Slope,nii_info.Intercept);
      N.mat = nii_info.mat;
      N.mat0 = nii_info.mat0;
      N.mat_intent = nii_info.mat_intent;
      N.mat0_intent = nii_info.mat0_intent;
      N.descrip = INFO.me.combine_method;
      create(N);
      N.dat(:,:,:) = reshape(src(:,vv),nii_info.dim);
      out(sess).files{vv} = fname;
      if ~mod(vv/N.dat.dim(1)/N.dat.dim(2),N.dat.dim(3)), disp('combined slice %d of %d', vv/N.dat.dim(1)/N.dat.dim(2),N.dat.dim(3)); end
    end
end % session loop

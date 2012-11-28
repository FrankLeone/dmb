function out = dmb_run_spm_cfg_run_runjobs(job)

% Initialise, fill, save and run a job with repeated inputs.
% To make use of possible parallel execution of independent jobs, all
% repeated jobs are filled first and (if successfully filled) run as one
% large job.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_run_runjobs.m 3944 2010-06-23 08:53:40Z volkmar $

rev = '$Rev: 3944 $'; %#ok

if isfield(job.save, 'savejobs')
    [p n e] = fileparts(job.save.savejobs.outstub);
    outfmt = fullfile(job.save.savejobs.outdir{1}, sprintf('%s_%%0%dd.m', n, ceil(log10(numel(job.inputs))+1)));
end;
hjobs = cell(size(job.inputs));
sts = false(size(job.inputs));
out.jobfiles = {};
for cr = 1:numel(job.inputs)
    cjob = cfg_util('initjob', job.jobs);
    inp = cell(size(job.inputs{cr}));
    for ci = 1:numel(job.inputs{cr})
        fn = fieldnames(job.inputs{cr}{ci});
        inp{ci} = job.inputs{cr}{ci}.(fn{1});
    end;
    sts(cr) = cfg_util('filljob', cjob, inp{:});
    if sts(cr)
        [un hjobs{cr}] = cfg_util('harvest', cjob);
    end;
    if isfield(job.save, 'savejobs')
        out.jobfiles{cr} = sprintf(outfmt, cr);
        cfg_util('savejob', cjob, out.jobfiles{cr});
    end;
    cfg_util('deljob', cjob);
end;
if all(sts)
    % keep all hjobs;
elseif any(sts) && strcmp(job.missing,'skip')
    hjobs = hjobs(sts);
else
    hjobs = {};
end
if ~isempty(hjobs)
    % Check whether qsubcellfun is installed
    if exist('qsubcellfun', 'file')
        % If we did not get any info on the time and mem requirements
        if isempty(job.mem) || isempty(job.time)
            tic
            memtic

            % Just run one job to see how much it takes
            out.jout(1) = cellfun(@dmb_run_spm_run_runjobs_one_job, hjobs(2));

            % Be on the safe side: multiply by 2
            if isempty(job.mem)
                mem = memtoc * 2;        
            else
                mem = job.mem;
            end
            if isempty(job.time)
                time = toc * 2;
            else
                time = job.time;
            end

            % If no memory was required, make it at least 1 MB
            if isnan(mem)
                mem = 1048000;
            end

            % Don't do jobs beneath one minute using gsubcellfun
            if time < 60
                % Just use cellfun
                out.jout(2:(length(hjobs))) = cellfun(@dmb_run_spm_run_runjobs_one_job, hjobs(2:end));
            else
                % And run qsubcellfun
                out.jout(2:(length(hjobs))) = qsubcellfun(@dmb_run_spm_run_runjobs_one_job, hjobs(2:end), 'memreq', mem, 'timreq', time);                   
            end  
        
        else
            % Otherwise, just copy from the input
            mem = job.mem;
            time = job.time;

            % Don't do jobs beneath one minute using gsubcellfun
            if time < 60
                % And run
                out.jout = cellfun(@dmb_run_spm_run_runjobs_one_job, hjobs);
            else
                % And run qsubcellfun
                out.jout = qsubcellfun(@dmb_run_spm_run_runjobs_one_job, hjobs, 'memreq', mem, 'timreq', time);                   
            end  
        end
    else
         out.jout = cellfun(@dmb_run_spm_run_runjobs_one_job, hjobs);
    end    
end;
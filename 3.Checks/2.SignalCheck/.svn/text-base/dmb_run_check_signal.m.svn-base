function out = dmb_run_check_signal (job)
%--------------------------------------------------------------------------
% BCH_CHECK_SIGNAL collects the timeseries of the global signal and
% separate slice signals. The resulting vectors are plotted and saved. This
% is especially usefull to check if your signal is stable over time. Any
% unstability in the signal might be due to suboptimal settings of the
% MR-scanner or that the scanner needs to be fixed. Spikes can be detected
% here, but the bch_check_spike does a better job. This function does not
% give you a specific value on which you can easilly determine what is good
% and what is bad. It remains a visual inspection. But please keep in mind
% that almost all of your scans will be fine. If you think you have spotted
% a problem or noticed that one subject is very different from all the
% others, please notify the person responsible for the scanner.
%
% created by Lennart Verhagen, march-2006
% L.Verhagen@donders.ru.nl
% version 2009-02-04
%--------------------------------------------------------------------------

%% sort input
%----------------------------------------------------
global defaults;

spm_defaults;

multiecho   = job.multiecho;
output_dir  = determine_path(job.files{1});
nr          = regexp(output_dir{1}, '/S\d+/');
output_dir  = output_dir{1}(1:(min(nr)+3));
subject     = job.subject;

signal_dir   = fullfile('fMRI', 'info', 'signal');
if ~exist(fullfile(output_dir, signal_dir), 'dir')
    mkdir(fullfile(output_dir, signal_dir));
end
% if (strcmp(job.files{1}{1}([end-1 end]), ',1'))
%     sessions      = cellfun(@(x)x(1:(end-2)), job.files, 'UniformOutput', false);
% else
sessions      = job.files;

out.files = sessions;

if ~iscell(sessions)
    sessions = {sessions};
end

nosessions = length(sessions);

% end
func_dir        = job.dir_branch.func_dir;
struc_dir       = job.dir_branch.struc_dir;
echo_dir        = job.dir_branch.echo_dir;
sess_dir        = job.dir_branch.sess_dir;
type_dir        = job.dir_branch.type_dir;



%% loop over subjects and sessions
%----------------------------------------------------
fprintf('\n\nbatch_SPM5: slice & global signal stability check initiated.');

signal_dir = fullfile(output_dir, signal_dir);
if ~exist(signal_dir,'dir'); mkdir(signal_dir); end

for sess = 1: nosessions
    files = sessions{sess};
    files = find_other_echoes(files, multiecho);
        
    nechoes = length(files); 
    for echo = 1: nechoes
        imgs = files{echo};
        
        if iscell(imgs)
            max_length = max(cellfun(@length, imgs));
            imgs = cell2mat(cellfun(@(x, max_length)[x repmat(' ', 1, max_length - length(x))], imgs, repmat({max_length}, size(imgs)), 'UniformOutput', false));
        end
        if isempty(imgs)
            warning('BATCH_SPM5:FilesNotFound','No files that pass the image filter (%s) have been found.',filter_img);
        end
                
        [slicesig,globalsig] = calc_sig(imgs);

        save(fullfile(signal_dir,['CheckSignal', '_', [subject '_' sess_dir, num2str(sess)], '_', [echo_dir, num2str(echo) '.mat']]),'*sig');
        
        h = figure('Name',['CheckSignal_' subject '_' sess_dir num2str(sess) '_' [echo_dir, num2str(echo)]],'NumberTitle','off');
        set(h,'Color','w');
        subplot(2,2,1); plot(slicesig);
        title_str = ['Stab check: ',subject ' ' sess_dir num2str(sess) ' ' [echo_dir, num2str(echo)]];

        title(['Slice Sig ' title_str]);
        subplot(2,2,3); plot(var(slicesig));
        title('Variance:');
        subplot(2,2,2); plot(globalsig);
        title(['Glob Sig ' title_str]);
        subplot(2,2,4); bar(var(globalsig));
        title('Variance:');

        figname = fullfile(signal_dir,sprintf('CheckSignal_%s%s%s.jpg', [subject '_' sess_dir, num2str(sess)], '_', [echo_dir, num2str(echo)]));
        saveas(h, figname,'jpg');
        close(h);
        
    end
    
end

clear global defaults;

fprintf('\nbatch_SPM5: slice & global signal stability check done.\n');
%==========================================================================


%% function - calc_sig
%----------------------------------------------------
function [sig,msig] = calc_sig(P)
% Calculate the global signal (mean intensity per image)
global defaults;
if isempty(defaults) || ~isfield(defaults,'analyze') ||...
         ~isfield(defaults.analyze,'flip')
     defaults.analyze.flip = 0;
end

fprintf('\n\t\tLoading the selected files...');
V = spm_vol(P);
fprintf(' done');

sig = zeros(length(V),V(1).dim(3));
msig = zeros(length(V),1);
%spm_progress_bar('Init',length(sig),'check global signal','images completed');
fprintf('\n\t\tCalculating the global signal from images:');
fprintf('\n\t\t1    ');
for i = 1:size(sig, 1),
    for z = 1:V(i).dim(3),
        img   = spm_slice_vol(V(i),...
            spm_matrix([0 0 z]),V(i).dim(1:2),0);
        sig(i,z) = sum(img(:))/prod(V(1).dim(1:2));
        msig(i) = msig(i) + sum(img(:));
    end;
    msig(i) = msig(i)/prod(V(1).dim(1:3));
    %spm_progress_bar('Set',i);
    fprintf('.');
    if rem(i,50)==0
        fprintf('\n\t\t');
        fprintf('%d ',i);
        if i < 10; fprintf(' '); end;
        if i < 100; fprintf(' '); end;
        if i < 1000; fprintf(' '); end;
    end
end

%spm_progress_bar('Clear');
%==========================================================================
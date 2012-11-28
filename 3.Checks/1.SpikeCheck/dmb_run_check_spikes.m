function out = dmb_run_check_spikes(job)
%--------------------------------------------------------------------------
% BCH_CHECK_SPIKE checks and removes spikes from functional images. Please
% note that it works on the original images. You can select to check for
% spikes only, or also remove them. If you choose for the latter, please
% note that you are changing the original images. The images before the
% changes will be saved in a separate directory, but still, it might be
% dangerous. For details on the different settings, please take a look at
% the comments below.
%
% created by Benedikt Poser, 2006-04-06
% please talk to me when you substatially modify this
% so I can keep things up to date on my side.
% any input is more than welcome! 
%
% adapted by Lennart Verhagen to work with the SPM5 batch, October 2007
% L.Verhagen@fcdonders.ru.nl
% version 2007-11-14

% Pieter and Inge adapted this for ME
%--------------------------------------------------------------------------

%% Split sessions
expected_n_sessions = job.expected_n_sessions;
job.data = dmb_run_split_sessions_inline(job.data, expected_n_sessions);

%% Perform operation
multiecho   = job.multiecho;
output_dirs  = job.output_dir;
subject     = ''; % job.subject;
cfg.mode    = job.mode;
flags.mode  = cfg.mode;

% if (strcmp(job.files{1}{1}([end-1 end]), ',1'))
%     sessions      = cellfun(@(x)x(1:(end-2)), job.files, 'UniformOutput', false);
% else
sessions      = job.data;

if ~iscell(sessions)
    sessions = {sessions};
end

nosessions = length(sessions);

% load spm defaults
spm_defaults;


%% Sort input and settings
%----------------------------------------------------

cfg.spike_threshold   = 0.3;                        % fractional deviation of slice mean that qualifies as a 'spike' 0.1 = 10%
cfg.prefix_spike      = '';                         % if you want a prefix for your new images, please say so. Beware however, this might intervene with your original functional prefix!


%% Configuration
%----------------------------------------------------
cfg.mask_type         = 'noise_corner';                 % 'noise' makes mask from noise level, 'noise_corner' takes image corners, 'intensity' simple intensity mask
cfg.masknoise         = 2;                              % if mask_type 'noise': creates mask based on typical noise*cfg.masknoise
cfg.maskint.int       = 0.3;                            % if mask_type 'intensity': creates mask based on intensity relative to volume mean: 1.0=mean of whole volume, 0.1=10% of mean
cfg.maskint.fix       = ('yes');                        % if mask_type 'intensity': 'yes' creates fixed mask from first 5 volumes, 'no' mask recalculation for each volume
cfg.maskint.mode      = 'outside_brain';                % if mask_type 'intensity':'inside_brain' or 'outside_brain' spike-intensity detection
cfg.base_cor_on       = 'timecourse_avg';               % base the correction on deviation from 'previous_vol' or 'timecourse_avg')


%% loop over subjects and sessions
%----------------------------------------------------
if strcmp('remove', cfg.mode);
    fprintf('\n\nbatch_SPM5: Checking and removing spikes from images.');
end
if strcmp('check', cfg.mode);
    fprintf('\n\nbatch_SPM5: Checking for spikes in images.');
end

INFO.check.spike.threshold  = 0.3;          % threshold: fractional deviation of slice mean that qualifies as a 'spike' e.g. 0.1 = 10%
INFO.check.spike.prefix     = '';           % prefix to be prepended before filename after spike removal. Beware, this might mess up your functional prefix!

% set some parameters we want to use
flags.mask_type         = ('intensity');     % 'noise' makes mask from noise level, 'noise_corner' takes image corners, 'intensity' simple intensity mask
flags.masknoise         = 2;                    % if mask_type 'noise': creates mask based on typical noise*flags.masknoise
flags.maskint.int       = 0.1;                  % if mask_type 'intensity': creates mask based on intensity relative to volume mean: 1.0=mean of whole volume, 0.1=10% of mean
flags.maskint.fix       = ('yes');              % if mask_type 'intensity': 'yes' creates fixed mask from first 5 volumes, 'no' mask recalculation for each volume
flags.maskint.mode      = ('outside_brain');    % if mask_type 'intensity':'inside_brain' or 'outside_brain' spike-intensity detection
flags.base_cor_on       = ('previous_vol'); 	% base the correction on deviation from 'previous_vol' or 'timecourse_avg')
flags.spike_threshold   = INFO.check.spike.threshold;	% fractional deviation of slice mean that qualifies as a 'spike' 0.1 = 10%
flags.file_prefix_addon = INFO.check.spike.prefix;      % if you want a prefix for your new images, please say so. Beware however, this might intervene with your original functional prefix!

if length(output_dirs) == 1 && length(sessions) > 1
    output_dirs = repmat(output_dirs, size(sessions));
end

disp (['I''m being called in run mode: '  flags.mode  ] );

spm('CreateIntWin');
for sess = 1: nosessions    
    
    files = sessions{sess};
    out.sess{sess} = files;
    output_dir = output_dirs{sess};
    flags.output_dir = output_dir;

    files = find_other_echoes(files, multiecho);
    
    nechoes = length(files); 
    for echo = 1: nechoes
        imgs = files{echo};
        
        if ~exist(fullfile(output_dir,['check_spike_' [subject, '_' num2str(sess)], '_', [num2str(echo)] '.jpg']), 'file')
        
            if iscell(imgs)
                max_length = max(cellfun(@length, imgs));
                imgs = cell2mat(cellfun(@(x, max_length)[x repmat(' ', 1, max_length - length(x))], imgs, repmat({max_length}, size(imgs)), 'UniformOutput', false));
            end

            V = spm_vol(imgs);

            %create and save mask
            [mask, noise] = getmask(V, flags);
            save_mask(mask,V,flags);

            % determine timecourse slice averages
            flags.runmode = ('check');
            [slice_averages, new_imgs_headers] = slcavg_dupl(V, mask, noise, flags);

            % detect spikes
            [affected_vol_slc, affected_vol] = detect_spikes (slice_averages, flags);
            save_spikefile(affected_vol_slc,affected_vol,V,flags);

            h = show_save_slice_avg(slice_averages, V, flags);
            figname = fullfile(output_dir,['check_spike_' [subject, '_' num2str(sess)], '_', [num2str(echo)] '.jpg']);

            saveas(h, figname,'jpg');

            % if spikes have been detected and we were in 'check' mode before: recall with remove flag
            if ( length(find(affected_vol_slc ~= 0))>0  && strcmp('remove', flags.mode) == 1 )
                fprintf('\n\nFOUND SPIKES!\n\n');
                flags.runmode = ('remove');
                flags.affected.vol = affected_vol;
                flags.affected.slc = affected_vol_slc;
                [slice_averages, new_imgs_headers] = slcavg_dupl(V, mask, noise, flags);
                %remove spikes
                remove_spikes(affected_vol_slc, new_imgs_headers);
            end
        else
            display([fullfile(output_dir,['check_spike_' [subject, '_' num2str(sess)], '_', [num2str(echo)] '.jpg']) ' already exists, skipping...']);
        end
    end
end

if strcmp('remove', flags.mode); spm('FigName', 'Spike Removal: Done');disp('batch_SPM5: spike removal done!'); end
if strcmp('check', flags.mode); spm('FigName', 'Spike Check Done'); disp('batch_SPM5: spike check done!');end    
close gcf;
%==========================================================================


%% Combine sessions again
[out.data no_sessions] = dmb_run_combine_sessions_inline(out.sess);

%% Check whether splitting and combing went alright
assert(no_sessions == expected_n_sessions);

%% function - getmask
%----------------------------------------------------
function [mask, noise]  = getmask(imgs_headers, flags)

headers = imgs_headers;
image_data = spm_read_vols_1by1(headers);
average_volume = mean (image_data, 4);
average_volume = reshape(average_volume, size(average_volume, 1), size(average_volume, 2), size(average_volume, 3));
mean_intensity = mean(average_volume(:));
mask = zeros(size(average_volume));

if strcmp('intensity', flags.mask_type) == 1
	if strcmp('inside_brain', flags.maskint.mode) == 1
        mask (find (average_volume > flags.maskint.int * mean_intensity)) = 1;
    elseif strcmp('outside_brain', flags.maskint.mode) == 1
        mask (find (average_volume <= flags.maskint.int * mean_intensity)) = 1;
	else
        fprintf('problem in check_spike subfunction getmask: invalid correction mode!\n\n')
    end
    noise = 'dummy';
elseif strcmp('noise', flags.mask_type) == 1
    % take what's definetly noise: 8x8 pixels in each corner of each slice
    tmp = average_volume(2:9, 2:9, :); noise(1) = mean(tmp(:));
    tmp = average_volume(2:9, (size(average_volume, 2)-1):-1:(size(average_volume, 2)-8), :) ; noise(2) = mean(tmp(:));
    tmp = average_volume((size(average_volume, 1)-1):-1:(size(average_volume, 1)-8), 2:9, :) ; noise(3) = mean(tmp(:));
    tmp = average_volume((size(average_volume, 1)-1):-1:(size(average_volume, 1)-8), (size(average_volume, 2)-1):-1:(size(average_volume, 2)-8), :); noise(4) = mean(tmp(:));
    noise = mean(noise);
    mask (find (average_volume <= noise * flags.masknoise)) = 1;
elseif strcmp('noise_corner', flags.mask_type) == 1   
    mask(2:9, 2:9, :) = 1;
    mask(2:9, (size(mask, 2)-1):-1:(size(mask, 2)-8), :) =1;
    mask((size(mask, 1)-1):-1:(size(mask, 1)-8), 2:9, :)  =1;
    mask((size(mask, 1)-1):-1:(size(mask, 1)-8), (size(mask, 2)-1):-1:(size(mask, 2)-8), :) =1;
    noise = 'dummy';
else
    fprintf('problem in check_spike subfunction getmask: invalid mask_type!\n\n')
end
%==========================================================================


%% function - preprend
%----------------------------------------------------
function PO = prepend(PI,pre)
[pth,nm,xt] = fileparts(deblank(PI));
PO             = fullfile(pth,[pre nm xt]);
%==========================================================================


%% function - save_mask
%----------------------------------------------------
function save_mask(mask,imgs_headers,flags)
header = imgs_headers(1); 
[pth,nm,xt] = fileparts(deblank(header.fname));
header.fname = fullfile(flags.output_dir,['spike_mask' xt]);
header.descrip = ('spike_removal_mask');
spm_write_vol(header, mask);
%==========================================================================


%% function - slcavg_dupl
%----------------------------------------------------
function [slice_averages, new_imgs_headers] = slcavg_dupl(imgs_headers, mask, noise, flags)
spm_progress_bar('Init', size(imgs_headers, 1),['Calc slice averages / data duplication, mode ' flags.runmode] );
new_imgs_headers = imgs_headers;
for volume = 1:size(imgs_headers,1)
    image = spm_read_vols(imgs_headers(volume));
    % create mask based on how we want to do it (see flags)
    if strcmp('intensity', flags.mask_type) == 1% use mask as calculated before
        if strcmp('yes', flags.maskint.fix) == 1
            mask = mask; 
        elseif strcmp('no', flags.maskint.fix) == 1 % recualculate the mask
            vol_mean = mean (image(:));
            mask = zeros(size(image));
            if strcmp('inside_brain', flags.correction_mode) == 1
                mask (find (image > flags.maskint.int * mean_intensity)) = 1;
	        elseif strcmp('outside_brain', flags.maskint.mode) == 1
                mask (find (image <= flags.maskint.int * mean_intensity)) = 1;  
            else
                fprintf('problem in check_spike subfunction slcavg_dupl: invalid correction mode!\n\n')
            end           
        else 
            fprintf('problem in check_spike subfunction slcavg_dupl: invalid intensity-mask mode!\n\n')
        end
    elseif strcmp('noise', flags.mask_type) == 1 % recalculate mask from noise
        mask = zeros(size(image));
        mask (find (image <= noise * flags.masknoise)) = 1;
    elseif strcmp('noise_corner', flags.mask_type) == 1 
        mask = mask; % we have the mask and don;t need to recalculate! 
    else 
        fprintf('problem in spike_check subfunction slcavg_dupl: invalid mask type!\n\n')
    end

    %calculate slice averages (after application of mask)
    data = image .* mask;
    for slice = 1:size(data, 3)
        slice_data = data(:,:,slice);
        a = find (slice_data > 0);
        non_zero = slice_data (a);
        slice_averages (volume, slice) = mean (non_zero(:));
    end

    %duplicate volume IF we are in remove mode
    if (strcmp('remove', flags.runmode) == 1) && flags.affected.vol(volume)
        new_imgs_headers(volume).descrip = strcat(imgs_headers(volume).descrip,' - un-spiked');
        if isempty(flags.file_prefix_addon)
            movefile(imgs_headers(volume).fname,flags.output_dir);
            new_imgs_headers(volume).fname = imgs_headers(volume).fname;
        else
            new_imgs_headers(volume).fname = prepend(imgs_headers(volume).fname, flags.file_prefix_addon);
        end
        spm_write_vol(new_imgs_headers(volume), image);
    end

    spm_progress_bar('Set',volume);
    
end
spm_progress_bar('Clear');
%==========================================================================


%% function - show_save_slice_avg
%----------------------------------------------------
function h = show_save_slice_avg(slice_averages, imgs_headers, flags)
[pth,nm,xt] = fileparts(deblank(imgs_headers(1).fname));
fullname = fullfile(flags.output_dir,['spike_sliceavg']);
save(fullname,'slice_averages');
for i = 1:size(slice_averages, 2)
    norm_slc_avg (:,i) = slice_averages(:,i) / mean(slice_averages(:,i));
end
h = figure(3); clf; subplot(2, 2, [1 2]); plot(norm_slc_avg); line((1:size(slice_averages, 1)), (1+flags.spike_threshold));
v = axis; if v(4) < (1+flags.spike_threshold*1.5); v(4) = (1+flags.spike_threshold*1.5); end; axis(v);
title(['Check spike results, mask: ' flags.mask_type ', ' flags.maskint.mode ', mode: ' flags.mode], 'Interpreter', 'none')

varSliceAverages = var(slice_averages, [], 1);
maxSliceAverages = max(slice_averages, [], 1);
subplot(2, 2, 3); plot(varSliceAverages); xlabel('Slice number (normally: bottom to top)'); ylabel('Variance of mean in slice.'); title('How much the curve at the top ''wobbels'')');
subplot(2, 2, 4); plot(maxSliceAverages); xlabel('Slice number (normally: bottom to top)'); ylabel('Maximum mean activity in slice.'); title('How high the curve at the top maximally is');

%==========================================================================


%% function - detect_spikes
%----------------------------------------------------
function [affected_vol_slc, affected_vol] = detect_spikes(slice_averages, flags)
spm_progress_bar('Init', (size(slice_averages, 1) -1),'Spike detection');
affected_vol_slc  = zeros (size(slice_averages, 1), size(slice_averages, 2));
affected_vol = zeros (size(slice_averages, 1),1);
mean_slice_averages = mean(slice_averages, 1);
for volume = 2:size(slice_averages, 1)-1
   for slice = 1:size(slice_averages, 2)
       if strcmp('previous_vol', flags.base_cor_on) == 1  
            if (  (slice_averages (volume, slice) - slice_averages(volume-1, slice) )  > flags.spike_threshold * slice_averages(volume-1, slice) )
                affected_vol_slc(volume, slice) = 1; 
                affected_vol(volume) = 1;
            end
       elseif strcmp('timecourse_avg', flags.base_cor_on) == 1   
            if (  (slice_averages (volume, slice) - mean_slice_averages(1, slice) )  > flags.spike_threshold * slice_averages(volume-1, slice) )
                affected_vol_slc(volume, slice) = 1; 
                affected_vol(volume) = 1;
            end
       else
           fprintf('problem in spike_check subfunction detect_spikes: invalid correction mode!\n\n')
       end
   end %slice
   spm_progress_bar('Set',volume-1);
end %volume
spm_progress_bar('Clear');
%==========================================================================


%% function - save_spikefile
%----------------------------------------------------
function save_spikefile(affected_vol_slc, affected_vol, imgs_headers,flags)

[pth,nm,xt] = fileparts(deblank(imgs_headers(1).fname));
fullname = fullfile(flags.output_dir,['spikey_vols']);
save(fullname,'affected_vol');
fullname = fullfile(flags.output_dir,['spikey_vol_slc']);
save(fullname,'affected_vol_slc');
%==========================================================================


%% function - remove_spikes
%----------------------------------------------------
function remove_spikes(affected_vol_slc, new_imgs_headers)
spm_progress_bar('Init', (size(affected_vol_slc, 1) -1),'Spike removal');

for volume = 2:size(affected_vol_slc, 1)-1
    for slice = 1:size(affected_vol_slc, 2)
        if ( affected_vol_slc(volume, slice) == 1 )  
           fprintf('correcting vol %2d slice %2d \n', volume, slice); 
            % load the previous and following volume....
             previous_vol  = spm_read_vols(new_imgs_headers(volume-1));
             following_vol = spm_read_vols(new_imgs_headers(volume+1));
             % do the deed and replace affected slice by the average of adjecent 
             current_vol (:,:, slice) = ( previous_vol (:,:, slice) + following_vol (:,:, slice)  ) ./ 2;
             %save the corrected volume
             
             %% To make sure no files are lost, backup the old files
            old_dir = new_imgs_headers(volume).fname;
            old_dir = old_dir (1:max(find(old_dir == '/')));
            
            if ~exist (fullfile(old_dir, 'spike_backup'), 'dir')
                mkdir(fullfile(old_dir, 'spike_backup'))
            end
            eval(['!cp ' new_imgs_headers(volume).fname ' ' fullfile(old_dir, 'spike_backup', ['backup_' new_imgs_headers(volume).fname])]);
            
             % Make backup of old file
             spm_write_plane(new_imgs_headers(volume),current_vol(:,:,slice), slice);
             %disp (strcat ('removed spike in file', ' ' , new_imgs_headers{volume}.fname)); 
         end
     end 
     spm_progress_bar('Set',volume-1);
 end  
 spm_progress_bar('Clear');
%==========================================================================

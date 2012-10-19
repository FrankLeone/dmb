function out = dmb_run_check_movie (job)

%% Split sessions
expected_n_sessions = job.expected_n_sessions;
job.data = dmb_run_split_sessions_inline(job.data, expected_n_sessions);

%% Perform operation
global defaults;

spm_defaults;



multiecho   = job.multiecho;
output_dirs  = job.output_dir;
subject     = job.subject;

% if (strcmp(job.files{1}{1}([end-1 end]), ',1'))
%     sessions      = cellfun(@(x)x(1:(end-2)), job.files, 'UniformOutput', false);
% else
sessions      = job.data;
% end

if ~iscell(sessions)
    sessions = {sessions};
end

% for nr_file = 1: length(sessions)
%     out(nr_file).files = sessions{nr_file};
% end

nosessions = length(sessions);

INFO.check.movie.which      = 'both';       % Indicate which movies should be created ('default', 'contrast', 'both').
INFO.check.movie.contrast   = 90;         % If the 'contrast' movie is selected (see .which): Contrast value of that movie. A value between -1 (lowest contrast) and 1 (highest contrast) with 0 to leave the image as it is. Set to 0.98 to see the noise clearly.
INFO.check.movie.bright     = 90;         % If the 'contrast' movie is selected (see .which): Brightness value of that movie. A value between -1 (very dark) and 1 (very bright) with 0 to leave the image as it is. Set to 0.97 to see the noise clearly.
INFO.check.movie.nr_imgs    = 1000;         % The maximum number of images to be read-in at once by bch_check_movie. For a very high number, you run the risk of overloading your memory.
INFO.check.movie.save_temp  = 1;            % Set to "1" if you want to save the movie during it's creation ("0" for not). This will get rid of possible memory problems, but slows down the calculations (especially if nr_imgs is low).
INFO.check.movie.fps        = 6;            % Frames per second.

contrast = INFO.check.movie.contrast/100;
bright = INFO.check.movie.bright/100;
if contrast > 1; contrast = 1; end
if contrast <= -1; contrast = -1+10^-9; end
if bright > 1; bright = 1; end
if bright < -1; bright = -1; end

cfg.which       = INFO.check.movie.which;
cfg.contrast    = INFO.check.movie.contrast;
cfg.max_imgs    = INFO.check.movie.nr_imgs;
cfg.save_temp   = INFO.check.movie.save_temp;
cfg.fps         = INFO.check.movie.fps;

if length(output_dirs) == 1 && length(sessions) > 1
    output_dirs = repmat(output_dirs, size(sessions));
end

for sess = 1: nosessions
    output_dir = output_dirs{sess};
    files = sessions{sess};
    out.sess{sess} = files;
    files = find_other_echoes(files, multiecho);
        
    nechoes = length(files); 
    for echo = 1: nechoes
        imgs = files{echo};

        mov_default_name = fullfile(output_dir,  'default', '_', [subject, '_'  num2str(sess)], '_', [num2str(echo)]);
        mov_contrast_name = fullfile(output_dir,  'contrast', '_', [subject, '_'  num2str(sess)], '_', [num2str(echo)]);

        n = length(imgs);
        m = INFO.check.movie.nr_imgs;
        i_on = 1;
        i_off = n;
        if n>m
            i_off = [];
            c = ceil(n/m);
            for d = 1:c-1
                i_on = [i_on floor(d*n/c)+1];
                i_off = [i_off floor(d*n/c)];
            end
            i_off = [i_off n];
        end

        for j = 1:length(i_on)

            fprintf('\n\tLoading images (part %i/%i)...',j,length(i_on));
            vols = spm_vol(imgs(i_on(j):i_off(j)));
            if ~isstruct(vols(1))
                for i = 1:length(vols)
                    tvols(i) = vols{i};
                end
                vols = tvols;
            end
            data = spm_read_vols_1by1(vols);
            fprintf('\tdone');

            clear vols;
            clear tvols;

            [dimx,dimy,nrslice,nrvols] = size(data);

            mosaic_format   = ceil(sqrt(nrslice)); % nr of slices in each direction
            mosaic_x        = mosaic_format * dimx;
            mosaic_y        = mosaic_format * dimy; % size in pixels
            mosaic          = zeros(mosaic_x, mosaic_y, nrvols);

            text_x          = round(mosaic_x - dimx/4);
            text_y          = round(mosaic_y - dimy/2);

            flip = spm_flip_analyze_images; % defaults.analyze.flip doesn't exist anymore!;
            ori = 'hor';

            for vol = 1:nrvols
                for slice = 1:nrslice

                    xmin = mod(slice - 1, mosaic_format) * dimx + 1;
                    xmax = xmin + dimx - 1;
                    ymin = (ceil(slice/mosaic_format)-1) * dimy + 1;
                    ymax = ymin + dimy - 1;

                    slice_data = reshape(data(:,:,slice,vol), dimx, dimy);
                    slice_data = rot90(slice_data);

                    if strcmp(ori, 'vert')
                        if flip, mosaic(xmin:xmax, ymax:-1:ymin, vol) = slice_data;
                        else     mosaic(xmin:xmax, ymin:ymax, vol)    = slice_data;
                        end
                    elseif strcmp(ori, 'hor')
                        if flip, mosaic(ymin:ymax, xmax:-1:xmin, vol) = slice_data;
                        else     mosaic(ymin:ymax, xmin:xmax, vol)    = slice_data;
                        end
                    end
                end
            end
            clear data;
            
            h = figure('NumberTitle','off');
            imagesc(mosaic(:,:,1));
            colormap(gray);
            axis tight
            set(gca,'nextplot','replacechildren');
            
            do_default = 0; do_contrast = 0;
            if strcmpi(cfg.which,'both') || strcmpi(cfg.which,'default')
                mov_default_name = fullfile(output_dir, sprintf('CheckMosaicMovie_%s%s%s_default.avi',[subject, '_', num2str(sess)], '_', [num2str(echo)]));
                do_default = 1;
            end
            if strcmpi(cfg.which,'both') || strcmpi(cfg.which,'contrast') && ...
                    cfg.contrast ~= 0 && cfg.bright ~= 0
                mov_contrast_name = fullfile(output_dir, sprintf('CheckMosaicMovie_%s%s%s_contrast.avi',[subject, '_', num2str(sess)], '_', [num2str(echo)]));
                do_contrast = 1;
            end
            
            if cfg.save_temp
                temp_default_file = fullfile(output_dir, sprintf('TempCheckMosaicMovie_%s%s%s_default.mat',[subject, '_', num2str(sess)], '_', [num2str(echo)]));
                temp_contrast_file = fullfile(output_dir, sprintf('TempCheckMosaicMovie_%s%s%s_contrast.mat',[subject, '_', num2str(sess)], '_', [num2str(echo)]));
            end

            if do_default
                % Add the frames to the movie - default
                fprintf('\n\t\tCreating default...');
                if cfg.save_temp && j>1; load(temp_default_file); end;
                for i = 1:size(mosaic,3)
                    idx = i_on(j)+i-1;
                    imagesc(mosaic(:,:,i));
                    hold on;
                    if mosaic(text_x,text_y,i) < mean(mean(mosaic(:,:,i)))
                        text(text_x,text_y,num2str(idx),'Color','w','FontSize',24,'HorizontalAlignment','right');
                    else
                        text(text_x,text_y,num2str(idx),'Color','k','FontSize',24,'HorizontalAlignment','right');
                    end
                    hold off;
                    mov_default(idx) = getframe;
                end
                if cfg.save_temp; save(temp_default_file,'mov_default'); clear mov_default; end;
                fprintf('\tdone');
            end

            if do_contrast
                % Add the frames to the movie - contrast
                fprintf('\n\t\tCreating contrast...');
                if cfg.save_temp && j>1; load(temp_contrast_file); end;
                for i = 1:size(mosaic,3)
                    img = mosaic(:,:,i)-min(min(mosaic(:, :, i)));
                    img = ((img./max(img(:))).*100);
                    cmin = min(min(img));
                    cmax = max(max(img));
                    cmean = mean([cmin cmax]);

                    if contrast >= 0
                        win = (1-contrast)*(cmax - cmean);
                    else
                        win = (cmax - cmean)/(1+contrast);
                    end
                    lev = cmean + -bright*(cmax+win-cmean);
                    clims = [lev-win lev+win];

                    idx = i_on(j)+i-1;
                    imagesc(img,clims);
                    hold on;
                    if mosaic(text_x,text_y,i) < lev
                        text(text_x,text_y,num2str(idx),'Color','w','FontSize',24,'HorizontalAlignment','right');
                    else
                        text(text_x,text_y,num2str(idx),'Color','k','FontSize',24,'HorizontalAlignment','right');
                    end
                    hold off;
                    mov_contrast(idx) = getframe;
                end
                if cfg.save_temp; save(temp_contrast_file,'mov_contrast'); clear mov_contrast; end;
                fprintf('\tdone');
            end

            clear mosaic;

        end

        if do_default
            fprintf('\n\tSaving movie - default...');
            if cfg.save_temp; load(temp_default_file); end;
            %movie(mov_default,1,fps)  % Play the default movie one time
            movie2avi(mov_default,mov_default_name,'fps',INFO.check.movie.fps);
            if cfg.save_temp; delete(temp_default_file); end;
            clear mov_default;
            fprintf('\tdone');
        end

        if do_contrast
            fprintf('\n\tSaving movie - contrast...');
            if cfg.save_temp; load(temp_contrast_file); end;
            %movie(mov_contrast,1,fps)  % Play the contrast movie one time
            movie2avi(mov_contrast,mov_contrast_name,'fps',INFO.check.movie.fps);
            if cfg.save_temp; delete(temp_contrast_file); end;
            clear mov_contrast;
            fprintf('\tdone');
        end
        close gcf;
    end
end

%% Combine sessions again
[out.data no_sessions] = dmb_run_combine_sessions_inline(job.data);

%% Check whether splitting and combing went alright
assert(no_sessions == expected_n_sessions);
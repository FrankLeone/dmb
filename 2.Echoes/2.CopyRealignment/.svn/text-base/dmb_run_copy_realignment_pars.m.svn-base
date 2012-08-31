function out = dmb_run_copy_realignment_pars (job)

sessions      = job.files;
multiecho     = true;

if ~iscell(sessions)
    sessions = {sessions};
end

nosessions = length(sessions);

q = 1;
for sess = 1: nosessions
    orig_files = sessions{sess};
    
    % Only include selected echo in the output
%     out(sess).files = orig_files;
    
    % Retrieve the movement parameters
    if iscell(orig_files)
        max_length = max(cellfun(@length, orig_files));
        imgs = cell2mat(cellfun(@(x, max_length)[x repmat(' ', 1, max_length - length(x))], orig_files, repmat({max_length}, size(orig_files)), 'UniformOutput', false));
    end
    orig_V = spm_vol(orig_files);
    
    % Get the other echoes
    files = find_other_echoes(orig_files, multiecho);       
    
    nechoes = length(files); 
    
%     out(sess).files = [];
    all_imgs_one_session = [];
    for echo = 1: nechoes
        imgs = files{echo};
%         assert (length(imgs) == length(orig_files));
        if (length(imgs) ~= length(orig_files))
            '?';
        end
        
        for nr_V = 1: length(imgs)
            spm_get_space(imgs{nr_V}, spm_get_space(orig_files{nr_V}));
        end       
        nr = (sess-1) * nechoes + 1;
        out(q).files = imgs;
        all_imgs_one_session = [all_imgs_one_session; imgs];
        q = q + 1;
    end
    out(q).files = all_imgs_one_session;
    q = q + 1;
end

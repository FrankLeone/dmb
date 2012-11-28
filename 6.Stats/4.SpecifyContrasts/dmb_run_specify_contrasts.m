function out = dmb_run_specify_contrasts(job)

SPM_dirs = job.SPMs;
out(1).SPMs  = SPM_dirs;
contrasts_file = job.contrasts_file;

fid = fopen(contrasts_file{1});

headers = textscan(fid, repmat('%s ', 1, 75+54), 1, 'delimiter', ','); %% 39 %% 57 %% 75
data = textscan(fid,['%s %s %s ' repmat('%f ', 1, 72+54)],'delimiter', ','); %% 36 %% 54

contrasts   = [data{4:length(data)}];
headers     = [headers{4:length(headers)}];
names       = data{1};
types       = data{2};
stats       = data{3};

nr_of_contrasts = size(contrasts, 1);
   
for nr_SPM = 1: length(SPM_dirs)
    SPM_dir         = SPM_dirs{nr_SPM}; %fullfile(INFO.dir.root, subject_name,INFO.dir.sessions{1}, INFO.dir.SPM, analysis);

    load (fullfile(SPM_dir)); 
    if isfield (SPM, 'xCon')
        SPM = rmfield(SPM, 'xCon');
    end
    
    order = SPM.xBF.order;
    
    nr_of_actual_columns    = size(SPM.xX.X, 2);
    actual_contrasts = zeros(nr_of_contrasts * order, nr_of_actual_columns);
    %% For each regressor in the csv file
    for nr_head = 1: length(headers)
        if ~isempty(headers{nr_head})
            for nr_order = 1: order
                % Find the regressors corresponding to the headers
                result = strfind(SPM.xX.name, [headers{nr_head} '*bf']);
                nrs = [];

                % Check the non-empty ones and add them to list of active ones
                for nr_result = 1: length(result)
                    if ~isempty(result{nr_result}) && ~isempty(strfind(SPM.xX.name{nr_result}, ['bf(' num2str(nr_order) ')']))
                        nrs = [nrs nr_result];                     
                    end
                end
                % Add to each contrast for this regressors the corresponding value
                for nr_contrast = 1: nr_of_contrasts
                    actual_contrasts(nr_contrast + (nr_order-1) * nr_of_contrasts, nrs) = contrasts(nr_contrast, nr_head);
                    actual_names{nr_contrast + (nr_order-1) * nr_of_contrasts} = [names{nr_contrast} '_' num2str(nr_order)];
                    actual_types{nr_contrast + (nr_order-1) * nr_of_contrasts} = types{nr_contrast};
                    actual_stats{nr_contrast + (nr_order-1) * nr_of_contrasts} = stats{nr_contrast};
                end
            end
        end
    end
    
    nr_of_contrasts = size(actual_contrasts, 1);
    names = actual_names;
    stats = actual_stats;
    types = actual_types;
    all_regr                = 1: nr_of_actual_columns;

    if ~isfield(SPM.xX, 'xKXs')
        load (fullfile(SPM_dir, 'SPM.mat')); 
        if isfield (SPM, 'xCon')
            SPM = rmfield(SPM, 'xCon');
        end
    end
    actual_nr = 1;    
    xKXs = SPM.xX.xKXs;
    
    for nr_contrast = 1: nr_of_contrasts
        contrast = actual_contrasts(nr_contrast, :);
        if any(contrast) % Check whether there are actually any non-zero values
            if strcmp(types{nr_contrast}, 'iX') || strcmp(types{nr_contrast}, 'iX0')
%                 SPM.xCon(actual_nr) = spm_FcUtil('Set',names{nr_contrast},stats{nr_contrast}, types{nr_contrast},setdiff(all_regr, find(contrast)),SPM.xX.xKXs);
                SPM.xCon(actual_nr) = spm_FcUtil('Set',names{nr_contrast},stats{nr_contrast}, types{nr_contrast},setdiff(all_regr, find(contrast)),xKXs);
            else
%                 SPM.xCon(actual_nr) = spm_FcUtil('Set',names{nr_contrast},stats{nr_contrast}, types{nr_contrast}, contrast',SPM.xX.xKXs);
                SPM.xCon(actual_nr) = spm_FcUtil('Set',names{nr_contrast},stats{nr_contrast}, types{nr_contrast}, contrast', xKXs);
            end
            actual_nr = actual_nr+1;
        end
    end

%     load (fullfile(SPM_dir)); 
    save (SPM_dir, 'SPM', '-v7.3'); 
%     clear SPM;
end
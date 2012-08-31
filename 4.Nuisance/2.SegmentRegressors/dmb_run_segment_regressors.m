function out = dmb_run_segment_regressors (job)

segment_files           = job.segment;
all_data                = job.files;
out_paths               = job.directory;

%% Used to split up set to make sure no memory problems occur
noSets                  = 10;

for nr_segment = 1: length(segment_files)
    dir{nr_segment} = segment_files{nr_segment}{1}(1:max(find(segment_files{nr_segment}{1} == filesep)));
    file_prefix{nr_segment} = segment_files{nr_segment}{1}(max(find(segment_files{nr_segment}{1} == filesep)) + 1 : max(find(segment_files{nr_segment}{1} == filesep)) + 2);
    segment4D = spm_read_vols(spm_vol(segment_files{nr_segment}{1}));
    size_segment = size(segment4D);
    
    segments(nr_segment, :, :, :) = segment4D; %reshape (segment4D, prod(size_segment(1:3)), 1);
end
clear segment4D;

segments = segments > 0.95;
concat_segments = reshape(segments, [size(segments) 1]);

%% Check whether enough output directories have been selected
if numel(out_paths) == 1 && numel(all_data) > 1
    out_paths = repmat(out_paths, size(all_data));
elseif numel(out_paths) ~= numel(all_data) 
    error('Number of output directories not 1 and not equal to number of sessions');
end

for nr_data = 1: length(all_data)
    out_path = out_paths{nr_data}{1};
    if ~exist(out_path, 'dir')
       mkdir(out_path);
    end
    
    noScans = length(all_data{nr_data});
    average = zeros(noScans, size(concat_segments, 1));
    
    %% Divide in multiple sets to make sure no memory problems occur
    
    setSize = round(noScans/noSets);
    setMinMax = 1:setSize:(noScans+1);
    setMinMax(end) = noScans+1;
    for nrSet = 1: length(setMinMax)-1
        set = setMinMax(nrSet): setMinMax(nrSet+1)-1;
        
        vols = spm_vol(all_data{nr_data}(set));
        data = spm_read_vols([vols{:}]);
        clear vols;    
        
        for nr_segment = 1: size(concat_segments, 1)
            assert(any(concat_segments(nr_segment, :))); %% Check that there is a voxel active in the mask.
            average(set, nr_segment) = sum(sum(sum(squeeze(concat_segments(nr_segment, :, :, :, ones(size(data, 4), 1))) .* data, 1), 2), 3);
        end
    end
    
    for nr_segment = 1: size(concat_segments, 1)
        average(:, nr_segment) = average(:, nr_segment)/sum(average(:, nr_segment));
    end

    corrMatrix = corr(average);
    
    R = average;
    filename = fullfile(out_path, ['average_comp_intensity_' [file_prefix{:}] '_' num2str(nr_data) '.mat']);
    
    save(filename, 'R');
    out(nr_data).average_intensity = {filename};
    
    concatSegments = permute(concat_segments, [2 3 4 1]);
    filename = fullfile(out_path, ['segments_' num2str(nr_data) '.mat']);
    save(filename, 'concatSegments', 'corrMatrix', 'average')

    clear data;
end
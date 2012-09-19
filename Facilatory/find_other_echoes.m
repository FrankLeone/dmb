function all_files = find_other_echoes (files, multiecho)

if nargin < 2
    multiecho = true;
end

first_file = files{1};
file_names = cellfun(@(x, nr)x(nr:(end-2)), files, repmat({max(regexp(first_file, '/'))+1}, size(files)), 'UniformOutput', false);
first_filename = file_names{1};
prefix      = first_filename(1, 1:(min(find(first_filename == '_'))));
file_names = cell2mat(file_names);
nrs_ref = unique(file_names(:, max(regexp(file_names(1, :), '_'))+1 : max(regexp(file_names(1, :), '\.'))-1), 'rows');

echo_dir = first_file(1:(max(regexp(first_file, '/'))-1));
if echo_dir(end) == filesep
    echo_dir(end) = [];
end
echo_dir_name = echo_dir(max(regexp(echo_dir, '/'))+1:end);
echo_dir_prefix = echo_dir_name(isletter(echo_dir_name));

base_dir = echo_dir(1:(max(regexp(echo_dir, '/'))-1));
[tmp_files dirs] = spm_select('List', base_dir, '.*');   
dirs = dirs(strmatch(echo_dir_prefix, dirs), :);
all_files = cell(size(dirs, 1), 1);

if multiecho
    for nr_dir = 1: size(dirs, 1)
        echo_file_names = spm_select('List', fullfile(base_dir,dirs(nr_dir, dirs(nr_dir, :) ~= ' ')), ['^' prefix '.*.nii']);
        nrs_tar = unique(echo_file_names(:, max(regexp(echo_file_names(1, :), '_'))+1 : max(regexp(echo_file_names(1, :), '\.'))-1), 'rows');
        [nrs ia ib] = intersect(str2num(nrs_tar), str2num(nrs_ref));
        echo_file_names = mat2cell(echo_file_names(ia, :), ones(length(ia), 1), size(echo_file_names, 2));
%         assert(length(echo_file_names) == length(file_names));
        all_files{nr_dir} = strcat(repmat({base_dir}, size(echo_file_names)), repmat({filesep}, size(echo_file_names)), repmat(dirs(nr_dir, dirs(nr_dir, :) ~= ' '), size(echo_file_names)), repmat({filesep}, size(echo_file_names)), echo_file_names);
    end        
else
    if (length(dirs) ~= 1)
        warning('DONDERS:ignoringEchoes', ['There appear to be multiple (' num2str(length(dirs)) ' to be exact) echoes, though only using one!']);
    end
      
    all_files = {files};
end

sizes = unique(cellfun(@length, all_files));
if numel(sizes) > 1
    for nr_dir = 1: length(all_files)
        all_files{nr_dir} = all_files{nr_dir}(1:min(sizes));
    end
end



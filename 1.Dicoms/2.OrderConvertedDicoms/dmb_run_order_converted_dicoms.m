function out = dmb_run_order_converted_dicoms (job)

ICED_filenames = false;
%% Check inputs

% Copy rename_table
rename_table = job.rename_table;
dir = fileparts(job.files{1});

% If it is only a string, it is probably a filename
if ischar(rename_table)
    if exist(rename_table, 'file')
        fid         = fopen(rename_table);
        tmpTable    = textscan(fid, '%s %s', 'delimiter', ' ');
        clear rename_table;
        rename_table(:, 1) = tmpTable{1};
        rename_table(:, 2) = tmpTable{2};
    end
end

%% Define variables
% Settings for ICED tag filenames
if ICED_filenames
    range_echo_nr       = [1 2]; % meaning: echo nr is located between 1st and 2nd '_' in filename
    range_scan_nr       = [4 5]; % meaning: scan nr is located between 4th and 5th '_' in filename
    range_type          = 1;
    range_session_nr    = [12 13]; % meaning: session nr is located between 12th and 13th '_' in filename
    curr_func_prefix    = 'f';
    curr_struc_prefix   = 's';
else
    % Settings for normal filenames
    range_echo_nr       = [4 5]; % meaning: echo nr is located between 4rd and 5th '-' in filename
    range_scan_nr       = [2 3]; % meaning: scan nr is located between 2rd and 5th '-' in filename
    range_type          = 1;
    range_scanday       = [0 1];
    range_session_nr    = [1 2]; % meaning: session nr is located between 1st and 2nd '_' in filename
    curr_func_prefix    = 'f';
    curr_struc_prefix   = 's';
end
%% Read in inputs
if (strcmp(job.files{1}([end-1 end]), ',1'))
    files_cell      = cellfun(@(x)x(1:(end-2)), job.files, 'UniformOutput', false);
else
    files_cell      = job.files;
end
if (size(files_cell, 2) > size(files_cell, 1))
    files_cell = files_cell';
end

base_filename   = job.subject;
func_dir        = job.dir_branch.func_dir;
struc_dir       = job.dir_branch.struc_dir;
echo_dir        = job.dir_branch.echo_dir;
sess_dir        = job.dir_branch.sess_dir;
type_dir        = job.dir_branch.type_dir;
move            = job.move;
expected_n_sessions = job.expected_n_sessions;

%% Locs file separator
locs_file_separators = cellfun(@regexp, files_cell, repmat({filesep}, size(files_cell)), 'UniformOutput', false);
last_separator       = cellfun(@max, locs_file_separators);
filenames            = cellfun(@(x)x((last_separator+1):end), files_cell, 'UniformOutput', false);
filenames            = cellfun(@(x)x(x ~= ' '), filenames, 'UniformOutput', false);
dirs                 = cellfun(@(x)x(1:(last_separator-1)), files_cell, 'UniformOutput', false);

%% Extract relevant parts of filenames
locs_underscores_minuses    = cellfun(@regexp, filenames, repmat({'_|-|\.'}, size(filenames)), 'UniformOutput', false);
lengths                     = cellfun(@length, locs_underscores_minuses);

% Make sure filename structure is the same for each file!
assert (length(unique(lengths)) == 1);

% Then convert it to a matrix
locs_underscores_minuses    = cell2mat (locs_underscores_minuses);

%% Determine the properties of the files
types                       = cellfun(@(x)x(:, range_type), filenames);
if size(locs_underscores_minuses, 1) ~= size(filenames, 1) || size(filenames, 1) == 1
    '!!';
end
echo_nrs                    = cellfun(@(x, a, b)x(a:b), filenames, num2cell(locs_underscores_minuses(:, range_echo_nr(1))+1), num2cell(locs_underscores_minuses(:, range_echo_nr(2))-1), 'UniformOutput', false);
session_nrs                 = cellfun(@(x, a, b)x(a:b), filenames, num2cell(locs_underscores_minuses(:, range_session_nr(1))+1), num2cell(locs_underscores_minuses(:, range_session_nr(2))-1), 'UniformOutput', false);
scan_nrs                    = cellfun(@(x, a, b)x(a:b), filenames, num2cell(locs_underscores_minuses(:, range_scan_nr(1))+1), num2cell(locs_underscores_minuses(:, range_scan_nr(2))-1), 'UniformOutput', false);
day_nrs                     = cellfun(@(x, a, b)x(2:b), filenames, repmat({2}, size(filenames, 1), 1), num2cell(locs_underscores_minuses(:, range_scanday(2))-1), 'UniformOutput', false);
u                           = repmat({'_'}, size(scan_nrs));
b                           = repmat({base_filename}, size(scan_nrs));

% Interpret echo_nrs
[uniq_vals a echo_nrs_int]  = unique(echo_nrs);
% assert(all(diff(echo_nrs_int(types == 'f')) >=0));

% Interpret session_nrs
session_nrs                 = cellfun(@(x) sscanf(char(x),['%f' 'DST' '%f']),session_nrs, 'UniformOutput', false); % splits session ID into 2 numbers (before and after 'DST') 
session_nrs                 = horzcat(session_nrs{:})'; % transformation into 2-column matrix
% If not ICED filenames, correct session nr
if ~ICED_filenames
    session_nrs                 = session_nrs - echo_nrs_int;
end

[uniqNrs tmp c] = unique(day_nrs);
if length(uniqNrs) ~= 1    
    assert(all(diff(c(types == 'f')) >=0));
    lastPreviousDay = 0;
    for nrDay = 1: length(uniqNrs)
        session_nrs(c == nrDay) = session_nrs(c == nrDay) + lastPreviousDay;
        lastPreviousDay = max(session_nrs(c==nrDay))+1;
    end
end

% [uniq_vals a sess_nrs]      = unique(session_nrs);
[uniq_vals a sess_nrs]      = unique(num2str(session_nrs), 'rows'); % searches unique values within 1st column (i.e. 1st number) => SESSIONS ARE ORDERED CORRECTLY!!
% Check whether we aren't switching sessions.
assert(all(diff(sess_nrs(types == 'f'))>=0))

% Convert to strings
session_nrs                 = num2cell(sess_nrs);
session_nrs                 = cellfun(@num2str, session_nrs, 'UniformOutput', false);

% Interpret scan_nrs
max_length = max(cellfun(@length, scan_nrs));
scan_nrs = cellfun(@(x, max_length) [repmat('0', 1, max_length-length(x)), x], scan_nrs, repmat({max_length}, length(scan_nrs), 1), 'UniformOutput', false);

%% Also determine the target directories
seps                        = repmat({filesep}, size(scan_nrs));

base_dir(types == curr_func_prefix, 1) = repmat({func_dir}, sum(types == curr_func_prefix), 1);
base_dir(types == curr_struc_prefix, 1) = repmat({struc_dir}, sum(types == curr_struc_prefix), 1);

func_sess_bools = types == curr_func_prefix;
struc_sess_bools = types == curr_struc_prefix;

func_sess_nrs = session_nrs(func_sess_bools);
struc_type_nrs = session_nrs(struc_sess_bools);

session_nrs_int = sess_nrs;
if ~isempty(func_sess_nrs)
    [func_vals a sess_nrs] = unique(num2str(session_nrs_int(func_sess_bools)), 'rows'); % instead of 'unique(func_sess_nrs);' => SESSIONS ARE ORDERED CORRECTLY!!
    assert(all(diff(sess_nrs)>=0));
    sess_dirs(func_sess_bools, 1) = strcat(repmat({sess_dir}, sum(func_sess_bools), 1), mat2cell(num2str(sess_nrs), ones(length(sess_nrs), 1), size(num2str(sess_nrs), 2)));
else
    disp('No functional scans included');
end

if ~isempty(struc_type_nrs)
    [struc_vals a type_nrs] = unique(num2str(session_nrs_int(struc_sess_bools)), 'rows');
    assert(all(diff(type_nrs)>=0));
    sess_dirs(struc_sess_bools, 1) = strcat(repmat({type_dir}, sum(struc_sess_bools), 1), mat2cell(num2str(type_nrs), ones(length(type_nrs), 1), size(num2str(type_nrs), 2)));
end

sess_dirs = strrep(sess_dirs, ' ', '0');

echo_dirs = strcat(repmat({echo_dir}, size(scan_nrs)), echo_nrs);
to_be_removed_nrs = [];
for nr = 1:size(rename_table, 1)
    if (~isempty(rename_table(nr, 2)))
        nrs = strcmp(sess_dirs, rename_table{nr, 1});
        sess_dirs(nrs) = repmat(rename_table(nr, 2), size(sess_dirs(nrs)));
    else
        to_be_removed_nrs = [to_be_removed_nrs; strcmp(sess_dirs, rename_table{nr, 1})];
    end
end

if numel(unique(echo_dirs(func_sess_bools, 1))) > 1
    directories(func_sess_bools, 1) = strcat(dirs(func_sess_bools, 1), seps(func_sess_bools, 1), base_dir(func_sess_bools, 1), seps(func_sess_bools, 1), sess_dirs(func_sess_bools, 1), seps(func_sess_bools, 1), echo_dirs(func_sess_bools, 1));
else
    directories(func_sess_bools, 1) = strcat(dirs(func_sess_bools, 1), seps(func_sess_bools, 1), base_dir(func_sess_bools, 1), seps(func_sess_bools, 1), sess_dirs(func_sess_bools, 1));
end
directories(struc_sess_bools, 1) = strcat(dirs(struc_sess_bools, 1), seps(struc_sess_bools, 1), base_dir(struc_sess_bools, 1), seps(struc_sess_bools, 1), sess_dirs(struc_sess_bools, 1));

%% And convert it to filenames
if numel(unique(echo_dirs(func_sess_bools, 1))) > 1
    new_filenames(func_sess_bools, 1)               = strcat(types(func_sess_bools, 1), u(func_sess_bools, 1), b(func_sess_bools, 1), u(func_sess_bools, 1), sess_dirs(func_sess_bools, 1), u(func_sess_bools, 1), echo_dirs(func_sess_bools, 1), u(func_sess_bools, 1), scan_nrs(func_sess_bools, 1));
else
    new_filenames(func_sess_bools, 1)               = strcat(types(func_sess_bools, 1), u(func_sess_bools, 1), b(func_sess_bools, 1), u(func_sess_bools, 1), sess_dirs(func_sess_bools, 1), u(func_sess_bools, 1), scan_nrs(func_sess_bools, 1));
end
new_filenames(struc_sess_bools, 1)               = strcat(types(struc_sess_bools, 1), u(struc_sess_bools, 1), b(struc_sess_bools, 1), u(struc_sess_bools, 1), sess_dirs(struc_sess_bools, 1), u(struc_sess_bools, 1), scan_nrs(struc_sess_bools, 1));

old_filenames = strcat(dirs, seps, filenames);
new_filenames = strcat(directories, seps, new_filenames, '.nii');

%% Check whether sessions should NOT be included
if ~isempty(to_be_removed_nrs)
    old_filenames(to_be_removed_nrs) = [];
    new_filenames(to_be_removed_nrs) = [];
end

%% Create dirs
unique_dirs = unique(directories);
warning off;
cellfun(@mkdir, unique_dirs);
warning on;

%% Copy actual files
if move
    fprintf('Started to MOVE files ...');
else
    fprintf('Started to copy files ...');
end

tic
if move
    for nr_file = 1: length(old_filenames)
        eval(['!mv ' old_filenames{nr_file} ' ' new_filenames{nr_file}]);
%           movefile(old_filenames{nr_file}, new_filenames{nr_file});
    end
else
%     for nr_file = 1: length(old_filenames)
%         eval(['!cp ' old_filenames{nr_file} ' ' new_filenames{nr_file}]);
% %           copyfile(old_filenames{nr_file}, new_filenames{nr_file});
%     end
    noPerSubStack = 1000;           
    addNumber = noPerSubStack - 1;
    nrStack = 1;
    filenameStack = cell(ceil(length(old_filenames)/noPerSubStack), 1);
    for nrFile = 1:noPerSubStack:length(old_filenames)
        if nrFile + addNumber < length(old_filenames)
            fromStack = old_filenames(nrFile:(nrFile + addNumber));
            toStack = new_filenames(nrFile:(nrFile + addNumber));
        else
            fromStack = old_filenames(nrFile:end);
            toStack = new_filenames(nrFile:end);
        end
        filenameStack{nrStack}.from = fromStack;
        filenameStack{nrStack}.to = toStack;
        nrStack = nrStack + 1;
    end

    result = qsubcellfun(@copy_many_files_distributedly, filenameStack, 'memreq', 1* 1024, 'timreq', 2 * 60, 'compile', 'yes');

end    
fprintf('... Ready\n\n');
toc

out = {};
if ~isempty(func_sess_nrs)
    tmp_new_filenames = new_filenames(func_sess_bools);
    echo_nrs_int = echo_nrs_int(func_sess_bools);
    nechoes = length(unique(echo_nrs));
    for nr_sess = 1: length(func_vals)
        for nr_echo = 1: nechoes
            nr = (nr_sess - 1) * nechoes + nr_echo;
            out(nr).files = sort(tmp_new_filenames(sess_nrs == nr_sess & echo_nrs_int == nr_echo));
            out(nr).subject = job.subject;
%             out(nr).name    = ['Func sess ' num2str(nr_sess) ' echo ' num2str(nr_echo)];
        end
    end
end

% if ~isempty(struc_type_nrs)
%     tmp_new_filenames = new_filenames(struc_sess_bools);
%     base_nr_sess = length(out);
%     for nr_sess = 1: length(struc_vals)
%         for nr_echo = 1: length(unique(echo_nrs))
%             nr = base_nr_sess + (nr_sess - 1) * nechoes + nr_echo;
%             out(nr).files = sort(tmp_new_filenames(type_nrs == nr_sess));
%             out(base_nr_sess+1).subject = {job.subject};
% %             out(nr).name    = ['Struc sess ' num2str(nr_sess) ' echo ' num2str(nr_echo)];
%         end
%     end
% end
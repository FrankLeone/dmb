function out = cfg_donders_run_split_sessions(job)

total_data = job.files;
no_sessions = job.expected_n_sessions;

filenames = fileCells2Mat(total_data);

separators = sum(filenames == filesep, 1);
separators = find(separators);
if max(separators) ~= size(filenames, 2)
    separators(end+1) = size(filenames, 2);
end
for nr_sep = 1: length(separators)
    [sess_nrs tmp sessions] = unique(filenames(:, 1:(separators(nr_sep))), 'rows');
    if size(sess_nrs, 1) == no_sessions
        break;
    end
end

sessions = sort(sessions);
warning('I made it order the session numbers, might influence other scripts!');
for nr_sess = 1: size(sess_nrs, 1)
    out(nr_sess).files = total_data(sessions == nr_sess);
end
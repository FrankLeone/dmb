function out = dmb_run_split_sessions_inline(total_data, no_sessions)

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

if size(sess_nrs, 1) == numel(sessions)
    sess_nrs = sess_nrs(sessions, :);
    sessions = 1: numel(sessions);    
end

assert(all(diff(sessions)>=0));

for nr_sess = 1: size(sess_nrs, 1)
    out{nr_sess} = total_data(sessions == nr_sess);
end
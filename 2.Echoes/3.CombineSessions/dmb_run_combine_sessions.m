function out = dmb_run_combine_sessions(job)

sessions = job.files;
no_sessions = length(sessions);

total_data = [];
for nr_sess = 1: no_sessions
	total_data = [total_data(:); sessions{nr_sess}];
end

out(1).total_data = total_data;
out(2).no_sessions = no_sessions;
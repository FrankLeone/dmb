function [total_data no_sessions] = dmb_run_combine_sessions_inline(job)

sessions = job.sess;
no_sessions = length(sessions);

total_data = [];
if ~isstruct(sessions)
    for nr_sess = 1: no_sessions    
        total_data = [total_data(:); sessions{nr_sess}(:)];
    end
else
    fieldNames = fieldnames(sessions(1));
    for nrField = 1: size(fieldNames, 1)
        total_data.(fieldNames{nrField}) = [];
    end
    for nr_sess = 1: no_sessions    
        for nrField = 1: size(fieldNames, 1)
            total_data.(fieldNames{nrField}) = [total_data.(fieldNames{nrField}); sessions(nr_sess).(fieldNames{nrField})];
        end
    end 
end 
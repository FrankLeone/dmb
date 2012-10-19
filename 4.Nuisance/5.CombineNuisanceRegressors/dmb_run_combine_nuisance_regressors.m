function out = dmb_run_combine_nuisance_regressors (job)

%% Split sessions
expected_n_sessions = job.expected_n_sessions;
for nrRegressor = 1: length(job.regressor)
    regressors{nrRegressor} = dmb_run_split_sessions_inline(job.regressor{nrRegressor}, expected_n_sessions);    
end
for nrRegr = 1: size(regressors, 2)
    for nrVal = 1: length(regressors{nrRegr})
        regressorMat{nrVal}{nrRegr} = regressors{nrRegr}{nrVal};
    end
end

%% Run actual script
for nrRegressorsSet = 1: length(regressorMat)

    regressors  = regressorMat{nrRegressorsSet};
    regr_path   = job.target_dir;%determine_path(regressors{1});
    origFilename    = fullfile(regr_path{1}, job.filename);

    if ~exist(regr_path{1}, 'dir')
        mkdir(regr_path{1});
    end

    total_R     = [];
    for nr_regr = 1: length(regressors)
        extra_R{nr_regr} = load(regressors{nr_regr}{1});
        if isstruct(extra_R{nr_regr})
            fieldname = fieldnames(extra_R{nr_regr});
            assert(numel(fieldname) == 1);
            extra_R{nr_regr} = extra_R{nr_regr}.(fieldname{1});
        end
        n_elements(nr_regr) = size(extra_R{nr_regr}, 1);  
    end

    to_be_included_elements = 1:min(n_elements);

    for nr_regr = 1: length(regressors)
        total_R = [total_R extra_R{nr_regr}(to_be_included_elements, :)];
    end

    R = total_R;
    if (nrRegressorsSet < 10)
        filename = [origFilename '0' num2str(nrRegressorsSet) '.mat'];
    else
        filename = [origFilename num2str(nrRegressorsSet) '.mat'];
    end
    
    save(filename, 'R');

    outSplit(nrRegressorsSet).R = {filename};
end
    
%% Combine sessions again
[out.R no_sessions] = dmb_run_combine_sessions_inline([outSplit.R]);

%% Check whether splitting and combing went alright
assert(no_sessions == expected_n_sessions);
function out = dmb_run_combine_nuisance_regressors (job)

regressors  = job.regressor;
regr_path   = job.target_dir;%determine_path(regressors{1});
filename    = fullfile(regr_path{1}, job.filename);

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

save(filename, 'R');

out(1).R = {filename};
    
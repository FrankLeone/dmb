function out = dmb_run_transform_movement_regressors(job)

regressors      = job.regressor;
order           = job.order;
nechoes         = 1;

for nr_sess = 1: length(regressors)
    R = load(regressors{nr_sess}{1});
    if isstruct(R)
        fieldname = fieldnames(R);
        assert(length(fieldname) == 1);
        R = R.(fieldname{1});
    end
    R = R(1:(end/nechoes), :);

    extra_pars  = [];
    for nr_order = 1: order
        extra_pars = [extra_pars [zeros(nr_order, size(R, 2)); diff(R, nr_order, 1)]];
    end

    R = [extra_pars];

    nr = strfind(regressors{nr_sess}{1}, '.txt');
    filename = [regressors{nr_sess}{1}(1:(nr-1)) '_deriv' num2str(order) '.mat'];
    save(filename, 'R');

    out(nr_sess).R = {filename};
    out(nr_sess).orig = {regressors{nr_sess}{1}};
end




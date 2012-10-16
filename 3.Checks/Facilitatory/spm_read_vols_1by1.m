function data = spm_read_vols_1by1(vols)
%% Read data from volumes (loaded with spm_vol) one by one, instead of all together. The function does check for the same dimensions, not the same orientation, meaning you can also load non-resliced data.

%% Check whether the dimensions are equal
spm_check_dimensions(vols);

%% Make initial 4D matrix
noVols = length(vols);
dims = vols(1).dim;
data = zeros([dims noVols]);

%% Load data sequentially
for nrVol = 1: noVols
    data(:, :, :, nrVol) = spm_read_vols(vols(nrVol));
end
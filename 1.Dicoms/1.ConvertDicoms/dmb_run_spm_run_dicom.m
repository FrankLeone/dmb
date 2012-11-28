function out = spm_run_dicom(job)
% SPM job execution function
% takes a harvested job data structure and call SPM functions to perform
% computations on the data.
% Input:
% job    - harvested job data structure (see matlabbatch help)
% Output:
% out    - computation results, usually a struct variable.
%_______________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% $Id: spm_run_dicom.m 2094 2008-09-15 16:33:10Z john $


wd = pwd;
try
    if ~isempty(job.outdir{1})
        cd(job.outdir{1});
        fprintf('   Changing directory to: %s\n', job.outdir{1});
    end
catch
    error('Failed to change directory. Aborting DICOM import.');
end

if job.convopts.icedims
    root_dir = ['ice' job.root];
else
    root_dir = job.root;
end;

[indices identifiers] = identify_filenames_by_specific_substring(job.data, '.', [], 4);
noElements = zeros(length(identifiers), 1);

dict = load('spm_dicom_dict.mat');
for nrIdentifier = 1: length(identifiers)
    jobs{nrIdentifier}.data = job.data(indices == nrIdentifier);
    jobs{nrIdentifier}.root = job.root;
    jobs{nrIdentifier}.outdir = job.outdir;
    jobs{nrIdentifier}.convopts = job.convopts;
    jobs{nrIdentifier}.rootdir = root_dir;
    noElements(nrIdentifier) = sum(indices == nrIdentifier);
    jobs{nrIdentifier}.dict = dict;
end

maxNoIdentifiers = max(noElements);
warning off;
out = qsubcellfun(@perform_actual_dicom_conversion, jobs, 'memreq', maxNoIdentifiers* 1024, 'timreq', maxNoIdentifiers * 1, 'compile', 'yes');
warning on;
files = {};
for nrOut = 1:length(out)
    files = [files; out{nrOut}.files];
end

out = files;

if ~isempty(job.outdir{1})
    fprintf('   Changing back to directory: %s\n', wd);
    cd(wd);
end


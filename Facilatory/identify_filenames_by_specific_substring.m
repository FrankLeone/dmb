function [locIdentifiers valuesIdentifiers]  = identify_filenames_by_specific_substring(data, identifier, nrOne, nrTwo)

if isempty(nrOne)
    nrOne = 1;
end
filenames           = cellfun(@get_filename, data, 'UniformOutput', false);
exampleFilename     = filenames{1};
nrsSep             = find(exampleFilename== identifier);
filenames           = strvcat(filenames);
identifierStrings   = filenames(:, nrOne:(nrsSep(nrTwo)-1));

[valuesIdentifiers lastIndex locIdentifiers] = unique(identifierStrings, 'rows');

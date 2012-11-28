function [filename] = get_filename(pathIncFilename)

pathIncFilename = pathIncFilename(1:max(find(pathIncFilename ~= ' ')));
if pathIncFilename(end) == filesep
    pathIncFilename(end) = [];
end

filename = pathIncFilename(max(find(pathIncFilename == filesep)+1):end);

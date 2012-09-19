function cell = fileMat2Cell(fileMat)

cell = mat2cell(fileMat, ones(size(fileMat, 1), 1), size(fileMat, 2));
cell = cellfun(@(X)X(1:max(find(X~=' '))), cell, 'UniformOutput', false);
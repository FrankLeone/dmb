function mat = fileCells2Mat(fileCells)

maxLength = 0;

for nr_cell = 1: length(fileCells);
    if length(fileCells{nr_cell}) > maxLength
        maxLength = length(fileCells{nr_cell});
    end
end

mat = repmat(' ', length(fileCells), maxLength);

for nr_cell = 1: length(fileCells)
    mat(nr_cell, 1:length(fileCells{nr_cell})) = fileCells{nr_cell};
end
function mat_dat = predata2mat(cell_dat)

num_cells = numel(cell_dat);
mat_dat = cell_dat{1};

for i = 2: num_cells
     mat_dat = [mat_dat cell_dat{i}];
    
end


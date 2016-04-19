asdf = SparseToASDF(testdata.binned', 1);

j_delay=1:30;
te_estimate=cell(3,3);

for j_order=1:3
    for i_order=1:3
   
        [te_estimate{i_order,j_order}, ~, ~]=ASDFTE(asdf,j_delay, i_order, j_order);
        
    end
end
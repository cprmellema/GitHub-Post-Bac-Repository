sensitivity2=cell(4,1);
specificity2=cell(4,1);
for i=1:1
    
    [sensitivity2{1,i},specificity2{1,i},~]=sensitivityspecificity(output2.real,output2.Entropy,100);
    [sensitivity2{2,i},specificity2{2,i},~]=sensitivityspecificity(output2.real,output2.GLMtest,100);
    [sensitivity2{3,i},specificity2{3,i},~]=sensitivityspecificity(output2.real,output2.Covariance,100);
    [sensitivity2{4,i},specificity2{4,i},~]=sensitivityspecificity(output2.real,output2.Differences,100);
end
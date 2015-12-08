B=cell(3,3,3,3);

for i=1:3
    for j=1:3
        for k=1:3
            for l=1:3
               B{i,j,k,l}=simNetworkGLMCoupled(30, 0.05*i, 0.05*j+0.1, 0.5*k+1, 0.5*l+1)
            end
        end
    end
end
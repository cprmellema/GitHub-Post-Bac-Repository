figure
X=[];
for j_order=1:3
    for i_order=1:3

        for i=1:30
            ijtest{i_order,j_order}(i,i)=0;
        end
        
        A= ijtest{i_order,j_order}(2:end,:);
        B= testdata.real_connections(2:end,:);
        
        A=normalize_connections(A);
        B=normalize_connections(B);
        
        C=A-B;
       
        x=reshape(C,1,870);
        
        X=[X;x];
               
    end
end

g=[ones(size(x));2*ones(size(x));3*ones(size(x));4*ones(size(x));5*ones(size(x));6*ones(size(x));7*ones(size(x));8*ones(size(x));9*ones(size(x))];

boxplot(X',g,'Labels',{'(1,1)','(1,2)','(1,3)','(2,1)','(2,2)','(2,3)','(3,1)','(3,2)','(3,3)'});

xlabel('(j order, i order) ')
ylabel('Predicted connection - Actual connection')
        
title('Connection plots')
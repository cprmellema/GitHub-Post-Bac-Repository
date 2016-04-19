figure
for j_order=1:3
    for i_order=1:3

        for i=1:30
            ijtest{i_order,j_order}(i,i)=0;
        end
        
        subplot(3,3,j_order+(i_order-1)*(3))
        
        A= ijtest{i_order,j_order}(2:end,:);
        B= testdata.real_connections(2:end,:);
        
        A=normalize_connections(A);
        B=normalize_connections(B);
       
        x=reshape(A,1,870);
        y=reshape(B,1,870);
        
        plot(0:0.001:max(y),0:0.001:max(y),'r')
        hold on
        scatter(x,y)        
        
        xlabel(strcat('Predicted Connection: (i order,j order) = (',num2str(j_order),',',num2str(i_order),')'))
        ylabel('Actual Connection')
        
        title('Connection graph')
        
    end
end
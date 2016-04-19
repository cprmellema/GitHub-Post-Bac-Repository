[m,n]=size(noisyTE{1,1});

% predicted=cell(1,50);
% 
% for j=1:m
%     for k=1:30
%        for i=1:50
%           predicted{j,k}=[predicted{j,k}(:,:),noisyTE{i}(m,n)];
%        end
%     end
% end

figure

z=zeros(50,120*120);

for i=1:50
        x=reshape(normalize_connections(noisyTE{i}),1,m*n);
        y=reshape(normalize_connections(J),1,m*n);
        z(i,:)=x-y;
end

boxplot(z')

ylabel('Predicted strength - actual (normalized by z score)');
xlabel('Delay in TE (in 5 ms steps)');
beep
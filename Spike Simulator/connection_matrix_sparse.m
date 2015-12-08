function [M] = connection_matrix_sparse(n_2, n_1, r_1, self)

M=logical( spalloc( n_2^2, n_1^2,n_1^2*(r_1+(r_1-1))^2 ) );

[X_2, Y_2]=ndgrid(1:n_2, 1:n_2);
X_2=X_2-1;
Y_2=Y_2-1;

h_1=(n_2-1)/(n_1-1);
[X_1, Y_1]=ndgrid(1:n_1, 1:n_1);
X_1=h_1*(X_1-1);
Y_1=h_1*(Y_1-1);

clear h_1

for j=1:n_1
    for i=1:n_1
        dist=sqrt((X_2-X_1(i,j)).^2+(Y_2-Y_1(i,j)).^2);
        
        if self==0
            dist_log=sparse(dist<=r_1&dist~=0);
        else
            dist_log=sparse(dist<=r_1);
        end
        M(:,n_1*(j-1)+i)=reshape(dist_log,n_2^2,1);
    end
end

clear dist i j

% if self==0
%     M=(M<=r_1)&(M~=0);
% else 
%     M=(M<=r_1);
% end
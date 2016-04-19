load('2Bsampled.mat')
x=randselect(toBsampled,30);
test=zeros(24001,30);
for i=1:30
test(:,i)=x{2,i};
end
out=GLMtest(test,'poisson','identity',30,1);
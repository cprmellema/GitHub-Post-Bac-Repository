function [ A ] = ROCarea( Sn, Sp )
%calculates area under ROC curve

A1=0;

x=(1-Sp);
x=[0,x,1];
y=Sn;
y=[0,y,1];

%area under Sn/SP curve
for i=1:length(x)-1
%     x(i+1)
%     x(i)
%     y(i+1)
%     y(i)
    
    w=x(i+1)-x(i);
    h=(y(i+1)+y(i))/2;
    
    A1=A1+w*h;
    
end

%area under x=y
A2=.5;

%difference in areas
A=A1-A2;

end


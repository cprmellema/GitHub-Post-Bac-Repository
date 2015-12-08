h=[];
for i=1:25
h=[h,ROCdistance{1,i}];
end
h=h';
boxplot(h)
hold on

j=[];
for i=1:25
j=[j,ROCdistance{2,i}];
end
j=j';
boxplot(j)

k=[];
for i=1:25
k=[k,ROCdistance{3,i}];
end
k=k';
boxplot(k)

s=[];
for i=1:25
s=[s,ROCdistance{4,i}];
end
s=s';
boxplot(s)
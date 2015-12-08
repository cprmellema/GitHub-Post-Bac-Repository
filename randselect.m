function [ sampled ] = randselect( fullset, numsamples )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

sampled=cell(2,numsamples);

[~,n]=size(fullset);

for i=1:numsamples
    
    h=rand;
    h=round(h*n);
    n=n-1; 
    
    sampled{1,i}=num2str(h);
    sampled{2,i}=fullset(:,h);
    
    fullset(:,h)=[];
    
end


function [spiked, notspiked] = FindSumsSpikesandNot( uniti, spikes, summedspikes )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[n,~]=size(spikes);

% avgspikes=zeros(1,m);
% 
% for i=1:m
%    avgspikes(1,i)=mean(spikes(:,i));
% end
% avguniti=avgspikes(1,uniti);
% 
% avgspikes(:,uniti);

spiked=[];
notspiked=[];

for j=1:n
    if spikes(j,uniti)>0
        spiked=[spiked;summedspikes(j,:)];
    else
        notspiked=[notspiked;summedspikes(j,:)];
    end
end

spiked(:,uniti)=[];
notspiked(:,uniti)=[];

end
A=GCprocess2('./20130117SpankyUtah005.nev','normal','identity',6);
A1=GCprocess2('./20130117SpankyUtah005.nev','poisson','log',6);
B=GCprocess2('./20130117SpankyUtah001.nev','normal','identity',6);
B1=GCprocess2('./20130117SpankyUtah001.nev','poisson','log',6);

save BrainControlLinear.mat A
save BrainControlGenLinear.mat A1
save ManualControlLinear.mat B
save ManualControlGenlinear.mat B1

subplot(2,2,1)
SpecialLinGraph('Brain control, linear GC',A,1)
subplot(2,2,2)
SpecialLinGraph('Brain control, Genlin GC',A1,1)
subplot(2,2,3)
SpecialLinGraph('Manual control, linear GC',B,1)
subplot(2,2,4)
SpecialLinGraph('Manual control, Genlin GC',B1,1)
% roundedA = round(A.muhat.*10)./10;
% scatter(roundedA(:,2),A.spikes(:,2),'b')
% title('Brain control, linear GC')
% hold on
% subplot(2,2,2)
% roundedA1 = round(A1.muhat.*10)./10;
% scatter(roundedA1(:,2),A1.spikes(:,2),'r')
% title('Brain control, general GC')
% hold on
% subplot(2,2,3)
% roundedB = round(B.muhat.*10)./10;
% scatter(roundedB(:,2),B.spikes(:,2),'g')
% title('Manual control, linear GC')
% hold on
% subplot(2,2,4)
% roundedB1 = round(B1.muhat.*10)./10;
% scatter(roundedB1(:,2),B1.spikes(:,2),'k')
% title('Manual control, general GC')
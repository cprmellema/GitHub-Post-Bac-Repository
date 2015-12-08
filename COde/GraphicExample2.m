load BrainControlLinear.mat
load BrainControlGenLinear.mat
load ManualControlLinear.mat
load ManualControlGenlinear.mat

[~,q]=size(A.spikes);
[~,t]=size(B.spikes);

n=max(q,t);

for j=1:n
    
    figure
    if j<=q
        subplot(2,2,1)
        SpecialLinGraph('Brain control, Linear',A,j)
        hold on

        subplot(2,2,2)
        SpecialLinGraph('Brain control, Genlinear',A1,j)
        hold on
    end

    if j<=t
        subplot(2,2,3)
        SpecialLinGraph('Manual control, linear',B,j)
        hold on

        subplot(2,2,4)
        SpecialLinGraph('Manual control, Genlinear',B1,j)
    end
    
    saveas(gcf,strcat('LinFigure',num2str(j),'.jpg'))

end
function fireWorks
fg=gcf;
fg.NumberTitle='off';
fg.MenuBar='none';
fg.Resize='off';
fg.Position=[100 100 500 500];
fg.Name='fireworks';

ax=axes(fg);
ax.Position=[0 0 1 1];
ax.XLim=[0 100];
ax.YLim=[0 100];
ax.Color=[0 0 0];
hold(ax,'on');

baseFw.rRange=[0.6 1.2];
baseFw.centerPosLim=[10 90,40 90];
baseFw.pntNum=120:200;
baseFw.cenNum=[2 6];
baseFw.colorLst=...
   [0.9569    0.4235    0.3216
    0.8196    0.8627    0.4863
    0.2157    0.6980    0.6784
    0.4706    0.6549    0.9373
    0.7333    0.8902    0.8980
    0.7020    0.8549    1.0000
    0.9373    0.9255    0.7490
    0.5451    0.7373    0.3804];
baseFw.brightDecay=0.98;
baseFw.pntSizeLim=[1 5];
baseFw.gv=0.013;

    function fw=createFWobj(~,~)
        fw.Num=baseFw.pntNum(randi(length(baseFw.pntNum)));
        fw.Rmax=rand(1,1).*(baseFw.rRange(2)-baseFw.rRange(1))+baseFw.rRange(1);
        fw.R=rand(fw.Num,1).*fw.Rmax;
        fw.theta=rand(fw.Num,1).*2.*pi;
        fw.cenPos=[randi(baseFw.centerPosLim(2)-baseFw.centerPosLim(1))+baseFw.centerPosLim(1),...
            randi(baseFw.centerPosLim(4)-baseFw.centerPosLim(3))+baseFw.centerPosLim(3)];
        fw.Pos=[cos(fw.theta),sin(fw.theta)].*fw.R+fw.cenPos;
        fw.Dir=fw.Pos-fw.cenPos;
        fw.color=baseFw.colorLst(randi(size(baseFw.colorLst,1)),:);
        fw.BD=baseFw.brightDecay;
        fw.gv=baseFw.gv;
        fw.pntSize=randi(baseFw.pntSizeLim(2)-baseFw.pntSizeLim(1))+baseFw.pntSizeLim(1);
    end

    function [fwSet,fwPlotSet]=createFWgroup(~,~)
        cenNum=randi(baseFw.cenNum(2)-baseFw.cenNum(1))+baseFw.cenNum(1);
        fwSet.Len=cenNum;
        for ii=1:cenNum
            fwSet.(['fw',num2str(ii)])=createFWobj();
            fwPlotSet.(['fw',num2str(ii)])=...
                scatter(fwSet.(['fw',num2str(ii)]).Pos(:,1),...
                        fwSet.(['fw',num2str(ii)]).Pos(:,2),...
                        fwSet.(['fw',num2str(ii)]).pntSize,'filled','CData',...
                        fwSet.(['fw',num2str(ii)]).color,'tag','fw');
        end 
    end
while 1
    [fwSet,fwPlotSet]=createFWgroup();
    for i=1:50
        for j=1:fwSet.Len
            set(fwPlotSet.(['fw',num2str(j)]),...
                'XData',i.*fwSet.(['fw',num2str(j)]).Dir(:,1)+fwSet.(['fw',num2str(j)]).cenPos(:,1),...
                'YData',i.*fwSet.(['fw',num2str(j)]).Dir(:,2)+fwSet.(['fw',num2str(j)]).cenPos(:,2)-i*i*(fwSet.(['fw',num2str(j)]).gv),...
                'CData',fwSet.(['fw',num2str(j)]).color.*(fwSet.(['fw',num2str(j)]).BD)^i);
        end
        pause(0.04)
    end
    delete(findobj('type','scatter'))
    pause(random('exponential',0.1))
end

end
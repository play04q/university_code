function []=lat_rlc()
[CASE]=load_DRVstability('m');
if isempty(CASE)
    return
end
nF=length(CASE.Files);
Files=CASE.Files;

%% 预读取每个数据文件
for i=1:nF
    if i==1
        Alpha_min=Files(i).M_SDRV.state(1,1).alpha;
        Alpha_max=Files(i).M_SDRV.state(end,1).alpha;
    else
        if Files(i).M_SDRV.state(1,1).alpha > Alpha_min
            Alpha_min=Files(i).M_SDRV.state(1,1).alpha;
        end
        if Files(i).M_SDRV.state(end,1).alpha < Alpha_max
            Alpha_max=Files(i).M_SDRV.state(end,1).alpha;
        end
    end
end

%高度  速度范围 
allstate=main_allstate('Sh');

%% 读取迎角计算范围
%首先确定迎角具体数值
disp (['当前文件序列中最大有效迎角范围为： ' num2str(rad2deg(Alpha_min)) ' > ' num2str(rad2deg(Alpha_max))])
tline=input('起始迎角>终止迎角，或单独迎角（默认为全部）[Deg]     ','s');
if ~isempty(tline)
    A1=strfind(tline,'>');
    if isempty(A1)
        T1=deg2rad(str2double(tline));
        T2=T1;
    else
        T1=deg2rad(str2double(tline(1:A1-1)));
        T2=deg2rad(str2double(tline(A1+1:end)));
    end
    if T1>Alpha_max
        T1=Alpha_max;
    end
    if T1<Alpha_min
        T1=Alpha_min;
    end
    if T2>Alpha_max
        T2=Alpha_max;
    end
    if T2<Alpha_min
        T2=Alpha_min;
    end
    
    Alpha_min=T1;
    Alpha_max=T2;
end


%找到迎角数值对应的ID,并进行计算
for i=1:nF
    [nA,~]=size(Files(i).M_SDRV.state);
   
    for j=1:nA
        %找到迎角对应的ID
        if j<=nA-1
            if Files(i).M_SDRV.state(j,1).alpha<=Alpha_min && Files(i).M_SDRV.state(j+1,1).alpha>Alpha_min
                Files(i).idx_start=j;
            end
        end
        if j>2
            if Files(i).M_SDRV.state(j-1,1).alpha<Alpha_max && Files(i).M_SDRV.state(j,1).alpha>=Alpha_max
                Files(i).idx_end=j;
            end
        end
    end
    
    idx=0;
    disp(['文件 <' Files(i).name '> 计算迎角状态点包含:'])
    for j=Files(i).idx_start:Files(i).idx_end
        fprintf('%8.1f\t',rad2deg(Files(i).M_SDRV.state(j,1).alpha))
        idx=idx+1;
        Tmp=Files(i).M_SDRV.state(j,1).DRVs;
        Tmp.CD=Files(i).M_SDRV.state(j,1).STC.CD;
        M_SDRV(idx)=Tmp;  %#ok<AGROW>
    end
    fprintf('\n')
    
    PROC.M_SDRV=M_SDRV;
    PROC.state=allstate;
    PROC.ref=Files(i).ref;
    PROC.inertias=Files(i).inertias;
    
    Files(i).MEig=lat_sdrv2eig(PROC);
end

%% 数据作图
nV=length(allstate.AS0);
if nF==1
    N=nV;
elseif nV==1
    N=nF;
else
    N=0;
    disp ('多方案多速度状态，根轨迹图仅显示单独模态图')
end

%% 画单个文件/单个速度下的根轨迹图
for i=1:N
    figure (620+i)
    clf
    hold on
    
    set(gcf,'Units','Normalized')
    set(gcf,'Position',[.5+.02*i,.5-.02*i,.35,.4])
    set(gcf,'NumberTitle','off')
    if nF==1
        T2=['<' Files(1).name '> ' 'V = ' num2str(allstate.AS0(i)) ' m/s'];
    elseif nV==1
        T2=['<' Files(i).name '> ' 'V = ' num2str(allstate.AS0) ' m/s'];
    end
    set(gcf,'Name',['Lateral Mode Root Locus ' T2])
    
    title({'Lateral Mode Root Locus';T2})
    xlabel('Real Axis')
    ylabel('Imaginary Axis')
    plot([0,0],[-9999,9999],'k:')
    plot([-9999,9999],[0,0],'k:')
    
    if nF==1
        tmp=Files(1).MEig;
        XX=squeeze(real(tmp(i,:,:)));
        YY=squeeze(imag(tmp(i,:,:)));
    else
        tmp=Files(i).MEig;
        XX=squeeze(real(tmp(1,:,:)));
        YY=squeeze(imag(tmp(1,:,:)));
    end
    
    xlim0=[min(min(XX)),max(max(XX))];
    ylim0=[min(min(YY)),max(max(YY))];
    xr=.05*(xlim0(2)-xlim0(1));
    yr=.05*(ylim0(2)-ylim0(1));
    xlim0=[xlim0(1)-xr,xlim0(2)+xr];
    ylim0=[ylim0(1)-yr,ylim0(2)+yr];

    axis([xlim0,ylim0])

    plot(XX(1,1),YY(1,1),'xr')
    plot(XX(:,1),YY(:,1),'r')
    plot(XX(end,1),YY(end,1),'or')

    plot(XX(1,2),YY(1,2),'xb')
    plot(XX(:,2),YY(:,2),'b')
    plot(XX(end,2),YY(end,2),'ob')

    plot(XX(1,3),YY(1,3),'xg')
    plot(XX(:,3),YY(:,3),'g')
    plot(XX(end,3),YY(end,3),'og')

    plot(XX(1,4),YY(1,4),'xc')
    plot(XX(:,4),YY(:,4),'c')
    plot(XX(end,4),YY(end,4),'oc')
    
    %以下部分为是否显示数据点
    %{
    plot(XX(2:end-1,1),YY(2:end-1,1),'+r')
    plot(XX(2:end-1,2),YY(2:end-1,2),'+b')
    plot(XX(2:end-1,3),YY(2:end-1,3),'+g')
    plot(XX(2:end-1,4),YY(2:end-1,4),'+c')
    %}
end

%% 画四个模态的根轨迹图
if nF==1
    T3=' vs Different Speed';
elseif nV==1
    T3=[' vs Different Model at V = ' num2str(state.AS0(1)) ' m/s'];
else
    T3='';
end


for i=1:4
    XX=[];
    YY=[];
    figure (510+i)
    clf
    hold on
    
    set(gcf,'Units','Normalized')
    set(gcf,'Position',[.05+.02*i,.5-.02*i,.35,.4])
    set(gcf,'Name',['Mode ',num2str(i),' Root Locus'])
    set(gcf,'NumberTitle','off')
    

    title(['Mode ',num2str(i),' Root Locus ' T3])
    if i==2 || i==3 
        xlabel('Real Axis')
        ylabel('Imaginary Axis')
    else
        xlabel('Angle of Attack /Deg')
        ylabel('Real Axis')
    end

    
    if nF==1
        tmp=Files(1).MEig;
        XX=[squeeze(real(tmp(:,:,i)))]';
        YY=[squeeze(imag(tmp(:,:,i)))]';
    elseif nV==1
        for j=1:nF
            tmp=Files(j).MEig;
            XX=[XX,squeeze(real(tmp(1,:,i)))'];
            YY=[YY,squeeze(imag(tmp(1,:,i)))'];
        end
    else
        for j=1:nF
            tmp=Files(j).MEig;
            XX=[XX,squeeze(real(tmp(:,:,i)))'];
            YY=[YY,squeeze(imag(tmp(:,:,i)))'];
        end
    end
    
    if i==1 || i==4
        YY=XX;
        tmp=Files(1);
        idx_start=Files(1).idx_start;
        idx_end=Files(1).idx_end;
        XX=ones(nA,1);
        for k=idx_start:idx_end
            XX(k-idx_start+1)=rad2deg(tmp.state.alpha0(k));
        end
        if nF==1
            XX=XX*ones(1,nV);
        elseif nV==1
            XX=XX*ones(1,nV);
        else
            XX=XX*ones(1,nV*nF);
        end
    end
    
    xlim0=[min(min(XX)),max(max(XX))];
    ylim0=[min(min(YY)),max(max(YY))];
    xr=.05*(xlim0(2)-xlim0(1));
    yr=.05*(ylim0(2)-ylim0(1));
    xlim0=[xlim0(1)-xr,xlim0(2)+xr];
    ylim0=[ylim0(1)-yr,ylim0(2)+yr];

    if xlim0==0 
        ylim(ylim0)
    else
        if ylim0==0
            xlim(xlim0)
        else
            axis([xlim0,ylim0])
        end
    end
    
    h1=plot(XX,YY);
    plot(XX(1,:)',YY(1,:)','x')
    plot(XX(end,:)',YY(end,:)','o')
    plot(XX(2:end-1,:),YY(2:end-1,:),'+')
    
    T4={};
    for j=1:nF
        for k=1:nV
            if nF==1
                T4{k}=['V = ',num2str(allstate.AS0(k)),' m/s'];
            elseif nV==1
                T4{j}=Files(j).name;
            else
                T4{(j-1)*nV+k}=[Files(j).name ', V = ',num2str(allstate.AS0(k)),' m/s'];
            end
        end
    end   
    line([0,0],[-9999,9999],'LineStyle',':')
    line([-9999,9999],[0,0],'LineStyle',':')
    legend(T4)
end

for i=1:nF
    for j=1:nV
        fprintf('模型 <%s>          速度 V=%8.4f \n',Files(i).name,allstate.AS0(j));
        fprintf('迎角                                特征根 \n');
        tmp=Files(i);
        idx_start=Files(i).idx_start;
        idx_end=Files(i).idx_end;
        for k=idx_start:idx_end
            fprintf('%5.2f   \t',rad2deg(tmp.state.alpha0(k)));
            fprintf('%22s \t',num2str(tmp.MEig(j,k-idx_start+1,1)));
            fprintf('%22s \t',num2str(tmp.MEig(j,k-idx_start+1,2)));
            fprintf('%22s \t',num2str(tmp.MEig(j,k-idx_start+1,3)));
            fprintf('%22s \n',num2str(tmp.MEig(j,k-idx_start+1,4)));
        end
        
    end
end



for i=1:nV
    
    
end

end


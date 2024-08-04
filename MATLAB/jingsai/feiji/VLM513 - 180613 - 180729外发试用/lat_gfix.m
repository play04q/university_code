function []=lat_gfix()
[CASE]=load_DRVstability('m');
if isempty(CASE)
    return
end
nF=length(CASE.Files);

tline=input('Load Factor < Default 1 > [g] ');
if isempty(tline)
    Gfix=1;
else
    Gfix=tline;
end

allstate=main_allstate('Sh');

tline=input('Method for Aerodynamic Derivatives Obtain [(I)nterpolation or (R)ecauculate <I for Default>] ','s');

if isempty(tline)
    Drv_Solvemode='nis';
else
    if strcmpi(tline(1),'r')
        Drv_Solvemode='nrs';
    else
        Drv_Solvemode='nis';
    end
end

nV=length(allstate.AS0);
nAS0=length(allstate.AS0);

MChr(nF)=struct('name',[],'MDR',[],'MSPR',[]);

MDR(nAS0)=struct('omega_nd',[],'zeta_d',[]);
MSPR(nAS0)=struct('T2DA',[],'REL',[]);
MRM(nAS0)=struct('TC',[]);
for i=1:nF
    MChr(i).name=CASE.Files(i).name;
    MChr(i).MDR=[];
    MChr(i).MSPR=[];
    MChr(i).MRM=[];
    
    CASE.Files(i).allstate=allstate;
    ref=CASE.Files(i).ref;
    
    M_SDRV=CASE.Files(i).M_SDRV;
    CL_Gfix=CASE.Files(i).inertias.m*9.8*Gfix./(.5*allstate.rho*allstate.AS0.^2*ref.S_ref_M);
    
    
    [nA,~]=size(CASE.Files(i).M_SDRV.state);
    CLs=zeros(1,nA);
    Alphas=zeros(1,nA);
    for j=nA:-1:1
        CLs(j)=CASE.Files(i).M_SDRV.state(j,1).STC.CL;
        Alphas(j)=CASE.Files(i).M_SDRV.state(j,1).alpha;
    end
    Alpha_intp=interp1(CLs,Alphas,CL_Gfix);
    
    disp (['-----' CASE.Files(i).name '空速迎角对应关系-----'])
    A1='Airspeed(m/s)\t';
    A2='Alpha(deg)   \t';
    A3='CL           \t';
    for j=1:nAS0
        A1=[A1 '%6.2f \t'];
        A2=[A2 '%6.2f \t'];
        A3=[A3 '%6.2f \t'];
    end
    fprintf ([A1 '\n'],allstate.AS0)
    fprintf ([A2 '\n'],rad2deg(Alpha_intp))
    fprintf ([A3 '\n'],CL_Gfix)

    for j=1:nAS0
        alpha=Alpha_intp(j);
        
        if isnan(alpha)
            disp (['模型文件' CASE.Files(i).name '计算点数不足以支持插值，需要重新生成气动导数文件'])
            disp (['当前待求升力系数为 ' num2str(CL_Gfix(j)) '，现有升力系数范围为：' num2str(M_SDRV(1).CL) '  ' num2str(M_SDRV(end).CL)])
            return
        else
            CASE.Files(i).allstate.alpha=alpha;
            CASE.Files(i).allstate.AS0=allstate.AS0(j);
            CASE.Files(i).allstate.AS=allstate.AS0(j);
        end

        [DYN_LAT]=lat_chr(CASE.Files(i),Drv_Solvemode);
        MDR(j)=DYN_LAT.DR;
        MSPR(j)=DYN_LAT.SPR;
        MRM(j)=DYN_LAT.RM;
 
    end
    fprintf('\n')
    MChr(i).MDR=[MChr(i).MDR MDR];
    MChr(i).MSPR=[MChr(i).MSPR MSPR];
    MChr(i).MRM=[MChr(i).MRM MRM];
end


if nV>1
    
    figure (64)
    clf
    set(gcf,'Units','Normalized')
    set(gcf,'Position',[.05,0.4,.7,.5])
    set(gcf,'NumberTitle','off')
    set(gcf,'Name',['Lateral mode characters vs airspeed change'])
    X=allstate.AS0'*ones(1,nF);
    
    H_plot(1)=subplot(2,3,1);
    hold on
    title ('\zeta_d vs speed')
    Y=zeros(nV,nF);
    for i=1:nV
        for j=1:nF
            Y(i,j)=MChr(j).MDR(i).zeta_d;
        end
    end
    plot(X,Y);
    plot(allstate.AS0,0.02.*ones(nV,1),'r');
    midx=(max(allstate.AS0)+min(allstate.AS0))/2;
    text(midx,0.02,'Level2')
    legend(MChr(:).name)
    xlabel('Airspeed (m/s)')
    ylabel('\zeta_d ')


    H_plot(2)=subplot(2,3,2);
    hold on
    title ('\zeta_d\omega_n_d vs speed')
    Y=zeros(nV,nF);
    for i=1:nV
        for j=1:nF
            Y(i,j)=MChr(j).MDR(i).omega_nd*MChr(j).MDR(i).zeta_d;
        end
    end
    plot(X,Y);
    plot(allstate.AS0,0.05.*ones(nV,1),'r');
    midx=(max(allstate.AS0)+min(allstate.AS0))/2;
    text(midx,0.05,'Level2')
    legend(MChr(:).name)
    xlabel('Airspeed (m/s)')
    ylabel('\zeta_d\omega_n_d (rad/s)')


    H_plot(3)=subplot(2,3,3);
    hold on
    title ('\omega_n_d vs speed')
    Y=zeros(nV,nF);
    for i=1:nV
        for j=1:nF
            Y(i,j)=MChr(j).MDR(i).omega_nd;
        end
    end
    plot(X,Y);
    plot(allstate.AS0,0.4.*ones(nV,1),'r');
    midx=(max(allstate.AS0)+min(allstate.AS0))/2;
    text(midx,0.4,'Level2')
    legend(MChr(:).name)
    xlabel('Airspeed (m/s)')
    ylabel('\omega_n_d (rad/s)')
    
    H_plot(4)=subplot(2,3,4);
    hold on
    title ('Eigenvalue of Spiral vs Speed')
    Y=zeros(nV,nF);
    for i=1:nV
        for j=1:nF
            Y(i,j)=MChr(j).MSPR(i).REL;
        end
    end
    plot(X,Y);
    plot(allstate.AS0,0.693/8.*ones(nV,1),'r');
    midx=(max(allstate.AS0)+min(allstate.AS0))/2;
    text(midx,0.693/8,'Level2')
    plot(allstate.AS0,0.693/4.*ones(nV,1),'r');
    text(midx,0.693/4,'Level3')
    legend(MChr(:).name)
    xlabel('Airspeed (m/s)')
    ylabel('Eigenvalue (rad/s)')
    
    H_plot(5)=subplot(2,3,5);
    hold on
    title ('Roll-mode Time Constant vs Speed')
    Y=zeros(nV,nF);
    for i=1:nV
        for j=1:nF
            Y(i,j)=MChr(j).MRM(i).TC;
        end
    end
    plot(X,Y);
    %midx=(max(allstate.AS0)+min(allstate.AS0))/2;
    %plot(allstate.AS0,10*ones(nV,1),'r');
    %text(midx,10,'Level3')
    legend(MChr(:).name)
    xlabel('Airspeed (m/s)')
    ylabel('Roll-mode \tau_R(s)')
    
    linkaxes(H_plot,'x')
end
end
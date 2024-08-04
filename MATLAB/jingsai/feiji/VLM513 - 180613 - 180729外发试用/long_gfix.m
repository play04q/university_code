function []=long_gfix()
[Mfile]=load_DRVstability('m');
if isempty(Mfile)
    return
end
nF=length(Mfile);

recent=main_recent;

disp ('-------------------确定求解参数-------->')
tline=input(['求解高度 < 默认 ' num2str(recent.ALT) ' > [m]   ']);
if ~isempty(tline)
    allstate.ALT=tline;
    allstate.rho=ISAtmosphere(allstate.ALT);
else
    allstate.ALT=recent.ALT;
    allstate.rho=ISAtmosphere(allstate.ALT);
end
recent.ALT=allstate.ALT;

tline=input('求解过载 < 默认 1 > [g] ');
if isempty(tline)
    Gfix=1;
else
    Gfix=tline;
end

tline=input(['求解速度范围，取点数量 < 默认 ' num2str(recent.AS0(1)) '>' num2str(recent.AS0(end)) ','  num2str(length(recent.AS0)) ' > [m/s] '],'s');
if ~isempty(tline)
   
    A1=strfind(tline,',');
    A2=strfind(tline,'>');
    if ~isempty(A1)
        ASnum=str2double(tline(A1+1:end));
        tline=tline(1:A1-1);
    else
        ASnum=3;
    end
    
    if ~isempty(A2)
        AS0=str2double(tline(1:A2-1));
        AS1=str2double(tline(A2+1:end));
    else
        AS0=str2double(tline)*0.9;
        AS1=str2double(tline)*1.1;
    end
    
    
    allstate.AS0=AS0:(AS1-AS0)/(ASnum-1):AS1;
    allstate.AS=allstate.AS0(1);
else
    allstate.AS0=recent.AS0;
end
recent.AS0=allstate.AS0;
nV=length(allstate.AS0);


tline=input('气动导数计算方式 [插值 (I)nterpolation or 重新计算 (R)ecauculate <默认I>] ','s');

if isempty(tline)
    Drv_Solvemode='nis';
else
    if strcmpi(tline(1),'r')
        Drv_Solvemode='nrs';
    else
        Drv_Solvemode='nis';
    end
end


main_recent(recent);
nAS0=length(allstate.AS0);

MChr(nF)=struct('name',[],'MDR',[],'MSPR',[]);

MPGD(nAS0)=struct('omega_n',[],'zeta',[]);
MSP(nAS0)=struct('omega_n',[],'zeta',[]);
for i=1:nF
    if nF>1
        disp(['**********************************************' Mfile(i).geo.name '**********************************************'])
    end
    MChr(i).name=Mfile(i).geo.name;
    MChr(i).MPGD=[];
    MChr(i).MSP=[];
    
    geo=Mfile(i).geo;
    state=Mfile(i).state;
    ref=Mfile(i).ref;
    inertias=Mfile(i).inertias;
    M_SDRV=Mfile(i).M_SDRV;

    CL_Gfix=inertias.m*9.8*Gfix./(.5*allstate.rho*allstate.AS0.^2*ref.S_ref);
    
    for j=1:nAS0
        state.AS=allstate.AS0(j);
        state.AS0=state.AS;
        state.alpha=interp1([M_SDRV.CL],[M_SDRV.alpha],CL_Gfix(j));
        if isnan(state.alpha)
            disp (['模型文件' MChr(i).name '计算点数不足以支持插值，需要重新生成气动导数文件'])
            disp (['当前待求升力系数为 ' num2str(CL_Gfix(j)) '，现有升力系数范围为：' num2str(M_SDRV(1).CL) '  ' num2str(M_SDRV(end).CL)])
            return
        end
        [PGD,SP]=long_chr(geo,state,ref,inertias,M_SDRV,Drv_Solvemode); 
        MPGD(j)=PGD;
        MSP(j)=SP;
    end
    MChr(i).MPGD=[MChr(i).MPGD MPGD];
    MChr(i).MSP=[MChr(i).MSP MSP];
end


if nV>1
    %短周期固有频率图
    X=[];
    Y=[];
    Tname={};
    for i=1:nF
        M_nalpha=zeros(1,nV);
        for j=1:nV
            q=.5*allstate.rho*allstate.AS0(j)^2;
            S=Mfile(i).ref.S_ref_M;
            CL_alpha=Mfile(i).M_SDRV.CL_alpha;
            W=Mfile(i).inertias.m*9.81;
            M_nalpha(j)=q*S*CL_alpha/W;
        end
        X=[X,M_nalpha']; %#ok<AGROW>
        Y=[Y;MChr(i).MSP.omega_n]; %#ok<AGROW>
        Tname=[Tname MChr(i).name];
    end
    Y=Y';
    long_fig_omeganSP_A(X,Y,Tname);
    
    

    

    %短周期阻尼比图
    X=[];
    Y=[];
    for i=1:nF
        X=[X,allstate.AS0']; %#ok<AGROW>
        Y=[Y;MChr(i).MSP.zeta]; %#ok<AGROW>
    end
    Y=Y';
    long_fig_zetaSP_AC(X,Y,Tname);

    %长周期阻尼比图
    X=[];
    Y=[];
    for i=1:nF
        X=[X,allstate.AS0']; %#ok<AGROW>
        Y=[Y;MChr(i).MPGD.zeta]; %#ok<AGROW>
    end
    Y=Y';
    long_fig_zetap(X,Y,Tname);
end
end
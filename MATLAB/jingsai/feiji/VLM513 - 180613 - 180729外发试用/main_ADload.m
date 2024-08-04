function [CASE,PROC,Results]=main_ADload(CASE,cmdline)
% �±�
% PTL - λ����
% FRIC - Ħ��
% Pid��Vid��ŵ�˳��  MESH - > sMESH -> WAKE

switch nargin
    case 0
        cmdline='';
    case 1
        cmdline='';
    case 2
        cmdline=lower(cmdline);
end

if ~exist('CASE','var')
    [CASE]=load_define('','nm');
    if isempty(CASE)
        PROC=[];
        Results=[];
        return
    end
end


nF=length(CASE.Files);
if nF==1 
Is_need_deflect=0;
for s=1:length(CASE.Files(1).geo)
    Is_need_deflect=Is_need_deflect || any(any(CASE.Files(1).geo(s).deflect~=0));
end
if Is_need_deflect==1
    if ~contains(cmdline,'n')
        beep
        pause(.2)
        beep
        pause(.2)
        beep
        disp ('')
        disp ('***************************************************************')
        disp ('*  CAUTION��Current File Contains Control Surface Deflection  *')
        disp ('***************************************************************')
        disp ('')
    end
end
    %�����ļ�������������
    [PROC,Results]=AD_Single(CASE,cmdline);
    
else  
    state_public=CASE.Files(1).state;
    % ��ȡ������
    disp ('-------------------ȷ��������-------->')
    tline=input(['���߶� < Ĭ�� ' num2str(state_public.ALT) ' > [m]   ']);
    if ~isempty(tline)
        state_public.ALT=tline;
    end

    tline=input(['������ < Ĭ�� ' num2str(state_public.AS) ' > [m/s] ']);
    if ~isempty(tline)
        state_public.AS=tline;
    end
    
    tline=input('��ʼӭ��>��ֹӭ�� <Ĭ�� 0>10 >[Deg]     ','s');
    if isempty(tline)
        state_public.alpha0=deg2rad(0:10);
    else
        A1=strfind(tline,',');
        A2=strfind(tline,'>');
        if ~isempty(A1)
            AoAstp=str2double(tline(A1+1:end))*pi/180;
            tline=tline(1:A1-1);
        else
            AoAstp=pi/180;
        end
        if ~isempty(A2)
            AoA0=str2double(tline(1:A2-1))*pi/180;
            AoA1=str2double(tline(A2+1:end))*pi/180;
        else
            AoA0=str2double(tline)*pi/180;
            AoA1=str2double(tline)*pi/180;
        end
        state_public.alpha0=AoA0:AoAstp:AoA1;
    end
    
    nA=length(state_public.alpha0);
    if nA==1
        tline=input('�Ƿ���ʾչ���غɷֲ� < Y/[N] > ');
        if ~isempty(tline)
            isSpanload=0;
        else
            isSpanload=1;
        end
    end
    
    figure (200)
    clf
    hold on
    title('�����ļ�չ�����Ա�')
    set(gcf,'Units','Normalized')
    set(gcf,'Position',[.05,.5,.35,.4])
    set(gcf,'Name','Section Compare')
    set(gcf,'NumberTitle','off')
    colors='brgkmcy';
    LegendName=cell(1,nF);
    for i=1:nF
        tic
        fprintf(['�����ļ� <' CASE.Files(i).name '> ...........'])
        
        CASE.Files(i).state=state_public;
        [PROC,CurrentResults.friction]=ADsolve_1(CASE.Files(i),'n');
        for j=1:nA
            PROC.state.alpha=PROC.state.alpha0(j);
            CurrentResults.PTL=solver_ADload(PROC,'n');
            CurrentResults=coeff_create3(CurrentResults,PROC);
            Results.Files(i).ADload(j)=CurrentResults;
            Results.Files(i).ADload(j).state=PROC.state;
            
            
            if isSpanload==1 
                if i==1
                    spanload2(PROC,CurrentResults,2);
                else
                    spanload2(PROC,CurrentResults,3);
                end
            end
        end
        fprintf('��ʱ�� %f s\n',toc)
        
        if PROC.drawtype(1)~='0'
            figure (200+i)
            set(gcf,'Units','Normalized')
            set(gcf,'Position',[.05+.01*i,.5-.02*i,.35,.4])
            set(gcf,'Name',PROC.name)
            set(gcf,'NumberTitle','off')
            
            if ~isempty(strfind(PROC.drawtype,'1'))
                geometryplot(PROC,1)
            elseif ~isempty(strfind(PROC.drawtype,'2'))
                geometryplot(PROC,2)
            end
        end
        
        figure(200)
        nwing=length(PROC.NODE);
        for j=1:nwing
            cNODE=PROC.NODE{j};
            [nSEC,~,~]=size(cNODE);
            for k=1:nSEC
                XX=squeeze(cNODE(k,:,1));
                YY=squeeze(cNODE(k,:,2));
                ZZ=squeeze(cNODE(k,:,3));
                KK(i)=plot3(XX,YY,ZZ,colors(i));
            end
        end
        LegendName{i}=PROC.name;
    end
    legend(KK,LegendName)
    
    Fcontents={'C_L','C_D','C_m','C_L/C_D'};
    nC=length(Fcontents);
    AoA=(rad2deg(state_public.alpha0))'*ones(1,nF);
    for i=1:nC
        Tmp=zeros(nA,nF);
        for j=1:nF
            for k=1:nA
                switch i
                    case 1
                        A=Results.Files(j).ADload(k).PTL.CL;
                    case 2
                        A=Results.Files(j).ADload(k).total.CD;
                    case 3
                        A=Results.Files(j).ADload(k).PTL.CMm;
                    case 4
                        A=Results.Files(j).ADload(k).PTL.CL/ ...
                            Results.Files(j).ADload(k).total.CD;
                end
                Tmp(k,j)=A;
            end
        end
        
        figure(210+i)
        clf
        hold on
        set(gcf,'Units','Normalized')
        set(gcf,'Position',[.5+.01*(i-1),.5-.02*(i-1),.35,.4])
        set(gcf,'NumberTitle','off')
        set(gcf,'Name',[Fcontents{i} ' Compares'])
        title([Fcontents{i} ' Compares'])
        xlabel('Alpha /Deg')
        ylabel(Fcontents{i})
        if nA~=1
            plot(AoA,Tmp)
        else
            plot([AoA;AoA],[Tmp;Tmp],'x')
        end
        legend(LegendName)
        
    end
    
    
        
    
    
    
end  %%if nF==1

end

function [PROC,Results]=AD_Single(CASE,cmdline)
isSpanload=0;
if ~contains(cmdline,'n')
    tline=input('�Ƿ���ʾչ���غɷֲ� < Y/[N] > ','s');
    if ~isempty(tline)
        isSpanload=1;
    end
end

nA=length(CASE.Files(1).state.alpha0);
nS=length(CASE.Files(1).state.beta0);
if nA==1 && nS==1
    T=cmdline;
else
    T='n';
end

%��������\���βο���Ϣ\����������||������������
[PROC,CurrentResults.friction]=pre_general(CASE.Files(1),T);

for i=1:nA
    PROC.state.alpha=PROC.state.alpha0(i);
    for j=nS:-1:1
        PROC.state.beta=PROC.state.beta0(j);
        CurrentResults.PTL=solver_ADload(PROC,T);
        CurrentResults=coeff_create3(CurrentResults,PROC);
        
        Results(1).state(i,j).STC=CurrentResults;
        Results(1).state(i,j).alpha=PROC.state.alpha;
        Results(1).state(i,j).beta=PROC.state.beta;
    end
    if nS==1
        CurrentResults.PTL.A=CurrentResults.PTL.CDi/CurrentResults.PTL.CL^2;
        if i==1
            CurrentResults.PTL.xNP=-1;
        else
            CurrentResults.PTL.xNP=PROC.ref.ref_point(1)+(CurrentResults.PTL.Mm-Mm0)/(CurrentResults.PTL.Z-Z0);
        end
        Results(1).state(i,j).STC=CurrentResults;
        Mm0=CurrentResults.PTL.Mm;
        Z0=CurrentResults.PTL.Z;    %����ϵ��Z����
    end
    
    %��һ�����ǹ���չ���غ���ʾ�ģ��Ժ��ٸ�
    if i==1
        if nA==1
            if ~contains(cmdline,'n')
                if isSpanload==1
                    spanload2(PROC,CurrentResults,1)
                end
            end
        else
            if ~contains(cmdline,'n')
                if isSpanload==1
                    spanload2(PROC,CurrentResults,2);
                end
            end
        end
    else  %i>1
        if ~contains(cmdline,'n')
            if isSpanload==1
                spanload2(PROC,CurrentResults,3);
            end
        end
    end

end
if nA==1 && nS==1
    post_fastview(Results(1).state(1,1).STC,PROC,'AD_simp')
else
    post_fastview(Results(1),PROC,'AD_Sweep')
end

if PROC.drawtype(1)~='0'
    if ~isempty(strfind(PROC.drawtype,'1'))
        figure (1)
        geometryplot(PROC,1)
    elseif ~isempty(strfind(PROC.drawtype,'2'))
        figure (2)
        geometryplot(PROC,2)
    end
end

end



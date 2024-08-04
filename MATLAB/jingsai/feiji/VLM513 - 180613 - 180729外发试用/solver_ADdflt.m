function [MultiResults]=solver_ADdflt(FILE,cmdline)
if nargin==0
    [CASE]=load_define('','ns');
    if isempty(CASE)
        MultiResults=[];
        return
    end
    FILE=CASE.Files(1);
    cmdline='';
elseif nargin==1
    cmdline='';
elseif nargin==2
    cmdline=lower(cmdline);
end

%��ȡ���涨��
nCF=0;
CF_DEF(1)=struct('nwing',[],'nelm',[]);
for i=1:length(FILE.geo)
    for j=1:length(FILE.geo(i).ny)
        if any(FILE.geo(i).fc(j,:))
            nCF=nCF+1;
            CF_DEF(nCF).nwing=i; %#ok<AGROW>
            CF_DEF(nCF).nelm=j; %#ok<AGROW>
        end
    end
end

if nCF==0
    disp(' No Control Surface Available for Current Input File ')
    MultiResults=[];
    return
end
disp ('-------------------Input the Analysis Condition----------->')
disp ('       Available Combinations of WingID and ElemID      ')
fprintf('WingID   ')
for i=1:nCF
    fprintf('\t %d ',CF_DEF(i).nwing)
end
fprintf('\n')
fprintf('ElemID   ')
for i=1:nCF
    fprintf('\t %d ',CF_DEF(i).nelm)
end
fprintf('\n')

IsERR=1;
while IsERR==1
    tline=input('Control Surface Index with Deflection Pattern{ WingID, ElemID[sIngle,Symetric,Differencial }:  ','s');   
    if ~isempty(tline)
        TmpStr=tline(end);
        if ~isnan(str2double(TmpStr))  %���������Ƿ�����ĸ
            DP=0;    %��������ƫת 
        else
            if strcmpi(TmpStr,'i')
                DP=0;
            elseif strcmpi(TmpStr,'s')
                DP=1;
            elseif strcmpi(TmpStr,'d')
                DP=2;
            end
            tline=tline(1:end-1);
        end
        A1=strfind(tline,',');
        if ~isempty(A1)   %�Ƿ��ж���
            WingID=str2double(tline(1:A1));
            ElemID=str2double(tline(A1+1:end));
            if any(FILE.geo(WingID).fc(ElemID))
                IsERR=0;
            end
        end
    else
        return
    end
    if IsERR==1 
        disp('Invalid Control Surface ID, Leave Blank to Terminate')
    end
end

tline=input('Control Surface Deflection Angle { Start > End, Angle Step }:  ','s');   
if ~isempty(tline)
    A1=strfind(tline,',');
    A2=strfind(tline,'>');
    if ~isempty(A1)   %�Ƿ��нǶȼ��
        ANGstp=deg2rad(str2double(tline(A1+1:end)));
        tline=tline(1:A1-1);
    else
        ANGstp=deg2rad(1);
    end

    if ~isempty(A2)   %�Ƿ����ٶȷ�Χ
        ANG0=deg2rad(str2double(tline(1:A2-1)));
        ANG1=deg2rad(str2double(tline(A2+1:end)));
    else
        ANG0=deg2rad(str2double(tline));
        ANG1=ANG0;
    end
    if ANG1<ANG0 
        ANGstp=-abs(ANGstp);
    end
    ANG=ANG0:ANGstp:ANG1;
    nANG=length(ANG);
else
    return
end    

    
%����ɶ����ƫת״̬��PROC����
if ~contains(cmdline,'n')
    tic
    fprintf('Preparing Solver Mesh.................')
end
%����޶���ƫתʱ����������
[PROC(nANG),TmpResults.friction]=pre_general(FILE,'nd'); 

% ����ÿ������ƫת������
for i=1:nANG
    PROC(i)=PROC(nANG);
    dlftANG=ANG(i);

    switch DP
        case 0   %����ƫת
            PROC(i).geo(WingID).deflect(ElemID,:)=[dlftANG,0];
        case 1   %�Գ�ƫת
            PROC(i).geo(WingID).deflect(ElemID,:)=[dlftANG,dlftANG];
        case 2   %�ƫת
            PROC(i).geo(WingID).deflect(ElemID,:)=[dlftANG,-dlftANG];
    end
    PROC(i).MESH=pre_Deflect(PROC(i));            %����ƫת
    if PROC(i).state.GND_EFF==1
        PROC(i).sMESH=pre_sMESH(PROC(i));    
    end
    PROC(i).OBJ_MESH=pre_form_MESH(PROC(i));          %V1->P1\P2,�������һ�֣������Ǹ���ԭ����
end

if ~contains(cmdline,'n')
    fprintf('Time Consumption %2.2f s\n',toc)
    tic
    fprintf('Aerodynamic Load Solving.................')
end

for i=nANG:-1:1
    TmpResults.PTL=solver_ADload(PROC(i),'n');
    TmpResults=coeff_create3(TmpResults,PROC(i));
    TmpResults.ANG=ANG(i);
    MultiResults(i)=TmpResults;
end

if ~contains(cmdline,'n')
    fprintf('Time Consumption %2.2f s\n',toc)
end

PROC0=PROC(1);
PROC0.CF=[WingID,ElemID,DP];
PROC0.ANG=ANG;

if ~contains(cmdline,'n')
    post_fastview(MultiResults,PROC0,'ADdflt')
end



end
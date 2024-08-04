function [CASE]=load_define(resfiles,cmdline)
%CASE��->Files().geo;state;ref;inertias
%cmdline-->    n����ʾ���ζ���ͼ   [s]/m����/���ļ���ȡ
fclose all;
if nargin==0 
    Is_UIopenfile=1;
    cmdline='s';
elseif nargin==1
    Is_UIopenfile=0;
    cmdline='sn';
elseif nargin==2
    if ~isempty(resfiles)
        Is_UIopenfile=0;
    else
        Is_UIopenfile=1;
    end
    cmdline=lower(cmdline);
end

if Is_UIopenfile==1
    if contains(cmdline,'m')
        [res_name,res_path]=main_getfile(1);
    else
        [res_name,res_path]=main_getfile();
    end
    if isempty(res_name)
        CASE=[];
        return
    else
        resfiles=strcat(res_path,res_name);
    end
end

if ~iscell(resfiles)
    nF=1;
    resfiles={resfiles};
else
    nF=length(resfiles);
end
CASE.Files(nF)=struct('geo',[],'state',[],'ref',[],'inertias',[],'CATfile',[]);

for i=1:nF
    resfile=resfiles{i};
    disp --------------------------------------------------------------------------------
    disp( ['��ȡ�ļ�    ' resfile])
    disp --------------------------------------------------------------------------------
    
    [geo,CATfile,Name,drawtype]=autoac(resfile);  %��ȡ������Ϣ
    [state, ref]=autoSR(resfile); %��ȡ����״̬��Ϣ
    geo=autodeflect(resfile,geo);     %��ȡ����ƫ����Ϣ
    inertias=autoint(resfile);        %��ȡ������Ϣ
    scales=autoscale(resfile);        %��ȡ������Ϣ

    CASE.Files(i).CATfile=CATfile;
    CASE.Files(i).drawtype=drawtype;
    CASE.Files(i).geo=geo;
    CASE.Files(i).state=state;
    CASE.Files(i).ref=ref;
    CASE.Files(i).inertias=inertias;
    CASE.Files(i).name=Name;
    CASE.Files(i).scales=scales;
    
    
    if drawtype(1)~='0' && ~contains(cmdline,'n')
        TMP.state=state;
        TMP.geo=geo;
        TMP.name=Name;
        TMP.CATfile=CATfile;
        TMP.ref=ref;
        TMP.drawtype=drawtype;
        TMP.P_nx=pre_NODEpercent(TMP);  %�������������򻮷ֵİٷֱ�
        TMP.NODE=pre_NODE(TMP);    %��������ڵ�����
        TMP.ref=pre_REFgeo(TMP);
        [TMP.MESH,TMP.HINGE]=pre_MESH(TMP);
        TMP.MESH=pre_Deflect(TMP);
        if ~isempty(strfind(TMP.drawtype,'1'))
            geometryplot(TMP,1)
        end
        if ~isempty(strfind(TMP.drawtype,'2'))
            geometryplot(TMP,2)
        end
    
    end

end





end

function [geo,CATfile,Name,drawtype]=autoac(resfile) %��ȡ���������β���
Cterm='$geometry';
    
res=fopen(resfile);
readflag=0;
while readflag==0
    tline=readline(res);
    if length(tline)>=length(Cterm)
        if strcmp(tline(1:length(Cterm)),Cterm)
            readflag=1;
        end
    end
    if feof(res)
        disp('�ļ����ڴ����Ҳ����ɻ����ζ�����Ϣ')
        return
    end
end


%���Ʊ������Ƿ�ͼ����ʾ��ǰͼ��
tline=readline(res);
drawtype=tline;

i=0;
while feof(res)==0 %%���ζ�ȡ�ļ���ÿһ��
    tline=readline(res);
    if isempty(tline),break,end

    if tline(1)=='#' || tline(1)=='$'
        % �����µĻ���ʼ
        if i>=1
            geo(i)=A; %#ok<AGROW>
        end
        if tline(1)=='#'
            i=i+1;
            j=0;
            stepper=0;
            clear A
            A.symetric=[];
            A.nx=[];
            A.ismain=[];
            A.startx=[];
            A.starty=[];
            A.startz=[];
            A.c=[];
            A.foil={};
            A.wingtype=[];
            A.b=[];
            A.SW=[];
            A.dihed=[];
            A.TW=[];
            A.ny=[];
        else
            break;
        end
    end

    switch stepper
        case 0

        case 1 %�Ƿ�Գ�	����������	�Ƿ�Ϊ������
            buf=splitstr(tline,char(9));%��TAB�ַ��ָ��ַ���
            A.symetric=str2double(buf(1));
            A.nx=str2double(buf(2));
            A.ismain=str2double(buf(3));

        case 2 %����ǰԵx����,����ǰԵy����,����ǰԵz����,���ҳ�,����Ťת��,����,��ģ��ʽ��1=��ͨ��ʽ 2=��ֱβ��
            buf=splitstr(tline,char(9));%��TAB�ַ��ָ��ַ���
            A.startx=str2double(buf(1));
            A.starty=str2double(buf(2));
            A.startz=str2double(buf(3));
            A.c(1)=str2double(buf(4));
            A.TW(1,1)=deg2rad(str2double(buf(5)));
            A.foil(1)=buf(6);
            A.wingtype=str2double(buf(7));
           

        otherwise %��ȡ���������Ϣ
            j=j+1;
            buf=splitstr(tline,char(9));%��TAB�ַ��ָ��ַ���
            %���չ��,���ҳ�,ǰԵ���ӽ�,�Ϸ���,�Ҳ�Ťת��,�Ҳ�����,չ��������,-
            %չ���������ɷ�ʽ,��Ե�����ٷֱ�
            A.b(j)=str2double(buf(1));
            A.c(j+1)=str2double(buf(2));
            A.SW(j)=str2double(buf(3))*pi/180;
            A.dihed(j)=str2double(buf(4))*pi/180;
            A.TW(j+1)=str2double(buf(5))*pi/180;
            A.foil(j+1)=buf(6);
            A.ny(j)=str2double(buf(7));
            

    end %%switch stepper
    
    stepper=stepper+1;
    
end %while feof(res)==0 %%���ζ�ȡ�ļ���ÿһ��

T=strfind(resfile,'.');
CATfile=[resfile(1:T(end)) 'CATin']; %T(end)��ֹ�ļ����д��ڶ��'.'
if isempty(dir(CATfile))
    CATfile=[];
end

for i=1:length(geo)
    if ~isempty(geo(i).ny)
        nelem=length(geo(i).ny);
        geo(i).fc=zeros(nelem,2); 
        geo(i).deflect=zeros(nelem,2); 
    end
end
if ~isempty(CATfile)
    geo=CATfile_Head(CATfile,geo);
end

    
nwing=length(geo);
s=0;
for i=1:nwing
    if geo(i).ismain==1
        s=s+1;
    end
end
if s~=1
    disp('����ȱ����������Ϣ���޷�����������ϵ�������')
end



for i=1:nwing
    if isfield(geo(i),'wingtype')
        if geo(i).wingtype==2 
            if geo(i).starty==0 && geo(i).dihed(1)==pi/2 && geo(i).symetric==1
                geo(i).symetric=0;
                beep
                disp ('*****************************************************')
                disp (' ��������ڴ���λ�ڶԳ���Ĵ�ֱβ�� - �Ƿ�Գ�ӦΪ0')
                disp ('*****************************************************')
            end
        end
    end
end

fclose(res);
Name=resfile(max(strfind(resfile,'\'))+1:end-3);

end  



function [state,ref]=autoSR(resfile)
Cterm='$state';    
res=fopen(resfile);

readflag=0;
while readflag==0
    tline=readline(res);
    if length(tline)>=length(Cterm)
        if strcmp(tline(1:length(Cterm)),Cterm)
            readflag=1;
        end
    end
    if feof(res)
        disp('�ļ����ڴ����Ҳ�������״̬������Ϣ')
        return
    end
end

%%��ȡ�ο��㶨��
tline=readline(res);
A1=strfind(tline,'%');

if ~isempty(A1)
    point=str2double(tline(1:A1-1));
    ref.ref_point=ref.mac_pos_M+[point*ref.C_mac_M/100 0 0];
else
    A2=strfind(tline,',');
    ref.ref_point(1)=str2double(tline(1:A2(1)-1));
    ref.ref_point(2)=str2double(tline(A2(1)+1:A2(2)-1));
    ref.ref_point(3)=str2double(tline(A2(2)+1:end));
end

%%��ȡӭ��
tline=readline(res);
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

state.alpha0=AoA0:AoAstp:AoA1;

%%��ȡ�໬��
tline=readline(res);
A1=strfind(tline,',');
A2=strfind(tline,'>');
if ~isempty(A1)
    AoSstp=str2double(tline(A1+1:end))*pi/180;
    tline=tline(1:A1-1);
else
    AoSstp=pi/180;
end
if ~isempty(A2)
    AoS0=str2double(tline(1:A2-1))*pi/180;
    AoS1=str2double(tline(A2+1:end))*pi/180;
else
    AoS0=str2double(tline)*pi/180;
    AoS1=str2double(tline)*pi/180;
end

state.beta0=AoS0:AoSstp:AoS1;

state.alpha=state.alpha0(1);
state.beta=state.beta0(1);

%%��ȡ�ٶ�
tline=readline(res);
A1=strfind(tline,',');
A2=strfind(tline,'>');
if ~isempty(A1)
    ASnum=str2double(tline(A1+1:end));
    tline=tline(1:A1-1);
else
    ASnum=2;
end
if ~isempty(A2)
    AS0=str2double(tline(1:A2-1));
    AS1=str2double(tline(A2+1:end));
else
    AS0=str2double(tline);
    AS1=str2double(tline);
end
state.AS0=AS0:(AS1-AS0)/(ASnum-1):AS1;
if AS1==AS0
    state.AS=AS0;
    state.AS0=AS0;
else
    state.AS=state.AS0(1);
end





%%��ȡ�߶�
tline=readline(res);
buf=sscanf(tline,'%f');
state.ALT=buf(1);

%%��ȡ�����ٶ�
tline=readline(res);
buf=sscanf(tline,'%f');
state.P=buf(1)*pi/180;
state.Q=buf(2)*pi/180;
state.R=buf(3)*pi/180;



%%ʹ��������-���Ͷ���(Prandtl-Glauert)��������?
tline=readline(res);
state.pgcorr=str2double(tline);

%%�������ЧӦ
tline=readline(res);
state.GND_EFF=str2double(tline);

state.inst=1;

%%β�д���ʽ
tline=readline(res);
state.wakelength=str2double(tline);

%alpha_dot��beta_dot
state.alpha_dot=0;
state.beta_dot=0;
fclose(res);
end


function geo=autodeflect(resfile,geo) %��ȡ����ƫ����Ϣ
Cterm='$surface';
res=fopen(resfile);

readflag=0;
while readflag==0
    tline=readline(res);
    if length(tline)>=length(Cterm)
        if strcmp(tline(1:length(Cterm)),Cterm)
            readflag=1;
        end
    end
    if feof(res)
        disp('�ļ��в����ڶ��涨����Ϣ')
        return
    end
end

while feof(res)==0 %%���ζ�ȡ�ļ���ÿһ��
    tline=readline(res);
    if isempty(tline),break,end
    if strcmp(tline(1),'$') ,break,end

    buf=sscanf(tline,'%f %f %f %f %f %f');
    if length(buf)~=6
        disp �ļ����йض���Ĳ��ֶ�����ڴ���
    end
    s=buf(1);
    t=buf(2);
    if geo(s).nx<2   %��չ��������̫�ٲ����Բ��ö���
        disp (['����' num2str(s) '��չ��������̫�ٲ����Բ��ö���,���涨����Ч' ])
        beep
        pause (3)
    else
        geo(s).fc(t,:)=[buf(3) buf(4)];
        geo(s).deflect(t,:)=[deg2rad(buf(5)) deg2rad(buf(6))];
    end
   
end

fclose(res);
end

function inertias=autoint(resfile)
Cterm='$inertia';
res=fopen(resfile);

readflag=0;
while readflag==0
    tline=readline(res);
    if length(tline)>=length(Cterm)
        if strcmp(tline(1:length(Cterm)),Cterm)
            readflag=1;
        end
    end
    if feof(res)
        disp('�ļ��в�����������Ϣ')
        inertias=[];
        return
    end
end


while feof(res)==0 %%���ζ�ȡ�ļ���ÿһ��
    tline=readline(res);
    if isempty(tline),break,end
    if strcmp(tline(1),'$') ,break,end

    if strcmp(tline,'#Ix')
        tline=readline(res);
        inertias.Ix=str2double(tline);
    end
    
    if strcmp(tline,'#Iy')
        tline=readline(res);
        inertias.Iy=str2double(tline);
    end
    
    if strcmp(tline,'#Iz')
        tline=readline(res);
        inertias.Iz=str2double(tline);
    end
        
    if strcmp(tline,'#Ixy')
        tline=readline(res);
        inertias.Ixy=str2double(tline);
    end
    
    if strcmp(tline,'#Iyz')
        tline=readline(res);
        inertias.Iyz=str2double(tline);
    end
    
    if strcmp(tline,'#Izx')
        tline=readline(res);
        inertias.Izx=str2double(tline);
    end
    
    if strcmp(tline,'#m')
        tline=readline(res);
        inertias.m=str2double(tline);
    end
    
end

fclose(res);
end

function scales=autoscale(resfile)
Cterm='$scale';
res=fopen(resfile);

readflag=0;
while readflag==0
    tline=readline(res);
    if length(tline)>=length(Cterm)
        if strcmp(tline(1:length(Cterm)),Cterm)
            readflag=1;
        end
    end
    if feof(res)
        scales=[];
        return
    end
end

disp ('�ļ��а�����������������Ϣ')
while feof(res)==0 %%���ζ�ȡ�ļ���ÿһ��
    tline=readline(res);
    if isempty(tline),break,end
    if strcmp(tline(1),'$') ,break,end

    scales.s_geo=str2double(tline);
end

fclose(res);
end
function allstate=main_allstate(cmdline)
% cmdline    
% s/S ���ٶ�/���ٶ�
% h-�߶�   a/A-��ӭ��/��ӭ��
% 

if nargin==0
    cmdline='';
end

recent=main_recent;

disp ('-------------------ȷ��������----------->')

%��ⵥӭ��
if contains(cmdline,'a')
    tline=input(['���ӭ�� < Ĭ�� ' num2str(rad2deg(recent.alpha)) ' > [deg] ']);
    if ~isempty(tline)
        allstate.alpha=deg2rad(tline);
    else
        allstate.alpha=recent.alpha;
    end
    allstate.alpha0=allstate.alpha;
    recent.alpha=allstate.alpha;
end
%����ӭ��
if contains(cmdline,'A')
end
    
%���߶�
if contains(cmdline,'h')
    tline=input(['���߶� < Ĭ�� ' num2str(recent.ALT) ' > [m]   ']);
    if ~isempty(tline)
        allstate.ALT=tline;
    else
        allstate.ALT=recent.ALT;
    end
    recent.ALT=allstate.ALT;
    allstate.rho=ISAtmosphere(allstate.ALT);
end

%������ٶ�
if contains(cmdline,'s')
    tline=input(['����ٶ� < Ĭ�� ' num2str(recent.AS) ' > [m/s] ']);
    if ~isempty(tline)
        allstate.AS=tline;
    else
        allstate.AS=recent.AS;
    end
    allstate.AS0=allstate.AS;
    recent.AS=allstate.AS;
end
%������ٶ�
if contains(cmdline,'S')
    tline=input(['����ٶȷ�Χ��ȡ������ < Ĭ�� ' num2str(recent.AS0(1)) '>' num2str(recent.AS0(end)) ','  num2str(length(recent.AS0)) ' > [m/s] '],'s');
    if ~isempty(tline)
        A1=strfind(tline,',');
        A2=strfind(tline,'>');
        if ~isempty(A1)   %�Ƿ���ȡ������
            ASnum=str2double(tline(A1+1:end));
            tline=tline(1:A1-1);
        else
            ASnum=3;
        end

        if ~isempty(A2)   %�Ƿ����ٶȷ�Χ
            AS0=str2double(tline(1:A2-1));
            AS1=str2double(tline(A2+1:end));
        else
            AS0=str2double(tline)*0.9;
            AS1=str2double(tline)*1.1;
        end
        allstate.AS0=AS0:(AS1-AS0)/(ASnum-1):AS1;
    else
        allstate.AS0=recent.AS0;
    end
    recent.AS0=allstate.AS0;
end




main_recent(recent);
end
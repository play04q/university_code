function allstate=main_allstate(cmdline)
% cmdline    
% s/S 单速度/多速度
% h-高度   a/A-单迎角/多迎角
% 

if nargin==0
    cmdline='';
end

recent=main_recent;

disp ('-------------------确定求解参数----------->')

%求解单迎角
if contains(cmdline,'a')
    tline=input(['求解迎角 < 默认 ' num2str(rad2deg(recent.alpha)) ' > [deg] ']);
    if ~isempty(tline)
        allstate.alpha=deg2rad(tline);
    else
        allstate.alpha=recent.alpha;
    end
    allstate.alpha0=allstate.alpha;
    recent.alpha=allstate.alpha;
end
%求解多迎角
if contains(cmdline,'A')
end
    
%求解高度
if contains(cmdline,'h')
    tline=input(['求解高度 < 默认 ' num2str(recent.ALT) ' > [m]   ']);
    if ~isempty(tline)
        allstate.ALT=tline;
    else
        allstate.ALT=recent.ALT;
    end
    recent.ALT=allstate.ALT;
    allstate.rho=ISAtmosphere(allstate.ALT);
end

%单求解速度
if contains(cmdline,'s')
    tline=input(['求解速度 < 默认 ' num2str(recent.AS) ' > [m/s] ']);
    if ~isempty(tline)
        allstate.AS=tline;
    else
        allstate.AS=recent.AS;
    end
    allstate.AS0=allstate.AS;
    recent.AS=allstate.AS;
end
%多求解速度
if contains(cmdline,'S')
    tline=input(['求解速度范围，取点数量 < 默认 ' num2str(recent.AS0(1)) '>' num2str(recent.AS0(end)) ','  num2str(length(recent.AS0)) ' > [m/s] '],'s');
    if ~isempty(tline)
        A1=strfind(tline,',');
        A2=strfind(tline,'>');
        if ~isempty(A1)   %是否有取点数量
            ASnum=str2double(tline(A1+1:end));
            tline=tline(1:A1-1);
        else
            ASnum=3;
        end

        if ~isempty(A2)   %是否有速度范围
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
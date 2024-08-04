function [res_name,res_path]=main_getfile(isMultiSelect)
%% 
if nargin<1
    isMultiSelect=0;
end

recent=main_recent();

if isMultiSelect==0

    def_res=[recent.res_path recent.res_name];
    [res_name,res_path,~]=uigetfile({'*.in','外形定义文件'},'选择外形及参数定义...',def_res);
    if ischar(res_path)
        recent.res_path=res_path;
        recent.res_name=res_name;
        main_recent(recent);
    else
        res_name=[];
        res_path=[];
    end
    
else
    
    def_res=[recent.res_path];
    if iscell(recent.res_mname)
        for i=1:length(recent.res_mname)
            def_res=[def_res '"' recent.res_mname{i} '" ']; %#ok<AGROW>
        end
    else
            def_res=[def_res '"' recent.res_mname '" '];
    end

    [res_mname,res_path,~]=uigetfile({'*.in','外形定义文件'},'选择外形及参数定义...',def_res,'MultiSelect','on');
    if ischar(res_path)
        recent.res_path=res_path;
        recent.res_mname=res_mname;
        res_name=res_mname;
        main_recent(recent);
    else
        res_name=[];
        res_path=[];
    end
    
end
    
end
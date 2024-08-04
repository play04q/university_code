function output=readline(res)
ok=0;
while ok==0 && feof(res)==0  
    tline=fgetl(res);
    ok=1;
    if isempty(tline)
        ok=0;
        continue
    end
    tline(findstr(tline,'"'))=[];
    if tline(1)=='%'
        ok=0;
        continue
    end
    if (double(tline(1))==9 || double(tline(1))==32) && length(unique(tline))==1
        ok=0;
        continue
    end
    if ok==1 
        output=tline;
        return
    end
end

output=[];
end

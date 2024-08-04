function XYZs=CATfile_readSEC(CATfile,SEC_name)
res=fopen(CATfile);
loop=1;
while loop==1
    tline=readline(res);
    if tline(1)=='#' && tline(2)==SEC_name(1)
        buf=sscanf(tline(2:end),'%d %d %d');
        nPTonCHORD=buf(3);
        loop=0;
    end
end
XYZs=[];
cmp_name=['$' SEC_name];
while feof(res)==0 %%依次读取文件的每一行
    tline=readline(res);
    if strcmp(cmp_name,tline(1:end))
        XYZs=zeros(nPTonCHORD,3);
        for i=1:nPTonCHORD
            tline=readline(res);
            buf=splitstr(tline,',');%以','字符分割字符串
            XYZs(i,1)=-str2double(buf(1))/1000;
            XYZs(i,2)=str2double(buf(2))/1000;
            XYZs(i,3)=str2double(buf(3))/1000;
        end
        if XYZs(1,1)>XYZs(end,1)
            IDX=nPTonCHORD:-1:1;
            XYZs=XYZs(IDX,:);
        end
        break
    end
end


fclose(res);

end

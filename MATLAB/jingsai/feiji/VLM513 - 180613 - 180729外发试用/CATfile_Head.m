function  geo=CATfile_Head(CATfile,geo)
res=fopen(CATfile);
tline=readline(res);
buf=sscanf(tline,'%d');
nwing=buf(1); %#ok<NASGU>

i=0;
loop=1;
while loop==1 
    tline=readline(res);
    if tline(1)=='$'
        loop=0;
    elseif tline(1)=='#'
        i=i+1;
        if ~isempty(geo(i).b)
            CATready=0;
        else
            CATready=1;
        end

        if CATready==1
            buf=sscanf(tline(2:end),'%d %d %d');
            nelem=buf(2);
            geo(i).nPTonCHORD=buf(3);
            geo(i).ny=zeros(1,nelem);

            geo(i).fc=zeros(nelem,2);
            geo(i).deflect=zeros(nelem,2);
        end
    else
        if CATready==1
            buf=sscanf(tline,'%d %d %d');
            geo(i).ny(buf(2))=buf(3);
        end
    end
end
fclose(res);

end
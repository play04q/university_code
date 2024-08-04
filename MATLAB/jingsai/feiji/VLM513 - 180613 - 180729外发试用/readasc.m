function [Xinterp,Yinterp]=readasc(ascfile)
Xinterp=0:(1/400):1;
res=fopen(ascfile);
X=[];
Y=[];
readflag=1;
i=1;
while readflag==1
    tline=readline(res);
    if ~isempty(tline)
        buf=splitstr(tline,' ');
        X(i)=str2double(buf(2));
        Y(i)=str2double(buf(6));
        i=i+1;
    end
    if feof(res)==1
        readflag=0;
    end
end
[X,idx]=sort(-X);
Y=Y(idx);
C=X(end)-X(1);
X=(X-X(1))/C;
Y=Y/C;
Yinterp=interp1(X,Y,Xinterp);
fclose(res);
end

function [LE,TE]=Geo_wing(geo,s)
nelem=length(geo(s).b);
tLE=zeros(nelem+1,3);
tTE=tLE;
tHINGE=zeros(nelem,2,3);
for t=1:nelem
    %前缘点
    if t==1
        tLE(t,1)=geo(s).startx;	 %#ok<*AGROW> %Element apex calculation
        tLE(t,2)=geo(s).starty;	 % Same-o
        tLE(t,3)=geo(s).startz;  % Same-o

        tTE(t,1)=tLE(t,1)+geo(s).c(t);
        tTE(t,2)=tLE(t,2);
        tTE(t,3)=tLE(t,3)-geo(s).c(t)*tan(geo(s).TW(t));
    end
    if geo(s).wingtype==1    %%一般机翼
        tLE(t+1,1)=tLE(t,1)+geo(s).b(t)*tan(geo(s).SW(t));
        tLE(t+1,2)=tLE(t,2)+geo(s).b(t);
        tLE(t+1,3)=tLE(t,3)+geo(s).b(t)*tan(geo(s).dihed(t));

        %后缘点
        tTE(t+1,1)=tLE(t+1,1)+geo(s).c(t+1);
        tTE(t+1,2)=tLE(t+1,2);
        tTE(t+1,3)=tLE(t+1,3)-geo(s).c(t+1)*tan(geo(s).TW(t+1));
    else     %%尾翼
        tLE(t+1,1)=tLE(t,1)+geo(s).b(t)*tan(geo(s).SW(t));
        tLE(t+1,2)=tLE(t,2)+geo(s).b(t)*cos(geo(s).dihed(t));
        tLE(t+1,3)=tLE(t,3)+geo(s).b(t)*sin(geo(s).dihed(t));

        %后缘点
        tTE(t+1,1)=tLE(t+1,1)+geo(s).c(t+1);
        tTE(t+1,2)=tLE(t+1,2)+sin(geo(s).dihed(t))*geo(s).c(t+1)*tan(geo(s).TW(t+1));
        tTE(t+1,3)=tLE(t+1,3)-cos(geo(s).dihed(t))*geo(s).c(t+1)*tan(geo(s).TW(t+1));
    end
    if ~(geo(s).fc(t,1)==0 && geo(s).fc(t,2)==0)
        tHINGE(t,1,:)=tTE(t,:)+(tLE(t,:)-tTE(t,:)).*geo(s).fc(t,1);
        tHINGE(t,2,:)=tTE(t+1,:)+(tLE(t+1,:)-tTE(t+1,:))*geo(s).fc(t,2);
    end

end
LE=tLE;
TE=tTE;


end
function [P_nx]=pre_NODEpercent(PROC)  % 根据舵面需要调整网格
geo=PROC.geo;
nwing=length(geo);
for s=1:nwing
    nelem=length(geo(s).ny);
    
    nx=geo(s).nx;
    percent=zeros(nelem+1,nx+1);
    hinge0=zeros(1,nelem);
    
    %新的算法，首先将连续的舵面沿展向分段
    %Flap_SAG(NSEG,1:4)=[起始翼段 终止翼段 平均弦长 铰链线弦向顺序号]
    FLAG_Status=1;
    NSEG=1;
    Flap_SEG=0;
    for t=1:nelem
        if FLAG_Status==1
            if geo(s).fc(t,1)~=0
                Flap_SEG(NSEG,1)=t;
                FLAG_Status=2;
            end
        end
        if FLAG_Status==2
            if t==nelem
                Flap_SEG(NSEG,2)=t;
                A=Flap_SEG(NSEG,1);
                B=Flap_SEG(NSEG,2);
                fc_avg=mean([geo(s).fc(A:B,1);geo(s).fc(A:B,2)]);
                Flap_SEG(NSEG,3)=fc_avg;
                nHINGE_line=fix((1-fc_avg)/(1/nx)+.5);   %铰链线在展向网格线的顺序号
                if nHINGE_line==nx
                    nHINGE_line=nx-1;
                end
                Flap_SEG(NSEG,4)=nHINGE_line;
                NSEG=NSEG+1;
                FLAG_Status=1;
            elseif geo(s).fc(t+1,1)==0
                Flap_SEG(NSEG,2)=t;
                A=Flap_SEG(NSEG,1);
                B=Flap_SEG(NSEG,2);
                fc_avg=mean([geo(s).fc(A:B,1);geo(s).fc(A:B,2)]);
                Flap_SEG(NSEG,3)=fc_avg;
                nHINGE_line=fix((1-fc_avg)/(1/nx)+.5);   %铰链线在展向网格线的顺序号
                if nHINGE_line==nx
                    nHINGE_line=nx-1;
                end
                Flap_SEG(NSEG,4)=nHINGE_line;
                NSEG=NSEG+1;
                FLAG_Status=1;
            elseif geo(s).fc(t+1,1)~=geo(s).fc(t,2)
                Flap_SEG(NSEG,2)=t;
                A=Flap_SEG(NSEG,1);
                B=Flap_SEG(NSEG,2);
                fc_avg=mean([geo(s).fc(A:B,1);geo(s).fc(A:B,2)]);
                Flap_SEG(NSEG,3)=fc_avg;
                nHINGE_line=fix((1-fc_avg)/(1/nx)+.5);   %铰链线在展向网格线的顺序号
                if nHINGE_line==nx
                    nHINGE_line=nx-1;
                end
                Flap_SEG(NSEG,4)=nHINGE_line;
                NSEG=NSEG+1;
                FLAG_Status=1;
            end
        end
    end
    %检查网格nx是否足够
    NSEG=NSEG-1;
    for i=1:NSEG-1
        if Flap_SEG(i,2)==Flap_SEG(i+1,1)-1
            if Flap_SEG(i,4)==Flap_SEG(i+1,4)
                beep
                error(['翼面#' num2str(s) '弦向网格数设置不足以满足舵面布置需要,请酌情增加'])
            end
        end
    end
    %
    Is_flap=0;
    SEGid=0;
    for t=1:nelem+1
        if Is_flap==0
            if any(t==Flap_SEG(:,1))
                Is_flap=1;
                SEGid=SEGid+1;
            else
                hinge0(t)=0;
                percent(t,:)=(0:nx)./nx;
                %percent(t,:)=sin(-pi/2+(0:nx)./nx*pi/2)+1;
            end
        end
        
        if Is_flap==2
            hinge0(t-1)=Flap_SEG(SEGid,4);
            if SEGid<NSEG
                if t==Flap_SEG(SEGid+1,1)
                    FLAG_2flaps=1;
                else
                    FLAG_2flaps=0;
                end
            else
                FLAG_2flaps=0;
            end
            
            if FLAG_2flaps==1
                Nf=[Flap_SEG(SEGid,4) Flap_SEG(SEGid+1,4)];
                fc=[geo(s).fc(t-1,2) geo(s).fc(t,1)];
                [n1,x]=min(Nf);
                [n2,y]=max(Nf);
                C1=(0:n1)/n1*(1-fc(x));
                C2=(1-fc(x))+(1:(n2-n1))/(n2-n1)*(fc(x)-fc(y));
                C3=(1-fc(y))+(1:(nx-n2))/(nx-n2)*fc(y);
                percent(t,:)=[C1 C2 C3];
                Is_flap=2;
                SEGid=SEGid+1;
            else
                Nf=Flap_SEG(SEGid,4);
                C1=(0:Nf)/Nf*(1-geo(s).fc(t-1,2));
                C2=(1-geo(s).fc(t-1,2))+(1:(nx-Nf))/(nx-Nf)*geo(s).fc(t-1,2);
                percent(t,:)=[C1 C2];
                if t-1==Flap_SEG(SEGid,2)
                    Is_flap=0;
                end
            end
            
        end
        
        if Is_flap==1
            Nf=Flap_SEG(SEGid,4);
            C1=(0:Nf)/Nf*(1-geo(s).fc(t,1));
            C2=(1-geo(s).fc(t,1))+(1:(nx-Nf))/(nx-Nf)*geo(s).fc(t,1);
            percent(t,:)=[C1 C2];
            Is_flap=2;
        end
            
      
    end
    
    P_nx(s).percent=percent;
    P_nx(s).hinge=hinge0;
end
end
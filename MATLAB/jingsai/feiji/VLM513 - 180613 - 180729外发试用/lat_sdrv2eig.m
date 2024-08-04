function [M_EIG,M_DYN]=lat_sdrv2eig(PROC,cmdline)
%求出特征根，并识别特征根对应的模态
%功能应包括速度、迎角扫掠和单独状态的
% MEig[速度ID,迎角ID,模态ID]  1-滚转收敛  2/3-荷兰滚  4-螺旋 
% 这个程序写的其实并不完善，没有考虑出现两对复根时候怎么处理。优先级不高，就先不管了
if nargin==1
    cmdline='';
end

nV=length(PROC.state.AS0);
nA=length(PROC.M_SDRV);
M_EIG=zeros(nV,nA,4);
for i=1:nV
    PROC.state.AS=PROC.state.AS0(i);
    for j=1:nA
        STB_LATin.DRVs=PROC.M_SDRV(j);
        STB_LATin.AS=PROC.state.AS0(i);
        STB_LATin.rho=PROC.state.rho;
        
        STB_LATin.CD=PROC.M_SDRV.CD;
        
        STB_LATin.ref=PROC.ref;
        STB_LATin.inertias=PROC.inertias;
        
        [eigvalue]=lat_eig(STB_LATin);
        M_EIG(i,j,:)=eigvalue;
    end
    
    %特征根排序
    % 从后往前，找到第一个标准的2个实根，2个虚根的状态
    TMPT=[];
    for j=nA:-1:1
        im=size(find(imag(M_EIG(i,j,:))~=0),1);
        re=size(find(imag(M_EIG(i,j,:))==0),1);
        if im==2 && re==2
            TMPT=j;
            break
        end
    end
    
    if isempty(TMPT)
        Eigs=squeeze(M_EIG)';
        if ~contains(cmdline,'n')
            disp ('注意：求解的所有模态特性中，均没有出现标准的<滚转收敛、荷兰滚、螺旋>模态')
            disp (Eigs)
        end

        M_DYN(i,j).DR.omega_nd=nan;%频率
        M_DYN(i,j).DR.zeta_d=nan;%阻尼比
        
        if sum(imag(Eigs)~=0)~=4   %存在实根时候
            [~,idx]=min(abs(Eigs));
            R_SPR=Eigs(idx);
            M_DYN(i,j).SPR.T2DA=0.693/R_SPR;
            M_DYN(i,j).SPR.REL=R_SPR;
            M_DYN(i,j).RM.TC=-1/min(Eigs);
        else   %不存在实根时候
            M_DYN(i,j).SPR.T2DA=nan;
            M_DYN(i,j).SPR.REL=nan;
            M_DYN(i,j).RM.TC=nan;
        end
    end

    if TMPT>=1
        for j=TMPT:-1:1
            if j==TMPT
                LEig=[];
            else
                LEig=squeeze(M_EIG(i,j+1,:));
            end
            CEig=squeeze(M_EIG(i,j,:));
            
            M_EIG(i,j,:)=sortEIG(CEig,LEig);
            M_DYN(i,j)=Eig2DYN(M_EIG(i,j,:));
        end
    end

    if TMPT<nA
        for j=TMPT+1:nA
            LEig=squeeze(M_EIG(i,j-1,:));
            CEig=squeeze(M_EIG(i,j,:));

            M_EIG(i,j,:)=sortEIG(CEig,LEig);
            M_DYN(i,j)=Eig2DYN(M_EIG(i,j,:));
        end

    end


end
end

function DYN_LAT=Eig2DYN(eigvalue)
eigvalue=squeeze(eigvalue);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%后处理

%显示荷兰滚频率和阻尼比
parta=real(eigvalue(2));
partb=imag(eigvalue(2));

if partb==0
    DYN_LAT.DR.omega_nd=nan;%频率
    DYN_LAT.DR.zeta_d=nan;%阻尼比
else
    DYN_LAT.DR.omega_nd=sqrt(parta^2+partb^2);%频率
    DYN_LAT.DR.zeta_d=-parta/DYN_LAT.DR.omega_nd;%阻尼比
end

DYN_LAT.SPR.T2DA=0.693/real(eigvalue(4));
DYN_LAT.SPR.REL=real(eigvalue(4));

DYN_LAT.RM.TC=-1/real(eigvalue(1));

end

function NEig=sortEIG(CEig,LEig)
im=size(find(imag(CEig)~=0),1);
re=size(find(imag(CEig)==0),1);

if im==2 && re==2   %当有两个实根、两个虚根时的排序
    %先找出两个实根模态、两各复根模态
    RSidx=zeros(1,2);   nRS=0;
    DRidx=zeros(1,2);   nDR=0;
    idx=zeros(1,4);
    for k=1:4
        if imag(CEig(k))==0 
            nRS=nRS+1;
            RSidx(nRS)=k;
        else
            nDR=nDR+1;
            DRidx(nDR)=k;
        end
    end
    if abs(CEig(RSidx(1)))>abs(CEig(RSidx(2)))  %找到两个实根模态，大实根对应滚转收敛模态
        idx(1)=RSidx(1);
        idx(4)=RSidx(2);
    else
        idx(1)=RSidx(2);
        idx(4)=RSidx(1);
    end
    if imag(CEig(DRidx(1)))>0    %荷兰滚模态两个根，把虚部是正的那个放到前面          
        idx(2)=DRidx(1);
        idx(3)=DRidx(2);
    else
        idx(2)=DRidx(2);
        idx(3)=DRidx(1);
    end
end

if  re==4   %四个实根时候
    C1=squeeze((LEig(1)+LEig(4))/2);%滚转收敛和螺旋模态，两根均值
    C2=squeeze((LEig(2)+LEig(3))/2);%荷兰滚模态，两根实部均值
    %先找到滚转收敛模态的根
    dis=squeeze(abs(LEig(1)-CEig));
    [~,idx(1)]=min(dis);

    %找到螺旋模态的根
    dis=abs(C1-squeeze((CEig(idx(1))+CEig(2:4))/2));  %除去前面的滚转模态实根，还剩下3个
    [~,Tmp]=min(dis);
    idx(4)=Tmp+1;   %因为1已经对应给滚转模态实根了

    %剩下的是荷兰滚模态
    DRidx=zeros(1,2);   nDR=0;
    for k=1:4
        if k~=idx(1) && k~=idx(4)
            nDR=nDR+1;
            DRidx(nDR)=k;
        end
    end
    if CEig(DRidx(1))>CEig(DRidx(2))  %荷兰滚退化模态，把大的实根放在前面
        idx(2)=DRidx(1);
        idx(3)=DRidx(2);
    else
        idx(2)=DRidx(2);
        idx(3)=DRidx(1);
    end
end

if im==4   %暂时先偷懒了
end

NEig=CEig(idx);
end
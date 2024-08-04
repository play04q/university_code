function [VDW,SW]=solver_VDW(Pin,Vin,SW)
%hl_limit;   %h/l的最小值
%hl_limit是一个有关计算数值稳定性的参数
%在141220版本前设置是1e-12。在141220版本，导入CATIA文件时Y=0截面会出现很小
%的数，使计算结果产生错误，因此将本参数调整为1e-7...
%进一步修改该参数，使04M的外侧副翼偏角为0.2DEG时，升阻比
%与偏转前相比发展趋势合理，得到3e-2

hl_limit=1e-7;%3e-2;

% VDW输出格式
% VDW[P, V, 3]
[Psize,~]=size(Pin);
[Vsize,~]=size(Vin);

lemmaP=ones(1,Psize);
lemmaV=ones(1,Vsize);

mDES(:,:,1)=Pin(:,1)*lemmaV;
mDES(:,:,2)=Pin(:,2)*lemmaV;
mDES(:,:,3)=Pin(:,3)*lemmaV;

mr1(:,:,1)=(Vin(:,1,1)*lemmaP)';
mr1(:,:,2)=(Vin(:,1,2)*lemmaP)';
mr1(:,:,3)=(Vin(:,1,3)*lemmaP)';

mr2(:,:,1)=(Vin(:,2,1)*lemmaP)';
mr2(:,:,2)=(Vin(:,2,2)*lemmaP)';
mr2(:,:,3)=(Vin(:,2,3)*lemmaP)';

r1=mDES-mr1;
r2=mDES-mr2;

%VDW=mega(r1,r2)/(4*pi);

%% 参考书见:钱翼稷.空气动力学[M].北京航空航天大学出版社,2008
%% Next part
Lr1=sqrt(sum(r1.^2,3)); 
Lr2=sqrt(sum(r2.^2,3));

R1(:,:,1)=r1(:,:,1)./Lr1;
R1(:,:,2)=r1(:,:,2)./Lr1;
R1(:,:,3)=r1(:,:,3)./Lr1;


R2(:,:,1)=r2(:,:,1)./Lr2;
R2(:,:,2)=r2(:,:,2)./Lr2;
R2(:,:,3)=r2(:,:,3)./Lr2;

L1=(R1-R2);

%MAng=acos(dot(R1,R2,3));     %求出r1,r2向量之间的夹角
%SW3=MAng<deg2rad(NearAngle) | MAng>pi-deg2rad(LineAngle);   %判断夹角是否已接近0，,即两点重合；或接近180度，即控制点接近涡线

%% First part
F1=cross(r1,r2,3);   %F1=0有两种情况：r1 r2 共线;其中任意一者为0
LF1=(sum(F1.^2,3));

%{
mFIX3(:,:,1)=(SW3);  %消除当r1 r2 共线时的无穷大
mFIX3(:,:,2)=(SW3);
mFIX3(:,:,3)=(SW3);
%}

%% Third part
R0=(r1-r2);   %r1=mDES-mr1 r2=mDES-mr2 -> R0=r1-r2
LR0=sqrt(sum(R0.^2,3));
%涡段长度为0判断
SW_l0=LR0==0;

SW_hl_limit_compneed=1;
if nargin==3
    if ~isempty(SW)
        SW_hl_limit_compneed=0;
    end
end

if SW_hl_limit_compneed==0
    SW_hl_limit=SW;
else
    %% 点到直线法向距离rp
    Lrp=sqrt(LF1)./sqrt(sum(R0.^2,3));
    Ratio_hl=Lrp./LR0;
    SW_hl_limit=Ratio_hl<hl_limit;
end

%0/0=nan
%当r1,r2共线时，其向量叉积等于0，叉积的模也等于0
%因此跑程序时控制点位于涡线段上造成的inf 出不来
F2(:,:,1)=F1(:,:,1)./(LF1);
F2(:,:,2)=F1(:,:,2)./(LF1);
F2(:,:,3)=F1(:,:,3)./(LF1);


%F2=Fac1AB(参考书P157)

%% combinging 2 and 3
L2=  R0(:,:,1).*L1(:,:,1)...
    +R0(:,:,2).*L1(:,:,2)...
    +R0(:,:,3).*L1(:,:,3);
%L2=Fac2AB(参考书P157)

%% Downwash
Tmp=F2(:,:,1).*L2;
%SW_hl_limit=[];
Tmp(SW_hl_limit)=0;
Tmp(SW_l0)=0;
VDW(:,:,1)=Tmp/(4*pi);

Tmp=F2(:,:,2).*L2;
Tmp(SW_hl_limit)=0;
Tmp(SW_l0)=0;
VDW(:,:,2)=Tmp/(4*pi);

Tmp=F2(:,:,3).*L2;
Tmp(SW_hl_limit)=0;
Tmp(SW_l0)=0;
VDW(:,:,3)=Tmp/(4*pi);

if nargin==3
    SW=SW_hl_limit;
end
end
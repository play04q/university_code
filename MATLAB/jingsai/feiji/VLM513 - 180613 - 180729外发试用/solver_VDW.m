function [VDW,SW]=solver_VDW(Pin,Vin,SW)
%hl_limit;   %h/l����Сֵ
%hl_limit��һ���йؼ�����ֵ�ȶ��ԵĲ���
%��141220�汾ǰ������1e-12����141220�汾������CATIA�ļ�ʱY=0�������ֺ�С
%������ʹ����������������˽�����������Ϊ1e-7...
%��һ���޸ĸò�����ʹ04M����ั��ƫ��Ϊ0.2DEGʱ�������
%��ƫתǰ��ȷ�չ���ƺ����õ�3e-2

hl_limit=1e-7;%3e-2;

% VDW�����ʽ
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

%% �ο����:Ǯ���.��������ѧ[M].�������պ����ѧ������,2008
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

%MAng=acos(dot(R1,R2,3));     %���r1,r2����֮��ļн�
%SW3=MAng<deg2rad(NearAngle) | MAng>pi-deg2rad(LineAngle);   %�жϼн��Ƿ��ѽӽ�0��,�������غϣ���ӽ�180�ȣ������Ƶ�ӽ�����

%% First part
F1=cross(r1,r2,3);   %F1=0�����������r1 r2 ����;��������һ��Ϊ0
LF1=(sum(F1.^2,3));

%{
mFIX3(:,:,1)=(SW3);  %������r1 r2 ����ʱ�������
mFIX3(:,:,2)=(SW3);
mFIX3(:,:,3)=(SW3);
%}

%% Third part
R0=(r1-r2);   %r1=mDES-mr1 r2=mDES-mr2 -> R0=r1-r2
LR0=sqrt(sum(R0.^2,3));
%�жγ���Ϊ0�ж�
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
    %% �㵽ֱ�߷������rp
    Lrp=sqrt(LF1)./sqrt(sum(R0.^2,3));
    Ratio_hl=Lrp./LR0;
    SW_hl_limit=Ratio_hl<hl_limit;
end

%0/0=nan
%��r1,r2����ʱ���������������0�������ģҲ����0
%����ܳ���ʱ���Ƶ�λ�����߶�����ɵ�inf ������
F2(:,:,1)=F1(:,:,1)./(LF1);
F2(:,:,2)=F1(:,:,2)./(LF1);
F2(:,:,3)=F1(:,:,3)./(LF1);


%F2=Fac1AB(�ο���P157)

%% combinging 2 and 3
L2=  R0(:,:,1).*L1(:,:,1)...
    +R0(:,:,2).*L1(:,:,2)...
    +R0(:,:,3).*L1(:,:,3);
%L2=Fac2AB(�ο���P157)

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
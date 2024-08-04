function [eigvalue]=lat_eig(STB_LATin)
%输入条件为飞机受力平衡状态，根据稳定轴系y轴上受力平衡有
g=9.81;
V=STB_LATin.AS;
rho=STB_LATin.rho;
%alpha=state.alpha;
theta0=0;
q=0.5*rho*V^2;

S=STB_LATin.ref.S_ref_M;
b=STB_LATin.ref.b_ref_M;

Ix=STB_LATin.inertias.Ix;
Iz=STB_LATin.inertias.Iz;
Izx=STB_LATin.inertias.Izx;
m=STB_LATin.inertias.m;

%输入条件为飞机受力平衡状态，根据稳定轴系y轴上受力平衡有


% 飞机的性能、稳定性、动力学与控制 航空工业出版社 2013.12
% Performance, Stability, Dynamics, and Control of Airplanes 2nd Ed.  AIAA
% Education Series

Clm_beta=STB_LATin.DRVs.Clm_beta;
Cnm_beta=STB_LATin.DRVs.Cnm_beta;
CC_beta=STB_LATin.DRVs.CC_beta;
Clm_P=STB_LATin.DRVs.Clm_P;
Cnm_P=STB_LATin.DRVs.Cnm_P;
CC_P=STB_LATin.DRVs.CC_P;
Clm_R=STB_LATin.DRVs.Clm_R;
Cnm_R=STB_LATin.DRVs.Cnm_R;
CC_R=STB_LATin.DRVs.CC_R;

%关于beta_dot的输入
if isfield(STB_LATin.DRVs,'Clm_beta_dot')
    Clm_beta_dot=STB_LATin.DRVs.Clm_beta_dot;
else
    Clm_beta_dot=0;
    %disp 注意：无导数Clm_beta_dot输入
end
if isfield(STB_LATin.DRVs,'Cnm_beta_dot')
    Cnm_beta_dot=STB_LATin.DRVs.Cnm_beta_dot;
else
    Cnm_beta_dot=0;
    %disp 注意：无导数Cnm_beta_dot输入
end
if isfield(STB_LATin.DRVs,'CC_beta_dot')
    CC_beta_dot=STB_LATin.DRVs.CC_beta_dot;
else
    CC_beta_dot=0;
   % disp 注意：无导数CC_beta_dot输入
end

%侧力的转换 中文版P325
CY_phi=m*g/(q*S)*cos(theta0);  %此时对应纵向可能为受力平衡或者不平衡均可，但不平衡时实际上theta0应该不是0
CY_beta=CC_beta;
CY_beta_dot=CC_beta_dot;
CY_P=CC_P;
CY_R=CC_R;

%{
%testcase
rho=1.225;
V=340*.158;

CY_beta=-0.564;

CY_phi=0.41;
Clm_beta=-0.074;
Clm_P=-0.41;
Clm_R=0.107;
Cnm_beta=0.0701;
Cnm_P=-0.0575;
Cnm_R=-0.125;
CY_beta_dot=0;
Clm_beta_dot=0;
Cnm_beta_dot=0;
CY_P=0;
CY_R=0;
S=17.1;
W=12232.6;
m=W/g;
b=10.1803;
c1=1.7374;
Ix=1420.8973;
Iy=4067.454;
Iz=4786.0375;
Izx=0;
%}



Ix1=Ix/(q*S*b);
Iz1=Iz/(q*S*b);
Ixz1=Izx/(q*S*b);

Ix1_1=Ix1/(Ix1*Iz1-Ixz1^2);
Iz1_1=Iz1/(Ix1*Iz1-Ixz1^2);
Ixz1_1=Ixz1/(Ix1*Iz1-Ixz1^2);

b1=b/(2*V);
m1=(2*m)/(rho*V*S);
xi1=Iz1_1*Clm_beta_dot+Ixz1_1*Cnm_beta_dot;
xi2=Ix1_1*Cnm_beta_dot+Ixz1_1*Clm_beta_dot;

A(1,1)=CY_beta/(m1-b1*CY_beta_dot);
A(1,2)=CY_phi/(m1-b1*CY_beta_dot);  
A(1,3)=CY_P*b1/(m1-b1*CY_beta_dot);
A(1,4)=0;
A(1,5)=-(m1-b1*CY_R)/(m1-b1*CY_beta_dot);
A(2,1)=0;
A(2,2)=0;
A(2,3)=1;
A(2,4)=0;
A(2,5)=0;
A(3,1)=Clm_beta*Iz1_1+Cnm_beta*Ixz1_1+xi1*b1*A(1,1);
A(3,2)=xi1*b1*A(1,2);
A(3,3)=Clm_P*b1*Iz1_1+Cnm_P*Ixz1_1*b1+xi1*b1*A(1,3);
A(3,4)=0;
A(3,5)=Clm_R*b1*Iz1_1+Cnm_R*Ixz1_1*b1+xi1*b1*A(1,5);
A(4,1)=0;
A(4,2)=0;
A(4,3)=0;
A(4,4)=0;
A(4,5)=1;
A(5,1)=Ix1_1*Cnm_beta+Ixz1_1*Clm_beta+b1*xi2*A(1,1);
A(5,2)=xi2*b1*A(1,2);
A(5,3)=b1*(Cnm_P*Ix1_1+Clm_P*Ixz1_1+xi2*A(1,3));
A(5,4)=0;
A(5,5)=b1*(Ix1_1*Cnm_R+Ixz1_1*Clm_R+xi2*A(1,5));

%fprintf('\n A矩阵为\n')
%disp (A)
eigvalue=eig(A);
eigvalue(eigvalue==0)=[];    %AIAA方法中有phi，是5X5矩阵，需要去掉一个特征根
end
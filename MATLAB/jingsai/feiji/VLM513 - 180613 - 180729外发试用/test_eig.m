
g=32.2;
V=176;
theta=0;
S=184;
b=33.4;
q=0.5*.002378*V^2;

Ix=1048;
Iz=3530;
Izx=0;
m=2750/g;

%}
%test sample
%{
clear all
Ix=1420.9;
Iy=4067.5;
Iz=4786.0;
Izx=0;

S=17.1;
c=1.74;
b=10.18;
V=340*.158;
CL=0.41;
CD=0.05;
g=9.8;
m=12224/g;

q=.5*1.225*V^2;
results.D=q*S*CD;



alpha=deg2rad(5.2716);
theta=deg2rad(5.2564);
%}


results.CC_beta=-.564;
results.CLm_beta=-0.074;
results.CNm_beta=0.071;
results.CLm_P=-0.410;
results.CNm_P=-0.0575;
results.CLm_R=0.107;
results.CNm_R=-0.125;

results.CC_P=0;
results.CC_R=0;

results.CD=0.05;

alpha=0.0;

C_beta =results.CC_beta*q*S;
D      =results.CD*q*S;
Lm_beta=results.CLm_beta*q*S*b;
Nm_beta=results.CNm_beta*q*S*b;

C_P    =results.CC_P*q*S* b/(2*V);
C_R    =results.CC_R*q*S* b/(2*V);
Lm_P   =results.CLm_P*q*S*b* b/(2*V);
Lm_R   =results.CLm_R*q*S*b* b/(2*V);
Nm_P   =results.CNm_P*q*S*b* b/(2*V);
Nm_R   =results.CNm_R*q*S*b* b/(2*V);

% 公式来自于于方振平、陈万春、张曙光《航空飞行器空气动力学》 P324
%D_Y_beta=(C_beta-D)/m/V;
D_Y_beta=(C_beta)/m/V;
D_Y_P   =C_P/m/V;
D_Y_R   =C_R/m/V;

D_Lm_beta=(Lm_beta+(Izx/Iz)*Nm_beta)/(Ix-Izx^2/Iz);
D_Lm_P   =(Lm_P   +(Izx/Iz)*Nm_P   )/(Ix-Izx^2/Iz);
D_Lm_R   =(Lm_R   +(Izx/Iz)*Nm_R   )/(Ix-Izx^2/Iz);

D_Nm_beta=(Nm_beta+(Izx/Ix)*Lm_beta)/(Iz-Izx^2/Ix);
D_Nm_P   =(Nm_P   +(Izx/Ix)*Lm_P   )/(Iz-Izx^2/Ix);
D_Nm_R   =(Nm_R   +(Izx/Ix)*Lm_R   )/(Iz-Izx^2/Ix);

A=[D_Y_beta    alpha+D_Y_P    D_Y_R-1   g*cos(theta)/V;
   D_Lm_beta   D_Lm_P         D_Lm_R           0;
   D_Nm_beta   D_Nm_P         D_Nm_R           0;
   0           1              tan(theta)       0]

eigvalue=eig(A)

function [eigvalue]=long_eig(results,state,ref,inertias)
%testcase

state.AS=.158*340;
state.rho=1.225;
ref.S_ref_M=17.1; %or book=16.7225
ref.C_mac_M=1.7374;
inertias.Iy=4067.454;
inertias.m=12232.6/9.81;
results.CL=0.41;
results.CD=0.05;
results.CL_alpha=4.44;
results.CD_alpha=0.33;
results.CMm_alpha=-.683;
results.CMm_alpha_dot=-4.36;
results.CMm_Q=-9.96;
results.CD_Q=0;
results.CL_Q=0;



V=state.AS;
rho=state.rho;
S=ref.S_ref_M;
MAC=ref.C_mac_M;
Iy=inertias.Iy;
m=inertias.m;
g=9.81;
q=0.5*rho*V^2;
W=m*g;
theta0=0;

%% 计算公式 
% 飞机的性能、稳定性、动力学与控制 航空工业出版社 2013.12
% Performance, Stability, Dynamics, and Control of Airplanes 2nd Ed.  AIAA
% Education Series

%关于alpha_dot的输入
if isfield(results,'CL_alpha_dot')
    CL_alpha_dot=results.CL_alpha_dot;
else
    CL_alpha_dot=0;
    disp 注意：无导数CL_alpha_dot输入
end
if isfield(results,'CD_alpha_dot')
    CD_alpha_dot=results.CD_alpha_dot;
else
    CD_alpha_dot=0;
    disp 注意：无导数CD_alpha_dot输入
end
if isfield(results,'CMm_alpha_dot')
    Cmm_alpha_dot=results.CMm_alpha_dot;
else
    Cmm_alpha_dot=0;
    disp 注意：无导数CMm_alpha_dot输入
end
%CD_u问题  CD_alpha_dot
CL=results.CL;
CD=results.CD;
CL_alpha=results.CL_alpha;
CD_alpha=results.CD_alpha;
Cmm_alpha=results.CMm_alpha;
CL_q=results.CL_Q;
CD_q=results.CD_Q;
Cmm_q=results.CMm_Q;

CD_u=0;
CL_u=0;
Cmm_u=0;


CW=W/(q*S);

I_y1=Iy/(q*S*MAC);

c1=MAC/(2*V);
m1=(2*m)/(rho*V*S);

Cx_u=-2*CD-CD_u;           %(4-432)
Cx_theta=-CL;              %(4-433 & z0轴受力平衡有W*cos(theta0)=L)
Cz_u=-2*CL-CL_u;           %(4-439)
Cz_theta=-CW*sin(theta0);  %(4-444推导得到)

Cx_alpha=CL-CD_alpha;      %(4-447)
Cz_alpha=-CL_alpha-CD;     %(4-454)

Cx_alpha_dot=-CD_alpha_dot;%(4-455)
Cx_q=-CD_q;                %(4-456)
Cz_alpha_dot=-CL_alpha_dot;%(4-457)
Cz_q=-CL_q;                %(4-458)


xi1=(Cx_alpha_dot*c1)/(m1-Cz_alpha_dot*c1);     %(6-8)
xi2=(Cmm_alpha_dot*c1)/(m1-Cz_alpha_dot*c1);    %(6-9)


A(1,1)=(Cx_u+xi1*Cz_u)/m1;
A(1,2)=(Cx_alpha+xi1*Cz_alpha)/m1;
A(1,3)=(Cx_q*c1+xi1*(m1+Cz_q*c1))/m1;
A(1,4)=(Cx_theta+xi1*Cz_theta)/m1;
A(2,1)=Cz_u/(m1-Cz_alpha_dot*c1);
A(2,2)=Cz_alpha/(m1-Cz_alpha_dot*c1);
A(2,3)=(m1+Cz_q*c1)/(m1-Cz_alpha_dot*c1);
A(2,4)=Cz_theta/(m1-c1*Cz_alpha_dot);
A(3,1)=(Cmm_u+xi2*Cz_u)/I_y1;
A(3,2)=(Cmm_alpha+xi2*Cz_alpha)/I_y1;
A(3,3)=(Cmm_q*c1+xi2*(m1+Cz_q*c1))/I_y1;
A(3,4)=xi2*Cz_theta/I_y1;
A(4,1)=0;
A(4,2)=0;
A(4,3)=1;
A(4,4)=0;

fprintf('\n A矩阵为\n')
disp (A)
eigvalue=eig(A);

end
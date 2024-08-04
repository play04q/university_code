function OBJ_BOUND=pre_form_BOUND(PROC)
% ���ɱ߽������Լ�P2\P3����յ��ٶ�ϵ��
% ÿ���㴦���ٶȰ����������֣�
% 1.Զǰ������ 2.Χ������ת���ڸ��㴦������ǣ�����ٶ� 
% 3.�������ߴ������յ�����


OBJ_MESH=PROC.OBJ_MESH;
OBJ_WAKE=PROC.OBJ_WAKE;
state=PROC.state;
ref=PROC.ref;


%���ɿ��Ƶ㴦�߽�����
wind0=(transform('da',state)*[-state.AS,0,0]')';           %������ϵת���������ϵ,��Ϊ�ɻ�������������
omegaD=transform('db',state)*[state.P state.Q state.R]';   %�����ϵ�ϵ�ת�����ٶ�

    
P1=OBJ_MESH.P1;
P2=OBJ_MESH.P2;
P3=OBJ_WAKE.P3;
nP1=length(P1);
nP2=length(P2);
nP3=length(P3);

Ndrct=OBJ_MESH.Ndrct;

%[X,u,v,w]=wind_dot(state,ref,P1,P2,P3);

if state.alpha_dot==0 && state.beta_dot==0
    M_wind=ones(nP1+nP2+nP3,1)*wind0;
else
    P=[P1;P2;P3];
    M_wind=[];
    M_wind(:,1)=interp1(X,u,P(:,1),'PCHIP');
    M_wind(:,2)=interp1(X,v,P(:,1),'PCHIP');
    M_wind(:,3)=interp1(X,w,P(:,1),'PCHIP');
end


%�ɵ��㷨,����������
%{
for i=1:FLAG.P1
    RotV=cross((P1(i,:)-ref.ref_point),omegaD); 
    P1V=wind0+RotV;
    P1NV(i)=dot(P1V,Ndrct(i,:));               %���߽���������Ϊ������
end
%}
DIS_P1=P1-ones(nP1,1)*ref.ref_point;   %P1�������Ĵ��ľ���
M_omegaD=ones(nP1,1)*omegaD';
M_RotV=cross(DIS_P1,M_omegaD,2);
M_P1V=M_wind(1:nP1,:)+M_RotV;
P1NV=dot(M_P1V,Ndrct,2);

%P2�㴦�����Ŷ������ٶ�
DIS_P2=P2-ones(nP2,1)*ref.ref_point;
M_omegaD=ones(nP2,1)*omegaD';
M_RotV=cross(DIS_P2,M_omegaD,2);
P2V=M_wind(nP1+1:nP1+nP2,:)+M_RotV;

%����P3�㴦���Ŷ������ٶ�
if nP3~=0
    P3V=zeros(nP3,3);
    for i=1:nP3
        RotV=cross((P3(i,:)-ref.ref_point),omegaD); 
        P3V(i,:)=wind0+RotV;
    end
else
    P3V=[];
end


OBJ_BOUND.P1NV=P1NV;
OBJ_BOUND.P2V=P2V;
OBJ_BOUND.P3V=P3V;

end

function [X,u,v,w]=wind_dot(state,ref,P1,P2,P3)
%���P1��P2��P3����ǰ�����λ�õ�
tmp=min([P1;P2]);
X1=tmp(1);
tmp=max([P1;P2]);
X2=tmp(1);
if ~isempty(P3)
    tmp=max(P3);
    X3=tmp(1);
end

dT=ref.C_mac_M/state.AS/20;
X(1)=ref.ref_point(1);
alpha(1)=state.alpha;
beta(1)=state.beta;

wind0=(transform('da',state)*[-state.AS,0,0]')';
u(1)=wind0(1);
v(1)=wind0(2);
w(1)=wind0(3);

while X(1)>X1
    Xn=X(1)-dT*u(1);
    alphan=alpha(1)+dT*state.alpha_dot;
    betan=beta(1)+dT*state.beta_dot;
    X=[Xn X]; %#ok<AGROW>
    alpha=[alphan alpha];  %#ok<AGROW>
    beta=[betan beta];  %#ok<AGROW>
    
    ST0.alpha=alpha(1);
    ST0.beta=beta(1);
    W=transform('da',ST0)*[-state.AS,0,0]';
    nu=W(1);
    nv=W(2);
    nw=W(3);
    u=[nu u];   %#ok<AGROW>
    v=[nv v];   %#ok<AGROW>
    w=[nw w];   %#ok<AGROW>
end

while X(end)<X2
    Xn=X(end)+dT*u(end);
    alphan=alpha(end)-dT*state.alpha_dot;
    betan=beta(end)-dT*state.beta_dot;
    X=[X Xn]; %#ok<AGROW>
    alpha=[alpha alphan];  %#ok<AGROW>
    beta=[beta betan];  %#ok<AGROW>
    
    ST0.alpha=alpha(end);
    ST0.beta=beta(end);
    W=transform('da',ST0)*[-state.AS,0,0]';
    nu=W(1);
    nv=W(2);
    nw=W(3);
    u=[u nu];   %#ok<AGROW>
    v=[v nv];   %#ok<AGROW>
    w=[w nw];   %#ok<AGROW>
end

if ~isempty(P3)
    dT=ref.b_ref_M/state.AS/5;
    while X(end)<X3
        Xn=X(1)+dT*u(end);
        alphan=alpha(end)-dT*state.alpha_dot;
        betan=beta(end)-dT*state.beta_dot;
        X=[X Xn]; %#ok<AGROW>
        alpha=[alpha alphan];  %#ok<AGROW>
        beta=[beta betan];  %#ok<AGROW>

        ST0.alpha=alpha(end);
        ST0.beta=beta(end);
        W=transform('da',ST0)*[-state.AS,0,0]';
        nu=W(1);
        nv=W(2);
        nw=W(3);
        u=[u nu];   %#ok<AGROW>
        v=[v nv];   %#ok<AGROW>
        w=[w nw];   %#ok<AGROW>
    end

end
% figure(991)
% clf
% plot(X,rad2deg(alpha))
%{
figure(991)
clf
hold on
nX=length(X);
for i=-ref.b_ref_M/2:ref.b_ref_M/4:ref.b_ref_M/2
    quiver3(X,ones(1,nX)*i,zeros(1,nX),u,v,w)

end
keyboard
%}
end
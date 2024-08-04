clear all
[CASE]=load_define([pwd '\import\Y8C.in'],'nm');  % ����ļ�
[PROC,~]=pre_general(CASE.Files(1),'n');
[PTL,PROC]=solver_ADload(PROC,'n');

%{
% % �����治�ɴ�Խ����
nC=10;
dH=PROC.state.ALT;

ST.theta=PROC.state.alpha;
ST.psi=0;
ST.phi=0;

P4=zeros(nC,3);
P4(:,1)=rand(1,nC)*10;
P4(:,2)=rand(1,nC)*10;
P4(:,3)=ones(1,nC)*dH;
for i=1:nC
     P4(i,:)=(transform('dg',ST)*P4(i,:)')';
end

% Ψ������һ���������ϴ�ٶȵ�
V_IDW=DWsolver(P4,PROC,PTL);

V_IDW_G=[];
for i=1:nC
    V_IDW_G(i,:)=(transform('gd',ST)*V_IDW(i,:)')';
end
%}


P4_G=[];
idx=1;
for x=0:-4:-100;
    for z=-20:4:20
        P4_G(idx,:)=[x,0,z];
        idx=idx+1;
    end
end
ST.theta=PROC.state.alpha;
ST.psi=0;
ST.phi=0;
[nC,~]=size(P4_G);
for i=1:nC
     P4(i,:)=(transform('dg',ST)*P4_G(i,:)')';
end
V_IDW=DWsolver(P4,PROC,PTL);
V_IDW_G=[];
for i=1:nC
    V_IDW_G(i,:)=(transform('gd',ST)*V_IDW(i,:)')';
end


MESH=PROC.MESH;
figure(229)
clf
hold on
axis equal
title ('��������ϵ X-��ǰ Y-���� Z-����')
set(gca,'ZDir','reverse')
for i=1:length(MESH.LATTICE)
    for j=1:6
        if MESH.LATTICE(i).V(j)~=0
            PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(1)).xyz')';  %_G��ָ��������ϵ
            PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(2)).xyz')';  %_G��ָ��������ϵ
            X=[PP1(1);PP2(1)];
            Y=[PP1(2);PP2(2)];
            Z=[PP1(3);PP2(3)];
            plot3(X,Y,Z,'-r'); 
        elseif j==4
            if MESH.LATTICE(i).V(2)~=0
                PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(2))).P(2)).xyz')';  %_G��ָ��������ϵ
            else
                PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(1))).P(2)).xyz')';  %_G��ָ��������ϵ
            end
            X=[PP1(1);PP2(1)];
            Y=[PP1(2);PP2(2)];
            Z=[PP1(3);PP2(3)];
            plot3(X,Y,Z,'-k'); 
        end
    end
end
for i=1:nC
    V=V_IDW_G(i,:);%+[-PROC.state.AS,0,0];
    P=P4_G(i,:);
    PV=P+V/3;
    XX=[P(1),PV(1)];
    YY=[P(2),PV(2)];
    ZZ=[P(3),PV(3)];
    plot3(XX,YY,ZZ,'-b')
end
function sMESH=pre_sMESH(PROC)
% V1(Vid).xyz(2,3)
% V1(Vid).Type
% LATTICE(Lid).V(2n)=Vid
% LATTICE(Lid).Lid_MESH=Lid_MESH

isdraw=0;

MESH=PROC.MESH;
state=PROC.state;

%Ԥ�Ƚ���Ҫ���ӵĽ��ж���
nL=length(MESH.LATTICE);
nV=length(MESH.V0);
nP=length(MESH.P0);


%disp([LN_max VN_max PN_max])
P0(1,nP)=struct('xyz',[],'Type',[],'Relation',[]);
V0(1,nV)=struct('P',[],'Type',[],'Relation',[]);
LATTICE(1,nL)=struct('V',[],'Lid_MESH',[]);

%�������ϵ�е�����ͶӰ��������ϵ�У������Чʱ���踩���ǵ���ӭ��
ST.theta=state.alpha;
ST.psi=0;
ST.phi=0;

dH=state.ALT;

for i=1:nP
    P0(i)=MESH.P0(i);
    P0_IMG_G=(transform('gd',ST)*MESH.P0(i).xyz')';  %_G��ָ��������ϵ
    P0_IMG_G(3)=P0_IMG_G(3)+2*(dH-P0_IMG_G(3));
    P0_IMG=(transform('dg',ST)*P0_IMG_G')';
    
    P0(i).xyz=P0_IMG;
    P0(i).Type=4;   %4-�����еĽǵ�
    %Relation ���ֲ���
end
sMESH.P0=P0;

for i=1:nV
    V0(i).Type=14;
    V0(i).P=MESH.V0(i).P+nP;
    V0(i).Relation=MESH.V0(i).Relation;
    %Relation ���ֲ���
end
sMESH.V0=V0;

for i=1:nL
    %�����е��ж�������ԭ���������෴
    LATTICE(i).V=-(MESH.LATTICE(i).V+nV*sign(MESH.LATTICE(i).V));
end
sMESH.LATTICE=LATTICE;

if isdraw==1
    figure(229)
    clf
    hold on
    axis equal
    title ('��������ϵ X-��ǰ Y-���� Z-����')
    for i=1:length(MESH.LATTICE)
        for j=1:6
            if MESH.LATTICE(i).V(j)~=0
                PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(1)).xyz')';  %_G��ָ��������ϵ
                PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(2)).xyz')';  %_G��ָ��������ϵ
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                plot3(X,Y,Z,'-r'); 
                
                PP1=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(1)).xyz')';  %_G��ָ��������ϵ
                PP2=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(2)).xyz')';  %_G��ָ��������ϵ
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                plot3(X,Y,Z,':r'); 
            elseif j==4
                if MESH.LATTICE(i).V(2)~=0
                    PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(2))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP1s=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP2s=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(2))).P(2)).xyz')';  %_G��ָ��������ϵ
                else
                    PP1=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP2=(transform('gd',ST)*MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(1))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP1s=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz')';  %_G��ָ��������ϵ
                    PP2s=(transform('gd',ST)*sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(1))).P(2)).xyz')';  %_G��ָ��������ϵ
                end
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                Xs=[PP1s(1);PP2s(1)];
                Ys=[PP1s(2);PP2s(2)];
                Zs=[PP1s(3);PP2s(3)];
                plot3(X,Y,Z,'-k'); 
                plot3(Xs,Ys,Zs,':k'); 
            end
        end
    end       
    
    figure(228)
    clf
    hold on
    axis equal
    title ('�������ϵ')
    for i=1:length(MESH.LATTICE)
        for j=1:6
            if MESH.LATTICE(i).V(j)~=0
                PP1=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(1)).xyz';  %_G��ָ��������ϵ
                PP2=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(2)).xyz';  %_G��ָ��������ϵ
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                plot3(X,Y,Z,'-r'); 
                
                PP1=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(1)).xyz';  %_G��ָ��������ϵ
                PP2=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(j))).P(2)).xyz';  %_G��ָ��������ϵ
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                plot3(X,Y,Z,':r'); 
            elseif j==4
                if MESH.LATTICE(i).V(2)~=0
                    PP1=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP2=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(2))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP1s=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP2s=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(2))).P(2)).xyz';  %_G��ָ��������ϵ
                else
                    PP1=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP2=MESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(1))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP1s=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(6))).P(2)).xyz';  %_G��ָ��������ϵ
                    PP2s=sMESH.P0(MESH.V0(abs(MESH.LATTICE(i).V(1))).P(2)).xyz';  %_G��ָ��������ϵ
                end
                X=[PP1(1);PP2(1)];
                Y=[PP1(2);PP2(2)];
                Z=[PP1(3);PP2(3)];
                Xs=[PP1s(1);PP2s(1)];
                Ys=[PP1s(2);PP2s(2)];
                Zs=[PP1s(3);PP2s(3)];
                plot3(X,Y,Z,'-k'); 
                plot3(Xs,Ys,Zs,':k'); 
            end
        end
    end       
    
    
end

end

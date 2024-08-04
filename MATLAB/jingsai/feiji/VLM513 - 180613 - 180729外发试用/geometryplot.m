function[]=geometryplot(PROC,quest)
switch quest
    case 1
        drawoutline(PROC)
    case 2
        drawelement(PROC)
end



end
    
function drawoutline(PROC)
%%绘制几何外形定义
clf
axis equal
hold on
view([0,90]);

NODE=PROC.NODE;
nwing=length(NODE);
for s=1:nwing
    nSEC=0;
    cNODE=NODE{s};
    tHINGE=PROC.HINGE{s};
    cGEO=PROC.geo(s);
    nelem=length(cGEO.ny);
    for t=1:nelem
        SEC1=sum(cGEO.ny(1:t-1))+1;
        SEC2=sum(cGEO.ny(1:t))+1;

        LE1=squeeze(cNODE(SEC1,1,:));
        LE2=squeeze(cNODE(SEC2,1,:));
        TE1=squeeze(cNODE(SEC1,end,:));
        TE2=squeeze(cNODE(SEC2,end,:));
        wingx=[LE1(1) LE2(1) TE2(1) TE1(1) LE1(1)];
        wingy=[LE1(2) LE2(2) TE2(2) TE1(2) LE1(2)];
        wingz=[LE1(3) LE2(3) TE2(3) TE1(3) LE1(3)];
        g=plot3(wingx,wingy,wingz,'k');
        set(g,'LineWidth',2);

        if PROC.geo(s).symetric==1
            g=plot3(wingx,-wingy,wingz,'k');
            set(g,'LineWidth',2);
        end
        
        if ~(all(tHINGE(t,1,:)==0) && all(tHINGE(t,2,:)==0)) %画舵面铰链线
            C1=TE1-LE1;  %弦线矢量
            C2=TE2-LE2;
            P_nx=PROC.P_nx;  
            P1=P_nx.percent(t,(P_nx.hinge(t)+1));   %铰链在弦线上的百分比
            P2=P_nx.percent(t+1,(P_nx.hinge(t)+1));
            H1=LE1+P1*C1; %铰链线坐标端点（假）没有考虑弯度因素
            H2=LE2+P2*C2;
            Fx=[H1(1) H2(1) TE2(1) TE1(1)];
            Fy=[H1(2) H2(2) TE2(2) TE1(2)];
            Fz=[H1(3) H2(3) TE2(3) TE1(3)];
            fill3(Fx,Fy,Fz,'y')

            if PROC.geo(s).symetric==1
                fill3(Fx,-Fy,Fz,'y')
            end
        end
        
    end
end



xlabel('飞机设计坐标系 x 轴')
ylabel('飞机设计坐标系 y 轴')
zlabel('飞机设计坐标系 z 轴')
title(['<' PROC.name '> 机翼几何定义三维显示'])
grid on

ref=PROC.ref;
h=line([ref.mac_pos_M(1) ref.mac_pos_M(1)+ref.C_mac_M],[ref.mac_pos_M(2) ref.mac_pos_M(2)],[ref.mac_pos_M(3) ref.mac_pos_M(3)]);
set(h,'LineWidth',5);

a=plot3(ref.ref_point(1),ref.ref_point(2),ref.ref_point(3),'r+');
set(a,'MarkerSize',15,'linewidth',3);
a=plot3(ref.ref_point(1),ref.ref_point(2),ref.ref_point(3),'ro');
set(a,'MarkerSize',15,'linewidth',3);

%plotting legend
L=gca;
set(L,'Position',[0.1 0.1 0.6 0.8]);
axes('position',[0.75 0.6 0.2 0.2]);
axis([0 3 0 3])
hold on

h=line([0.1 0.4],[3 3]);
set(h,'LineWidth',6);

a=plot(0.25,2,'r+');
set(a,'MarkerSize',15,'linewidth',3);
a=plot(0.25,2,'ro');
set(a,'MarkerSize',15,'linewidth',3);


text(.8,3,'MAC');
text(.8,2,'ref point')

axis off
end

function drawelement(PROC)
MESH=PROC.MESH;
ref=PROC.ref;
clf
hold on, grid on, axis equal, view([-30 25]);

nELEM=length(MESH.ELEM);
nL=length(MESH.LATTICE);

for i=1:nELEM
    pX=[MESH.ELEM(i).xyz(1,1) MESH.ELEM(i).xyz(2,1) MESH.ELEM(i).xyz(3,1) MESH.ELEM(i).xyz(4,1) MESH.ELEM(i).xyz(1,1) ];
    pY=[MESH.ELEM(i).xyz(1,2) MESH.ELEM(i).xyz(2,2) MESH.ELEM(i).xyz(3,2) MESH.ELEM(i).xyz(4,2) MESH.ELEM(i).xyz(1,2) ];
    pZ=[MESH.ELEM(i).xyz(1,3) MESH.ELEM(i).xyz(2,3) MESH.ELEM(i).xyz(3,3) MESH.ELEM(i).xyz(4,3) MESH.ELEM(i).xyz(1,3) ];
    plot3(pX,pY,pZ,'k');  %画网格

    rc=MESH.C(i).xyz;
    A=MESH.C(i).xyz+MESH.C(i).N*max(ref.b_ref)/20;					%Check routine
    nX=[rc(1) A(1)];				%Calculating normals
    nY=[rc(2) A(2)];				         
    nZ=[rc(3) A(3)];
    plot3(nX,nY,nZ,'--b');
end

for i=1:nL
    for j=1:6
        VID=MESH.LATTICE(i).V(j);
        if VID>0
            A=MESH.P0(MESH.V0(VID).P(1)).xyz;
            B=MESH.P0(MESH.V0(VID).P(2)).xyz;
            pX=[A(1) B(1)];
            pY=[A(2) B(2)];
            pZ=[A(3) B(3)];
            plot3(pX,pY,pZ,':r');  %画涡线
        elseif VID<0
            A=MESH.P0(MESH.V0(-VID).P(2)).xyz;
            B=MESH.P0(MESH.V0(-VID).P(1)).xyz;
            pX=[A(1) B(1)];
            pY=[A(2) B(2)];
            pZ=[A(3) B(3)];
            plot3(pX,pY,pZ,':r');  %画涡线
        end
    end
    
end
xlabel('飞机设计坐标系 x 轴')
ylabel('飞机设计坐标系 y 轴')
zlabel('飞机设计坐标系 z 轴')
title(['<' PROC.name '>机翼布局、涡线、控制点、面元法向详图'])
end
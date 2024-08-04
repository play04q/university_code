function sWAKE=pre_sWAKE(PROC)

WAKE=PROC.WAKE;
state=PROC.state;

VN_WAKE=length(WAKE.V0);   %在WAKE中现有的V数量
PN_WAKE=length(WAKE.P0);
LN_WAKE=length(WAKE.LATTICE);



%将设计轴系中的坐标投影到地面轴系中，计算地效时假设俯仰角等于迎角
ST.theta=state.alpha;
ST.psi=0;
ST.phi=0;

dH=state.ALT;
P0=WAKE.P0;
for i=1:PN_WAKE
    P0_IMG_G=(transform('gd',ST)*WAKE.P0(i).xyz')';  %_G是指地面坐标系
    P0_IMG_G(3)=P0_IMG_G(3)+2*(dH-P0_IMG_G(3));
    P0_IMG=(transform('dg',ST)*P0_IMG_G')';
    
    P0(i).xyz=P0_IMG;
    P0(i).Type=4;   %4-镜像涡的角点
    %Relation 保持不变
end
sWAKE.P0=P0;

V0=WAKE.V0;
PN_MESH=length(PROC.MESH.P0);

for i=1:VN_WAKE
    V0(i).Type=14;
    if V0(i).P(1)<=PN_MESH    %引用MESH中的点时需要映射到sMESH中
        V0(i).P(1)=WAKE.V0(i).P(1)+PN_MESH;  
    else
        V0(i).P(1)=WAKE.V0(i).P(1)+PN_WAKE;  %WAKE中的新点映射至sWAKE
    end
    if V0(i).P(2)<=PN_MESH   %(理论上来说第二个都应该是新生成的，不存在这个问题)
        V0(i).P(2)=WAKE.V0(i).P(2)+PN_MESH;  
        keyboard
    else
        V0(i).P(2)=WAKE.V0(i).P(2)+PN_WAKE;  %WAKE中的新点映射至sWAKE
    end

    V0(i).Relation=WAKE.V0(i).Relation;
    %Relation 保持不变
end
sWAKE.V0=V0;

LATTICE=WAKE.LATTICE;
for i=1:LN_WAKE
    %镜像涡的涡段向量与原向量方向相反
    LATTICE(i).V=-(WAKE.LATTICE(i).V+VN_WAKE*sign(WAKE.LATTICE(i).V));
end
sWAKE.LATTICE=LATTICE;
end

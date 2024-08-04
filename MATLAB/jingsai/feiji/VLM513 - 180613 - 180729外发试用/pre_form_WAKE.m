function OBJ_WAKE=pre_form_WAKE(PROC)
%V2->P3
%161201整合加入 V1->P3  V2->P1\P2
MESH=PROC.MESH;
WAKE=PROC.WAKE;

if PROC.state.GND_EFF==1
    sMESH=PROC.sMESH;
    sWAKE=PROC.sWAKE;
    nP0_sMESH=length(sMESH.P0);
    nP0_sWAKE=length(sWAKE.P0);
    nV0_sWAKE=length(sWAKE.V0);
else
    nP0_sMESH=0;
    nP0_sWAKE=0;
    nV0_sWAKE=0;
end

%综合MESH\sMESH\WAKE\sWAKE中的P0信息
P_IDX=0;
nP0_MESH=length(MESH.P0);
nP0_WAKE=length(WAKE.P0);
P0=zeros(nP0_MESH+nP0_sMESH+nP0_WAKE+nP0_sWAKE,3);

for i=1:nP0_MESH
    P_IDX=P_IDX+1;
    P0(P_IDX,:)=MESH.P0(i).xyz;
end
for i=1:nP0_sMESH
    P_IDX=P_IDX+1;
    P0(P_IDX,:)=sMESH.P0(i).xyz;
end
for i=1:nP0_WAKE
    P_IDX=P_IDX+1;
    P0(P_IDX,:)=WAKE.P0(i).xyz;
end
for i=1:nP0_sWAKE
    P_IDX=P_IDX+1;
    P0(P_IDX,:)=sWAKE.P0(i).xyz;
end


%由P0生成V2涡，来自WAKE和sWAKE两部分
V2_IDX=0;
nV0_WAKE=length(WAKE.V0);
V2=zeros(nV0_WAKE+nV0_sWAKE,2,3);
for i=1:nV0_WAKE
    V2_IDX=V2_IDX+1;
    V2(V2_IDX,1,:)=P0(WAKE.V0(i).P(1),:);
    V2(V2_IDX,2,:)=P0(WAKE.V0(i).P(2),:);
end
for i=1:nV0_sWAKE
    V2_IDX=V2_IDX+1;
    V2(V2_IDX,1,:)=P0(sWAKE.V0(i).P(1),:);
    V2(V2_IDX,2,:)=P0(sWAKE.V0(i).P(2),:);
end

%求出V2->P1\P2点处的诱导速度系数
P1=PROC.OBJ_MESH.P1;
P2=PROC.OBJ_MESH.P2;
P12=[P1;P2];
OBJ_WAKE.DW_V2toP12=solver_VDW(P12,V2);  


%生成尾涡角点P3
WL=length(WAKE.LATTICE(1).V)/2;
if WL==1
    P3=[];
else
    nP3=length(WAKE.P0);
    P3=zeros(nP3,3);
    for i=1:nP3
        P3(i,:)=WAKE.P0(i).xyz;
    end
end


%生成P3点处诱导系数
if ~isempty(P3)
    %求出V1->P3点处的诱导速度系数
    V1=PROC.OBJ_MESH.V1;
    OBJ_WAKE.DW_V1toP3=solver_VDW(P3,V1);  
    %求出V2->P3点处的诱导速度系数
    OBJ_WAKE.DW_V2toP3=solver_VDW(P3,V2);  
else
    OBJ_WAKE.DW_V1toP3=[];
    OBJ_WAKE.DW_V2toP3=[];
end


OBJ_WAKE.P3=P3;
OBJ_WAKE.V2=V2;

%生成LATTICE对应的向量指针
NL_WAKE=length(WAKE.LATTICE);
NVinL_WAKE=length(WAKE.LATTICE(1).V);
GND_EFF=PROC.state.GND_EFF;
if GND_EFF==1
    L=zeros(NL_WAKE,NVinL_WAKE*2);
else
    L=zeros(NL_WAKE,NVinL_WAKE);    
end
Lid_MESH=zeros(1,NL_WAKE);

for i=1:NL_WAKE
    Lid_MESH(i)=WAKE.LATTICE(i).Lid_MESH;
    if GND_EFF==1
        L(i,1:NVinL_WAKE)=WAKE.LATTICE(i).V;
        L(i,NVinL_WAKE+1:NVinL_WAKE*2)=sWAKE.LATTICE(i).V;
    else
        L(i,:)=WAKE.LATTICE(i).V;
    end
end
OBJ_WAKE.L=L;
OBJ_WAKE.Lid_MESH=Lid_MESH;

end



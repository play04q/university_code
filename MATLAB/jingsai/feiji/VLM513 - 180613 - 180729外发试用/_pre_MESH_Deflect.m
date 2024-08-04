function ADJ_MESH=pre_MESH_Deflect(MESH_Deflect,OBJ_MESH,Relation)
%OBJ_MESH是进行偏转前的状态
P1=OBJ_MESH.P1;
P2=OBJ_MESH.P2;
V1=OBJ_MESH.V1;
Ndrct=OBJ_MESH.Ndrct;

%气动力作用点P2
FLAG.P2=length(MESH_Deflect.V0);
P2_ADJ=zeros(FLAG.P2,3);
P2_IDX=zeros(FLAG.P2,1);
ID=1;
for i=1:FLAG.P2
    if isequal(MESH_Deflect.V0(i).Relation,Relation)
        P2_ADJ(ID,:)=(MESH_Deflect.P0(MESH_Deflect.V0(i).P(1)).xyz+MESH_Deflect.P0(MESH_Deflect.V0(i).P(2)).xyz)/2;
        P2_IDX(ID)=i;
        ID=ID+1;
    end
end
P2_ADJ(ID:end,:)=[];
P2_IDX(ID:end)=[];
P2(P2_IDX,:)=P2_ADJ;

%生成控制点P1
FLAG.P1=length(MESH_Deflect.C);
P1_ADJ=zeros(FLAG.P1,3);
P1_IDX=zeros(FLAG.P1,3);
ID=1;
for i=1:FLAG.P1
    if isequal(MESH_Deflect.C(i).Relation,Relation)
        P1_ADJ(ID,:)=MESH_Deflect.C(i).xyz;
        P1_IDX(ID)=i;
        ID=ID+1;
    end
end
P1_ADJ(ID:end,:)=[];
P1_IDX(ID:end)=[];
P1(P1_IDX,:)=P1_ADJ;

%综合MESH中的P0信息
nP0_MESH=length(MESH_Deflect.P0);
P0=zeros(nP0_MESH,3);
for i=1:nP0_MESH
    P0(i,:)=MESH_Deflect.P0(i).xyz;
end

%由P0信息和V0信息输出V1涡
FLAG.V1=length(MESH_Deflect.V0);
V1_ADJ=zeros(FLAG.V1,2,3);
V1_IDX=zeros(FLAG.V1);
ID=1;
for i=1:FLAG.V1
    if isequal(MESH_Deflect.V0(i).Relation,Relation)
        V1_ADJ(ID,1,:)=P0(MESH_Deflect.V0(i).P(1),:);
        V1_ADJ(ID,2,:)=P0(MESH_Deflect.V0(i).P(2),:);
        V1_IDX(ID)=i;
        ID=ID+1;
    end
end
V1_ADJ(ID:end,:,:)=[];
V1_IDX(ID:end)=[];
V1(V1_IDX,:,:)=V1_ADJ;

%控制点处的法向量
Ndrct_ADJ=zeros(FLAG.P1,3);
Ndrct_IDX=zeros(FLAG.P1);
ID=1;
for i=1:FLAG.P1
    if isequal(MESH_Deflect.C(i).Relation,Relation)
        Ndrct_ADJ(ID,:)=MESH_Deflect.C(i).N;
        Ndrct_IDX(ID)=i;
        ID=ID+1;
    end
end
Ndrct_ADJ(ID:end,:)=[];
Ndrct_IDX(ID:end)=[];
Ndrct(Ndrct_IDX,:)=Ndrct_ADJ;

DW_V1ADJtoP12=solver_VDW([P1;P2],V1_ADJ);  
DW_V1toP12ADJ=solver_VDW([P1_ADJ;P2_ADJ],V1);  

ADJ_MESH.DW_V1toP12=OBJ_MESH.DW_V1toP12;
for i=1:length(V1_IDX)
    ADJ_MESH.DW_V1toP12(:,V1_IDX(i),:)=DW_V1ADJtoP12(:,i,:);
end

A=length(P1_IDX);
B=length(P2_IDX);
for i=1:A+B
    if i<=A
        ADJ_MESH.DW_V1toP12(P1_IDX(i),:,:)=DW_V1toP12ADJ(i,:,:);
    else
        ADJ_MESH.DW_V1toP12(FLAG.P1+P2_IDX(i-A),:,:)=DW_V1toP12ADJ(i,:,:);
    end
end

ADJ_MESH.P1=P1;
ADJ_MESH.P2=P2;
ADJ_MESH.V1=V1;
ADJ_MESH.Ndrct=Ndrct;
ADJ_MESH.L=OBJ_MESH.L;
ADJ_MESH.FLAG=OBJ_MESH.FLAG;

end
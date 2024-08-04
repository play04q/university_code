function OBJ_MESH=pre_form_MESH(PROC)
MESH=PROC.MESH;
if isfield(PROC,'sMESH')  %��������������Ϣʱ
    sMESH=PROC.sMESH;
    GND_EFF=1;
else
    GND_EFF=0;
end
%�������������õ�P2
nP2=length(MESH.V0);
P2=zeros(nP2,3);
for i=1:nP2
    P2(i,:)=(MESH.P0(MESH.V0(i).P(1)).xyz+MESH.P0(MESH.V0(i).P(2)).xyz)/2;
end

%���ɿ��Ƶ�P1
nP1=length(MESH.C);
P1=zeros(nP1,3);
for i=1:nP1
    P1(i,:)=MESH.C(i).xyz;
end

%�ۺ�MESH�е�P0��Ϣ
nP0_MESH=length(MESH.P0);
if GND_EFF==1
    P0=zeros(nP0_MESH*2,3);    
else
    P0=zeros(nP0_MESH,3);    
end

for i=1:nP0_MESH
    P0(i,:)=MESH.P0(i).xyz;
end
if GND_EFF==1
    for i=1:nP0_MESH
        P0(nP0_MESH+i,:)=sMESH.P0(i).xyz;
    end
end

%��P0��Ϣ��V0��Ϣ���V1��
nV=length(MESH.V0);
if GND_EFF==1
    V1=zeros(nV*2,2,3);
else
    V1=zeros(nV,2,3);
end
for i=1:nV
    V1(i,1,:)=P0(MESH.V0(i).P(1),:);
    V1(i,2,:)=P0(MESH.V0(i).P(2),:);
    if GND_EFF==1 
        V1(nV+i,1,:)=P0(sMESH.V0(i).P(1),:);
        V1(nV+i,2,:)=P0(sMESH.V0(i).P(2),:);
    end
end

%����LATTICE��Ӧ������ָ��
nL_MESH=length(MESH.LATTICE);
Vsize=length(MESH.LATTICE(1).V);
if GND_EFF==1
    L=zeros(nL_MESH,Vsize*2);    
else
    L=zeros(nL_MESH,Vsize);    
end

for i=1:nL_MESH
    if GND_EFF==1
        L(i,1:Vsize)=MESH.LATTICE(i).V;
        L(i,Vsize+1:Vsize*2)=sMESH.LATTICE(i).V;
    else
        L(i,:)=MESH.LATTICE(i).V;
    end
end

%���Ƶ㴦�ķ�����
Ndrct=zeros(nP1,3);
for i=1:nP1
    Ndrct(i,:)=MESH.C(i).N;
end

%���V1->P1\P2�㴦���յ��ٶ�ϵ��
if ~isfield(PROC,'OBJ_MESH')   %��������OBJ_MESHʱ˵��SW������
    [OBJ_MESH.DW_V1toP12,OBJ_MESH.SW]=solver_VDW([P1;P2],V1,'');  %��һ�������������Ĺ�
else
    [OBJ_MESH.DW_V1toP12,~]=solver_VDW([P1;P2],V1,PROC.OBJ_MESH.SW); 
end
OBJ_MESH.P1=P1;
OBJ_MESH.P2=P2;
OBJ_MESH.V1=V1;
OBJ_MESH.L=L;
OBJ_MESH.Ndrct=Ndrct;
OBJ_MESH.GND_EFF=GND_EFF;

end
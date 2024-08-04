
function [Results]=solver_compute(PROC)
%P[Pid,3]
%P1   %���Ƶ㣬ֻ��Ҫ������ϴϵ��
%P2   %���������õ㣬����ϴ�ٶ�
%P3   %β�еĹյ㣬ֻ��Ҫ�����ϴ�ٶȲ����

%V[Vid,2(start&end),3(xyz)]
%-->����������м����V1G(������������������ǿ���)V1G[id,2,3]
%V1   %����������    ���õ��Pid   V����ǿ��L��ֵ
%V2   %����������
state=PROC.state;
ref=PROC.ref;

OBJ_MESH=PROC.OBJ_MESH;
OBJ_WAKE=PROC.OBJ_WAKE;
OBJ_BOUND=PROC.OBJ_BOUND;


%����OBJ����VDW�����������������е���ϴϵ����
VDW_P12=[OBJ_MESH.DW_V1toP12,OBJ_WAKE.DW_V2toP12];
VDW_P3=[OBJ_WAKE.DW_V1toP3,OBJ_WAKE.DW_V2toP3];
VDW=[VDW_P12;VDW_P3];

P1=OBJ_MESH.P1;
P2=OBJ_MESH.P2;
P3=OBJ_WAKE.P3;

nP1=length(P1);
nP2=length(P2);

P=[P1;P2;P3];
L_aMESH=OBJ_MESH.L;
L_aWAKE=OBJ_WAKE.L;
NVinL_MESH=length(L_aMESH(1,:));  %����MESH��sMESH
NVinL_WAKE=length(L_aWAKE(1,:));  %����WAKE��sWAKE
NL_MESH=length(PROC.MESH.LATTICE);
NL_WAKE=length(PROC.WAKE.LATTICE);

P2V=OBJ_BOUND.P2V;
P1NV=OBJ_BOUND.P1NV;


%���ÿ��LATTICE�Կ��Ƶ㴦���յ��ٶ�ϵ��
%����MESH��WAKE��ÿ��LATTICE��������ж�����ͬ�������Ҫ�ֿ�ͳ��
[Psize,~]=size(P);
LDW=zeros(Psize,NL_MESH,3);
 %��������������
for i=1:NL_MESH
    for j=1:NVinL_MESH
        if L_aMESH(i,j)~=0
            Vid=L_aMESH(i,j);
            if Vid>0
                LDW(:,i,:)=LDW(:,i,:)+VDW(:,Vid,:);
            else
                LDW(:,i,:)=LDW(:,i,:)-VDW(:,-Vid,:);
            end
        end
    end
end

%��������������
for i=1:NL_WAKE
    Lid=OBJ_WAKE.Lid_MESH(i);  %�ҵ�WAKE��LATTICE��Ӧ��MESH�е����к�
    for j=1:NVinL_WAKE
        Vid=L_aWAKE(i,j);
        if Vid>0
           LDW(:,Lid,:)=LDW(:,Lid,:)+VDW(:,Vid,:);
        else
           LDW(:,Lid,:)=LDW(:,Lid,:)-VDW(:,-Vid,:);
        end
    end
end

%�����P1λ�÷�����յ��ٶ�ϵ��
lemma=ones(1,nP1);
mN(:,:,1)=OBJ_MESH.Ndrct(:,1)*lemma;
mN(:,:,2)=OBJ_MESH.Ndrct(:,2)*lemma;
mN(:,:,3)=OBJ_MESH.Ndrct(:,3)*lemma;
LDW_normal=dot(LDW(1:nP1,:,:),mN,3);
Results.dwcond=cond(LDW_normal);            %����������

%���ÿ��LATTICE����ǿ
Gamma=LDW_normal\(-P1NV);
%disp(Gamma)

%���յ��ٶ���ϵ������ǿ���ÿ��P2�㴦���յ��ٶ�
P2_IW(:,1)=LDW(nP1+1:nP1+nP2,:,1)*Gamma;
P2_IW(:,2)=LDW(nP1+1:nP1+nP2,:,2)*Gamma;
P2_IW(:,3)=LDW(nP1+1:nP1+nP2,:,3)*Gamma; 

%���ɸ�������������ͬ��ǿ��  �ò����е�V1��LATTICE������������
V1=OBJ_MESH.V1;
V1=V1(1:length(PROC.MESH.V0),:,:);  %����������ʱ��Ҫȥ������Ĳ���
nV1=length(V1);
V1_gamma=zeros(nV1,1);
LATTICE=PROC.MESH.LATTICE;
for i=1:length(LATTICE)  %MESH�е�LATTICE����
    Lid=i;
    for j=1:length(LATTICE(1).V)   %ÿ��LATTICE�а�����Vѭ��һ��
        if LATTICE(i).V(j)~=0
            Vid=LATTICE(i).V(j);
            if Vid>0
                V1_gamma(Vid)=V1_gamma(Vid)+Gamma(Lid);
            else
                V1_gamma(-Vid)=V1_gamma(-Vid)-Gamma(Lid);
            end
        end
    end
end
%��V1�������DELTA��ʽ
V1G(:,1)=V1_gamma.*(V1(:,2,1)-V1(:,1,1));	
V1G(:,2)=V1_gamma.*(V1(:,2,2)-V1(:,1,2));
V1G(:,3)=V1_gamma.*(V1(:,2,3)-V1(:,1,3));

%ÿ��P2��Բο���ĵ�����
P2_arm=P(nP1+1:nP1+nP2,:)-ones(nP2,1)*ref.ref_point;

F(:,:)=state.rho*cross(P2V+P2_IW,V1G);		    
M(:,:)=cross(P2_arm,F(:,:),2);

Results.F=F;
Results.M=M;
Results.Gamma=Gamma;
Results.state=state;
% Gamma
% [nV1G,~]=size(V1G);
% NN=zeros(1,nV1G);
% for i=1:nV1G
%     NN(i)=norm(V1G(i,:));
% end
end


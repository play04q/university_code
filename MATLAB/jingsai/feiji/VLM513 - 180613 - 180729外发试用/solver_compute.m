
function [Results]=solver_compute(PROC)
%P[Pid,3]
%P1   %控制点，只需要求其下洗系数
%P2   %气动力作用点，求下洗速度
%P3   %尾涡的拐点，只需要求出下洗速度并输出

%V[Vid,2(start&end),3(xyz)]
%-->程序中求出中间变量V1G(附着涡向量，引入涡强后的)V1G[id,2,3]
%V1   %附着涡向量    作用点的Pid   V的涡强由L赋值
%V2   %脱体涡向量
state=PROC.state;
ref=PROC.ref;

OBJ_MESH=PROC.OBJ_MESH;
OBJ_WAKE=PROC.OBJ_WAKE;
OBJ_BOUND=PROC.OBJ_BOUND;


%联立OBJ生成VDW矩阵（所有向量对所有点下洗系数）
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
NVinL_MESH=length(L_aMESH(1,:));  %包括MESH和sMESH
NVinL_WAKE=length(L_aWAKE(1,:));  %包括WAKE和sWAKE
NL_MESH=length(PROC.MESH.LATTICE);
NL_WAKE=length(PROC.WAKE.LATTICE);

P2V=OBJ_BOUND.P2V;
P1NV=OBJ_BOUND.P1NV;


%求出每个LATTICE对控制点处的诱导速度系数
%由于MESH和WAKE中每个LATTICE里包含的涡段数不同，因此需要分开统计
[Psize,~]=size(P);
LDW=zeros(Psize,NL_MESH,3);
 %附着涡向量部分
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

%脱体涡向量部分
for i=1:NL_WAKE
    Lid=OBJ_WAKE.Lid_MESH(i);  %找到WAKE中LATTICE对应在MESH中的序列号
    for j=1:NVinL_WAKE
        Vid=L_aWAKE(i,j);
        if Vid>0
           LDW(:,Lid,:)=LDW(:,Lid,:)+VDW(:,Vid,:);
        else
           LDW(:,Lid,:)=LDW(:,Lid,:)-VDW(:,-Vid,:);
        end
    end
end

%求出在P1位置法向的诱导速度系数
lemma=ones(1,nP1);
mN(:,:,1)=OBJ_MESH.Ndrct(:,1)*lemma;
mN(:,:,2)=OBJ_MESH.Ndrct(:,2)*lemma;
mN(:,:,3)=OBJ_MESH.Ndrct(:,3)*lemma;
LDW_normal=dot(LDW(1:nP1,:,:),mN,3);
Results.dwcond=cond(LDW_normal);            %矩阵条件数

%求解每个LATTICE的涡强
Gamma=LDW_normal\(-P1NV);
%disp(Gamma)

%由诱导速度项系数和涡强求出每个P2点处的诱导速度
P2_IW(:,1)=LDW(nP1+1:nP1+nP2,:,1)*Gamma;
P2_IW(:,2)=LDW(nP1+1:nP1+nP2,:,2)*Gamma;
P2_IW(:,3)=LDW(nP1+1:nP1+nP2,:,3)*Gamma; 

%生成附着涡向量（连同涡强）  该部分中的V1、LATTICE均不包含镜像
V1=OBJ_MESH.V1;
V1=V1(1:length(PROC.MESH.V0),:,:);  %计算气动力时需要去掉镜像的部分
nV1=length(V1);
V1_gamma=zeros(nV1,1);
LATTICE=PROC.MESH.LATTICE;
for i=1:length(LATTICE)  %MESH中的LATTICE数量
    Lid=i;
    for j=1:length(LATTICE(1).V)   %每个LATTICE中包含的V循环一遍
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
%将V1变成向量DELTA形式
V1G(:,1)=V1_gamma.*(V1(:,2,1)-V1(:,1,1));	
V1G(:,2)=V1_gamma.*(V1(:,2,2)-V1(:,1,2));
V1G(:,3)=V1_gamma.*(V1(:,2,3)-V1(:,1,3));

%每个P2点对参考点的的力臂
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


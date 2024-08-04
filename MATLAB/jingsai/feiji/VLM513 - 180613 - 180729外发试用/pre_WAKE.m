function [WAKE]=pre_WAKE(PROC)

% 在生成新的尾涡时，采用结构变量WAKE进行记录。
% V0中引用的Pid继续MESH中的编号继续命名
% LATTICE中引用的Vid同样延续MESH中的序号进行命名
%
% 定义数组上标时先根据每个涡段最多ny+1条尾涡线进行定义
% FLAG用于传递信息，包括尾涡分段数，尾涡长度，还有编号编到哪里等

global Isdraw;
Isdraw=0;

if Isdraw==1
    figure(110) 
    clf
    hold on
    axis equal
end

MESH=PROC.MESH;
ref=PROC.ref;
geo=PROC.geo;
state=PROC.state;
   
infdist=20*ref.b_ref_M;
nwing=length(geo);
FLAG.WL=state.wakelength;   %尾涡段数

%infdist=infdist/50;
%FLAG.WL=3;

FLAG.LN=1;                  %WAKE中的LATTICE顺序号
FLAG.VN=1;
FLAG.PN=1;

FLAG.Lid_MESH=0;             %对应到MESH中的LATTICE序号
if state.GND_EFF==1
    FLAG.VN_EXST=length(MESH.V0)*2;  
    FLAG.PN_EXST=length(MESH.P0)*2;
else
    FLAG.VN_EXST=length(MESH.V0);    %在MESH和sMESH中现有的V数量
    FLAG.PN_EXST=length(MESH.P0);
end

FLAG.Vinf=transform('da',state)*[-infdist,0,0]';    %将风轴系中向量[-inf,0,0]投影到设计轴系中
if FLAG.WL==0
    FLAG.WL=1;
    FLAG.Vinf=[infdist,0,0]';    %当尾涡段数为0时，尾涡延设计轴系X轴方向
end

%进行数组上标初步定义
LN_max=0;
VN_max=0;
PN_max=0;
for s=1:nwing
    LN_max=LN_max+sum(geo(s).ny)*(1+geo(s).symetric);
    VN_max=VN_max+sum(geo(s).ny+1)*FLAG.WL*(1+geo(s).symetric);
    PN_max=PN_max+(FLAG.WL+1)*sum(geo(s).ny+1)*FLAG.WL*(1+geo(s).symetric);
end
%disp([LN_max VN_max PN_max])
LATTICE(1,LN_max)=struct('V',[],'Lid_MESH',[]);
P0(1,PN_max)=struct('xyz',[],'Type',[],'Relation',[]);
V0(1,VN_max)=struct('P',[],'Type',[],'Relation',[]);

for s=1:nwing
    [P0,V0,LATTICE,FLAG]=WAKE_create(MESH,geo,s,P0,V0,LATTICE,FLAG);
    if geo(s).symetric==1
        [P0,V0,LATTICE,FLAG]=WAKE_create(MESH,geo,s,P0,V0,LATTICE,FLAG);
    end
end

[WAKE]=WAKE_squeeze(LATTICE,V0,P0);
end



function [P0,V0,LATTICE,FLAG]=WAKE_create(MESH,geo,s,P0,V0,LATTICE,FLAG)
global Isdraw
WL=FLAG.WL;   %尾涡的段数
Vinf=FLAG.Vinf;
VN=FLAG.VN;   %涡变量顺序号(在WAKE中的)
PN=FLAG.PN;
LN=FLAG.LN;
Lid_MESH=FLAG.Lid_MESH;   %WAKE中的LATTICE对应到MESH中LATTICE的顺序号
VN_EXST=FLAG.VN_EXST;
PN_EXST=FLAG.PN_EXST;
    
nelem=length(geo(s).ny);
nx=geo(s).nx;

P0_id=0;
for t=1:nelem
    ny=geo(s).ny(t);

    for i=0:ny
        if Isdraw==1
            VN_last=VN;    %为后面画图用的变量
        end
        
        % 定位最后后缘处脱体涡的起点
        if i~=1
            Lid_MESH=Lid_MESH+nx;
        end
        SkipFirst=0;  %当没有舵面布置时跳过，跳过第一段后每段最左侧的点
        if i==0
            if P0_id~=MESH.V0((-MESH.LATTICE(Lid_MESH).V(6))).P(2); 
                P0_id=MESH.V0((-MESH.LATTICE(Lid_MESH).V(6))).P(2);
            else
                SkipFirst=1;
            end
        else
            if all(MESH.LATTICE(Lid_MESH).V(2:5)==0)  %正常后缘处涡格是V3/V4/V5=0，三角翼最外侧V2=0
                P0_id=MESH.V0((MESH.LATTICE(Lid_MESH).V(1))).P(2);    
            else
                P0_id=MESH.V0((MESH.LATTICE(Lid_MESH).V(2))).P(2);
            end
        end

% 说明：当翼段过渡时，由于可能存在舵面偏转问题，因此需要检查新翼段的第一个点
%       和上一个翼段的最后一个点是否重合，如果重合则不用重复生成尾涡。
%       注：当两个翼段存在因后缘偏转而产生错动时需要生成两个尾涡

        % 生成脱体涡涡线向量
        if ~SkipFirst
            for j=1:WL
                P0(PN).xyz=MESH.P0(P0_id).xyz+j/WL*Vinf';
                P0(PN).Relation=[0 0 0];
                P0(PN).Type=3;

                if j==1
                    V0(VN).P(1)=P0_id;
                    V0(VN).P(2)=PN+PN_EXST;
                else
                    V0(VN).P(1)=PN-1+PN_EXST;
                    V0(VN).P(2)=PN+PN_EXST;
                end
                PN=PN+1;
                                
                V0(VN).Type=12;
                V0(VN).Relation=[0 0 0];
                VN=VN+1;
            end
        end

        if i~=0
            LATTICE(LN).V=[(-(VN-WL-1):(-(VN-2*WL)))-VN_EXST,(VN-WL:VN-1)+VN_EXST];
        	LATTICE(LN).Lid_MESH=Lid_MESH;
            LN=LN+1;
        end

        if Isdraw==1   
            figure(110)
            if i>0  %画整个机翼
                for ii=Lid_MESH-nx+1:Lid_MESH
                    pX=[MESH.ELEM(ii).xyz(1,1) MESH.ELEM(ii).xyz(2,1) MESH.ELEM(ii).xyz(3,1) MESH.ELEM(ii).xyz(4,1) MESH.ELEM(ii).xyz(1,1) ];
                    pY=[MESH.ELEM(ii).xyz(1,2) MESH.ELEM(ii).xyz(2,2) MESH.ELEM(ii).xyz(3,2) MESH.ELEM(ii).xyz(4,2) MESH.ELEM(ii).xyz(1,2) ];
                    pZ=[MESH.ELEM(ii).xyz(1,3) MESH.ELEM(ii).xyz(2,3) MESH.ELEM(ii).xyz(3,3) MESH.ELEM(ii).xyz(4,3) MESH.ELEM(ii).xyz(1,3) ];
                    plot3(pX,pY,pZ,'k');  %画网格
                end
            end

            %画涡段
            for ii=VN_last:VN-1
                if ii==VN_last
                    XX=[MESH.P0(V0(ii).P(1)).xyz(1);P0(V0(ii).P(2)-PN_EXST).xyz(1)];
                    YY=[MESH.P0(V0(ii).P(1)).xyz(2);P0(V0(ii).P(2)-PN_EXST).xyz(2)];
                    ZZ=[MESH.P0(V0(ii).P(1)).xyz(3);P0(V0(ii).P(2)-PN_EXST).xyz(3)];
                else
                    XX=[P0(V0(ii).P(1)-PN_EXST).xyz(1);P0(V0(ii).P(2)-PN_EXST).xyz(1)];
                    YY=[P0(V0(ii).P(1)-PN_EXST).xyz(2);P0(V0(ii).P(2)-PN_EXST).xyz(2)];
                    ZZ=[P0(V0(ii).P(1)-PN_EXST).xyz(3);P0(V0(ii).P(2)-PN_EXST).xyz(3)];
                end

                plot3(XX,YY,ZZ,'-*');
                XX=mean(XX);
                YY=mean(YY);
                ZZ=mean(ZZ);
                text(XX,YY,ZZ,['\color{red}' num2str(ii+VN_EXST)]);
            end
        end

    end
end

FLAG.VN=VN;
FLAG.PN=PN;
FLAG.LN=LN;
FLAG.Lid_MESH=Lid_MESH;

end

function [WAKE]=WAKE_squeeze(LATTICE,V0,P0)
%去掉网格变量中预留位置的空值
for i=length(P0):-1:1
    if ~isempty(P0(i).Relation)
        break
    end
end
if i~=1
    P0(i+1:end)=[];
end
for i=length(V0):-1:1
    if ~isempty(V0(i).Relation)
        break
    end
end
if i~=1
    V0(i+1:end)=[];
end
WAKE.LATTICE=LATTICE;  %LATTICE的数量完全由后缘处网格数量决定，事前就很方便确定
WAKE.V0=V0;
WAKE.P0=P0;
end


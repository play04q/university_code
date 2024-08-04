function [WAKE]=pre_WAKE(PROC)

% �������µ�β��ʱ�����ýṹ����WAKE���м�¼��
% V0�����õ�Pid����MESH�еı�ż�������
% LATTICE�����õ�Vidͬ������MESH�е���Ž�������
%
% ���������ϱ�ʱ�ȸ���ÿ���ж����ny+1��β���߽��ж���
% FLAG���ڴ�����Ϣ������β�зֶ�����β�г��ȣ����б�űൽ�����

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
FLAG.WL=state.wakelength;   %β�ж���

%infdist=infdist/50;
%FLAG.WL=3;

FLAG.LN=1;                  %WAKE�е�LATTICE˳���
FLAG.VN=1;
FLAG.PN=1;

FLAG.Lid_MESH=0;             %��Ӧ��MESH�е�LATTICE���
if state.GND_EFF==1
    FLAG.VN_EXST=length(MESH.V0)*2;  
    FLAG.PN_EXST=length(MESH.P0)*2;
else
    FLAG.VN_EXST=length(MESH.V0);    %��MESH��sMESH�����е�V����
    FLAG.PN_EXST=length(MESH.P0);
end

FLAG.Vinf=transform('da',state)*[-infdist,0,0]';    %������ϵ������[-inf,0,0]ͶӰ�������ϵ��
if FLAG.WL==0
    FLAG.WL=1;
    FLAG.Vinf=[infdist,0,0]';    %��β�ж���Ϊ0ʱ��β���������ϵX�᷽��
end

%���������ϱ��������
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
WL=FLAG.WL;   %β�еĶ���
Vinf=FLAG.Vinf;
VN=FLAG.VN;   %�б���˳���(��WAKE�е�)
PN=FLAG.PN;
LN=FLAG.LN;
Lid_MESH=FLAG.Lid_MESH;   %WAKE�е�LATTICE��Ӧ��MESH��LATTICE��˳���
VN_EXST=FLAG.VN_EXST;
PN_EXST=FLAG.PN_EXST;
    
nelem=length(geo(s).ny);
nx=geo(s).nx;

P0_id=0;
for t=1:nelem
    ny=geo(s).ny(t);

    for i=0:ny
        if Isdraw==1
            VN_last=VN;    %Ϊ���滭ͼ�õı���
        end
        
        % ��λ����Ե�������е����
        if i~=1
            Lid_MESH=Lid_MESH+nx;
        end
        SkipFirst=0;  %��û�ж��沼��ʱ������������һ�κ�ÿ�������ĵ�
        if i==0
            if P0_id~=MESH.V0((-MESH.LATTICE(Lid_MESH).V(6))).P(2); 
                P0_id=MESH.V0((-MESH.LATTICE(Lid_MESH).V(6))).P(2);
            else
                SkipFirst=1;
            end
        else
            if all(MESH.LATTICE(Lid_MESH).V(2:5)==0)  %������Ե���и���V3/V4/V5=0�������������V2=0
                P0_id=MESH.V0((MESH.LATTICE(Lid_MESH).V(1))).P(2);    
            else
                P0_id=MESH.V0((MESH.LATTICE(Lid_MESH).V(2))).P(2);
            end
        end

% ˵��������ι���ʱ�����ڿ��ܴ��ڶ���ƫת���⣬�����Ҫ�������εĵ�һ����
%       ����һ����ε����һ�����Ƿ��غϣ�����غ������ظ�����β�С�
%       ע����������δ������Եƫת��������ʱ��Ҫ��������β��

        % ������������������
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
            if i>0  %����������
                for ii=Lid_MESH-nx+1:Lid_MESH
                    pX=[MESH.ELEM(ii).xyz(1,1) MESH.ELEM(ii).xyz(2,1) MESH.ELEM(ii).xyz(3,1) MESH.ELEM(ii).xyz(4,1) MESH.ELEM(ii).xyz(1,1) ];
                    pY=[MESH.ELEM(ii).xyz(1,2) MESH.ELEM(ii).xyz(2,2) MESH.ELEM(ii).xyz(3,2) MESH.ELEM(ii).xyz(4,2) MESH.ELEM(ii).xyz(1,2) ];
                    pZ=[MESH.ELEM(ii).xyz(1,3) MESH.ELEM(ii).xyz(2,3) MESH.ELEM(ii).xyz(3,3) MESH.ELEM(ii).xyz(4,3) MESH.ELEM(ii).xyz(1,3) ];
                    plot3(pX,pY,pZ,'k');  %������
                end
            end

            %���ж�
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
%ȥ�����������Ԥ��λ�õĿ�ֵ
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
WAKE.LATTICE=LATTICE;  %LATTICE��������ȫ�ɺ�Ե������������������ǰ�ͺܷ���ȷ��
WAKE.V0=V0;
WAKE.P0=P0;
end


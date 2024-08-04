function sWAKE=pre_sWAKE(PROC)

WAKE=PROC.WAKE;
state=PROC.state;

VN_WAKE=length(WAKE.V0);   %��WAKE�����е�V����
PN_WAKE=length(WAKE.P0);
LN_WAKE=length(WAKE.LATTICE);



%�������ϵ�е�����ͶӰ��������ϵ�У������Чʱ���踩���ǵ���ӭ��
ST.theta=state.alpha;
ST.psi=0;
ST.phi=0;

dH=state.ALT;
P0=WAKE.P0;
for i=1:PN_WAKE
    P0_IMG_G=(transform('gd',ST)*WAKE.P0(i).xyz')';  %_G��ָ��������ϵ
    P0_IMG_G(3)=P0_IMG_G(3)+2*(dH-P0_IMG_G(3));
    P0_IMG=(transform('dg',ST)*P0_IMG_G')';
    
    P0(i).xyz=P0_IMG;
    P0(i).Type=4;   %4-�����еĽǵ�
    %Relation ���ֲ���
end
sWAKE.P0=P0;

V0=WAKE.V0;
PN_MESH=length(PROC.MESH.P0);

for i=1:VN_WAKE
    V0(i).Type=14;
    if V0(i).P(1)<=PN_MESH    %����MESH�еĵ�ʱ��Ҫӳ�䵽sMESH��
        V0(i).P(1)=WAKE.V0(i).P(1)+PN_MESH;  
    else
        V0(i).P(1)=WAKE.V0(i).P(1)+PN_WAKE;  %WAKE�е��µ�ӳ����sWAKE
    end
    if V0(i).P(2)<=PN_MESH   %(��������˵�ڶ�����Ӧ���������ɵģ��������������)
        V0(i).P(2)=WAKE.V0(i).P(2)+PN_MESH;  
        keyboard
    else
        V0(i).P(2)=WAKE.V0(i).P(2)+PN_WAKE;  %WAKE�е��µ�ӳ����sWAKE
    end

    V0(i).Relation=WAKE.V0(i).Relation;
    %Relation ���ֲ���
end
sWAKE.V0=V0;

LATTICE=WAKE.LATTICE;
for i=1:LN_WAKE
    %�����е��ж�������ԭ���������෴
    LATTICE(i).V=-(WAKE.LATTICE(i).V+VN_WAKE*sign(WAKE.LATTICE(i).V));
end
sWAKE.LATTICE=LATTICE;
end

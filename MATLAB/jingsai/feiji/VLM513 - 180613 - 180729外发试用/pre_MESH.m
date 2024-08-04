function [MESH,HINGE]=pre_MESH(PROC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������㷨�ϲο��� Tomas Melin ��д���и񷨼������Tornado
% ��������϶��㷨�����������������˼��㾫����ֵ�ȶ���
% 
%���ļ��н���ȥ�������н��м򻯣�����Ե֮ǰ����ȫ����Ϊ�л���������Ե����
%���������С�������ԭ����8�㶨λ��Ϊ�����ڵ�6�㶨λ��
%OBJ_MESH������� VDW P V1 L;Ndrct;P1NV; P2V; FLAG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Isdraw;
Isdraw=0;   %2��Ӧ��һ��С�������е�BUG��ʱ��ȥ����
if Isdraw~=0
    figure(110)
    clf
    hold on
end

MESH=struct('ELEM',[],'C',[],'P0',[],'V0',[],'LATTICE',[],'nwing',0);
geo=PROC.geo;
MESH.nwing=length(geo);

P_nx=PROC.P_nx;
NODE=PROC.NODE;

nwing=length(geo);
HINGE={};

for s=1:nwing
    [dELEM,dC,dP0,dV0,dLATTICE,tHINGE]=mesh(NODE{s},P_nx(s),geo(s),s);

    if geo(s).symetric==1
        [dELEM,dC,dP0,dV0,dLATTICE]=mesh_symetric(dELEM,dC,dP0,dV0,dLATTICE);
    end
    MESH=mesh_add(MESH,dELEM,dC,dP0,dV0,dLATTICE);
    HINGE{s}=tHINGE;
end
    


%% ������������򻮷�վλ�ֲ�
%{
figure (990)
clf
hold on
for s=1:geo.nwing
    tLE=LE{s};
    tTE=TE{s};
    percent=percent_nx{s};
    nx=geo.nx(s);
    for t=1:geo.nelem(s)
        wingx=[tLE(t,1) tLE(t+1,1) tTE(t+1,1) tTE(t,1)];
        wingy=[tLE(t,2) tLE(t+1,2) tTE(t+1,2) tTE(t,2)];
        wingz=[tLE(t,3) tLE(t+1,3) tTE(t+1,3) tTE(t,3)]; 
        
        g=fill3(wingx,wingy,wingz,'w');
        set(g,'LineWidth',2);
        
        for i=1:nx
            XX=[tLE(t,1)+(tTE(t,1)-tLE(t,1))*percent(t,1,i);tLE(t+1,1)+(tTE(t+1,1)-tLE(t+1,1))*percent(t,2,i)];
            YY=[tLE(t,2)+(tTE(t,2)-tLE(t,2))*percent(t,1,i);tLE(t+1,2)+(tTE(t+1,2)-tLE(t+1,2))*percent(t,2,i)];
            ZZ=[tLE(t,3)+(tTE(t,3)-tLE(t,3))*percent(t,1,i);tLE(t+1,3)+(tTE(t+1,3)-tLE(t+1,3))*percent(t,2,i)];
            plot3(XX,YY,ZZ)
        end
    end
end
%}

%if Isdraw==2
%{
    figure(110)
    for i=1:length(geo(s).b)
        hold on;axis equal
        XX=[tLE(i,1) tLE(i+1,1) tTE(i+1,1) tTE(i,1) tLE(i,1)];
        YY=[tLE(i,2) tLE(i+1,2) tTE(i+1,2) tTE(i,2) tLE(i,2)];
        ZZ=[tLE(i,3) tLE(i+1,3) tTE(i+1,3) tTE(i,3) tLE(i,3)];
        plot3(XX,YY,ZZ);
        if geo(s).symetric==1
            YY=[-tLE(i,2) -tLE(i+1,2) -tTE(i+1,2) -tTE(i,2) -tLE(i,2)];
            plot3(XX,YY,ZZ);
        end
    end
%}


%{
for i=1:length(MESH.LATTICE)
    A1=MESH.P0(MESH.V0(MESH.LATTICE(i).V(1)).P(1)).xyz;
    B1=MESH.P0(MESH.V0(MESH.LATTICE(i).V(1)).P(2)).xyz;
    A3=MESH.P0(MESH.V0(-MESH.LATTICE(i).V(4)).P(1)).xyz;
    B3=MESH.P0(MESH.V0(-MESH.LATTICE(i).V(4)).P(2)).xyz;
    PP=(A1+B1+A3+B3)/4;
    htext=text(PP(1),PP(2),PP(3),['\color{red}' num2str(i)]);
    for j=1:6
        if MESH.LATTICE(i).V(j)~=0
            if MESH.LATTICE(i).V(j)>0
                XX=[MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(1)).xyz(1);MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(1)];
                YY=[MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(1)).xyz(2);MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(2)];
                ZZ=[MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(1)).xyz(3);MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(3)];
                X=MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(1);
                Y=MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(2);
                Z=MESH.P0(MESH.V0(MESH.LATTICE(i).V(j)).P(2)).xyz(3);
            else
                XX=[MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(2)).xyz(1);MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(1)];
                YY=[MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(2)).xyz(2);MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(2)];
                ZZ=[MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(2)).xyz(3);MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(3)];
                X=MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(1);
                Y=MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(2);
                Z=MESH.P0(MESH.V0(-MESH.LATTICE(i).V(j)).P(1)).xyz(3);
            end
            hp1(j)=plot3(XX,YY,ZZ,'-r'); 
            set(hp1(j),'LineWidth',2);
            hp2=plot3(X,Y,Z,'*r');
            pause(.2);
            delete(hp2);
        else
            hp1(j)=plot3(XX(2),YY(2),ZZ(2),'-r'); %#ok<*AGROW>
        end
    end
    delete(hp1);
    delete(htext);
end        
%}

end

function[ELEM,C,P0,V0,LATTICE,tHINGE]=mesh(Node,P_nx,geo,s)
global Isdraw
hinge_n=P_nx.hinge;
nelem=length(geo.ny);
nx=geo.nx;
tHINGE=zeros(nelem,2,3);

ELEM(1,nx*sum(geo.ny))=struct('xyz',[],'Relation',[]);
C(1,nx*sum(geo.ny))=struct('xyz',[],'N',[],'Relation',[]);
LATTICE(1,nx*sum(geo.ny))=struct('V',[]);
P0(1,2*(2*nx*(sum(geo.ny)+1)))=struct('xyz',[],'Type',[],'Relation',[]);
V0(1,2*((2*nx-1)*(sum(geo.ny)+1)+(nx+1)*(sum(geo.ny))))=struct('P',[],'Type',[],'Relation',[]);


CN=1;
PN=1;
VN=1;
LN=1;
EN=1;
SECid=0;
for t=1:nelem
    if t==1
        ny_start=1;
    else
        ny_start=2;
    end
    ny=geo.ny(t);
    
    for i=ny_start:ny+1   %��չ��ʼ�ƽ�
        PN_last=PN;
        CN_last=CN;
        VN_last=VN;
        SECid=SECid+1;
        
        %����������Ԫ�������ڵ�    
        %��A1    A2��
        %  B1    B2
        %  C1    C2
        
        %��Y�������ɿ��Ƶ�
        if ~(t==1 && i==1)     %Y���򻮷�
            for j=2:nx+1
                A1=squeeze(Node(SECid-1,j-1,:))';         
                B1=squeeze(Node(SECid-1,j  ,:))'; 
                A2=squeeze(Node(SECid  ,j-1,:))';         
                B2=squeeze(Node(SECid  ,j  ,:))'; 
                %���Ƶ�����
                SCL=0.75;      %SCL=���Ƶ����ԪǰԵ�ٷֱȣ������õġ�
                C(CN).xyz=(A1+SCL*(B1-A1)+A2+SCL*(B2-A2))/2; %�µĿ��Ƶ�
                %����
                A12=(A1+A2)/2;
                B12=(B1+B2)/2;
                L1=squeeze(B12-A12);
                AB1=A1+SCL*(B1-A1);
                AB2=A2+SCL*(B2-A2);
                L2=squeeze(AB1-AB2);
                Drct=cross(L1,L2);
                C(CN).N=Drct/norm(Drct);
                if hinge_n(t)~=0 && j-1>hinge_n(t)  %hingeʵ�����Ǵ�ǰԵ���ĵڼ�����
                    C(CN).Relation=[s t 1];
                else               
                    C(CN).Relation=[s 0 1];
                end
                CN=CN+1;
            end
        end
        
        for j=2:nx+1   %��X�������ɽڵ�
            A2=squeeze(Node(SECid,j-1,:))';         
            B2=squeeze(Node(SECid,j  ,:))'; 
            if i==ny+1 && isequal(Node(SECid,1,:),Node(SECid,end,:))  %�������������
                P0(PN).xyz=A2  ; %�µĸ����е�
                P0(PN).Relation=[s 0 1];
                P0(PN).Type=2;
                PN=PN+1;
                break
            end
            SCL=0.25;                 %SCL=�����о���ԪǰԵ�ٷֱ�
            P0(PN).xyz=A2+SCL*(B2-A2); %�µĸ����е�
            P0(PN+1).xyz=B2;

            if hinge_n(t)~=0 && j-1>hinge_n(t)
                    P0(PN).Relation=[s t 1];
                    P0(PN+1).Relation=[s t 1];
            else
                    P0(PN).Relation=[s 0 1];
                    P0(PN+1).Relation=[s 0 1];
            end
            P0(PN).Type=1;
            if j==nx+1
                P0(PN+1).Type=2;
            else
                P0(PN+1).Type=1;
            end
            PN=PN+2;
        end
            
        %��Y�������ɸ���������
        if ~(t==1 && i==1)     %Y���򻮷�
            for j=1:2:2*nx-1  %B1��B2��֮�����У���˲���Ϊ2;��Ե��������Y��������
                if i==ny+1 &&isequal(Node(SECid,1,:),Node(SECid,end,:))  %�������������
                    Pid_end=PN-1;
                    Pid_startfix=2*nx-1;
                else
                    Pid_end=PN-2*nx+j-1;
                    Pid_startfix=0;
                end
                if t>1 && i==2        %����ÿ����εĵ�һ��
                    CF_flag=(hinge_n(t-1)~=0) || (hinge_n(t)~=0);
                    if CF_flag==1   %�����ڶ���ʱ
                        if hinge_n(t)==0
                            CF_nx=nx-hinge_n(t-1);
                        elseif hinge_n(t-1)==0
                            CF_nx=nx-hinge_n(t);
                        else
                            CF_nx=nx-min(hinge_n(t-1:t));    %���洦�ิ�Ƶ�������
                        end
                        if j/2<=nx-CF_nx          %��һ�ζ���ǰ��
                            V0(VN).P=[PN-4*nx+j-1-2*CF_nx+Pid_startfix,Pid_end];
                        else
                            V0(VN).P=[PN-4*nx+j-1+Pid_startfix,Pid_end];
                        end
                    else           %�����ڶ���ʱ����һ�����
                        V0(VN).P=[PN-4*nx+j-1+Pid_startfix,Pid_end];
                    end
                else    %���ǵ�һ��ʱ����һ�����
                    V0(VN).P=[PN-4*nx+j-1+Pid_startfix,Pid_end];
                end
                V0(VN).Type=11;

                
                if hinge_n(t)~=0 && (j/2)>hinge_n(t)    
                    V0(VN).Relation=[s t 1];
                else
                    V0(VN).Relation=[s 0 1];
                end
                VN=VN+1;
            end  %for
        end
        
        for j=2:nx*2   %��X��������������
            if i==ny+1 && isequal(Node(SECid,1,:),Node(SECid,end,:))  %�������������
                break
            end
            V0(VN).P=[PN-2*nx+j-2,PN-2*nx+j-1];
            V0(VN).Type=11;
            if hinge_n(t)~=0 && (j/2)>hinge_n(t)
                V0(VN).Relation=[s t 1];
            else
                V0(VN).Relation=[s 0 1];
            end
            VN=VN+1;
        end
       
        if ~(t==1 && i==1)    %����LATTICE
            for j=1:nx
                if t>1 && i==2        %����ÿ����εĵ�һ��
                     CF_flag=(hinge_n(t-1)~=0) || (hinge_n(t)~=0);
                     if hinge_n(t)==0
                         CF_nx=nx-hinge_n(t-1);
                     elseif hinge_n(t-1)==0
                         CF_nx=nx-hinge_n(t);
                     else
                         CF_nx=nx-min(hinge_n(t-1:t));    %���洦�ิ�Ƶ�������
                     end
                else
                    CF_flag=0;
                end
                
                % �Ҳ����������жε�ȷ�� V2/V3
                if i==ny+1 && isequal(Node(SECid,1,:),Node(SECid,end,:))  %�������������
                    Vid_startfix=2*nx-1;
                    V2=0;
                    V3=0;
                else    %һ������������
                    Vid_startfix=0;
                    V2=VN-(2*nx-1)+2*j-2;
                    if j==nx   %��Եλ������
                        V3=0;
                    else
                        V3=VN-(2*nx-1)+2*j-1;
                    end
                end
                
                % ǰ��չ�������жε�ȷ�� V1/V4
                V1=VN-(3*nx)+j+Vid_startfix;
                if j==nx %��Եλ������
                    V4=0;
                else
                    V4=-(VN-(3*nx)+j+1+Vid_startfix);
                end
                
                %������������жε�ȷ�� V5/V6
                %���������ڶ���ʱ��Ҫ���Ƕ���λ�ô������ɵ��ж�
                if CF_flag==1 && j<=nx-CF_nx %�����ڶ���,���������ڽ�����֮��
                     if j<nx-CF_nx          %��һ�ζ���ǰ��
                        V5=-(VN-(5*nx-1)+2*j-2*CF_nx+Vid_startfix);
                        V6=-(VN-(5*nx-1)+2*j-1-2*CF_nx+Vid_startfix);
                     elseif j==nx-CF_nx     %��һ�ζ����ϵ�
                        V5=-(VN-(5*nx-1)+2*j+Vid_startfix);%-(VN-(3*nx)-2*CF_nx+Vid_startfix);
                        V6=-(VN-(5*nx-1)+2*j-1-2*CF_nx+Vid_startfix);%-(VN-(3*nx)-4*CF_nx-1+Vid_startfix);
                     end
                 else  %����Ҫ���Ƕ�������ʱ��һ�����
                    V6=-(VN-(5*nx-1)+2*j-1+Vid_startfix);
                    if j==nx  %��Եλ������
                        V5=0;
                    else      %�Ǻ�Եλ��
                        V5=-(VN-(5*nx-1)+2*j+Vid_startfix);
                    end
                end
                LATTICE(LN).V=[V1,V2,V3,V4,V5,V6];
                %disp(LATTICE(LN).V)                
                LN=LN+1;
            end
        end
        
        if i==ny+1 && t<nelem    %�����������������λ�õ�����Ϊ��������׼��
            CF_flag=(hinge_n(t)~=0) || (hinge_n(t+1)~=0);
            if CF_flag==1
                if hinge_n(t+1)==0
                    CF_nx=nx-hinge_n(t);
                elseif hinge_n(t)==0
                    CF_nx=nx-hinge_n(t+1);
                else
                    CF_nx=nx-min(hinge_n(t:t+1));    %���洦��������
                end
                for j=1:CF_nx*2  %һ������Ԫ���������ڵ���Ҫ����
                    P0(PN)=P0(PN-2*CF_nx);  %�����洦�Ľڵ㸴��һ����������
                    if hinge_n(t+1)==0
                        P0(PN).Relation=[s 0 1];
                    else
                        if j/2<=CF_nx-(nx-hinge_n(t+1))
                            P0(PN).Relation=[s 0 1];
                        else
                            P0(PN).Relation=[s t+1 1];
                        end
                    end
                    if j==CF_nx*2
                        P0(PN).Type=2;
                    else
                        P0(PN).Type=1;
                    end
                    PN=PN+1;
                end
                for j=1:CF_nx*2
                    if j==1
                        V0(VN).P=[PN-4*CF_nx+j-2,PN-2*CF_nx+j-1];  
                    else
                        V0(VN).P=[PN-2*CF_nx+j-2,PN-2*CF_nx+j-1];   %����λ�õ���������������
                    end
                    V0(VN).Type=11;
                    if j/2<=CF_nx-(nx-hinge_n(t+1))
                        V0(VN).Relation=[s 0 1];
                    else
                        V0(VN).Relation=[s t+1 1];
                    end
                    VN=VN+1;
                end
            end
        end
        
        if i>=2 
            for j=2:nx+1
                ELEM(EN).xyz(1,:)=squeeze(Node(SECid-1,j-1,:))';
                ELEM(EN).xyz(2,:)=squeeze(Node(SECid,  j-1,:))';
                ELEM(EN).xyz(3,:)=squeeze(Node(SECid,  j  ,:))';
                ELEM(EN).xyz(4,:)=squeeze(Node(SECid-1,j  ,:))';
                if hinge_n(t)~=0 && j-2>=hinge_n(t)
                    ELEM(EN).Relation=[s,t,1];
                else
                    ELEM(EN).Relation=[s,0,1];
                end
                EN=EN+1;
            end
        end
        %if i==2 && hinge_n(t)~=0
        %    tHINGE(t,1,:)=squeeze(Node(SECid-1,hinge_n(t)+1,:))';
        %    tHINGE(t,2,:)=squeeze(Node(SECid  ,hinge_n(t)+1,:))';
        %end   ��ȥ�Ľ�����ֻ��ֱ��λ����ȷ���ʽ������
        if i==2 && hinge_n(t)~=0
            tHINGE(t,1,:)=squeeze(Node(SECid-1,hinge_n(t)+1,:))';
        end
        if i==ny+1 && hinge_n(t)~=0
            tHINGE(t,2,:)=squeeze(Node(SECid  ,hinge_n(t)+1,:))';
        end
        
        if Isdraw==1
            figure(110)
            %������ڵ�
            for tmp=PN_last:PN-1
                if P0(tmp).Relation(2)==0
                    CR='*g';
                else
                    CR='*b';
                end
                plot3(P0(tmp).xyz(1),P0(tmp).xyz(2),P0(tmp).xyz(3),CR);
                text(P0(tmp).xyz(1),P0(tmp).xyz(2),P0(tmp).xyz(3),num2str(tmp));
            end

            %���ж�
            for j=VN_last:VN-1
                XX=[P0(V0(j).P(1)).xyz(1);P0(V0(j).P(2)).xyz(1)];
                YY=[P0(V0(j).P(1)).xyz(2);P0(V0(j).P(2)).xyz(2)];
                ZZ=[P0(V0(j).P(1)).xyz(3);P0(V0(j).P(2)).xyz(3)];

                if V0(j).Relation(2)==0
                    CR='-g';
                else
                    CR='-b';
                end
                plot3(XX,YY,ZZ,CR);
                XX=(P0(V0(j).P(1)).xyz(1)+P0(V0(j).P(2)).xyz(1))/2;
                YY=(P0(V0(j).P(1)).xyz(2)+P0(V0(j).P(2)).xyz(2))/2;
                ZZ=(P0(V0(j).P(1)).xyz(3)+P0(V0(j).P(2)).xyz(3))/2;
                text(XX,YY,ZZ,['\color{red}' num2str(j)]);
            end

            %�����Ƶ�
            cCHORD=squeeze(Node(SECid,end,:)-Node(SECid,1,:))';
            SCL=norm(cCHORD)/10;
            for j=CN_last:CN-1
                X=[C(j).xyz(1);C(j).xyz(1)+SCL*C(j).N(1)];
                Y=[C(j).xyz(2);C(j).xyz(2)+SCL*C(j).N(2)];
                Z=[C(j).xyz(3);C(j).xyz(3)+SCL*C(j).N(3)];
                if C(j).Relation(2)==0
                    CR='-g';
                else
                    CR='-b';
                end
                plot3(X,Y,Z,CR);
            end
            keyboard
        end
    end
end

if Isdraw==2
    figure(110)
    for i=1:LN-1
        A1=P0(V0(LATTICE(i).V(1)).P(1)).xyz;
        B1=P0(V0(LATTICE(i).V(1)).P(2)).xyz;
        A3=P0(V0(-LATTICE(i).V(4)).P(1)).xyz;
        B3=P0(V0(-LATTICE(i).V(4)).P(2)).xyz;
        PP=(A1+B1+A3+B3)/4;
        htext=text(PP(1),PP(2),PP(3),['\color{red}' num2str(i)]);
        for j=1:6
            if LATTICE(i).V(j)~=0
                if LATTICE(i).V(j)>0
                    XX=[P0(V0(LATTICE(i).V(j)).P(1)).xyz(1);P0(V0(LATTICE(i).V(j)).P(2)).xyz(1)];
                    YY=[P0(V0(LATTICE(i).V(j)).P(1)).xyz(2);P0(V0(LATTICE(i).V(j)).P(2)).xyz(2)];
                    ZZ=[P0(V0(LATTICE(i).V(j)).P(1)).xyz(3);P0(V0(LATTICE(i).V(j)).P(2)).xyz(3)];
                    X=P0(V0(LATTICE(i).V(j)).P(2)).xyz(1);
                    Y=P0(V0(LATTICE(i).V(j)).P(2)).xyz(2);
                    Z=P0(V0(LATTICE(i).V(j)).P(2)).xyz(3);
                else
                    XX=[P0(V0(-LATTICE(i).V(j)).P(2)).xyz(1);P0(V0(-LATTICE(i).V(j)).P(1)).xyz(1)];
                    YY=[P0(V0(-LATTICE(i).V(j)).P(2)).xyz(2);P0(V0(-LATTICE(i).V(j)).P(1)).xyz(2)];
                    ZZ=[P0(V0(-LATTICE(i).V(j)).P(2)).xyz(3);P0(V0(-LATTICE(i).V(j)).P(1)).xyz(3)];
                    X=P0(V0(-LATTICE(i).V(j)).P(1)).xyz(1);
                    Y=P0(V0(-LATTICE(i).V(j)).P(1)).xyz(2);
                    Z=P0(V0(-LATTICE(i).V(j)).P(1)).xyz(3);
                end
                hp1(j)=plot3(XX,YY,ZZ,'-r'); 
                set(hp1(j),'LineWidth',2);
                hp2=plot3(X,Y,Z,'*r');
                pause(.2);
                delete(hp2);
            else
                hp1(j)=plot3(XX(2),YY(2),ZZ(2),'-r'); %#ok<*AGROW>
            end
        end
        delete(hp1);
        delete(htext);
    end
end

%ȥ�����������Ԥ��λ�õĿ�ֵ
idx=0;
for i=1:length(P0)
    if isempty(P0(i).Relation)
        idx=i;
        break
    end
end
if idx~=0
    P0(idx:end)=[];
end
idx=0;
for i=1:length(V0)
    if isempty(V0(i).Relation)
        idx=i;
        break
    end
end
if idx~=0
    V0(idx:end)=[];
end
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ELEM,C,P0,V0,LATTICE]=mesh_symetric(ELEM,C,P0,V0,LATTICE)
nELEM=length(ELEM);
nC=length(C);
nP0=length(P0);
nV0=length(V0);
nL=length(LATTICE);

dELEM=ELEM;
for i=1:nELEM
    for j=1:4
        dELEM(i).xyz(j,2)=-dELEM(i).xyz(j,2);
    end
    if dELEM(i).Relation(3)==1
        dELEM(i).Relation(3)=2;
    end
end

dC=C;
for i=1:nC
    dC(i).xyz(2)=-dC(i).xyz(2);
    dC(i).N(2)=-dC(i).N(2);
    if dC(i).Relation(3)==1
        dC(i).Relation(3)=2;
    end
end

dP0=P0;
for i=1:nP0
    dP0(i).xyz(2)=-dP0(i).xyz(2);
    if dP0(i).Relation(3)==1
        dP0(i).Relation(3)=2;
    end
end

dV0=V0;
for i=1:nV0
    dV0(i).P=dV0(i).P+nP0;
    if dV0(i).Relation(3)==1
        dV0(i).Relation(3)=2;
    end
end

dLATTICE=LATTICE;
for i=1:nL
    for j=1:6
        if dLATTICE(i).V(j)<0
            dLATTICE(i).V(j)=dLATTICE(i).V(j)-nV0;
        elseif dLATTICE(i).V(j)>0
            dLATTICE(i).V(j)=dLATTICE(i).V(j)+nV0;
        end
    end
end

ELEM=[ELEM dELEM];
C=[C dC];
P0=[P0 dP0];
V0=[V0 dV0];
LATTICE=[LATTICE dLATTICE];
end


function MESH=mesh_add(MESH,dELEM,dC,dP0,dV0,dLATTICE)
nP0=length(MESH.P0);
nV0=length(MESH.V0);

ndV0=length(dV0);
ndL=length(dLATTICE);

for i=1:ndV0
    dV0(i).P=dV0(i).P+nP0;
end

for i=1:ndL
    for j=1:6
        if dLATTICE(i).V(j)<0
            dLATTICE(i).V(j)=dLATTICE(i).V(j)-nV0;
        elseif dLATTICE(i).V(j)>0
            dLATTICE(i).V(j)=dLATTICE(i).V(j)+nV0;
        end
    end
end
MESH.ELEM=[MESH.ELEM dELEM];
MESH.C=[MESH.C dC];
MESH.P0=[MESH.P0 dP0];
MESH.V0=[MESH.V0 dV0];
MESH.LATTICE=[MESH.LATTICE dLATTICE];
end


function NODE=pre_NODE(PROC)
%生成几何图形上的节点NODE(wingID,sectionID,pointID,XYZ)
%NODE{s}=[展向,弦向,3]
global Isdraw;
Isdraw=0;

%设置弦向划分网格的站位点
P_nx=PROC.P_nx;

geo=PROC.geo;
CATfile=PROC.CATfile;
nwing=length(geo);
NODE=cell(1,nwing);

if Isdraw==1    %画网格线
    figure (110)
    clf
    hold on
    axis equal
end 
for s=1:nwing
    if isempty(geo(s).b)
        NODE{s}=NODEcreate_CAT(CATfile,P_nx(s),geo(s),s);
    else
        %生成机翼的前后缘向量
        [LE,TE]=Geo_wing(geo,s);
        NODE{s}=NODEcreate_TXT(P_nx,LE,TE,geo,s);
    end

    if Isdraw==1    %画网格线
        figure (110)
        sNODE=NODE{s};
        [ny,nx,~]=size(sNODE);
        for i=2:ny
             for j=2:nx
                 XX=[sNODE(i-1,j-1,1);sNODE(i-1,j,1);sNODE(i,j,1);sNODE(i,j-1,1);sNODE(i-1,j-1,1)];
                 YY=[sNODE(i-1,j-1,2);sNODE(i-1,j,2);sNODE(i,j,2);sNODE(i,j-1,2);sNODE(i-1,j-1,2)];
                 ZZ=[sNODE(i-1,j-1,3);sNODE(i-1,j,3);sNODE(i,j,3);sNODE(i,j-1,3);sNODE(i-1,j-1,3)];
                 plot3(XX,YY,ZZ,'-');
             end
        end
    end
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NODE=NODEcreate_CAT(CATfile,P_nx,geo,s)
percent_nx=P_nx.percent;
nelem=length(geo.ny);

IDX=0;
for t=1:nelem
    if t==1
        ny_start=0;
    else
        ny_start=1;
    end
    ny=geo.ny(t);
    
    for i=ny_start:ny   %沿展向开始推进
        IDX=IDX+1;
        %读取当前翼段使用的翼型
        SEC_name=[num2str(s) '-' num2str(t) '-' num2str(i)];
        NODE(IDX,:,:)=CATfile_CamberNodes(CATfile,SEC_name,percent_nx(t,:)); %沿中弧线布置节点

    end
    
end


end

function NODE=NODEcreate_TXT(P_nx,LE,TE,geo,s)
global Isdraw;
percent_nx=P_nx(s).percent;
nelem=length(geo(s).b);
nx=geo(s).nx;

if geo(s).wingtype==1
    frotate=zeros(1,nelem);
else
    frotate=geo(s).dihed(:);
end

IDX=0;
for t=1:nelem
    percent_cy=(0:geo(s).ny(t))./geo(s).ny(t);
    LE1=LE(t,:);
    TE1=TE(t,:);
    LE2=LE(t+1,:);
    TE2=TE(t+1,:);
    
    %绘图，显示当前翼段外形
    if Isdraw==1 || Isdraw==2
        figure(110) %UNCOMMENT THESE ROWS TO DRAW WING OUTLINES 
        hold on;axis equal
        XX=[LE1(1) LE2(1) TE2(1) TE1(1)];
        YY=[LE1(2) LE2(2) TE2(2) TE1(2)];
        ZZ=[LE1(3) LE2(3) TE2(3) TE1(3)];
        plot3(XX,YY,ZZ);
    end
    
    dLE=LE2-LE1;%前缘增量
    dTE=TE2-TE1;%后缘增量
    
    %读取当前翼段使用的翼型
    [F1x,F1yc,~,~]=readfoil(geo(s).foil(t)); %翼段内侧翼型
    [F2x,F2yc,~,~]=readfoil(geo(s).foil(t+1)); %翼段外侧翼型
    
    if t==1
        ny_start=1;
    else
        ny_start=2;
    end
    ny=geo(s).ny(t);
    
    for i=ny_start:ny+1   %沿展向开始推进
        IDX=IDX+1;
        cLE=LE1+percent_cy(i)*dLE;
        cTE=TE1+percent_cy(i)*dTE;
        cCHORD=cTE-cLE;  
        %P_Spanwise=1表示当前翼弦位于翼段最内侧,P_Spanwise=0表示位于最外侧
        P_Spanwise=sqrt((cLE(2)-LE2(2))^2+(cLE(3)-LE2(3))^2)/sqrt((LE1(2)-LE2(2))^2+(LE1(3)-LE2(3))^2); 
        
        if ~isequal(cTE,cLE)
            %当前翼弦的切向和法向
            cCHORDtan=cCHORD/norm(cCHORD);
            cCHORDnom=cCHORDtan*[cos(-pi/2)    0   -sin(-pi/2)
                                    0          1         0
                                 sin(-pi/2)    0    cos(-pi/2)];  %相当于绕y轴方向转-90deg
            cCHORDnom=cCHORDnom*[   1         0              0
                                    0    cos(frotate(t))   sin(frotate(t))
                                    0    -sin(frotate(t))  cos(frotate(t))];  %相当于绕x轴方向转dihed rad                 
        end
        
        %画切向和法向
        %{ 
        if Isdraw==1  
            figure(110) %UNCOMMENT THESE ROWS TO DRAW WING OUTLINES 
            AA=[cTE;cTE+cCHORDtan]';
            plot3(AA(1,:),AA(2,:),AA(3,:));
            AA=[cTE;cTE+cCHORDnom]';
            plot3(AA(1,:),AA(2,:),AA(3,:));
        end
        %}

        for j=1:nx+1
            % 进行弦向划分
            P_Chordwise(j)=percent_nx(t,j)*P_Spanwise+percent_nx(t+1,j)*(1-P_Spanwise);
            p(j,:)=cLE+P_Chordwise(j)*cCHORD;   %当前节点位置
        end
        if  ~(i==ny+1 && geo(s).c(t+1)==0)  %弯度修正
            YC1=interp1(F1x,F1yc,P_Chordwise,'PCHIP','extrap'); %element inboard camber slope  
            YC2=interp1(F2x,F2yc,P_Chordwise,'PCHIP','extrap'); %element outboard camber slope 
            dY=(YC1*P_Spanwise+YC2*(1-P_Spanwise))*norm(cCHORD); %%
            NODE(IDX,:,:)=p+dY'*cCHORDnom;  %节点坐标(加弯度因素的)，中间变量
        else
            NODE(IDX,:,:)=p;   %对于三角翼外侧尖点不需要弯度修正
        end
    end
end
end

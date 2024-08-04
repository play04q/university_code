function spanload2(PROC,CurrentResults,cmdline)
persistent legendTXT
colors={'b','r','g','k','m','c','y','b:','r:','g:','k:','m:','c:','y:'};
%cmdline 1-单文件单迎角   2-多状态更新   3-多状态添加 
%求展向分布时只考虑每个涡环上V1段产生的气动力
%首先找到所有V1段对应的Vid
if isempty(legendTXT) || cmdline==1 || cmdline==2
    legendTXT=cell(0,0);
    figure(51)
    clf
%     figure(52)
%     clf
end

MESH=PROC.MESH;
geo=PROC.geo;
Lsize=length(MESH.LATTICE);
nwing=MESH.nwing;
matrix_Vid_LV1=zeros(nwing,Lsize);

IDX=zeros(1,nwing);
for i=1:Lsize
    Vid=MESH.LATTICE(i).V(1);  %依次得到每个涡环上V1对应的Vid
    wingID=MESH.V0(Vid).Relation(1);
    
    IDX(wingID)=IDX(wingID)+1;
    matrix_Vid_LV1(wingID,IDX(wingID))=Vid;
end

Tad=transform('ad',PROC.state);
for s=1:nwing
    if PROC.geo(s).ismain==1
        IDX_main=s;
    end
end
        
Vids=squeeze(matrix_Vid_LV1(IDX_main,:));
Vids(Vids==0)=[];
nV_wing=length(Vids);
b_ref=PROC.ref.b_ref(IDX_main);

FPM0=zeros(nV_wing,3);
Y0=zeros(1,nV_wing);
for i=1:nV_wing
    pVxyz1=MESH.P0(MESH.V0(Vids(i)).P(1)).xyz;
    pVxyz2=MESH.P0(MESH.V0(Vids(i)).P(2)).xyz;
    pSPAN=abs(pVxyz2(2)-pVxyz1(2));
    PV_Center=(pVxyz1+pVxyz2)/2;

    F_aero=Tad*(CurrentResults.PTL.F(Vids(i),:))';
    Y0(i)=PV_Center(2);
    FPM0(i,:)=F_aero/pSPAN;  %每个面元上的展向分布力N/m
end
[Y0,IX]=sort(Y0);            %对截面处升力-展向站位进行排序
FPM0=FPM0(IX,:);

%对相同展向位置进行合并
%按展向截面坐标进行分组，为避免数值上的错误采用下面方法
i=2;
Y=Y0;
lastY=Y(1);
while i<=length(Y)
    if abs(Y(i)-lastY)<=0.0001
        Y(i)=[];
    else
        lastY=Y(i);
        i=i+1;
    end
end

FPM=zeros(length(Y),3);
IDX=1;
for i=1:nV_wing
    if i==1
        lastY=Y0(1);
    else
        KK=abs(Y0(i)-lastY);
        if KK>.0001
            IDX=IDX+1;
            lastY=Y0(i);
        end
    end
    FPM(IDX,:)=FPM(IDX,:)+FPM0(i,:);
end

FPM=[FPM;[0,0,0]];
Y=[Y,b_ref/2]; 
if geo(IDX_main).symetric==1
    FPM=[[0,0,0];FPM];  
    Y=[-b_ref/2,Y];  
end

Y_interp=Y(1):(Y(end)-Y(1))/50:Y(end);
Lift=CurrentResults.PTL.nL(IDX_main);
LPM_interp=interp1(Y,-squeeze(FPM(:,3))',Y_interp,'pchip');
DPM_interp=interp1(Y,-squeeze(FPM(:,1))',Y_interp,'pchip');
LPMe_interp=(4*Lift/pi/b_ref).*sqrt(1-(Y_interp/(b_ref/2)).^2);

%求解每个展向位置的弦长，考虑到CATIA导入的模型可能存在曲线前缘
%因此采用分段插值方法
KK=length(Y_interp);
Y_interp_Half=Y_interp(fix(KK/2+.5):KK);

nelem=length(geo(IDX_main).ny);
cNODE=PROC.NODE{IDX_main};
CHORD_interp=zeros(1,fix(KK/2+.5));
YHid_start=1;
for t=1:nelem
    if t==1 
        SEC_start=1;
        for i=1:IDX_main-1
            SEC_start=SEC_start+sum(geo(i).ny);
        end
    else
        SEC_start=SEC_end;
    end
    SEC_end=SEC_start+geo(IDX_main).ny(t);
    CHORDs=abs(cNODE(SEC_start:SEC_end,end,1)-cNODE(SEC_start:SEC_end,1,1));
    Ys=cNODE(SEC_start:SEC_end,1,2);
    YHid_end=sum(Ys(end)>=Y_interp_Half);
    CHORD_interp(YHid_start:YHid_end)=interp1(Ys,CHORDs, ...
        Y_interp_Half(YHid_start:YHid_end),'pchip');
    YHid_start=YHid_end+1;
end
CHORD_interp=[fliplr(CHORD_interp(2:end)) CHORD_interp];

q=.5*PROC.state.rho*PROC.state.AS^2;
CLPM_interp=LPM_interp./CHORD_interp./q;
CLPMe_interp=LPMe_interp./CHORD_interp./q;
CDPM_interp=DPM_interp./CHORD_interp./q;

figure(51)
subplot(2,2,1)
hold on
xlabel('Spanwise Position m')
ylabel('Lift N/m')
if cmdline==1
    plot(Y_interp,LPMe_interp,'b:')
    legendTXT={'Ellipse Distribution of Lift',['<' PROC.name '> at Alpha = ',num2str(rad2deg(PROC.state.alpha))]};
else
    legendTXT=[legendTXT,['<' PROC.name '> at Alpha = ',num2str(rad2deg(PROC.state.alpha))]];
end
T=length(legendTXT);
if T>14 
    T=T-14;
end
plot(Y_interp,LPM_interp,colors{T})
legend(legendTXT,'location','EastOutside')

subplot(2,2,3)
hold on
xlabel('Spanwise Position m')
ylabel('Lift Coefficient')
if cmdline==1
    plot(Y_interp,CLPMe_interp,'b:')
    legendTXT={['<' PROC.name '> at Alpha = ',num2str(rad2deg(PROC.state.alpha))], ...
        'Ellipse Distribution of C_L'};
end
T=length(legendTXT);
if T>14 
    T=T-14;
end
plot(Y_interp,CLPM_interp,colors{T})
legend(legendTXT,'location','EastOutside')

% figure(52)
% if cmdline==1
%     legendTXT={['<' PROC.name '> at Alpha = ',num2str(rad2deg(PROC.state.alpha))]};
% end
subplot(2,2,2)
hold on
xlabel('Spanwise Position m')
ylabel('Drag N/m')
T=length(legendTXT);
if T>14 
    T=T-14;
end
plot(Y_interp,DPM_interp,colors{T})
legend(legendTXT,'location','EastOutside')

subplot(2,2,4)
hold on
xlabel('Spanwise Position m')
ylabel('Drag Coefficient')
T=length(legendTXT);
if T>14 
    T=T-14;
end
plot(Y_interp,CDPM_interp,colors{T})
legend(legendTXT,'location','EastOutside')

% 当升力满足椭圆分布时的升力沿展向分布情况
%disp(trapz(Y_interp,DPM_interp))
%}




end

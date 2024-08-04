function[results]=solver_friction(PROC)
%zeroliftdragpred, Zero Lift Drag Prediction.
%This function predicts the zero lift drag of an airplane configuration
%
%Component buildup method, Eckerts equation, Raymer formulatation, Melin
%Implementation
%
%--------------------------------------------
%
%Inputs are:
% Tornado variable structures.
% Mach: Mach number, useful range [0 0.7], it will still work up to M=1,
%       but the errors will start to increase
%
% Alt:  Altitude in meters. The atmosphere model used is the 1976 
%       International Standard Atmosphere (ISA).
%
% geo:  Geometry structure at defined in Tornado. However, all airfoil
%       sections MUST be defined by a coordinate file. Plus an interference
%       factor matrix, geo.inter, which defines the interference factors of
%       each partition. If Geo.inter is undefined it will be assumed to be
%       ones, which is fairly close anyway.
%
% ref:  Reference units structure as defined in Tornado.
%
%----------------------------------------------
%
% Outputs:
%
% CD0:  Matrix with zero lift drag for each wing partition in Tornado Standard.
%       First wing centersection drag is set to zero as it is assimed to be
%       inside a fuselage.
%
%                    Partition 1      partition 2    partition 3   ...
%       first wing        0                X              X        ... 
%       second wing       X                X              X        ...
%       third wing        X                X              X        ...
%            :            ...             ...            ...       ...
%
%
% Re
%
%-----------------------------------------------
%
% 算法特殊说明
% 层流至稳流转捩点设置位于10%弦长处
% 机体表面粗糙度设置为光滑喷漆后状态
% Tubulent transition is hardcoded to 10% chord.
% If the maximum thickness to chord ratio is constant across a partition,
% and if it's position moves. The innermost position will be selected.
% Surface roughness is hardcoded to smooth paint.
%
%%%%%%%%%%%%%%%%%%%%%%%
state=PROC.state;
ref=PROC.ref;


%% Constants definition  阻力估算基于Raymer方法
Condition.K=0.633984*10^(-5);                   %蒙皮表面粗糙值，取光滑涂漆数值 (Raymer table 12.4) 原文2.08E-5 ft
Condition.tpoint=0.1;                           %Hardcoded transitionpoint all parts  层流转捩点位置
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%% Computing state
[Condition.Rho,a,~,Condition.Miu]=ISAtmosphere(state.ALT);     %Calling International Standard atmosphere.
Condition.V=state.AS;
Condition.Mach=Condition.V/a;
%%%%%%%%%%%%%%%%%%%%%

%% Wing drag / Lifting Surface Drag!
nwing=PROC.MESH.nwing;
%Re=(Rho*V)*ref.C_mac_M/(Miu);                        %Reference reynolds no / Cmac  

for s=1:nwing
    if isempty(PROC.geo(s).b)
        [dCD0,dSwet,dVol]=D0_CAT(PROC,Condition,s);
    else
        [dCD0,dSwet,dVol]=D0_TXT(PROC,Condition,s);
    end
    results.nCD0(s)=dCD0;
    results.nD0(s)=.5*Condition.Rho*state.AS^2*ref.S_ref_M*dCD0;
    results.nSwet(s)=dSwet;
    results.nVol(s)=dVol;

end

results.CD0=sum(results.nCD0);
results.D0=sum(results.nD0);
%ref.Swet=sum(results.nSwet);
%ref.Vol=sum(results.nVol);
end %Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dCD0,dSwet,dVol]=D0_CAT(PROC,Condition,s)
K=Condition.K;
tpoint=Condition.tpoint;
Rho=Condition.Rho;
V=Condition.V;
Mach=Condition.Mach;
Miu=Condition.Miu;
ref=PROC.ref;

dCD0=0;
dSwet=0;
dVol=0;
nelem=length(PROC.geo(s).ny);
for t=1:nelem
    if t==1 
        SEC_name=[num2str(s) '-' num2str(t) '-0'];
        FOIL1=CATfile_foil(PROC.CATfile,SEC_name); %最内侧截面翼型
    end

    for i=1:PROC.geo(s).ny(t)
        SEC_name=[num2str(s) '-' num2str(t) '-' num2str(i)];
        FOIL2=CATfile_foil(PROC.CATfile,SEC_name); %外侧截面翼型
        MAC=(2*(FOIL1.C^2 + FOIL1.C*FOIL2.C + FOIL2.C^2))/(3*(FOIL1.C + FOIL2.C)); 

        wing.Re=(Rho*V*MAC)./(Miu);              %Reynolds Number for wing
        wing.Re_cutoff=38.21*(MAC/K).^1.053;     %Cutoff Re 中断雷诺数 Raymer (12.28)
        wing.Re_use=min([wing.Re wing.Re_cutoff]);        %取较小Re数值计算

        %%%%%%%%%%%%%%%%%%%%%%%
        %计算翼段的湿面积
        A4=[FOIL1.XYZu;flipud(FOIL1.XYZb)];
        B4=[FOIL2.XYZu;flipud(FOIL2.XYZb)];

        LwetA=sum(sqrt(sum((diff(A4)).^2,2)));
        LwetB=sum(sqrt(sum((diff(B4)).^2,2)));

        LE1=(FOIL1.XYZu(1,:)+FOIL1.XYZb(1,:))/2;
        LE2=(FOIL2.XYZu(1,:)+FOIL2.XYZb(1,:))/2;
        TE1=(FOIL1.XYZu(end,:)+FOIL1.XYZb(end,:))/2;
        TE2=(FOIL2.XYZu(end,:)+FOIL2.XYZb(end,:))/2;
        CHORD1=TE1-LE1;
        CHORD2=TE2-LE2;

        %这里用第二截面前缘点到第一截面弦线的距离作为几何展长
        %用几何展长当作两截面微段组成梯形的高
        b=norm(cross(CHORD1,(LE2-LE1)))/FOIL1.C;

        wing.Swet=(LwetA+LwetB)/2*b;
        if PROC.geo(s).symetric==1
            wing.Swet=wing.Swet*2; 
        end
        %%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%
        % Internal Volume
        Area_A=sum((FOIL1.Tx(1:end-1)+FOIL1.Tx(2:end)/2).*(FOIL1.C*.01));
        Area_B=sum((FOIL2.Tx(1:end-1)+FOIL2.Tx(2:end)/2).*(FOIL2.C*.01));

        wing.Vol=1/3*b*(Area_A+Area_B+sqrt(Area_A*Area_B));                  %Volume of a frustum

        if PROC.geo(s).symetric==1
            wing.Vol=wing.Vol*2;
        end
        %%%%%%%%%%%%%%%%%%%%%%%

        % Max thickness inner airfoil
        mtci=FOIL1.tc;
        mtcipos=FOIL1.xtc;

        % Max thickness outer airfoil
        mtco=FOIL2.tc;
        mtcopos=FOIL2.xtc;

        mtcc=[mtcipos mtcopos];
        [tc,indx]=max([mtci mtco]);  
        xc=mtcc(indx);      

        %求解最大厚度线后掠角
        mtiXYZ=LE1+CHORD1*mtcipos;   %内侧截面最大厚度处坐标
        mtoXYZ=LE2+CHORD2*mtcopos;   %外侧截面最大厚度处坐标
        V_mt=mtoXYZ-mtiXYZ;       %最大厚度线向量
        %以最大厚度线向量与YZ平面夹角作为最大厚度线后掠角
        Lambda=asin(dot(V_mt,[1,0,0])/(norm(V_mt)*norm([1,0,0])));      

        if Mach<1 
            M=1;
        else
            M=Mach;
        end
        wing.cf_lam=1.328/sqrt(wing.Re_use);
        wing.cf_turb=0.455/(log10(wing.Re_use)^2.58*(1+0.144*M^2)^0.65); %wing turbulent skin friction coefficient Raymer (12.27)

        if xc~=0
            wing.FF=(1+0.6./(xc)*(tc)+100*(tc)^4)*(1.34*Mach^0.18*cos(Lambda)^0.28) ;%raymer eq (12.30)
        else
            wing.FF=(1.34*Mach^0.18*cos(Lambda)^0.28); %当厚度为零时对上式进行处理.
        end

        wing.cf_composite=(1-tpoint)*wing.cf_turb+tpoint*wing.cf_lam;
        QQ=1;           %部件干扰因子,Q=1

        dCD0=dCD0+wing.cf_composite*wing.FF*QQ*wing.Swet/ref.S_ref_M;
        dSwet=dSwet+wing.Swet;
        dVol=dVol+wing.Vol;

        FOIL1=FOIL2;
    end
end
end

function [dCD0,dSwet,dVol]=D0_TXT(PROC,Condition,s)
K=Condition.K;
tpoint=Condition.tpoint;
Rho=Condition.Rho;
V=Condition.V;
Mach=Condition.Mach;
Miu=Condition.Miu;
ref=PROC.ref;

geo=PROC.geo;

dCD0=0;
dSwet=0;
dVol=0;
nelem=length(geo(s).b);
for t=1:nelem
    MAC=(2*(geo(s).c(t)^2 + geo(s).c(t)*geo(s).c(t+1) + geo(s).c(t+1)^2))/(3*(geo(s).c(t) + geo(s).c(t+1))); 

    wing.Re=(Rho*V*MAC)./(Miu);              %Reynolds Number for wing
    wing.Re_cutoff=38.21*(MAC/K).^1.053;     %Cutoff Re 中断雷诺数 Raymer (12.28)
    wing.Re_use=min([wing.Re wing.Re_cutoff]);        %取较小Re数值计算

    %%%%%%%%%%%%%%%%%%%%%%%
    %计算翼段的湿面积
    [Ax,~,Ay1,Ay2]=readfoil(geo(s).foil(t));
    [Bx,~,By1,By2]=readfoil(geo(s).foil(t+1));

    % Wetted area
    A4=[flipud([Ax;Ay1]');[Ax;Ay2]'];
    B4=[flipud([Bx;By1]');[Bx;By2]'];

    LwetA=sum(sqrt(sum((diff(A4*geo(s).c(t))).^2,2)));
    LwetB=sum(sqrt(sum((diff(B4*geo(s).c(t+1))).^2,2)));

    wing.Swet=(LwetA+LwetB)/2*geo(s).b(t);
    if geo(s).symetric==1
        wing.Swet=wing.Swet*2; 
    end
    %%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%
    % Internal Volume
    Area_A=sum((diff(A4(:,1))).*((A4(2:end,2)+A4(1:end-1,2))/2)*geo(s).c(t)^2);   %Area of innermost section   
    Area_B=sum((diff(B4(:,1))).*((B4(2:end,2)+B4(1:end-1,2))/2)*geo(s).c(t)^2); %Area of outermost section 
    wing.Vol=1/3*geo(s).b(t)*(Area_A+Area_B+sqrt(Area_A*Area_B));                  %Volume of a frustum

    if geo(s).symetric==1
        wing.Vol=wing.Vol*2;
    end
    %%%%%%%%%%%%%%%%%%%%%%%

    % Max thickness inner airfoil
    tc=abs(Ay1-Ay2); %thickness to chord ratio 
    [mtci,indx]=max(tc);
    mtcipos=Ax(indx);

    % Max thickness outer airfoil
    tc=abs(By1-By2); %thickness to chord ratio       
    [mtco,indx]=max(tc);
    mtcopos=Bx(indx);

    mtcc=[mtcipos mtcopos];
    [tc,indx]=max([mtci mtco]);  
    xc=mtcc(indx);      

    %最大厚度线后掠角
    XC2=geo(s).c(t)*.25+tan(geo(s).SW(t))*geo(s).b(t)-0.25*geo(s).c(t+1);  %外段机翼界面x坐标
    Lambda=atan((XC2+geo(s).c(t+1)*mtcopos-geo(s).c(t)*mtcipos)/geo(s).b(t));

    if Mach<1 
        M=1;
    else
        M=Mach;
    end
    wing.cf_lam=1.328/sqrt(wing.Re_use);
    wing.cf_turb=0.455/(log10(wing.Re_use)^2.58*(1+0.144*M^2)^0.65); %wing turbulent skin friction coefficient Raymer (12.27)


    if xc~=0
        wing.FF=(1+0.6./(xc)*(tc)+100*(tc)^4)*(1.34*Mach^0.18*cos(Lambda)^0.28) ;%raymer eq (12.30)
    else
        wing.FF=(1.34*Mach^0.18*cos(Lambda)^0.28); %Thin, really thin, wing.
    end

    wing.cf_composite=(1-tpoint)*wing.cf_turb+tpoint*wing.cf_lam;
    QQ=1;           %部件干扰因子,Q=1

    dCD0=dCD0+wing.cf_composite*wing.FF*QQ*wing.Swet/ref.S_ref_M;
    dSwet=dSwet+wing.Swet;
    dVol=dVol+wing.Vol;
end
end
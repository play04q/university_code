function test_deflect2
%舵面偏转数值稳定性测试
if 1
    resfile='H:\VLM513s\VLM513 - 180613\import\Sample_CF_Deflect2.in';
    [geo,state,ref,~]=autoread(resfile);

    CTRLsurf=CTRLsurf_assign(geo);
    [MESH,HINGE]=pre_MESH(geo);
    OBJ_MESH=pre_form_MESH(MESH);
    [WAKE]=pre_WAKE(MESH,geo,state,ref);
    OBJ_WAKE=pre_form_WAKE(MESH,WAKE);     %V2->P3
    OBJ_CROSS=pre_form_CROSS(OBJ_MESH,OBJ_WAKE,state,ref);     %V1->P3  V2->P1\P2
    [Results]=solver_compute(OBJ_MESH,OBJ_WAKE,OBJ_CROSS,state,ref);
    [Results]=coeff_create3(Results,state,ref,MESH); 

    idx=1;
    geo0=geo;
    nwing=length(geo);
    for s=1:nwing
        geo0(s).deflect=zeros(length(geo0(s).deflect),2);
    end
    MESH0=MESH;

    fprintf('Control Surface')
    for i=-5:0.1:5
        fprintf('...%d ',i);
        geo_T=geo0;

        WingID=CTRLsurf(1).Relation(1);
        SEGID=CTRLsurf(1).Relation(2);
        SIDE=CTRLsurf(1).Relation(3);
        geo_T(WingID).deflect(SEGID,SIDE)=deg2rad(i);

        MESH_Deflect=pre_Deflect(geo_T,MESH0,HINGE);
        ADJ_MESH=pre_MESH_Deflect(MESH_Deflect,OBJ_MESH,CTRLsurf(1).Relation);

        [WAKE]=pre_WAKE(MESH_Deflect,geo,state,ref);
        OBJ_WAKE=pre_form_WAKE(MESH_Deflect,WAKE);     %V2->P3
        OBJ_CROSS=pre_form_CROSS(ADJ_MESH,OBJ_WAKE,state,ref);     %V1->P3  V2->P1\P2
        [Results2]=solver_compute(ADJ_MESH,OBJ_WAKE,OBJ_CROSS,state,ref);
        [Results2]=coeff_create3(Results2,state,ref,MESH); 
        %系数
        L(idx)=Results2.L;
        D(idx)=Results2.Di;
        C(idx)=Results2.C;
        Lm(idx)=Results2.Lm;
        Mm(idx)=Results2.Mm;
        Nm(idx)=Results2.Nm;
        ANG(idx)=i;
        idx=idx+1;

    end

    save('test_deflect2','L','D','C','Lm','Mm','Nm','ANG')
end
load('test_deflect2.mat')
figure (110)
clf
hold on
subplot(2,3,1)
plot(ANG,L)
title('L')
subplot(2,3,2)
plot(ANG,D)
title('D')
subplot(2,3,3)
plot(ANG,C)
title('C')
subplot(2,3,4)
plot(ANG,Lm)
title('Lm')
subplot(2,3,5)
plot(ANG,Mm)
title('Mm')
subplot(2,3,6)
plot(ANG,Nm)
title('Nm')

figure (120)
for i=1:50
    L_d(i)=(L(51+i)-L(51-i))/deg2rad(2*i*.1);
    D_d(i)=(D(51+i)-D(51-i))/deg2rad(2*i*.1);
    C_d(i)=(C(51+i)-C(51-i))/deg2rad(2*i*.1);
    Lm_d(i)=(Lm(51+i)-Lm(51-i))/deg2rad(2*i*.1);
    Mm_d(i)=(Mm(51+i)-Mm(51-i))/deg2rad(2*i*.1);
    Nm_d(i)=(Nm(51+i)-Nm(51-i))/deg2rad(2*i*.1);
    ANG_d(i)=deg2rad(i*.1);
end
clf
hold on
subplot(2,3,1)
plot(ANG_d,L_d)
title('L_d')
subplot(2,3,2)
plot(ANG_d,D_d)
title('D_d')
subplot(2,3,3)
plot(ANG_d,C_d)
title('C_d')
subplot(2,3,4)
plot(ANG_d,Lm_d)
title('Lm_d')
subplot(2,3,5)
plot(ANG_d,Mm_d)
title('Mm_d')
subplot(2,3,6)
plot(ANG_d,Nm_d)
title('Nm_d')

end

function [CTRLsurf]=CTRLsurf_assign(geo)
%CF(1).WID  .SEGID
CTRLsurf=struct('Relation',[],'CL_d',[],'CD_d',[],'CC_d',[],'CLm_d',[],'CMm_d',[],'CNm_d',[]);
NCSF=1;
nwing=length(geo);
for s=1:nwing
    lastCSF=NCSF;
    nelem=length(geo(s).b);
    for t=1:nelem
        if any(geo(s).fc(t,:)~=0)
            CTRLsurf(NCSF).Relation=[s t 1];
            NCSF=NCSF+1;
        end
    end
    if geo(s).symetric==1
        dCTRLsurf=CTRLsurf(lastCSF:NCSF-1);
        for i=1:length(dCTRLsurf)
            dCTRLsurf(i).Relation(3)=2;
        end
        CTRLsurf=[CTRLsurf,dCTRLsurf]; %#ok<AGROW>
    end
end

end
cd('H:\VLM513 - 160728_FWOPT')
[CASE]=load_define([pwd '\FWOPT_temp\FWOPT.in']);
%[CASE]=load_define([pwd '\import\04m.in']);

nA=length(CASE.Files(1).state.alpha0);
T='n';

[PROC,~]=pre_general(CASE.Files(1),T);


%AS0=[160,170,180,190,200];
%alpha0=[7.07 6.39 5.82 5.33 4.92];

ALT0=0:2000:10000;
alpha0=3:10;


%geo.dihed=deg2rad([-6,-6,-2,-2,10]);
%[zeroliftdrag,ref]=zeroliftdragpred(state,geo,ref);

MDR=[];
MSPR=[];
MRM=[];



E_omega=[];
E_zeta=[];
E_SPR_REL=[];
E_RM_TC=[];

H_omega=[];
H_zeta=[];
H_SPR_REL=[];
H_RM_TC=[];

F_omega=[];
F_zeta=[];
F_SPR_REL=[];
F_RM_TC=[];

tic
for i=1:6
    PROC.state.ALT=ALT0(i);
    PROC.state.rho=ISAtmosphere(PROC.state.ALT);
    
    for j=1:8
        PROC.state.AS=80;
        PROC.state.AS0=80;
        
        PROC.state.alpha=deg2rad(alpha0(j));
        [results]=solver_DRVstability(PROC,'','n');

        MDrv.alpha=PROC.state.alpha;
        MDrv.CD0=0.0100;

        MDrv.CL =results.CL;
        MDrv.CDi=results.CDi;
        MDrv.CC =results.CC;

        MDrv.CLm=results.CLm;
        MDrv.CMm=results.CMm;
        MDrv.CNm=results.CNm;

        MDrv.CD=MDrv.CD0+MDrv.CDi;

        MDrv.CL_beta =results.CL_beta;
        MDrv.CD_beta =results.CD_beta;
        MDrv.CC_beta =results.CC_beta;
        MDrv.CX_beta =results.CX_beta;
        MDrv.CY_beta =results.CY_beta;
        MDrv.CZ_beta =results.CZ_beta;
        MDrv.CLm_beta=results.CLm_beta;
        fprintf('CLm_beta is %3.5f\n',MDrv.CLm_beta)
        MDrv.CMm_beta=results.CMm_beta;
        MDrv.CNm_beta=results.CNm_beta;


        MDrv.CL_P =results.CL_P;
        MDrv.CD_P =results.CD_P;
        MDrv.CC_P =results.CC_P;
        MDrv.CX_P =results.CX_P;
        MDrv.CY_P =results.CY_P;
        MDrv.CZ_P =results.CZ_P;
        MDrv.CLm_P=results.CLm_P;
        MDrv.CMm_P=results.CMm_P;
        MDrv.CNm_P=results.CNm_P;

        MDrv.CL_R =results.CL_R;
        MDrv.CD_R =results.CD_R;
        MDrv.CC_R =results.CC_R;
        MDrv.CX_R =results.CX_R;
        MDrv.CY_R =results.CY_R;
        MDrv.CZ_R =results.CZ_R;
        MDrv.CLm_R=results.CLm_R;
        MDrv.CMm_R=results.CMm_R;
        MDrv.CNm_R=results.CNm_R;
        
        for k=1:3
            switch k
                case 1
                    CASE.Files.inertias.m=23.497;
                    CASE.Files.inertias.Ix=3.85;
                    CASE.Files.inertias.Iy=2.90;
                    CASE.Files.inertias.Iz=6.64;
                    CASE.Files.inertias.Izx=-0.35;
                    disp ('空机')
                case 2
                    CASE.Files.inertias.m=44.59;
                    CASE.Files.inertias.Ix=4.75;
                    CASE.Files.inertias.Iy=3.71;
                    CASE.Files.inertias.Iz=8.27;
                    CASE.Files.inertias.Izx=-0.35;
                    disp ('半油')
                case 3
                    CASE.Files.inertias.m=65.807;
                    CASE.Files.inertias.Ix=8.80;
                    CASE.Files.inertias.Iy=4.73;
                    CASE.Files.inertias.Iz=13.29;
                    CASE.Files.inertias.Izx=-0.35;
                    disp('满油')
            end
            
            AS=(CASE.Files.inertias.m*9.8/.5/PROC.state.rho/PROC.REF.S_ref_M/results.CL)^.5;
            fprintf('升力系数 %3.3f',results.CL)
            PROC.state.AS=AS;
            PROC.state.AS0=AS;

            [DR,SPR,RM]=lat_chr(PROC.geo,PROC.state,PROC.REF, CASE.Files.inertias,MDrv,'nis');
            
            switch k
                case 1
                    E_omega(i,j)=DR.omega_nd;
                    E_zeta(i,j)=DR.zeta_d;
                    E_SPR_REL(i,j)=SPR.REL;
                    E_RM_TC(i,j)=RM.TC;
                case 2
                    H_omega(i,j)=DR.omega_nd;
                    H_zeta(i,j)=DR.zeta_d;
                    H_SPR_REL(i,j)=SPR.REL;
                    H_RM_TC(i,j)=RM.TC;
                case 3
                    F_omega(i,j)=DR.omega_nd;
                    F_zeta(i,j)=DR.zeta_d;
                    F_SPR_REL(i,j)=SPR.REL;
                    F_RM_TC(i,j)=RM.TC;
            end
        end
    end

end

Zcords=cell2mat(PROC.NODE);
h_min=min(min(Zcords(:,:,3))); %最小-.22

%disp(DR_s)
%disp(SPR_s)
%disp(LAT_s)
disp (toc)
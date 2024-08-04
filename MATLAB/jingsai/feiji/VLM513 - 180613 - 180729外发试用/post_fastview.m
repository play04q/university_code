function post_fastview(Results,PROC,quest)
state=PROC.state;
ref=PROC.ref;

switch quest
    case 'AD_simp'
        basis(PROC)
        AD_simp(PROC.geo,Results)
    
    case 'AD_Sweep' 
        basis(PROC)
        AD_Sweep(PROC,Results)
        
    case 'DRV_S'
        basis(PROC)
        DRV_S(Results)
    
    case 'DRV_S_LAT'
        DRV_S_LAT(Results)
        
    case 'DRV_S_LONG'
        DRV_S_LONG(Results)
        
    case 'DRV_C'
        basis(PROC)
        DRV_C(Results)
        
    case 'M_SDRV'
        DRV_SM(Results)
    
    case 'M_CDRV_A'
        basis(PROC,'b')
        DRV_CM_A(Results)
        
    case 'ADdflt'
        basis(PROC)
        AD_Deflect(Results)
        
end

end

function basis(PROC,cmdline)
geo=PROC.geo;
state=PROC.state;
ref=PROC.ref;
FName=PROC.name;

if nargin<2 
    cmdline='ab';
end
    
nwing=length(geo);
fprintf('**************************************************************************************************************************\n')
fprintf([' Model name <' FName '> Cauculation state ...                           \n'])
T1=' Air speed \t   Altitude \t';
if contains(cmdline,'a')
    T1=[T1 ' Alpha \t'];
end
if contains(cmdline,'b')
    T1=[T1 '  Beta \t'];
end
T1=[T1 '     P \t     Q \t     R \t'];
if isfield(PROC,'ANG')
    T1=[T1 '    CSurf ID'];
end
T1=[T1 '\n'];
fprintf(T1);
fprintf(' %9.2d \t %10.2d \t',state.AS,state.ALT);
if contains(cmdline,'a')
    fprintf(' %5.1f \t',rad2deg(state.alpha));
end
if contains(cmdline,'b')
    fprintf(' %5.1f \t',rad2deg(state.beta));
end
fprintf(' %5.1f \t %5.1f \t %5.1f \t',rad2deg(state.P),rad2deg(state.Q),rad2deg(state.R));
if isfield(PROC,'ANG')
    switch PROC.CF(3)
        case 0
            T2='       [%d,%d]';
        case 1
            T2='    [%d,%d]SYM';
        case 2
            T2='    [%d,%d]DIF';
    end
    fprintf(T2,PROC.CF(1),PROC.CF(2));
end
fprintf('\n')

fprintf('**************************************************************************************************************************\n')
fprintf(' Geometry define of the wings ...                                                                       \n')
fprintf(' Index Number \t Wing area \t MAC length \t Wing span \t Aspect ratio \t Is main \n');

for i=1:nwing
    fprintf(' %12d \t %9.2f \t %10.2f \t %9.2f \t %12.2f \t ',i,ref.S_ref(i),ref.C_mac(i),ref.b_ref(i),ref.R_asp(i))
    if geo(i).ismain==1
        fprintf('      M \n');
    else
        fprintf('      0 \n');
    end
end
end

function AD_simp(geo,results)
nwing=length(geo);
fprintf('***********************************************************************************************************************\n')
fprintf(' Force and moment of the aircraft ...                                                                     \n')
fprintf('       CL \t      CD0 \t      CDi \t CD.total \t       CC \t      Clm \t      Cmm \t      Cnm \t     Cond \n');
fprintf(' %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.2f\n',results.PTL.CL,results.friction.CD0,...
    results.PTL.CDi,results.PTL.CDi+results.friction.CD0,results.PTL.CC,results.PTL.Clm,results.PTL.Cmm,results.PTL.Cnm,...
    results.PTL.dwcond);
fprintf('           L \t      D.total \t            C \t           Lm \t           Mm \t           Nm \t      L/D \n')
fprintf('%12.4E \t %12.4E \t %12.4E \t %12.4E \t %12.4E \t %12.4E \t %8.2f \n',results.PTL.L,results.PTL.Di+results.friction.D0,results.PTL.C,...
    results.PTL.Lm,results.PTL.Mm,results.PTL.Nm,00);%results.total.LDr
    fprintf('***********************************************************************************************************************\n')
    
% if nwing>1
%     fprintf(' Force and moment of the wing-elemens ...                                                                        \n')
%     fprintf(' Index Number\t           L\t     D.total\t           C\t          Lm\t          Mm\t          Nm \n')
%     for i=1:nwing
%         fprintf(' %12d\t%12.4E\t%12.4E\t%12.4E\t%12.4E\t%12.4E\t%12.4E\n',i,results.PTL.nL(i),results.total.nD(i),...
%             results.PTL.nC(i),results.PTL.nLm(i),results.PTL.nMm(i),results.PTL.nNm(i));
%     end
%     fprintf('***********************************************************************************************************************\n')
% end

end
function AD_Sweep(PROC,MR)
state=PROC.state;
ref=PROC.ref;

[nA,nS]=size(MR.state);
if nS==1  %迎角扫掠
    TYPE=1;
    TStr=' Alpha';
    Num=nA;
else
    TYPE=2;
    TStr='  Beta';
    Num=nS;
end

fprintf('**********************************************************************************************************************\n')
fprintf(' Air speed\t  Altitude\t    P\t    Q\t    R\t Wing area\tMAC length\t Wing span\tAspect ratio \t     CD0\n');
fprintf(' %9.2d\t%10.2d\t%5.1f\t%5.1f\t%5.1f\t%10.2f\t%10.2f\t%10.2f\t%12.2f\t%8.4f\n',state.AS,state.ALT,...
    rad2deg(state.P),rad2deg(state.Q),rad2deg(state.R),ref.S_ref_M,ref.C_mac_M,ref.b_ref_M,ref.R_asp_M,MR.state(1,1).STC.friction.CD0);
fprintf('**********************************************************************************************************************\n')
fprintf('%s\t     CL\t    CDi\t    Cmm\t  L/D\t         L\t         D\t        Mm\t     CC\t    Clm\t   Cnm\t    NPx\t      A\n',TStr)

for i=1:Num
    if TYPE==1
        CR=MR.state(i,1).STC;
        ANG=MR.state(i,1).alpha;
    else
        CR=MR.state(1,i).STC;
        ANG=MR.state(1,i).beta;
        CR.PTL.xNP=-1;
        CR.PTL.A=-1;
    end

    fprintf(' %5.1f\t%7.4f\t%7.4f\t%7.4f\t%5.1f\t%10.3E\t%10.3E\t%10.3E\t%7.4f\t%7.4f\t%7.4f\t%7.3f\t%7.3f\n',rad2deg(ANG),...
        CR.PTL.CL,CR.PTL.CDi,CR.PTL.Cmm,CR.Total.LDr,CR.PTL.L,CR.Total.D, ...
        CR.PTL.Mm,CR.PTL.CC,CR.PTL.Clm,CR.PTL.Cnm,CR.PTL.xNP,CR.PTL.A)
end
fprintf('**********************************************************************************************************************\n')
end

function AD_Deflect(MR)
fprintf('**********************************************************************************************************************\n')
fprintf(' Angle\t     CL\t    CDi\t    Cmm\t  L/D\t         L\t         D\t        Mm\t     CC\t    Clm\t   Cnm\n')
for i=1:length(MR)
fprintf(' %5.1f\t%7.4f\t%7.4f\t%7.4f\t%5.1f\t%10.3E\t%10.3E\t%10.3E\t%7.4f\t%7.4f\t%7.4f\n',...
    rad2deg(MR(i).ANG),MR(i).PTL.CL,MR(i).PTL.CDi,MR(i).PTL.Cmm,MR(i).Total.LDr,MR(i).PTL.L,MR(i).Total.D, ...
    MR(i).PTL.Mm,MR(i).PTL.CC,MR(i).PTL.Clm,MR(i).PTL.Cnm)
end
fprintf('**********************************************************************************************************************\n')
end

function DRV_S(Results)
DRVs=Results.DRVs;
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment derivatives of the aircraft ...      (per Rad)                                                          \n')
fprintf(' F&M  /dev \t        .d_alpha \t          d_beta \t             d_P \t             d_Q \t             d_R \n');
fprintf('         L \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.L_alpha,DRVs.L_beta,DRVs.L_P,DRVs.L_Q,DRVs.L_R);
fprintf('         D \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.D_alpha,DRVs.D_beta,DRVs.D_P,DRVs.D_Q,DRVs.D_R);
fprintf('         C \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.C_alpha,DRVs.C_beta,DRVs.C_P,DRVs.C_Q,DRVs.C_R);
fprintf('        Lm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Lm_alpha,DRVs.Lm_beta,DRVs.Lm_P,DRVs.Lm_Q,DRVs.Lm_R);
fprintf('        Mm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Mm_alpha,DRVs.Mm_beta,DRVs.Mm_P,DRVs.Mm_Q,DRVs.Mm_R);
fprintf('        Nm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Nm_alpha,DRVs.Nm_beta,DRVs.Nm_P,DRVs.Nm_Q,DRVs.Nm_R);
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment coefficients derivatives of the aircraft ...     (per Rad)                                                           \n')
fprintf(' Coeff/dev \t        .d_alpha \t          d_beta \t             d_P \t             d_Q \t             d_R \n');
fprintf('        CL \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CL_alpha,DRVs.CL_beta,DRVs.CL_P,DRVs.CL_Q,DRVs.CL_R);
fprintf('        CD \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CD_alpha,DRVs.CD_beta,DRVs.CD_P,DRVs.CD_Q,DRVs.CD_R);
fprintf('        CC \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CC_alpha,DRVs.CC_beta,DRVs.CC_P,DRVs.CC_Q,DRVs.CC_R);
fprintf('       Clm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Clm_alpha,DRVs.Clm_beta,DRVs.Clm_P,DRVs.Clm_Q,DRVs.Clm_R);
fprintf('       Cmm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Cmm_alpha,DRVs.Cmm_beta,DRVs.Cmm_P,DRVs.Cmm_Q,DRVs.Cmm_R);
fprintf('       Cnm \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.Cnm_alpha,DRVs.Cnm_beta,DRVs.Cnm_P,DRVs.Cnm_Q,DRVs.Cnm_R);
fprintf('**************************************************************************************************************************\n')
fprintf(' Force coefficients derivatives in body axis ...     (per Rad)                                                           \n')
fprintf(' Coeff/dev \t        .d_alpha \t          d_beta \t             d_P \t             d_Q \t             d_R \n');
fprintf('        CX \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CX_alpha,DRVs.CX_beta,DRVs.CX_P,DRVs.CX_Q,DRVs.CX_R);
fprintf('        CY \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CY_alpha,DRVs.CY_beta,DRVs.CY_P,DRVs.CD_Q,DRVs.CY_R);
fprintf('        CZ \t %15.4f \t %15.4f \t %15.4f \t %15.4f \t %15.4f\n',DRVs.CZ_alpha,DRVs.CZ_beta,DRVs.CZ_P,DRVs.CC_Q,DRVs.CZ_R);
fprintf('**************************************************************************************************************************\n')

end

function DRV_C(CDRV)
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment derivatives of the control surface(s) ...      (per Rad)                                                          \n')
fprintf(' Surf /F&M DRVs   \t   L_delta \t       D_delta \t       C_delta \t     Lm_delta \t      Mm_delta \t      Nm_delta \n');
for i=1:length(CDRV.CL_)
    fprintf('       #%d    \t %13.4f \t %13.4f \t %13.4f \t %13.4f \t %13.4f\t %13.4f\n',i,CDRV.L_(i),CDRV.D_(i),CDRV.C_(i),CDRV.Lm_(i),CDRV.Mm_(i),CDRV.Nm_(i));
end
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment coefficients derivatives of the control surface(s) ...     (per Rad)                                                           \n')
fprintf(' Surf /Coeff DRVs \t  CL_delta \t      CD_delta \t      CC_delta \t     Clm_delta \t     Cmm_delta \t     Cnm_delta \n');
for i=1:length(CDRV.CL_)
    fprintf('       #%d    \t %13.4f \t %13.4f \t %13.4f \t %13.4f \t %13.4f\t %13.4f\n',i,CDRV.CL_(i),CDRV.CD_(i),CDRV.CC_(i),CDRV.Clm_(i),CDRV.Cmm_(i),CDRV.Cnm_(i));
end
fprintf('**************************************************************************************************************************\n')

end


function DRV_SM(M_SDRV)
[nA,nS]=size(M_SDRV.state);
if nS==1  %迎角扫掠
    TYPE=1;
    TStr=' Alpha ';
    Num=nA;
else
    TYPE=2;
    TStr='  Beta ';
    Num=nS;
end

if isfield(M_SDRV.state(1,1).DRVs,'CL_alpha')
    fprintf('**************************************************************************************************************************\n')
    fprintf(' Force and moment coefficients derivatives of longitudinal motion ...     (per Rad)                                                           \n')
    fprintf('%s\t  CL_alpha \t  CD_alpha \t Cmm_alpha \t      CL_Q \t      CD_Q \t     Cmm_Q \n',TStr);
    for i=1:Num
        if TYPE==1
            SDRV=M_SDRV.state(i,1).DRVs;
            Angle=M_SDRV.state(i,1).alpha;
        else
            SDRV=M_SDRV.state(1,i).DRVs;
            Angle=M_SDRV.state(1,i).beta;
        end
        fprintf(' %5.1f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f\n', ... 
            rad2deg(Angle),SDRV.CL_alpha,SDRV.CD_alpha,SDRV.Cmm_alpha,SDRV.CL_Q,SDRV.CD_Q,SDRV.Cmm_Q);
    end
end
if isfield(M_SDRV.state(1,1).DRVs,'CC_beta')
    fprintf('**************************************************************************************************************************\n')
    fprintf(' Force and moment coefficients derivatives of lateral-directional motion ...     (per Rad)                                                           \n')
    fprintf('%s\t   CC_beta \t  Clm_beta \t  Cnm_beta \t      CC_P \t     Clm_P \t     Cnm_P \t      CC_R \t     Clm_R \t     Cnm_R\n',TStr);
    for i=1:Num
        if TYPE==1
            SDRV=M_SDRV.state(i,1).DRVs;
            Angle=M_SDRV.state(i,1).alpha;
        else
            SDRV=M_SDRV.state(1,i).DRVs;
            Angle=M_SDRV.state(1,i).beta;
        end
        fprintf(' %5.1f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f\n', ... 
            rad2deg(Angle),SDRV.CC_beta,SDRV.Clm_beta,SDRV.Cnm_beta,SDRV.CC_P,SDRV.Clm_P,SDRV.Cnm_P, ...
            SDRV.CC_R,SDRV.Clm_R,SDRV.Cnm_R);
    end
end
if isfield(M_SDRV.state(1,1).DRVs,'CL_alpha') && isfield(M_SDRV.state(1,1).DRVs,'CC_beta')
    fprintf('**************************************************************************************************************************\n')
    fprintf(' Force and moment coefficients derivatives of cross-axis motion ...     (per Rad)                                                           \n')
    fprintf('%s\t CL_|beta| \t CD_|beta| \tCmm_|beta| \t    CL_|P| \t    CD_|P| \t   Cmm_|P| \t    CL_|R| \t    CD_|R| \t   Cmm_|R|\n',TStr);
    for i=1:Num
        if TYPE==1
            SDRV=M_SDRV.state(i,1).DRVs;
            Angle=M_SDRV.state(i,1).alpha;
        else
            SDRV=M_SDRV.state(1,i).DRVs;
            Angle=M_SDRV.state(1,i).beta;
        end
        fprintf(' %5.1f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f \t %9.4f\n', ... 
            rad2deg(Angle),SDRV.CL_beta,SDRV.CD_beta,SDRV.Cmm_beta,SDRV.CL_P,SDRV.CD_P,SDRV.Cmm_P, ...
            SDRV.CL_R,SDRV.CD_R,SDRV.Cmm_R);
    end
end
fprintf('**************************************************************************************************************************\n')
end

function DRV_CM_A(M_CDRV)
[nA,nS]=size(M_CDRV.state);
if nS==1  %迎角扫掠
    TYPE=1;
    TStr=' Alpha  ';
    Num=nA;
else
    TYPE=2;
    TStr=' Beta   ';
    Num=nS;
end
for i=1:length(M_CDRV.state(1,1).DRVs.CL_)  %遍历每个舵面 
    fprintf('**************************************************************************************************************************\n')
    fprintf(' Force and moment coefficients derivatives of the control surface [#%d] ...     (per Rad)\n',i)
    fprintf('%s\t  CL_delta \t      CD_delta \t      CC_delta \t     Clm_delta \t     Cmm_delta \t     Cnm_delta \n',TStr);
    for j=1:Num
        if TYPE==1
            CDRV=M_CDRV.state(j,1).DRVs;
            Angle=M_CDRV.state(j,1).alpha;
        else
            CDRV=M_CDRV.state(1,j).DRVs;
            Angle=M_CDRV.state(1,j).beta;
        end
        fprintf(' %4.1f \t %13.4f \t %13.4f \t %13.4f \t %13.4f \t %13.4f\t %13.4f\n',...
            rad2deg(Angle),CDRV.CL_(i),CDRV.CD_(i),CDRV.CC_(i),CDRV.Clm_(i),CDRV.Cmm_(i),CDRV.Cnm_(i));
    end
    fprintf('**************************************************************************************************************************\n')
end

end

function DRV_S_LAT(Results)
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment coefficients derivatives of the aircraft ...     (per Rad)                                                           \n')
fprintf(' Coeff/dev \t      1.  d_beta \t         2.  d_P \t         3.  d_R \n');
fprintf('   A.   CC \t %15.4f \t %15.4f \t %15.4f\n',Results.CC_beta,Results.CC_P,Results.CC_R);
fprintf('   B.  Clm \t %15.4f \t %15.4f \t %15.4f\n',Results.Clm_beta,Results.Clm_P,Results.Clm_R);
fprintf('   C.  Cnm \t %15.4f \t %15.4f \t %15.4f\n',Results.Cnm_beta,Results.Cnm_P,Results.Cnm_R);
fprintf('**************************************************************************************************************************\n')

end

function DRV_S_LONG(results)
fprintf('**************************************************************************************************************************\n')
fprintf(' Force and moment coefficients derivatives of the aircraft ...     (per Rad)      未完成，先做导数求解                            \n')
fprintf(' Coeff/dev \t      1.   alpha \t         2.  d_Q \t         3.  d_R \n');
fprintf('   A.   CL \t %15.4f \t %15.4f \t %15.4f\n',results.CC_beta,results.CC_P,results.CC_R);
fprintf('   B.   CD \t %15.4f \t %15.4f \t %15.4f\n',results.Clm_beta,results.Clm_P,results.Clm_R);
fprintf('   C.  Cmm \t %15.4f \t %15.4f \t %15.4f\n',results.Cnm_beta,results.Cnm_P,results.Cnm_R);
fprintf('**************************************************************************************************************************\n')

end
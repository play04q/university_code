function [Results]=solver_DRVstability(PROC,cmdline)
%增量定义
dAng=.1/57.3;
%相当于2m翼展飞机在15m/s空速下，以1度每秒滚转速度时对应的无因次角速度
dPR=(1/57.3*2)/(2*15)*(2*PROC.state.AS)/PROC.ref.b_ref_M;   
%相当于0.2m平均气动弦长飞机在15m/s空速下，以1度每秒俯仰速度时对应的无因次角速度
dQ=(1/57.3*.2)/(2*15)*(2*PROC.state.AS)/PROC.ref.C_mac_M;   

if ~contains(cmdline,'n')
    fprintf('Base...');
end

OriginResults.PTL=solver_ADload(PROC,'n');
OriginResults=coeff_create3(OriginResults,PROC);
Results0=OriginResults.PTL;

STC.CL =Results0.CL;
STC.CDi=Results0.CDi;
STC.CC =Results0.CC;

STC.Clm=Results0.Clm;
STC.Cmm=Results0.Cmm;
STC.Cnm=Results0.Cnm;

if ~contains(cmdline,'2')
    %迎角导数
    if ~contains(cmdline,'n')
        fprintf('d_alpha...')
    end
    PROC.state.alpha=PROC.state.alpha+dAng;
    TmpResults.PTL=solver_ADload(PROC,'n');
        
    Results1=coeff_create3(TmpResults,PROC);
    Results1=Results1.PTL;
    PROC.state.alpha=PROC.state.alpha-dAng;

    DRVs.L_alpha=(Results1.L-Results0.L)/(dAng);
    DRVs.D_alpha=(Results1.Di-Results0.Di)/(dAng);
    DRVs.C_alpha=(Results1.C-Results0.C)/(dAng);
    DRVs.X_alpha=(Results1.X-Results0.X)/(dAng);
    DRVs.Y_alpha=(Results1.Y-Results0.Y)/(dAng);
    DRVs.Z_alpha=(Results1.Z-Results0.Z)/(dAng);
    DRVs.Lm_alpha=(Results1.Lm-Results0.Lm)/(dAng);
    DRVs.Mm_alpha=(Results1.Mm-Results0.Mm)/(dAng);
    DRVs.Nm_alpha=(Results1.Nm-Results0.Nm)/(dAng);

    DRVs.CL_alpha=(Results1.CL-Results0.CL)/(dAng);
    DRVs.CD_alpha=(Results1.CDi-Results0.CDi)/(dAng);
    DRVs.CC_alpha=(Results1.CC-Results0.CC)/(dAng);
    DRVs.CX_alpha=(Results1.CX-Results0.CX)/(dAng);
    DRVs.CY_alpha=(Results1.CY-Results0.CY)/(dAng);
    DRVs.CZ_alpha=(Results1.CZ-Results0.CZ)/(dAng);
    DRVs.Clm_alpha=(Results1.Clm-Results0.Clm)/(dAng);
    DRVs.Cmm_alpha=(Results1.Cmm-Results0.Cmm)/(dAng);
    DRVs.Cnm_alpha=(Results1.Cnm-Results0.Cnm)/(dAng);
            
    %俯仰角速度导数
    if ~contains(cmdline,'n')
        fprintf('d_q...')
    end
    PROC.state.Q=PROC.state.Q+dQ;
    TmpResults.PTL=solver_ADload(PROC,'n');
        
    Results1=coeff_create3(TmpResults,PROC);
    Results1=Results1.PTL;
    PROC.state.Q=PROC.state.Q-dQ;
    
    DRVs.L_Q=(Results1.L-Results0.L)/(dQ);
    DRVs.D_Q=(Results1.Di-Results0.Di)/(dQ);
    DRVs.C_Q=(Results1.C-Results0.C)/(dQ);
    DRVs.X_Q=(Results1.X-Results0.X)/(dQ);
    DRVs.Y_Q=(Results1.Y-Results0.Y)/(dQ);
    DRVs.Z_Q=(Results1.Z-Results0.Z)/(dQ);
    DRVs.Lm_Q=(Results1.Lm-Results0.Lm)/(dQ);
    DRVs.Mm_Q=(Results1.Mm-Results0.Mm)/(dQ);
    DRVs.Nm_Q=(Results1.Nm-Results0.Nm)/(dQ);

    delta=(dQ)/(2*PROC.state.AS/PROC.ref.C_mac_M);
    DRVs.CL_Q=(Results1.CL-Results0.CL)/delta;
    DRVs.CD_Q=(Results1.CDi-Results0.CDi)/delta;
    DRVs.CC_Q=(Results1.CC-Results0.CC)/delta;
    DRVs.CX_Q=(Results1.CX-Results0.CX)/delta;
    DRVs.CY_Q=(Results1.CY-Results0.CY)/delta;
    DRVs.CZ_Q=(Results1.CZ-Results0.CZ)/delta;
    DRVs.Clm_Q=(Results1.Clm-Results0.Clm)/delta;
    DRVs.Cmm_Q=(Results1.Cmm-Results0.Cmm)/delta;
    DRVs.Cnm_Q=(Results1.Cnm-Results0.Cnm)/delta;
    
end
        
if ~contains(cmdline,'1')
    %侧滑角导数
    if ~contains(cmdline,'n')
        fprintf('d_beta...')
    end
    PROC.state.beta=PROC.state.beta+dAng;
    TmpResults.PTL=solver_ADload(PROC,'n');
        
    Results1=coeff_create3(TmpResults,PROC);
    Results1=Results1.PTL;
    PROC.state.beta=PROC.state.beta-dAng;


    DRVs.L_beta=(Results1.L-Results0.L)/(dAng);
    DRVs.D_beta=(Results1.Di-Results0.Di)/(dAng);
    DRVs.C_beta=(Results1.C-Results0.C)/(dAng);
    DRVs.X_beta=(Results1.X-Results0.X)/(dAng);
    DRVs.Y_beta=(Results1.Y-Results0.Y)/(dAng);
    DRVs.Z_beta=(Results1.Z-Results0.Z)/(dAng);
    DRVs.Lm_beta=(Results1.Lm-Results0.Lm)/(dAng);
    DRVs.Mm_beta=(Results1.Mm-Results0.Mm)/(dAng);
    DRVs.Nm_beta=(Results1.Nm-Results0.Nm)/(dAng);

    DRVs.CL_beta=(Results1.CL-Results0.CL)/(dAng);
    DRVs.CD_beta=(Results1.CDi-Results0.CDi)/(dAng);
    DRVs.CC_beta=(Results1.CC-Results0.CC)/(dAng);
    DRVs.CX_beta=(Results1.CX-Results0.CX)/(dAng);
    DRVs.CY_beta=(Results1.CY-Results0.CY)/(dAng);
    DRVs.CZ_beta=(Results1.CZ-Results0.CZ)/(dAng);
    DRVs.Clm_beta=(Results1.Clm-Results0.Clm)/(dAng);
    DRVs.Cmm_beta=(Results1.Cmm-Results0.Cmm)/(dAng);
    DRVs.Cnm_beta=(Results1.Cnm-Results0.Cnm)/(dAng);

    %滚转角速度导数
    if ~contains(cmdline,'n')
        fprintf('d_p...')
    end
    PROC.state.P=PROC.state.P+dPR;
    TmpResults.PTL=solver_ADload(PROC,'n');
        
    Results1=coeff_create3(TmpResults,PROC);
    Results1=Results1.PTL;
    PROC.state.P=PROC.state.P-dPR;
    

    DRVs.L_P=(Results1.L-Results0.L)/(dPR);
    DRVs.D_P=(Results1.Di-Results0.Di)/(dPR);
    DRVs.C_P=(Results1.C-Results0.C)/(dPR);
    DRVs.X_P=(Results1.X-Results0.X)/(dPR);
    DRVs.Y_P=(Results1.Y-Results0.Y)/(dPR);
    DRVs.Z_P=(Results1.Z-Results0.Z)/(dPR);
    DRVs.Lm_P=(Results1.Lm-Results0.Lm)/(dPR);
    DRVs.Mm_P=(Results1.Mm-Results0.Mm)/(dPR);
    DRVs.Nm_P=(Results1.Nm-Results0.Nm)/(dPR);

    delta=(dPR)/(2*PROC.state.AS/PROC.ref.b_ref_M);
    DRVs.CL_P=(Results1.CL-Results0.CL)/delta;
    DRVs.CD_P=(Results1.CDi-Results0.CDi)/delta;
    DRVs.CC_P=(Results1.CC-Results0.CC)/delta;
    DRVs.CX_P=(Results1.CX-Results0.CX)/delta;
    DRVs.CY_P=(Results1.CY-Results0.CY)/delta;
    DRVs.CZ_P=(Results1.CZ-Results0.CZ)/delta;
    DRVs.Clm_P=(Results1.Clm-Results0.Clm)/delta;
    DRVs.Cmm_P=(Results1.Cmm-Results0.Cmm)/delta;
    DRVs.Cnm_P=(Results1.Cnm-Results0.Cnm)/delta;


    %偏航角速度
    if ~contains(cmdline,'n')
        fprintf('d_r...')
    end
    PROC.state.R=PROC.state.R+dPR;
    TmpResults.PTL=solver_ADload(PROC,'n');
        
    Results1=coeff_create3(TmpResults,PROC);
    Results1=Results1.PTL;
    PROC.state.R=PROC.state.R-dPR;
    
    DRVs.L_R=(Results1.L-Results0.L)/(dPR);
    DRVs.D_R=(Results1.Di-Results0.Di)/(dPR);
    DRVs.C_R=(Results1.C-Results0.C)/(dPR);
    DRVs.X_R=(Results1.X-Results0.X)/(dPR);
    DRVs.Y_R=(Results1.Y-Results0.Y)/(dPR);
    DRVs.Z_R=(Results1.Z-Results0.Z)/(dPR);
    DRVs.Lm_R=(Results1.Lm-Results0.Lm)/(dPR);
    DRVs.Mm_R=(Results1.Mm-Results0.Mm)/(dPR);
    DRVs.Nm_R=(Results1.Nm-Results0.Nm)/(dPR);

    delta=(dPR)/(2*PROC.state.AS/PROC.ref.b_ref_M);
    DRVs.CL_R=(Results1.CL-Results0.CL)/delta;
    DRVs.CD_R=(Results1.CDi-Results0.CDi)/delta;
    DRVs.CC_R=(Results1.CC-Results0.CC)/delta;
    DRVs.CX_R=(Results1.CX-Results0.CX)/delta;
    DRVs.CY_R=(Results1.CY-Results0.CY)/delta;
    DRVs.CZ_R=(Results1.CZ-Results0.CZ)/delta;
    DRVs.Clm_R=(Results1.Clm-Results0.Clm)/delta;
    DRVs.Cmm_R=(Results1.Cmm-Results0.Cmm)/delta;
    DRVs.Cnm_R=(Results1.Cnm-Results0.Cnm)/delta;
end

Results.STC=STC;
Results.DRVs=DRVs;
end


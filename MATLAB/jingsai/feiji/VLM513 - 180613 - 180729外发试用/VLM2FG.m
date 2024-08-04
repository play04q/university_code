function [state,ref,inertias,Drvs,Ctrl]=VLM2FG()
settings=config('startup'); %setting directories 设置程序运行的目录环境
[CASE]=load_define();
if isempty(CASE)
    return
end

allstate=main_allstate('hs');

recent=main_recent();
def_res=[settings.procdir recent.controlDrv];
[FileName,FilePath,~]=uigetfile({'*.xls;*.xlsx','控制参数文件'},'选择控制参数定义文件...',def_res);
recent.controlDrv=FileName;
main_recent(recent);

xlsdata=xlsread([FilePath FileName]);
Ctrl.ENG.Thrust=xlsdata(1,1);
Ctrl.ENG.Tcst=xlsdata(1,2);
Ctrl.ENG.Pitch=xlsdata(1,3);

Ctrl.CL_de=xlsdata(3,1);
Ctrl.CD_de=xlsdata(3,2);
Ctrl.Cmm_de=xlsdata(3,3);
Ctrl.Clm_da=xlsdata(5,1);
Ctrl.Cnm_da=xlsdata(5,2);
Ctrl.CC_da=xlsdata(5,3);
Ctrl.Clm_dr=xlsdata(7,1);
Ctrl.Cnm_dr=xlsdata(7,2);
Ctrl.Cc_dr=xlsdata(7,3);


CASE.Files(1).state.alpha0=deg2rad(-5:15);
CASE.Files(1).state.ALT=allstate.ALT;
CASE.Files(1).state.rho=allstate.rho;
CASE.Files(1).state.AS=allstate.AS;
CASE.Files(1).state.AS0=allstate.AS0;

nA=length(CASE.Files(1).state.alpha0);
cmdline='n';

[CASE,PROC,Results]=main_ADload(CASE,'n');
Alphas=CASE.Files(1).state.alpha0;
for i=nA:-1:1
    CLs(i)=Results.state(i,1).STC.PTL.CL;
end
CD0=Results.state(1,1).STC.friction.CD0;

TarCL=CASE.Files.inertias.m*9.8/.5/allstate.rho/allstate.AS^2/PROC.ref.S_ref_M;
TarAlpha=interp1(CLs,Alphas,TarCL,'pchip');
if TarCL>1
    beep
    disp 空速设置太小
    return
end
    
fprintf('alpha is %2.5f deg\n',rad2deg(TarAlpha))

PROC.state.alpha=TarAlpha;
PROC.state.alpha0=PROC.state.alpha;

[results]=solver_DRVstability(PROC,'');
if ~contains(cmdline,'n') 
    elapsedTime=toc;
    fprintf('耗时%f s\n',elapsedTime)
    post_fastview(results,PROC,'DRV_S');
end
Drvs=results.DRVs;
Drvs.alpha=PROC.state.alpha;

Drvs.CD=CD0+results.STC.CDi;
Drvs.CL =results.STC.CL;
Drvs.CC =results.STC.CC;

Drvs.Clm=results.STC.Clm;
Drvs.Cmm=results.STC.Cmm;
Drvs.Cnm=results.STC.Cnm;
      
inertias=CASE.Files.inertias;
state=PROC.state;
ref=PROC.ref;
end
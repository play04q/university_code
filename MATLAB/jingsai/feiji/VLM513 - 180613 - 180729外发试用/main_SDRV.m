function [CASE,PROC,Results]=main_SDRV(FILE,cmdline)
%% cmdling=['1=longi','2=lat',''[3]=both']  n=不显示信息
if nargin==0
    [CASE]=load_define('','ns');
    if isempty(CASE)
        PROC=[];
        Results=[];
        return
    end
    FILE=CASE.Files(1);
    cmdline='';
elseif nargin==1
    cmdline='';
elseif nargin==2
    cmdline=lower(cmdline);
    CASE.Files=FILE;
end

nA=length(FILE.state.alpha0);
nS=length(FILE.state.beta0);

if nA==1 && nS==1
    T=cmdline;
else
    T='n';
end
[PROC,Results0.friction]=pre_general(FILE,T);  %基本状态的摩擦阻力系数

Is_need_deflect=0;
for s=1:length(PROC.geo)
    Is_need_deflect=Is_need_deflect || any(any(PROC.geo(s).deflect~=0));
end
if Is_need_deflect==1
    if ~contains(cmdline,'n')
        beep
        disp ('***************************************************************')
        disp ('*  CAUTION：Current File Contains Control Surface Deflection  *')
        disp ('***************************************************************')
    end
end


if nA==1 && nS==1
    % 单独状态
    [Results]=solver_DRVstability(PROC,cmdline);
    if ~contains(cmdline,'n') 
        elapsedTime=toc;
        fprintf('耗时%f s\n',elapsedTime)
        post_fastview(Results,PROC,'DRV_S');
    end
elseif nS==1   %迎角扫掠求解
    SID=['sdrv_' PROC.name '_A'];
    disp('AoA Swept Stability Derivative Analysis Results - Output to File')
    disp(['Output File Name: \procsave\' SID '.mat'])
    
    for i=nA:-1:1
        alpha=PROC.state.alpha0(i);
        PROC.state.alpha=alpha;
        fprintf(' Alpha =  %5.2f\n ',rad2deg(alpha))
        
        [Results]=solver_DRVstability(PROC,cmdline);
        fprintf('\n')
        
        
        M_SDRV.state(i,1).alpha=alpha;
        M_SDRV.state(i,1).beta=0;
        
        Results.STC.CD=Results.STC.CDi+Results0.friction.CD0;
        M_SDRV.state(i,1).STC=Results.STC;
        M_SDRV.state(i,1).DRVs=Results.DRVs;
    end
    
    M_SDRV.ref=PROC.ref;
    save([pwd '\procsave\' SID],'M_SDRV')
    
    if ~contains(cmdline,'n')
        post_fastview(M_SDRV,PROC,'M_SDRV')
    end

elseif nA==1   %侧滑角扫掠求解
    for i=nS:-1:1
        beta=PROC.state.beta0(i);
        PROC.state.beta=beta;
        fprintf(' Beta =  %5.2f\n ',rad2deg(beta))
        
        [Results]=solver_DRVstability(PROC,cmdline);
        fprintf('\n')
        
        M_SDRV.state(1,i).alpha=0;
        M_SDRV.state(1,i).beta=beta;
        
        Results.STC.CD=Results.STC.CDi+Results0.friction.CD0;
        M_SDRV.state(1,i).STC=Results.STC;
        M_SDRV.state(1,i).DRVs=Results.DRVs;
    end
    
    if ~contains(cmdline,'n')
        post_fastview(M_SDRV,PROC,'M_SDRV')
    end
    
else
    SID=['sdrv_' PROC.name '_B'];
    disp('AoA and AoS Swept Stability Derivative Analysis Results - Output to File')
    disp(['Output File Name: \procsave\' SID '.mat'])
    
    for i=nA:-1:1
        for j=nS:-1:1
            alpha=PROC.state.alpha0(i);
            beta=PROC.state.beta0(j); 
            PROC.state.alpha=alpha;
            PROC.state.beta=beta;

            [Results]=solver_DRVstability(PROC,'n');

            M_SDRV.state(i,j).alpha=alpha;
            M_SDRV.state(i,j).beta=beta;

            Results.STC.CD=Results.STC.CDi+Results0.friction.CD0;
            M_SDRV.state(i,j).STC=Results.STC;
            M_SDRV.state(i,j).DRVs=Results.DRVs;
        end
    end
    
    M_SDRV.ref=PROC.ref;
    save([pwd '\procsave\' SID],'M_SDRV')

end

end



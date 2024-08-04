function [PROC,M_CDRV]=CDRV_fix(FILE,cmdline)
if nargin==0
    [CASE]=load_define('','ns');
    if isempty(CASE)
        PROC=[];
        M_CDRV=[];
        return
    end
    FILE=CASE.Files(1);
    cmdline='';
elseif nargin==1
    cmdline='';
elseif nargin==2
    cmdline=lower(cmdline);
end

nA=length(FILE.state.alpha0);
nS=length(FILE.state.beta0);

%读取舵面定义，并将所有操纵面偏角置零
nCF=0;
M_CDRV.CF_DEF(1)=struct('nwing',[],'nelm',[]);
for i=1:length(FILE.geo)
    for j=1:length(FILE.geo(i).ny)
        if any(FILE.geo(i).fc(j,:))
            nCF=nCF+1;
            FILE.geo(i).deflect(j,:)=[0,0];
            M_CDRV.CF_DEF(nCF).nwing=i;
            M_CDRV.CF_DEF(nCF).nelm=j;
        end
    end
end

%先完成舵面非偏转状态的PROC构成
if ~contains(cmdline,'n')
    tic
    fprintf('Preparing Solver Mesh.................')
end
%完成无舵面偏转时的网格生成
[PROC(nCF+1),~]=pre_general(FILE,'nf'); %f-不计算摩擦阻力

% 生成每个舵面偏转的网格
for i=1:nCF
    nwing=M_CDRV.CF_DEF(i).nwing;
    nelm=M_CDRV.CF_DEF(i).nelm;
    
    PROC(i)=PROC(nCF+1);
    PROC(i).geo(nwing).deflect(nelm,:)=[deg2rad(.5),0];
    PROC(i).MESH=pre_Deflect(PROC(i));            %舵面偏转
    if PROC(i).state.GND_EFF==1
        PROC(i).sMESH=pre_sMESH(PROC(i));    
    end
    PROC(i).OBJ_MESH=pre_form_MESH(PROC(i));          %V1->P1\P2,重新求解一轮，并不是覆盖原数据
end

if ~contains(cmdline,'n')
    fprintf('Time Consumption %2.2f s\n',toc)
    fprintf('Control Derivative Solving.................')
end

if nA==1 && nS==1
    % 单点状态求操纵导数
    [CDRV]=solver_DRVcontrol(PROC,'n');
    if ~contains(cmdline,'n') 
        elapsedTime=toc;
        fprintf('Time Consumption %2.2f s\n',elapsedTime)
        tic
        post_fastview(CDRV,PROC,'DRV_C');  %M_CDRV
    end
elseif nS==1 %迎角单独扫掠
    for i=nA:-1:1
        alpha=PROC(nCF+1).state.alpha0(i);
        for j=1:nCF+1
            PROC(j).state.alpha=alpha;
        end
        M_CDRV.state(i,1).alpha=alpha;
        M_CDRV.state(i,1).beta=PROC(nCF+1).state.beta;
        M_CDRV.state(i,1).DRVs=solver_DRVcontrol(PROC,'n');
    end
    if ~contains(cmdline,'n') 
        elapsedTime=toc;
        fprintf('Time Consumption %2.2f s\n',elapsedTime)
        post_fastview(M_CDRV,PROC,'M_CDRV_A');  %M_CDRV
    end
    %计算结果输出
    SID=['cdrv_' PROC(nCF+1).name '_A1'];
    disp('AoA Swept Control Derivative Analysis Results - Output to File')
    disp(['Output File Name: \procsave\' SID '.mat'])
    save([pwd '\procsave\' SID],'M_CDRV')
    
elseif nA==1  %侧滑角单独扫掠
    for i=nS:-1:1
        beta=PROC(nCF+1).state.beta0(i);
        for j=1:nCF+1
            PROC(j).state.beta=beta;
        end
        M_CDRV.state(1,i).beta=beta;
        M_CDRV.state(1,i).alpha=PROC(nCF+1).state.alpha;
        M_CDRV.state(1,i).DRVs=solver_DRVcontrol(PROC,'n');
    end
    if ~contains(cmdline,'n') 
        elapsedTime=toc;
        fprintf('Time Consumption %2.2f s\n',elapsedTime)
        post_fastview(M_CDRV,PROC,'M_CDRV_A');  %M_CDRV
    end
    
else
    for i=nA:-1:1
        alpha=PROC(nCF+1).state.alpha0(i);
        for j=nS:-1:1
            beta=PROC(nCF+1).state.beta0(j);
            for k=1:nCF+1
                PROC(k).state.alpha=alpha;
                PROC(k).state.beta=beta;
            end
            M_CDRV.state(i,j).alpha=alpha;
            M_CDRV.state(i,j).beta=beta;
            M_CDRV.state(i,j).DRVs=solver_DRVcontrol(PROC,'n');
        end
    end
    
    if ~contains(cmdline,'n') 
        elapsedTime=toc;
        fprintf('Time Consumption %2.2f s\n',elapsedTime)
    end
    %计算结果输出
    SID=['cdrv_' PROC(nCF+1).name '_B1'];
    disp('AoA and AoS Swept Control Derivative Analysis Results - Output to File')
    disp(['Output File Name: \procsave\' SID '.mat'])
    save([pwd '\procsave\' SID],'M_CDRV')
    
end
    


end
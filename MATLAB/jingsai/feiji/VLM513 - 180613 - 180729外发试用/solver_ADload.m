function [Results_PTL,PROC]=solver_ADload(PROC,cmdline)
% V1 附着涡   V2 脱体涡
% P1 控制点   P2 气动力作用点  P3 尾涡点

if ~contains(cmdline,'n')
    tic
    fprintf('生成尾涡网格.................')
end
PROC.WAKE=pre_WAKE(PROC);
if PROC.state.GND_EFF==1
    PROC.sWAKE=pre_sWAKE(PROC);    
end

if ~contains(cmdline,'n')
    fprintf('耗时 %2.2f s\n',toc)
    tic
    fprintf('生成计算格式与边界条件.......')
end

PROC.OBJ_WAKE=pre_form_WAKE(PROC);       %V2->P1\P2   V1\V2->P3  
PROC.OBJ_BOUND=pre_form_BOUND(PROC);     %生成边界条件以及P2\P3点的诱导速度系数

if ~contains(cmdline,'n')
    fprintf('耗时 %2.2f s\n',toc)
    tic
    fprintf('求解方程组...................')
end
[Results_PTL]=solver_compute(PROC);

if ~contains(cmdline,'n')
    fprintf('耗时 %2.2f s\n',toc)
end

end
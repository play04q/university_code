function [Results_PTL,PROC]=solver_ADload(PROC,cmdline)
% V1 ������   V2 ������
% P1 ���Ƶ�   P2 ���������õ�  P3 β�е�

if ~contains(cmdline,'n')
    tic
    fprintf('����β������.................')
end
PROC.WAKE=pre_WAKE(PROC);
if PROC.state.GND_EFF==1
    PROC.sWAKE=pre_sWAKE(PROC);    
end

if ~contains(cmdline,'n')
    fprintf('��ʱ %2.2f s\n',toc)
    tic
    fprintf('���ɼ����ʽ��߽�����.......')
end

PROC.OBJ_WAKE=pre_form_WAKE(PROC);       %V2->P1\P2   V1\V2->P3  
PROC.OBJ_BOUND=pre_form_BOUND(PROC);     %���ɱ߽������Լ�P2\P3����յ��ٶ�ϵ��

if ~contains(cmdline,'n')
    fprintf('��ʱ %2.2f s\n',toc)
    tic
    fprintf('��ⷽ����...................')
end
[Results_PTL]=solver_compute(PROC);

if ~contains(cmdline,'n')
    fprintf('��ʱ %2.2f s\n',toc)
end

end
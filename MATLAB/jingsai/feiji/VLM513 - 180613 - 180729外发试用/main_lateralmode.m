function main_lateralmode()
% 模态特性求解：
% 读单文件->输入求解状态->求单EIG->判读模态（排序）
% 根轨迹求解
% 读多文件->输入求解状态->求多EIG->判读模态（排序)->作图
% 定载模态求解
% 读多文件->输入求解状态->求多EIG->判读模态（排序)->作图
% MDRV,state,ref,inertias

loop=1;

while loop==1	
disp('   ')
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('"  Lateral-directional Mode Analysis                  ')
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('    [1]. 模态特性求解 ')
disp('    [2]. 根轨迹求解 ')
disp(' ')    
disp('    [3]. 定载横航向模态求解 ')
%disp('    [4]. 参数敏度分析 ')
disp(' ')
disp('    [0]. 返回')
disp(' ')


answ=input('	请选择执行项目代号: ');
      
    if isempty(answ)
      answ=0;
    end
    
    switch answ
        case 1  %模态特性求解
            [CASE]=load_DRVstability();
            if ~isempty(CASE)
                lat_chr(CASE.Files(1));
            end
            
        case 2  %根轨迹作图
            lat_rlc();

        case 3
            lat_gfix();
            

            
        case 0
            return
    end
end



end





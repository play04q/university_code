function main_longitudinalmode()
loop=1;

while loop==1;	
    disp('   ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"  纵向模态求解                                       ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('    [1]. 模态特性求解 ')
    %disp('    [2]. 根轨迹求解 ')
    disp(' ')    
    disp('    [3]. 定载纵向模态求解 ')
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
            [geo,state,ref,inertias,M_SDRV]=load_DRVstability();
            if ~isempty(geo)
                long_chr(geo,state,ref,inertias,M_SDRV);
            end
            
            
 %       case 2  %根轨迹作图
 %           lat_rlc();

        case 3
            long_gfix();
            

            
        case 0
            return
    end
end



end





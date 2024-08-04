function[]=postproc2(geo,state,ref,lattice,results)
settings=config('startup');
loop1=1;
while loop1==1;
    disp(' ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"                                                    ')
    disp('"  主菜单                                            ')
    disp('"      |---->后处理功能                              ')
    disp('"                                                    ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp(' ')
    disp(' [1].  清除所有图表曲线')
    disp(' ')
    disp(' [2].  图形显示当前几何外形定义')
    disp(' ')
    disp(' [3].  载荷分布图：单点求解计算')
    disp(' [4].  三维载荷分布图：单点求解计算')
    disp(' ')
    disp(' [4].  计算结果曲线：迎角变化计算 ')
    
    disp(' ')
    disp(' [0].  返回')
    disp(' ')

    quest=input('	请选择执行项目代号: ');
    if isempty(quest)
        return
    end

    switch(quest)
        case 1
           close all

        case 2
            if geo.inst==0          %avoid crash if geometry is empty
                terror1(41)
            else
                geometryplot(lattice,geo,ref,0);
            end

        case 3
           if strcmp(state.type,'simp')
               [results]=spanload2(results,geo,lattice,state,ref);
           end

        case 4
           load3d(results,geo,lattice,state,ref);

        case 5
           resultplot(3);

        case 6
           resultplot(4);

        case 7
           resultplot(5);

        case 8
           resultplot(6);

        case 9
           resultplot(7);

        case 10
           resultplot(8);

        case 11
            resultplot(9)

        case 12
            resultplot(10)
        case 13
             definitions;

        case 14
            cd(settings.odir)
            dir
            cd(settings.hdir)
            disp(' ');
            
            JID=input('请选择需要导出的计算结果存档文件(JID): ','s');
            if isempty(JID)
                JID=('trial');            
                disp(' ')
                disp(' 读取默认计算结果存档文件名"trial" ');
                disp(' ')
            end
            fname=input('请输入目标文本文件名: ','s');
            simpexport(JID,fname);
        
        case 15
            cd(settings.odir)
            dir
            cd(settings.hdir)
            disp(' ');
            
            quest=1;
            JID=input('请选择需要导出的计算结果存档文件(JID): ','s');
            if isempty(JID)
                JID=('trial');            
                disp(' ')
                disp(' 读取默认计算结果存档文件名"trial" ');
                disp(' ')
            end
            fname=input('请输入目标文本文件名: ','s');
            swpexport(JID,fname,quest);

    case 0
        loop1=0;

    otherwise
        terror1(11)   
    end %% switch
end  %%while loop1=1
    
   



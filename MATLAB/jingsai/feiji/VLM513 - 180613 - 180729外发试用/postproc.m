function[]=postproc(lattice,geo,ref);
settings=config('startup');
loop1=1;
while loop1==1;
    disp(' ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"                                                    ')
    disp('"  主菜单                                            ')
    disp('"      |---->图形显示及后处理       ')
    disp('"                                                    ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp(' ')
    disp(' [1].  清除所有图表曲线')
    disp(' ')
    disp(' [2].  图形显示当前几何外形定义')
    disp(' [3].  计算结果：单点求解计算')   
    disp(' [4].  载荷分布图：单点求解计算')
    disp(' ')
    disp(' [5].  计算结果曲线：迎角变化计算 ')
    disp(' [6].  Solution plot, Beta sweep')
    disp(' [7].  Solution plot, Delta sweep')
    disp(' [8].  Solution plot, Roll rate sweep')
    disp(' [9].  Solution plot, Pitch rate sweep')
    disp(' [10]. Solution plot, Yaw rate sweep')
    disp(' ')
    disp(' [11]. Perform a trefftz plane analysis, (experimental).') 
    disp(' [12]. 计算结果：零升阻力估算')
    disp(' [13]. Plot derivative definitions,')
    disp(' ')
    disp(' [14]. 将单点求解计算结果导出为文本文件.')
    disp(' [15]. 将迎角变化计算结果导出为文本文件.')
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
                geometryplot(lattice,geo,ref);
            end

        case 3
           resultplot(1);

        case 4
           resultplot(2);

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
    
   



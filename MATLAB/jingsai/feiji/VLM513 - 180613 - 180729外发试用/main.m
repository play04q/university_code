%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本软件在编写的最早阶段曾大量参考了 Tomas Melin 编写的 Tornado 涡格法软件
% 在此对前人的工作表示由衷的敬意
% 宋磊
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
geo=[];
state=[];
ref=[];

loop=1;                     %program run bit

while loop==1
    disp('   ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""')
	disp('"  VLM510  Build 180614                                          "')
	disp('"  Main Menu                                                     "')
	disp('"  Beihang University  北京航空航天大学      航空科学与工程学院    "')
	disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('    [1]. Cauculation Case File Check ')
    disp(' ')    
    disp('    [2]. Aerodynamic Force/Moment Analysis ')
    disp('    [3]. Stability Derivatives Analysis ')
    disp('    [4]. Control Surface Deflection Analysis... ')
    disp(' ')
    disp('    [5]. 纵向模态求解... ')
    disp('    [6]. Lateral-directional Dynamic Stability Analysis... ')
    disp(' ')
    disp(' 后处理和图形显示')
    disp('    [7]. 后处理功能 ' )
    disp('    [8]. 计算数据校准 ' )
    disp(' ')
    disp('    [10]. 关于 / 更新情况')
    disp('    [0]. Exit')
	disp(' ')
	
    answ=input('	请选择执行项目代号: ');
      
    if isempty(answ)
      answ=0;
    end

    disp(' ')

    switch answ
        case 1
            load_define();
        
        case 2
            %计算求解
            [CASE,PROC,Results]=main_ADload();
            
        case 3
            [CASE,PROC,Results]=main_SDRV();
        
        case 4
            main_CtrlSurf();
            
        case 5
            main_longitudinalmode();
            
        case 6
            main_lateralmode;
            
        case 7
            postproc2(geo,state,ref,lattice,Results);
            
        case 8
            main_cli()
            
        case 88
            close all
            x=[];
            l=[];
            m=[];
            n=[];
            [geo,state,ref,lattice,results]=autosolve(geo,state,ref);
            for i=0:.1:30
                state.P=deg2rad(i);
                x=[x i];
                [geo,state,ref,lattice,results]=autosolve(geo,state,ref);
                l=[l results.Lm];
                m=[m results.Mm];
                n=[n results.Nm];
                %[results]=spanload2(results,geo,lattice,state,ref);
            end
            
            figure (881)
            plot(x,l)
            figure (882)
            plot(x,m)
            figure (883)
            plot(x,n)
            %}
            
            
        case 222
         %Enter new state variables   
         [state,lattice]=statesetup2(state,lattice);
        
        case 3
         %Change a control surface deflection 
         sfdef(geo,lattice);
         
        case 4
            geo=setrefpoint(geo,ref);
        
        case 5
         %生成计算网格
         [lattice,ref]=latticemenu(geo,state,lattice,ref);
         lattice.inst=1;
         
       
         
        
         
        
            
        
        case 9
            postproc(lattice,geo,ref)

        
        case 10
         infomation
         
      case 0
   	   loop=0;

         
      otherwise
         
   end
   
end
end
%%%

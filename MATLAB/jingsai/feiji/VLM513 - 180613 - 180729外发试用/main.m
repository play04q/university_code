%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ڱ�д������׶��������ο��� Tomas Melin ��д�� Tornado �и����
% �ڴ˶�ǰ�˵Ĺ�����ʾ���Եľ���
% ����
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
	disp('"  Beihang University  �������պ����ѧ      ���տ�ѧ�빤��ѧԺ    "')
	disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('    [1]. Cauculation Case File Check ')
    disp(' ')    
    disp('    [2]. Aerodynamic Force/Moment Analysis ')
    disp('    [3]. Stability Derivatives Analysis ')
    disp('    [4]. Control Surface Deflection Analysis... ')
    disp(' ')
    disp('    [5]. ����ģ̬���... ')
    disp('    [6]. Lateral-directional Dynamic Stability Analysis... ')
    disp(' ')
    disp(' �����ͼ����ʾ')
    disp('    [7]. ������ ' )
    disp('    [8]. ��������У׼ ' )
    disp(' ')
    disp('    [10]. ���� / �������')
    disp('    [0]. Exit')
	disp(' ')
	
    answ=input('	��ѡ��ִ����Ŀ����: ');
      
    if isempty(answ)
      answ=0;
    end

    disp(' ')

    switch answ
        case 1
            load_define();
        
        case 2
            %�������
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
         %���ɼ�������
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

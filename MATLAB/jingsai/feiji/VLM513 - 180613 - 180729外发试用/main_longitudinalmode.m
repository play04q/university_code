function main_longitudinalmode()
loop=1;

while loop==1;	
    disp('   ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"  ����ģ̬���                                       ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('    [1]. ģ̬������� ')
    %disp('    [2]. ���켣��� ')
    disp(' ')    
    disp('    [3]. ��������ģ̬��� ')
    %disp('    [4]. �������ȷ��� ')
    disp(' ')
    disp('    [0]. ����')
    disp(' ')


    answ=input('	��ѡ��ִ����Ŀ����: ');
      
    if isempty(answ)
      answ=0;
    end
    
    switch answ
        case 1  %ģ̬�������
            [geo,state,ref,inertias,M_SDRV]=load_DRVstability();
            if ~isempty(geo)
                long_chr(geo,state,ref,inertias,M_SDRV);
            end
            
            
 %       case 2  %���켣��ͼ
 %           lat_rlc();

        case 3
            long_gfix();
            

            
        case 0
            return
    end
end



end





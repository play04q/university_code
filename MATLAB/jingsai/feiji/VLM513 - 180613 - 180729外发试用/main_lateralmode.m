function main_lateralmode()
% ģ̬������⣺
% �����ļ�->�������״̬->��EIG->�ж�ģ̬������
% ���켣���
% �����ļ�->�������״̬->���EIG->�ж�ģ̬������)->��ͼ
% ����ģ̬���
% �����ļ�->�������״̬->���EIG->�ж�ģ̬������)->��ͼ
% MDRV,state,ref,inertias

loop=1;

while loop==1	
disp('   ')
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('"  Lateral-directional Mode Analysis                  ')
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('    [1]. ģ̬������� ')
disp('    [2]. ���켣��� ')
disp(' ')    
disp('    [3]. ���غẽ��ģ̬��� ')
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
            [CASE]=load_DRVstability();
            if ~isempty(CASE)
                lat_chr(CASE.Files(1));
            end
            
        case 2  %���켣��ͼ
            lat_rlc();

        case 3
            lat_gfix();
            

            
        case 0
            return
    end
end



end





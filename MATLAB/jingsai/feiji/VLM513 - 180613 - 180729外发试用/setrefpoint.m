%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [REF_POINT] = setrefpoint (REF_POINT,REF)
%
% Allows the user to manipulate the reference point position through
% a simple interface. The [x,y,z] position of the REF_POINT is either set
% directly, or as a percentage of the MAC in ther structure REF (Ref.C_mac)
%
% Example:
%
%  [ref_point]=setrefpoint(ref_point,ref);
%
% Calls:
%       questions       Contain user interface queries in string
%                       format. 
%
% Author: Tomas Melin <melin@kth.se>
% Keywords: Tornado text based user interface
%
% Revision History:
%   Bristol, 2007-06-27:  Addition of new header. TM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [geo]=setrefpoint(geo,ref)
loop1=1;
while loop1==1;
    disp(' ')
	disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"                                                    ')
    disp('"  ���˵�                                            ')
    disp('"      |----->�ƶ����ļ��ο���                        ')
    disp('"                                                    ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
	disp(' ')
	disp('	[1]. �ƶ��ο��� x ����')   
	disp('	[2]. �ƶ��ο��� y ����')
	disp('	[3]. �ƶ��ο��� z ����')
    disp('	[4]. ��ƽ�������� (MAC) ���ƶ��ο���')
    disp(' ')
    disp('	[5]. �ƶ����� x ����')   
	disp('	[6]. �ƶ����� y ����')
	disp('	[7]. �ƶ����� z ����')
    disp('	[8]. ��ƽ�������� (MAC) ���ƶ�����')
    disp(' ')
    disp('	[0]. �����ϼ��˵�')
    disp(' ')
    disp(strcat('��ǰ�ο���λ��: ',num2str(geo.ref_point)))
    disp(' ')
    q=input(' 	��ѡ��ִ����Ŀ����: ');
     
    if isempty(q)
        q=0;%�س����Զ������ϼ��˵�
    end


    switch q
        case 1 
            %move in x
            geo.ref_point(1)=input('�µĲο���x���꣨��������ϵ��[m] = ');
            
        case 2 
            %move in y
            geo.ref_point(2)=input('�µĲο���y���꣨��������ϵ��[m] = ');

        case 3  
            %move in z
            geo.ref_point(3)=input('�µĲο���z���꣨��������ϵ��[m] = ');

        case 4 
             %Move ref point to percentage of MAC
             point=input('��ƽ��������(MAC)���µĲο���λ�� [%]= ');
             geo.ref_point=ref.mac_pos+[point*ref.C_mac/100 0 0];
        
        case 5
            %move in x
            geo.CG(1)=input('�µ�����x���꣨��������ϵ��[m] = ');
            
        case 6 
            %move in y
            geo.CG(2)=input('�µ�����y���꣨��������ϵ��[m] = ');

        case 7  
            %move in z
            geo.CG(3)=input('�µ�����z���꣨��������ϵ��[m] = ');

        case 8 
             %Move ref point to percentage of MAC
             point=input('��ƽ��������(MAC)���µ�����λ�� [%]= ');
             geo.CG=ref.mac_pos+[point*ref.C_mac/100 0 0];

        case 0
            loop1=0;
        
        otherwise
            terror1(11);
    end %% switch q ���˵�ѡ��
end  %% while loop1==1; ȫ��ѭ��

end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
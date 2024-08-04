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
    disp('"  主菜单                                            ')
    disp('"      |----->移动重心及参考点                        ')
    disp('"                                                    ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
	disp(' ')
	disp('	[1]. 移动参考点 x 坐标')   
	disp('	[2]. 移动参考点 y 坐标')
	disp('	[3]. 移动参考点 z 坐标')
    disp('	[4]. 在平均气动弦 (MAC) 上移动参考点')
    disp(' ')
    disp('	[5]. 移动重心 x 坐标')   
	disp('	[6]. 移动重心 y 坐标')
	disp('	[7]. 移动重心 z 坐标')
    disp('	[8]. 在平均气动弦 (MAC) 上移动重心')
    disp(' ')
    disp('	[0]. 返回上级菜单')
    disp(' ')
    disp(strcat('当前参考点位于: ',num2str(geo.ref_point)))
    disp(' ')
    q=input(' 	请选择执行项目代号: ');
     
    if isempty(q)
        q=0;%回车即自动返回上级菜单
    end


    switch q
        case 1 
            %move in x
            geo.ref_point(1)=input('新的参考点x坐标（机体坐标系）[m] = ');
            
        case 2 
            %move in y
            geo.ref_point(2)=input('新的参考点y坐标（机体坐标系）[m] = ');

        case 3  
            %move in z
            geo.ref_point(3)=input('新的参考点z坐标（机体坐标系）[m] = ');

        case 4 
             %Move ref point to percentage of MAC
             point=input('在平均气动弦(MAC)上新的参考点位置 [%]= ');
             geo.ref_point=ref.mac_pos+[point*ref.C_mac/100 0 0];
        
        case 5
            %move in x
            geo.CG(1)=input('新的重心x坐标（机体坐标系）[m] = ');
            
        case 6 
            %move in y
            geo.CG(2)=input('新的重心y坐标（机体坐标系）[m] = ');

        case 7  
            %move in z
            geo.CG(3)=input('新的重心z坐标（机体坐标系）[m] = ');

        case 8 
             %Move ref point to percentage of MAC
             point=input('在平均气动弦(MAC)上新的重心位置 [%]= ');
             geo.CG=ref.mac_pos+[point*ref.C_mac/100 0 0];

        case 0
            loop1=0;
        
        otherwise
            terror1(11);
    end %% switch q 主菜单选项
end  %% while loop1==1; 全局循环

end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
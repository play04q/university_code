function load3d(results,geo,lattice,state,ref)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	CONFIG: Basic computation function   	%		 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Computes the spanload (force/meter) for 
%  all wings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Tomas Melin, KTH, Department of% 
%	Aeronautics, copyright 2002				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Context: Auxillary function for TORNADO%
%	Called by: TORNADO SOlverloop          %
%	Calls:	None									%
%	Loads:	None									%
%	Generates:	force per meter array 
%     			(ystations X wings)			
%					Ystation array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Revision history post alfa 1.0			%
%  2007-02-14  rho moved to state 
%  2002-05-02
%   input var T (taper) added to get local
%	 chords.
% input var AS (airspeed) added 
%   local chord computation function call added
%

[psize vsize ~]=size(lattice.VORTEX);
try
    close 3
end
figure(3)
hold on, grid on, axis equal, view([-30 25]);
set(gca,'zdir','reverse')

for i=1:psize
    pX=[];
    pY=[];
    pZ=[];
    for j=1:4
        P=transform('ad',state)*squeeze(lattice.XYZ(i,j,:));
        pX=[pX P(1)];
        pY=[pY P(2)];
        pZ=[pZ P(3)];
    end
    pX=[pX pX(1)];
    pY=[pY pY(1)];
    pZ=[pZ pZ(1)];

    plot3(pX,pY,pZ,'k');
    
    rc=squeeze((lattice.VORTEX(i,3,:)+lattice.VORTEX(i,4,:))/2);
    A=rc+results.F(i,:)'./results.L.*(max(ref.b_ref)*30);					%Check routine
    rc=transform('ad',state)*rc;
    A=transform('ad',state)*A;
    nX=[rc(1) A(1)];				%Calculating normals
    nY=[rc(2) A(2)];				         
    nZ=[rc(3) A(3)];
    plot3(nX,nY,nZ,'--b');
    
end

xlabel('飞机设计坐标系 x 轴')
ylabel('飞机设计坐标系 y 轴')
zlabel('飞机设计坐标系 z 轴')
title('机翼布局、涡线、控制点、面元法向详图')


end

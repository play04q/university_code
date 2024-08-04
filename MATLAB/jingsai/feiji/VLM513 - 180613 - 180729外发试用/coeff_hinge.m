function [Results]=coeff_hinge(Results,PROC)
PTL=Results.PTL;
state=PROC.state;
ref=PROC.ref;
MESH=PROC.MESH;
Results.state=state;

q=0.5*state.rho*state.AS^2;	

nwing=length(PROC.geo);

PTL.FORCE=sum(PTL.F,1);						%沿飞机设计轴系三个方向的合力  
PTL.MOMENTS=sum(PTL.M,1);					%Summing up moments	


%% 计算体轴系上的各向合力和系数
xyzFORCE=transform('bd',state)*PTL.FORCE';

PTL.X=xyzFORCE(1);
PTL.Y=xyzFORCE(2);
PTL.Z=xyzFORCE(3);

PTL.CX=xyzFORCE(1)/(q*ref.S_ref_M);
PTL.CY=xyzFORCE(2)/(q*ref.S_ref_M);
PTL.CZ=xyzFORCE(3)/(q*ref.S_ref_M);

%% 计算风轴系上的各向合力和系数
xyzFORCE=transform('ad',state)*PTL.FORCE';

PTL.Di=-xyzFORCE(1)';
PTL.C=xyzFORCE(2)';
PTL.L=-xyzFORCE(3)';

PTL.CL=PTL.L/(q*ref.S_ref_M);
PTL.CDi=PTL.Di/(q*ref.S_ref_M);
PTL.CC=PTL.C/(q*ref.S_ref_M);

if isfield(Results,'friction')
     friction=Results.friction;
     Total.D=friction.D0+PTL.Di;
     Total.CD=friction.CD0+PTL.CDi;
     Total.LDr=PTL.L/Total.D;
end

%% 计算体轴系上的各向和力矩和系数
xyzFORCE=transform('bd',state)*PTL.MOMENTS';

PTL.Lm=xyzFORCE(1)';
PTL.Mm=xyzFORCE(2)';
PTL.Nm=xyzFORCE(3)';

PTL.CLm=PTL.Lm/(q*ref.S_ref_M*ref.b_ref_M);
PTL.CMm=PTL.Mm/(q*ref.S_ref_M*ref.C_mac_M);
PTL.CNm=PTL.Nm/(q*ref.S_ref_M*ref.b_ref_M);

%% 计算每个机翼上的力和力矩
nV0=length(MESH.V0);
%V0_Relation=zeros(nV0,3);
%for i=1:nV0
%    V0_Relation(i,:)=MESH.V0(i).Relation;
%end
nwing=MESH.nwing;

nFORCE=zeros(nwing,3);
nMOMENTS=zeros(nwing,3);
for i=1:nV0
    WingID=MESH.V0(i).Relation(1);
    nFORCE(WingID,:)=nFORCE(WingID,:)+PTL.F(i,:);
    nMOMENTS(WingID,:)=nMOMENTS(WingID,:)+PTL.M(i,:);
end

for i=1:nwing
    xyzFORCE=transform('ad',state)*nFORCE(i,:)';
    PTL.nDi(i)=-xyzFORCE(1)';
    PTL.nC(i)=xyzFORCE(2)';
    PTL.nL(i)=-xyzFORCE(3)';
    
   % if isfield(Results,'friction')
   %     total.nD(i)=PTL.nDi(i)+friction.nD0(i);
   % end


    xyzM=transform('bd',state)*nMOMENTS(i,:)';
    PTL.nLm(i)=xyzM(1)';
    PTL.nMm(i)=xyzM(2)';
    PTL.nNm(i)=xyzM(3)';
end


Results.PTL=PTL;
Results.Total=Total;
%Results.total=total;
return
%% 计算每块面元上的Cp
normal_force=dot(Results.F,lattice.N,2);                                
panel_area=Parea(lattice.XYZ);
stat_press=normal_force'./panel_area;	%Delta pressure, top/bottom
Results.cp=(stat_press./q)';


try
    if state.pgcorr==1
        [Results,state]=fpgcorr(Results,state);
    end
end 






end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [panel_area]=Parea(XYZ)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tarea: Subsidary function for TORNADO					   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the area of each panel								
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Author:	Tomas Melin, KTH, Department of Aeronautics	%
%				Copyright 2000											
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTEXT:	Subsidaty function for TORNADO					
% Called by:	coeff_create
% 
% Calls:			MATLAB 5.2 std fcns								
% Loads:	none
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[psize,~,~]=size(XYZ);
for i=1:psize
   p1=[XYZ(i,1,1) XYZ(i,1,2) XYZ(i,1,3)];	%sets up the vectors 
   p2=[XYZ(i,2,1) XYZ(i,2,2) XYZ(i,2,3)];	%to the corners of the		
   p3=[XYZ(i,3,1) XYZ(i,3,2) XYZ(i,3,3)];	%panel.
   p4=[XYZ(i,4,1) XYZ(i,4,2) XYZ(i,4,3)];
   
   a=p2-p1;	%sets up the edge vectors
   b=p4-p1;
   c=p2-p3;
   d=p4-p3;
   
   ar1=norm(cross(b,a))/2;	%claculates the ctoss product of
   ar2=norm(cross(c,d))/2;	%two diagonal corners
   
 	panel_area(i)=ar1+ar2;	%Sums up the product to make the
end						    %Area
end% function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[lc]=fLocal_chord2(geo,lattice)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Geometry function 						 	%		 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Computes the Local chord at each collocation 
%  point row.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Tomas Melin, KTH, Department of% 
%	Aeronautics, copyright 2002				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Context: Auxillary function for TORNADO%
%	Called by: TORNADO spanload            %
%	Calls:	None									%
%	Loads:	None									%
%	Generates:	Local chord vector lc, same 
%  order as colloc, N, and the others
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[indx1 indx2]=size(geo.b);

for s=1:indx1;	   		%Looping over wings
	CHORDS(s,1)=geo.c(s);		%calculating chords of first element
end

for s=1:indx1				%Looping over wings
	for t=1:indx2			%Looping over partitions
	%Chord loop, generating chords for wing partitions
            CHORDS(s,t+1)=CHORDS(s,t)*geo.T(s,t);	%calculating
      												%element root-chord
   end
end




lc=[];	%Local chord vector.


panelchords1=sqrt(sum((lattice.XYZ(:,1,:)-lattice.XYZ(:,4,:)).^2,3)); %inboard
panelchords2=sqrt(sum((lattice.XYZ(:,2,:)-lattice.XYZ(:,3,:)).^2,3)); %outboard
panelchords3=(panelchords1+panelchords2)/2; %Chord of each panel, CAUTION 
                                            %this is really camber line
                                            %length, so not really chord
                                            %for very cambered profiles

for i=1:indx1;			%Wing	
   for j=1:indx2;		%Partition
      lemma=[]; %local chord lemma vector.
      chordwisepanels=geo.nx(i,j)+geo.fnx(i,j); %number of panels chordwise on 
                                                %this partition 
      for k=1:geo.ny(i,j)                       %loop over panel strips.
          if geo.ny(i,j)~=0
              lemma=[lemma sum(panelchords3(1:chordwisepanels))];
              panelchords3=panelchords3((chordwisepanels+1):end);
              %size(panelchords3);
          end
      end  
      if geo.symetric(i)==1	%symmetric wings got two sides
         lc=[lc lemma lemma];
         panelchords3=panelchords3((chordwisepanels*geo.ny(i,j)+1):end);
      else
         lc=[lc lemma];
      end
          
   end
end
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Results,state]=fpgcorr(Results,state)
%Prandtl Glauert correction
[state.rho a p_1]=ISAtmosphere(state.ALT);

M=state.AS/a;
corr=1/(sqrt(1-M^2));

         
Results.F=Results.F*corr;
Results.FORCE=Results.FORCE*corr;
Results.M =Results.M*corr;
Results.MOMENTS=Results.MOMENTS*corr; 

Results.cp=Results.cp*corr; 
Results.CX=Results.CX*corr; 
Results.CY=Results.CY*corr; 
Results.CZ=Results.CZ*corr; 
Results.D=Results.D*corr; 
Results.C=Results.C*corr; 
Results.L=Results.L*corr; 
Results.CL=Results.CL*corr; 
Results.CD=Results.CD*corr; 
Results.CC=Results.CC*corr; 
Results.Clm=Results.Cl*corr; 
Results.Cmm=Results.Cm*corr; 
Results.Cnm=Results.Cn*corr; 

Results.ForcePerMeter=Results.ForcePerMeter*corr; 
Results.CL_local=Results.CL_local*corr;

   Results.CL_a=Results.CL_a*corr;
   Results.CD_a=Results.CD_a*corr;
   Results.CC_a=Results.CC_a*corr;
   Results.CX_a=Results.CX_a*corr;
   Results.CY_a=Results.CY_a*corr;
   Results.CZ_a=Results.CZ_a*corr;
   Results.Cl_a=Results.Cl_a*corr;
   Results.Cm_a=Results.Cm_a*corr;
   Results.Cn_a=Results.Cn_a*corr;
   
   Results.CL_b=Results.CL_b*corr;
   Results.CD_b=Results.CD_b*corr;
   Results.CC_b=Results.CC_b*corr;
   Results.CX_b=Results.CX_b*corr;
   Results.CY_b=Results.CY_b*corr;
   Results.CZ_b=Results.CZ_b*corr;
   Results.Cl_b=Results.Cl_b*corr;
   Results.Cm_b=Results.Cm_b*corr;
   Results.Cn_b=Results.Cn_b*corr;
   
   Results.CL_P=Results.CL_P*corr;
   Results.CD_P=Results.CD_P*corr;
   Results.CC_P=Results.CC_P*corr;
   Results.CX_P=Results.CX_P*corr;
   Results.CX_P=Results.CX_P*corr;
   Results.CZ_P=Results.CZ_P*corr;
   Results.Cl_P=Results.Cl_P*corr;
   Results.Cm_P=Results.Cm_P*corr;
   Results.Cn_P=Results.Cn_P*corr;
   
   Results.CL_Q=Results.CL_Q*corr;
   Results.CD_Q=Results.CD_Q*corr;
   Results.CC_Q=Results.CC_Q*corr;
   Results.CX_Q=Results.CX_Q*corr;
   Results.CY_Q=Results.CY_Q*corr;
   Results.CZ_Q=Results.CZ_Q*corr;
   Results.Cl_Q=Results.Cl_Q*corr;
   Results.Cm_Q=Results.Cm_Q*corr;
   Results.Cn_Q=Results.Cn_Q*corr;
   
   Results.CL_R=Results.CL_R*corr;
   Results.CD_R=Results.CD_R*corr;
   Results.CC_R=Results.CC_R*corr;
   Results.CX_R=Results.CX_R*corr;
   Results.CY_R=Results.CY_R*corr;
   Results.CZ_R=Results.CZ_R*corr;
   Results.Cl_R=Results.Cl_R*corr;
   Results.Cm_R=Results.Cm_R*corr;
   Results.Cn_R=Results.Cn_R*corr;
   
   try
    Results.CL_d=Results.CL_d*corr;
    Results.CD_d=Results.CD_d*corr;
    Results.CC_d=Results.CC_d*corr;
    Results.CX_d=Results.CX_d*corr;
    Results.CY_d=Results.CY_d*corr;
    Results.CZ_d=Results.CZ_d*corr;
    Results.Cl_d=Results.Cl_d*corr;
    Results.Cm_d=Results.Cm_d*corr;
    Results.Cn_d=Results.Cn_d*corr;
   end



end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

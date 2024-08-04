%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 1999, 2007 Tomas Melin
%
% This file is part of Tornado
%
% Tornado is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public
% License as published by the Free Software Foundation;
% either version 2, or (at your option) any later version.
%
% Tornado is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
% PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public
% License along with Tornado; see the file GNU GENERAL 
% PUBLIC LICENSE.TXT.  If not, write to the Free Software 
% Foundation, 59 Temple Place -Suite 330, Boston, MA
% 02111-1307, USA.
%
% usage: [output] = config(input)
%
% This function sets some reference units in Tornado. For example:
% If the user doesn't wasn the reference area to be computet within 
% Tornado, this is the file to set it in. 
%
% Example:
%
%  S_ref=config('S_ref')
%
%  in case 'S_ref' is unspecified in config.m, the function will return 
%  an empty matrix []. 
%
%
% Calls:
%           none
%
% Author:   Tomas Melin <melin@kth.se>
% Keywords: Tornado core function.
%
% Revision History:
%   Bristol, 2007-12-15:  Addition of output directory configuration. TM
%   Bristol, 2007-07-25:  Addition of new header. TM
%   Bristol, 2007-06-20:  Addition of Verbose configuration. TM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output]=config(input)
switch input

   case 'startup'
       output.hdir=pwd;                                %tornado home  
       output.afdir=strcat(pwd,'\userdata\airfoil');   %airfoil directory 
       output.cbdir=[pwd '\userdata\camber'];
       output.imdir=strcat(pwd,'\import\');
       output.exdir=strcat(pwd,'\export');
       output.calidir=[pwd '\calibration\'];
       output.procdir=[pwd '\procsave\'];
   
   case 'S_ref'
   	output=[];		%[m^2]	reference surface
      
   case 'b_ref'
      output=[];		%[m] reference span		
      
   case 'C_mac'
      output=[];		%[m] mean aerodynamic chord, reference chord
      
   case 'mac_pos'
      output=[];   %[m m m] , xyz triplet, start of C_mac
      
   case 'infinity'
      output=[];	%Arbitiary length of wake constant
      
   case 'near'
      output=1e-7; %Vortex core radius, change if soulutions are in bad condition 
      
    case 'verbose'
        output=1;   %Set to 1 for talkative output, 0 for silent
        
    case 'delta'
        output=pi/180;  %Delta change in varables during finite difference
    
    case 'dAngle'
        output=pi/180;
    
    case 'dOmega'
        output=pi/180;
        
   otherwise
		output=0;   
	end

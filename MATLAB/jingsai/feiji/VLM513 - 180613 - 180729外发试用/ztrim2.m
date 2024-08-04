function [results,rudderangle]=ztrim(geo,state,trimaxis,trimwing,trimrudder,solvertype)
%Trimfunction for TORNADO
%
%
% Trimaxis is the body axis of momentum to trim around:
%   1=l (roll);
%   2=m (pitch);
%   3=n (yaw);
%
% Trimwing is the wing number to change incidence on to acieve trim
%
% Trimrudder is the rudder (control effector) to change setting of in order
% to acieve trim.
%
%  Output:
%   rudderangle is either the needed change in incedence of a wing, Or the 
%   rudder setting needed to acieve trim.
%%%%%%%%

results.matrix=ones(9,6,1);        
twistdelta=0.001;
converged=0;
rudderangle=0;  


%% Checking input
if trimaxis==1  
elseif trimaxis==2
elseif trimaxis==3
else
    terror(18)
    results=[];
    return
end

if trimwing*trimrudder>0
    terror(19)
    results=[];
    return
end
if trimrudder>0;
    if sum(sum(geo.flapped'))==0
         terror(2)
         results=[];
    return
    end
end
if sum(sum(geo.flapped'))<trimrudder
    terror(2)
    results=[];
    return
end

if trimwing<1
    if trimrudder<1
        terror(20)
        results=[];
        return
    end
end




%% Computing baseline results
[lattice,ref]=fLattice_setup2(geo,state,solvertype);  
[results]=solver9(results,state,geo,lattice,ref);
[results]=coeff_create2(results,lattice,state,ref,geo);

    if trimaxis==1
         m0=results.Cl;
    elseif trimaxis==2
         m0=results.Cm;
    elseif trimaxis==3
         m0=results.Cn;
    end


k=0;
rudderangle=0;
%% Iterating
while converged==0; %Looping until converged condition
    k=k+1;
    rudderangle=rudderangle+twistdelta;
    
    if trimwing>0
        %change twist
        geo.TW(trimwing,:,:)=geo.TW(trimwing,:,:)+twistdelta;
    end
    if trimrudder>0
        %change ruddersetting          
              [n,m]=find(geo.flapped');
              geo.flap_vector(m(trimrudder),n(trimrudder))=rudderangle; 
    end
    
    
    [lattice,ref]=fLattice_setup2(geo,state,solvertype);  
    [results]=solver9(results,state,geo,lattice,ref);
    [results]=coeff_create2(results,lattice,state,ref,geo);
            
    if trimaxis==1
         m1=results.Cl;
    elseif trimaxis==2
         m1=results.Cm;
    elseif trimaxis==3
         m1=results.Cn;
    end
            
    if abs(m1)<0.001
       converged=1;
       tdisp('C O N V E R G E D ! ! !')
       return
    end
            
    if k>9
       tdisp('NOT CONVERGED!!!')
       results=[];
       return
    end

    dm_dTW=(m1-m0)/twistdelta;
    m0=m1;
            
    twistdelta=-m0/dm_dTW;
            

        end
            
 
      	
        
        
   results.matrix(:,:)=[results.CL results.CL_a results.CL_b results.CL_P results.CL_Q results.CL_R
           results.CD results.CD_a results.CD_b results.CD_P results.CD_Q results.CD_R
           results.CC results.CC_a results.CC_b results.CC_P results.CC_Q results.CC_R
           results.Cl results.Cl_a results.Cl_b results.Cl_P results.Cl_Q results.Cl_R
           results.Cm results.Cm_a results.Cm_b results.Cm_P results.Cm_Q results.Cm_R
           results.Cn results.Cn_a results.Cn_b results.Cn_P results.Cn_Q results.Cn_R
           results.CX results.CX_a results.CX_b results.CX_P results.CX_Q results.CX_R
           results.CY results.CY_a results.CY_b results.CY_P results.CY_Q results.CY_R
           results.CZ results.CZ_a results.CZ_b results.CZ_P results.CZ_Q results.CZ_R]; 
   end     
   


function [results]=ztrim()
settings=config('startup');

cd(settings.acdir)
    load A4_nac
cd(settings.hdir)

cd(settings.sdir)
    load ABstate
cd(settings.hdir)



trimwing=2;
    
    
   lock(4)=0;
   
   a1=-5*pi/180;   %input('	From alfa [deg]: ')*pi/180;
   b1=1*pi/180;    %input('	Increment [deg]: ')*pi/180;
   c1=10*pi/180;   %input('	To alpha [deg]: ')*pi/180;
   j=0;

   results.matrix=ones(9,6,1);
   for alpha=a1:b1:c1
        
        state.alpha=alpha;
        j=j+1;
        
        twistdelta=0.01;
        twistdistr=geo.TW(trimwing,:,:);
        converged=0;
        [lattice,ref]=fLattice_setup2(geo,state,1);  
        [results]=solver9(results,state,geo,lattice,ref);
        [results]=coeff_create2(results,lattice,state,ref,geo);
        Cm0=results.Cm;
        k=0;
        while converged==0;
        k=k+1
            figure(1);plot(k,Cm0,'*');hold on;ylabel('Cm')
            
            geo.TW(trimwing,:,:)=geo.TW(trimwing,:,:)+twistdelta;
            figure(2);plot(k,(geo.TW(trimwing,1,1))*180/pi,'*');hold on;ylabel('Twist')
            figure(3);plot((geo.TW(trimwing,1,1))*180/pi,Cm0,'o');hold on;xlabel('Twist');ylabel('Cm')
            
            [lattice,ref]=fLattice_setup2(geo,state,0);  
            [results]=solver9(results,state,geo,lattice,ref);
            [results]=coeff_create2(results,lattice,state,ref,geo);
            
            Cm1=results.Cm;
            
            dCm_dTW=(Cm1-Cm0)/twistdelta;
            Cm0=Cm1;
            
            twistdelta=-Cm0/dCm_dTW;
            
            if abs(results.Cm)<0.001
                converged=1;
                disp('C O N V E R G E D ! ! !')
            end
        end
            
 
      	results.alpha_sweep(j)=state.alpha;	
        
        
results.matrix(:,:,j)=[results.CL results.CL_a results.CL_b results.CL_P results.CL_Q results.CL_R
           results.CD results.CD_a results.CD_b results.CD_P results.CD_Q results.CD_R
           results.CC results.CC_a results.CC_b results.CC_P results.CC_Q results.CC_R
           results.Cl results.Cl_a results.Cl_b results.Cl_P results.Cl_Q results.Cl_R
           results.Cm results.Cm_a results.Cm_b results.Cm_P results.Cm_Q results.Cm_R
           results.Cn results.Cn_a results.Cn_b results.Cn_P results.Cn_Q results.Cn_R
           results.CX results.CX_a results.CX_b results.CX_P results.CX_Q results.CX_R
           results.CY results.CY_a results.CY_b results.CY_P results.CY_Q results.CY_R
           results.CZ results.CZ_a results.CZ_b results.CZ_P results.CZ_Q results.CZ_R]; 
   end     
   
end  

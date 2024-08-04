function [CDRV]=solver_DRVcontrol(PROC,cmdline)
dANG=deg2rad(0.5);

if ~contains(cmdline,'n')
    fprintf('Base...');
end
nCF=length(PROC)-1;

for i=nCF+1:-1:1
    CR(i).PTL=solver_ADload(PROC(i),'n');
    CR(i)=coeff_create3(CR(i),PROC(i));
    
    if i<=nCF
        CDRV.CL_(i)=(CR(i).PTL.CL-CR(nCF+1).PTL.CL)/dANG;
        CDRV.CD_(i)=(CR(i).PTL.CDi-CR(nCF+1).PTL.CDi)/dANG;
        CDRV.CC_(i)=(CR(i).PTL.CC-CR(nCF+1).PTL.CC)/dANG;
        CDRV.Clm_(i)=(CR(i).PTL.Clm-CR(nCF+1).PTL.Clm)/dANG;
        CDRV.Cmm_(i)=(CR(i).PTL.Cmm-CR(nCF+1).PTL.Cmm)/dANG;
        CDRV.Cnm_(i)=(CR(i).PTL.Cnm-CR(nCF+1).PTL.Cnm)/dANG;
        
        CDRV.L_(i)=(CR(i).PTL.L-CR(nCF+1).PTL.L)/dANG;
        CDRV.D_(i)=(CR(i).PTL.Di-CR(nCF+1).PTL.Di)/dANG;
        CDRV.C_(i)=(CR(i).PTL.C-CR(nCF+1).PTL.C)/dANG;
        CDRV.Lm_(i)=(CR(i).PTL.Lm-CR(nCF+1).PTL.Lm)/dANG;
        CDRV.Mm_(i)=(CR(i).PTL.Mm-CR(nCF+1).PTL.Mm)/dANG;
        CDRV.Nm_(i)=(CR(i).PTL.Nm-CR(nCF+1).PTL.Nm)/dANG;
    end
end

end


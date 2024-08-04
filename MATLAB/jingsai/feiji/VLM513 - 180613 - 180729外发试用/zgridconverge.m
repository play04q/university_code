function [results,converge]=zgridconverge(geo,state,results,solvertype)


xscalefactor=2;
yscalefactor=2;

g0=geo;
g1=geo;
g2=geo;
g0.nx=2*double(g0.nx>0);
g0.ny=2*double(g0.ny>0); 
g0.fnx=2*double(g0.fnx>0);



%% Computing baseline results
[lattice,ref]=fLattice_setup2(g0,state,solvertype);  
[results]=solver9(results,state,g0,lattice,ref);
[results]=coeff_create2(results,lattice,state,ref,g0);

CL0=results.CL;
CD0=results.CD;
Cm0=results.Cm;

%% Iterating
converged=0;
k=0;

xscalefactor=1.5;
yscalefactor=1.5;

while converged==0
k=k+1;


%nx sensitivity;

g1.nx =ceil(g0.nx  *xscalefactor);
[lattice,ref]=fLattice_setup2(g1,state,solvertype);  
[results]=solver9(results,state,g1,lattice,ref);
[results]=coeff_create2(results,lattice,state,ref,g1);


CL1=results.CL;
CD1=results.CD;
Cm1=results.Cm;

dC(1,1)=((CL1-CL0)/CL0)/xscalefactor;
dC(2,1)=((CD1-CD0)/CD0)/xscalefactor;
%dC(3,1)=((Cm1-Cm0)/Cm0)/xscalefactor;

%ny sensitivity;
g2.ny =ceil(g0.ny  *yscalefactor);
[lattice,ref]=fLattice_setup2(g2,state,solvertype);  
[results]=solver9(results,state,g2,lattice,ref);
[results]=coeff_create2(results,lattice,state,ref,g2);

CL2=results.CL;
CD2=results.CD;
Cm2=results.Cm;

dC(1,2)=((CL2-CL0)/CL0)/yscalefactor;
dC(2,2)=((CD2-CD0)/CD0)/yscalefactor;
%dC(3,2)=((Cm2-Cm0)/Cm0)/yscalefactor;

Vdiff=sum(sqrt(abs(dC)),1)
[void J]=max(Vdiff);

if J==1
    g0.nx(1,:) =ceil(g0.nx(1,:)  *xscalefactor);
    CL(k)=results.CL;
    CD(k)=results.CD;
    Cm(k)=results.Cm;
else
    g0.ny(1,:) =ceil(g0.ny(1,:)  *yscalefactor);
    CL(k)=results.CL;
    CD(k)=results.CD;
    Cm(k)=results.Cm;
end
g0.nx
g0.ny
A(k)=sum(sum(g0.nx.*g0.ny));

plot(A,(CL-CL0)./CL0)
hold on

    if k>10
        tdisplay('NOT CONVERGED!')
        return
    end

end
g2.nx =g2.nx  *scalefactor;
g2.ny =g2.ny  *scalefactor; 
g2.fnx=g2.fnx *scalefactor;
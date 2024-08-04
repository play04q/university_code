function [L]=transform(input,state)
Ldb=[-1  0   0
    0   1   0
    0   0   -1];
Lbd=[-1  0   0
    0   1   0
    0   0   -1];

if isfield(state,'alpha')
    Lba=[cos(state.alpha)*cos(state.beta) -cos(state.alpha)*sin(state.beta) -sin(state.alpha)
         sin(state.beta) cos(state.beta) 0
         sin(state.alpha)*cos(state.beta) -sin(state.alpha)*sin(state.beta) cos(state.alpha)];

    Lab=[cos(state.alpha)*cos(state.beta) sin(state.beta) sin(state.alpha)*cos(state.beta)
         -cos(state.alpha)*sin(state.beta) cos(state.beta) -sin(state.alpha)*sin(state.beta)
         -sin(state.alpha) 0 cos(state.alpha)];
end

if isfield(state,'theta')
    Lbg=[cos(state.theta)*cos(state.psi) cos(state.theta)*sin(state.psi) -sin(state.theta)
        sin(state.theta)*sin(state.phi)*cos(state.psi)-cos(state.phi)*sin(state.psi) sin(state.theta)*sin(state.phi)*sin(state.psi)+cos(state.phi)*cos(state.psi) sin(state.phi)*cos(state.theta)
        sin(state.theta)*cos(state.phi)*cos(state.psi)+sin(state.phi)*sin(state.psi) sin(state.theta)*cos(state.phi)*sin(state.psi)-sin(state.phi)*cos(state.psi) cos(state.phi)*cos(state.theta)];
    Lgb=Lbg';
end
 
switch input
     case 'db'        
         L=Ldb;
     case 'bd'
         L=Lbd;
     case 'ba'
        L=Lba;
     case 'ab'
        L=Lab;
     case 'ad'
         L=Lab*Lbd;
     case 'da'
         L=Ldb*Lba;
    case 'bg'
        L=Lbg;
    case 'gb'
        L=Lgb';
    case 'dg'
        L=Ldb*Lbg;
    case 'gd'
        L=Lgb*Lbd;
end
function optidihed
eigv=-0.587+2.364i;

parta=real(eigv);
partb=imag(eigv);
omega_nd=sqrt(parta^2+partb^2);%ÆµÂÊ
zeta_d=-parta/omega_nd;%×èÄá±È

disp AAA
disp (satisvalue(zeta_d,omega_nd))




end

function sv=satisvalue(zeta_d,omega_nd)
A=[0.08,0.15,0.4];
B=[zeta_d zeta_d*omega_nd omega_nd];
C1=B./A;
C2=(C1-.1./(C1.^20))+.1;
sv=mean(C2);



end
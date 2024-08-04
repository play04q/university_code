p0=2e6;
lmda=1060;
gama=(1.09e-3*lmda.^(-4.05))+(3.912/23*(lmda./550).^-1.3);
% figure(1); 
% plot(lmda,gama)
 a=exp(-gama.*25);
% figure(2);
% plot(gama,a)
g=min(gama);
p=p0*exp(-g*25);
disp('初始功率');disp(p0);
disp('最终功率');disp(p);
disp('衰减比值');disp(exp(-g*25));

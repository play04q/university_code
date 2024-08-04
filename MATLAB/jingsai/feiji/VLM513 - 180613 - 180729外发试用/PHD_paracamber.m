function c=PHD_paracamber(C,XC,alphaLE,alphaTE)
%       C  ������
%      XC  ���������ڵ�����λ��
% alphaLE  �ҳ�10%�����л�����x��н�
% alphaTE  ��Ե�㴦��������x��н�

%     bXC  �����ȴ��л�������

%       T  ��Ժ��
%      XT  ��������ڵ�����λ��
%  betaTE  ��Ե�н�
%    rho0  ǰԵ�뾶

alphaLE=deg2rad(alphaLE);
alphaTE=deg2rad(alphaTE);

syms x;
Pc=[C 0 tan(alphaLE) -tan(alphaTE)];

f0=[
    sin(pi*x^1)
    sin(pi*x^1.5)
    sin(pi*x^2)
    sin(pi*x^2.5)
    ];%�л��߱��ʽ

df0=[
    pi*cos(pi*x)
    pi*1.5*x^.5*cos(pi*x^1.5)
    pi*2*x*cos(pi*x^2)
    pi*2.5*x^1.5*cos(pi*x^2.5)
    ];%�л��߱��ʽһ�ε�

F=[subs(f0,x,XC) subs(df0,x,XC) subs(df0,x,0) subs(df0,x,1)];
F=double(F);


f=@(c,A)(c(1)*sin(pi*A.^1)+c(2)*sin(pi*A.^1.5)+c(3)*sin(pi*A.^2)+c(4)*sin(pi*A.^2.5));
c=Pc/F;

end
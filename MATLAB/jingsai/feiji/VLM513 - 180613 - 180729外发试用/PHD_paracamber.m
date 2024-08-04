function c=PHD_paracamber(C,XC,alphaLE,alphaTE)
%       C  相对弯度
%      XC  最大弯度所在的弦向位置
% alphaLE  弦长10%处的中弧线与x轴夹角
% alphaTE  后缘点处中心线与x轴夹角

%     bXC  最大弯度处中弧线曲率

%       T  相对厚度
%      XT  最大厚度所在的弦向位置
%  betaTE  后缘夹角
%    rho0  前缘半径

alphaLE=deg2rad(alphaLE);
alphaTE=deg2rad(alphaTE);

syms x;
Pc=[C 0 tan(alphaLE) -tan(alphaTE)];

f0=[
    sin(pi*x^1)
    sin(pi*x^1.5)
    sin(pi*x^2)
    sin(pi*x^2.5)
    ];%中弧线表达式

df0=[
    pi*cos(pi*x)
    pi*1.5*x^.5*cos(pi*x^1.5)
    pi*2*x*cos(pi*x^2)
    pi*2.5*x^1.5*cos(pi*x^2.5)
    ];%中弧线表达式一次导

F=[subs(f0,x,XC) subs(df0,x,XC) subs(df0,x,0) subs(df0,x,1)];
F=double(F);


f=@(c,A)(c(1)*sin(pi*A.^1)+c(2)*sin(pi*A.^1.5)+c(3)*sin(pi*A.^2)+c(4)*sin(pi*A.^2.5));
c=Pc/F;

end
%-6 -2 10    04M
%0   0   0    04
%3.1 -4.6 -9.9   04-F1
%-10 -1.5 10     04-F2



name={'04M    ';'04       ';'04-F1  ';'04-F2  '};

DR_product=[0.2189    0.0669    0.0465    0.0457
0.1890    0.0404    0.0173    0.0119
0.3025    0.1253    0.0990    0.0990
0.2249    0.0731    0.0530       NaN];

DR_s=[];
for i=1:4
    DR_s=[DR_s;score(score(DR_product(i,:),'DR_product'),'total')];
end

T1=name;
for i=1:4
    T1(i)={[cell2mat(name(i)) num2str(DR_s(i))]};
end

SPR_REL=[0.0888    0.0213    0.0087    0.0047
0.0846    0.0191    0.0077    0.0041
0.1323    0.0425    0.0194    0.0101
0.0862    0.0164   -0.0005    0.0487];

SPR_s=[];
for i=1:4
    SPR_s=[SPR_s;score(score(SPR_REL(i,:),'SPR_REL'),'total')];
end

T2=name;
for i=1:4
    T2(i)={[cell2mat(name(i)) num2str(SPR_s(i))]};
end

V=[20,34,48,62];

%LAT_s=(DR_s.*SPR_s).^.5-abs(DR_s-SPR_s);
%LAT_s=min(DR_s,SPR_s);
LAT_s=[];
for i=1:4
    LAT_s=[LAT_s;score([SPR_s(i) DR_s(i)],'total')];
end

T=name;
for i=1:4
    T(i)={[cell2mat(name(i)) num2str(LAT_s(i))]};
end

figure (9098)
clf
hold on
plot(V,DR_product(1,:),'r')
plot(V,DR_product(2,:),'g')
plot(V,DR_product(3,:),'b')
plot(V,DR_product(4,:),'k')

legend(T1)


figure (9099)
clf
hold on
plot(V,SPR_REL(1,:),'r')
plot(V,SPR_REL(2,:),'g')
plot(V,SPR_REL(3,:),'b')
plot(V,SPR_REL(4,:),'k')
legend(T2)
text(35,0,T)


% x=0.2125;
% y=0.0625;
% x1=0.05;
% y1=0;
% x2=0.175;
% y2=0.125;
% fac1ab=((x-x1)*(y-y2)-(x-x2)*(y-y1))/((x-x1)*(y-y2)-(x-x2)*(y-y1))^2
% A=[0.05,0,0];
% B=[0.175,0.125,0];
% C=[0.2125,0.0625,0];
% r1=C-A;
% r2=C-B;
% r0=B-A;
% Fac1ab=cross(r1,r2)/norm(cross(r1,r2))^2
% 
% fac2ab=((x2-x1)*(x-x1)+(y2-y1)*(y-y1))/sqrt((x-x1)^2+(y-y1)^2)   -  ((x2-x1)*(x-x2)+(y2-y1)*(y-y2))/sqrt((x-x2)^2+(y-y2)^2)
% Fac2ab=dot(r0,(r1/norm(r1)-r2/norm(r2)))
% 
% figure(1)
% x = -pi:pi/20:pi;
% plot(x,cos(x),'-ro',x,sin(x),'-.b')
% h = legend('cos_x','sin_x',2);
% set(h,'Interpreter','none')
%{
function m
A=[2;2;0];
B=[5;0;0];
C=[5;10;0];
rotatev(A,B,C,pi/2)
end

function [p1]=rotatev(p0,V0,V1,theta)
vector=(V1-V0)/norm(V1-V0);
ux=vector(1);
uy=vector(2);
uz=vector(3);
R=[cos(theta)+ux^2*(1-cos(theta)) ux*uy*(1-cos(theta))-uz*sin(theta) ux*uz*(1-cos(theta))+uy*sin(theta);...
    uy*ux*(1-cos(theta))+uz*sin(theta) cos(theta)+uy^2*(1-cos(theta)) uy*uz*(1-cos(theta))-ux*sin(theta);...
    uz*ux*(1-cos(theta))-uy*sin(theta) uz*uy*(1-cos(theta))+ux*sin(theta) cos(theta)+uz^2*(1-cos(theta))];
p1=V0+R*(p0-V0);
end
%}

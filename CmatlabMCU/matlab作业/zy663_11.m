clear;clf;clc;
x=0:0.05:7;
y1=sin(x);
y2=1.5*cos(x);
y3=sin(2*x);
y4=5*cos(2*x);
subplot(2,2,1);plot(x,y1);title('sinx');
subplot(2,2,2);plot(x,y2);title('1.5*cosx');
subplot(2,2,3);plot(x,y3);title('sin2x');
subplot(2,2,4);plot(x,y4);title('5*cos2x');
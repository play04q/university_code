addpath("img\");
%% 
x=0:0.1:3*pi;
y1=sin(x);
y2=cos(x);
figure;
subplot(1,2,1);
plot(x,y1);
ylabel('sin(x)');
subplot(1,2,2);
plot(x,y2);
ylabel('cos(x)');
axis([0,2*pi,-2,2])
%% 
x=-2.9:0.2:2.9;
figure;
bar(x,exp(-x.*x),'red');

%%  2
x=0:0.02:2*pi;
y1=exp(x)/100;
y2=sin(x+2);
plot(x,y1,'r','LineWidth',3);
hold on
plot(x,y2,'--','Color','blue');

%%  3爱心
clear; clc; close all; 
f = @(x, y, z)(x.^2 + 2.25*y.^2 + z.^2 - 1).^3 -  ...
    x.^2.* z.^3 - 0.1125*y.^2.*z.^3;
g = @(x, y, z)(sqrt(x.^2+y.^2)-2.5).^2 + z.^2 - 0.4^2;
t = linspace(-5, 5);
[x1, y1, z1] = meshgrid(t);
[x2, y2, z2] = meshgrid(t);
val1 = f(x1, y1, z1);
val2 = g(x2, y2, z2);
[p1, v1] = isosurface(x1, y1, z1, val1, 0);
[p2, v2] = isosurface(x2, y2, z2, val2, 0);
figure()
subplot(1, 1, 1)
h = patch('faces',p1,'vertices',v1,'facevertexcdata',jet(size(v1,1)),...
    'facecolor','w','edgecolor','flat'); hold on;
patch('faces',p2,'vertices',v2,'facevertexcdata',jet(size(v2,1)),...
    'facecolor','w','edgecolor','flat');
grid on; axis equal; axis([-3,3,-3,3,-1.5,1.5]); view(3)
title("520");
warning('off');
T = suptitle("$I\ Love\ U\ !$"); 
set(T,'Interpreter','latex','FontSize',24)
pic_num = 1;
for i = 1:20
    v1 = 0.98 * v1;
    set(h, 'vertices', v1); drawnow;
    F = getframe(gcf);
    I = frame2im(F);
    [I,map]=rgb2ind(I,256);
    if pic_num == 1
        imwrite(I,map,'BeatingHeart.gif','gif','Loopcount',inf,'DelayTime',0.05);
    else
        imwrite(I,map,'BeatingHeart.gif','gif','WriteMode','append','DelayTime',0.05);
    end
    pic_num = pic_num + 1;
end
for i = 1:20
    v1 = v1 / 0.98;
    set(h, 'vertices', v1); drawnow;
    F = getframe(gcf);
    I = frame2im(F);
    [I,map] = rgb2ind(I,256);
    imwrite(I,map,'BeatingHeart.gif','gif','WriteMode','append','DelayTime',0.05);
    pic_num = pic_num + 1;
end

%%  4读图像
img=imread("10001.png");
imshow(img);

%%  面积
Y=[1 5 3;3 2 7;1 5 3;2 6 1];
area(Y);
grid on
colormap summer
set(gca,'Layer','top');
title('Stacked Area Plot');

%%  等高线图
t=-10:0.05:10;
[x,y]=meshgrid(t);
a=2;b=1;
z1=x.^2./a^2+y.^2./b^2;
figure;
meshc(x,y,z1);

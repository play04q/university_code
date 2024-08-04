figure(111)
x = linspace(0,3*pi);
y1 = sin(x);
p1 = plot(x,y1);

hold on
y2 = sin(x - pi/4);
p2 = plot(x,y2);

y3 = sin(x - pi/2);
p3 = plot(x,y3);
hold off

legend([p1 p3],'First','Third')
x=0:0.01:4*pi;
y=sin(x);
h=findobj('tag','togglebutton1');
n=get(h,'value');
if n==1
    m=plot(x,y);
    set(h,'string','清楚图形')
else
    delete(m) 
    set(h,'string','绘制图形')
end]
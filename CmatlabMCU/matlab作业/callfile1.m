x=0.01:0.01:20;
switch h
    case 1
        y=sin(x);
    case 2
        y=cos(x);
    case 3
        y=tan(x);
    case 4
        y=cot(x);
end
f=plot(x,y)
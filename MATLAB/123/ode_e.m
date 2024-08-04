function sx=ode_e(t,x)
sx(1,1)=-10*x(1)-35*x(2)-50*x(3)-24*x(4)+1;
sx(2,1)=x(1);
sx(3,1)=x(2);
sx(4,1)=x(3);
end
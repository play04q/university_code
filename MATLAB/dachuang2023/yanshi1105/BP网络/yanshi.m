load('yanshishuju.mat');
P_y=zeros(12,1);
for i=1:12
    P_y(i,1)=sim(results.Network,P_x(i,:)');
end
P_y=round(P_y);
disp(P_y);
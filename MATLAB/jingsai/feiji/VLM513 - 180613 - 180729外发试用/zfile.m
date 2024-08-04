clear
settings=config('startup')
cd(settings.odir)
load q1-Cx
cd(settings.hdir)


[a vor_length void]=size(lattice.VORTEX);%extracting number of sections in 
										   %"horseshoes"
b1=vor_length/2;

p1(:,:)=lattice.VORTEX(:,b1,:);		%Calculating panel vortex midpoint	
p2(:,:)=lattice.VORTEX(:,b1+1,:);	%to use as a force locus
midp(:,:)=(p1+p2)./2;	            % LOCAL vortex midpoint.



%(geo.nx+geo.fnx)*geo.ny*(geo.symetric+1)


P=lattice.XYZ;
j=1;
k=0;
for a=1:geo.nwing

    for b=1:geo.nelem(a)
 
        sftem=geo.ny(a,b).*(geo.symetric(a)+1);    %strips for this partition 
        for c=1:(sftem)
            k=k+1;           %Strip number
            
            panels=geo.nx(a,b)+geo.fnx(a,b);
            
            s1=(P(j,1,:)+P(j,2,:))/2;   %midchord leading edge
            s2=(P(j+panels-1,3,:)+P(j+panels-1,4,:))/2;  %midchord trailing edge
            
            plot3(s1(1),s1(2),s1(3),'rd')
            plot3(s2(1),s2(2),s2(3),'rd')
            
            C=s2-s1;         %Chord vector
            
            lc(k)=sqrt(sum(C.^2));
            
            C2=C.*0.25;      %Quarter chord point
            
            C4(k,:)=s1+C2;
            
            plot3(C4(k,1),C4(k,2),C4(k,3),'ok')
            hold on
            
            
            j=j+(geo.nx(a,b)+geo.fnx(a,b))  ;         
            
        end
    end
end

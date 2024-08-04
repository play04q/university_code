function MESH=pre_Deflect(PROC)
MESH=PROC.MESH;
HINGE=PROC.HINGE;

geo=PROC.geo;
Is_need_deflect=0;
for s=1:length(geo)
    Is_need_deflect=Is_need_deflect || any(any(geo(s).deflect~=0));
end
if Is_need_deflect==0
    return
end

nP0=length(MESH.P0);
nELEM=length(MESH.ELEM);
nC=length(MESH.C);

for i=1:nP0
    A=MESH.P0(i).Relation;
    if all(A~=0)
        WingID=A(1);
        SEGID=A(2);
        SIDE=A(3);
        if geo(WingID).deflect(SEGID,SIDE)~=0 
            P0=MESH.P0(i).xyz;
            if SIDE==1
                V0=squeeze(HINGE{WingID}(SEGID,1,:));
                V1=squeeze(HINGE{WingID}(SEGID,2,:));
                theta=geo(WingID).deflect(SEGID,SIDE);
            else  %SIDE=2
                V0=squeeze(HINGE{WingID}(SEGID,1,:));
                V1=squeeze(HINGE{WingID}(SEGID,2,:));
                V0(2)=-V0(2);
                V1(2)=-V1(2);
                theta=-geo(WingID).deflect(SEGID,SIDE);
            end
            MESH.P0(i).xyz=(rotatev(P0',V0,V1,theta))';
        end
    end
end

for i=1:nELEM
    A=MESH.ELEM(i).Relation;
    if all(A~=0)
        WingID=A(1);
        SEGID=A(2);
        SIDE=A(3);
        if geo(WingID).deflect(SEGID,SIDE)~=0 
            for j=1:4
                P0=MESH.ELEM(i).xyz(j,:);
                if SIDE==1
                    V0=squeeze(HINGE{WingID}(SEGID,1,:));
                    V1=squeeze(HINGE{WingID}(SEGID,2,:));
                    theta=geo(WingID).deflect(SEGID,SIDE);
                else  %SIDE=2
                    V0=squeeze(HINGE{WingID}(SEGID,1,:));
                    V1=squeeze(HINGE{WingID}(SEGID,2,:));
                    V0(2)=-V0(2);
                    V1(2)=-V1(2);
                    theta=-geo(WingID).deflect(SEGID,SIDE);
                end
                MESH.ELEM(i).xyz(j,:)=rotatev(P0',V0,V1,theta);
            end
        end
    end
end

for i=1:nC
    A=MESH.C(i).Relation;
    if all(A~=0)
        WingID=A(1);
        SEGID=A(2);
        SIDE=A(3);
        if geo(WingID).deflect(SEGID,SIDE)~=0 
            P0=MESH.C(i).xyz;
            P1=MESH.C(i).xyz+MESH.C(i).N;
            if SIDE==1
                V0=squeeze(HINGE{WingID}(SEGID,1,:));
                V1=squeeze(HINGE{WingID}(SEGID,2,:));
                theta=geo(WingID).deflect(SEGID,SIDE);
            else  %SIDE=2
                V0=squeeze(HINGE{WingID}(SEGID,1,:));
                V1=squeeze(HINGE{WingID}(SEGID,2,:));
                V0(2)=-V0(2);
                V1(2)=-V1(2);
                theta=-geo(WingID).deflect(SEGID,SIDE);
            end
            P0x=(rotatev(P0',V0,V1,theta))';
            P1x=(rotatev(P1',V0,V1,theta))';
            MESH.C(i).xyz=P0x;
            MESH.C(i).N=P1x-P0x;
        end
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




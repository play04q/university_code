function [ref]=pre_REFgeo(PROC)
%求解平均气动弦长及其位置、以及平均几何弦长，从只求第一个修改为所有机翼
geo=PROC.geo;
ref=PROC.ref;

Node=PROC.NODE;


nwing=length(Node);
for s=1:nwing
    N=Node{s};  %提取当前翼面的所有网格节点
    [nSEC,~,~]=size(N);
    
    for t=1:nSEC-1
        %Chord loop, generating chords for wing sections.
        %And startingpoints for partition-quads
        %前缘点
        LEx0=N(t,1,1);	 %#ok<*AGROW> %Element apex calculation
        LEy0=N(t,1,2);	 % Same-o
        LEz0=N(t,1,3);  % Same-o
        TEx0=N(t,end,1);
        TEy0=N(t,end,2);
        TEz0=N(t,end,3);
        
        LEx1=N(t+1,1,1);
        LEy1=N(t+1,1,2);
        LEz1=N(t+1,1,3);
        TEx1=N(t+1,end,1);
        TEy1=N(t+1,end,2);
        TEz1=N(t+1,end,3);
        
        C0=TEx0-LEx0;%当前段弦长
        C1=TEx1-LEx1;%下段弦长
        if geo(s).wingtype==2  %判断是垂尾模式还是一般
            b(s,t)=((LEz1-LEz0)^2+(LEy1-LEy0)^2)^.5;
        else
            b(s,t)=LEy1-LEy0; %当前段展长
        end
        %以下五式用于求平均气动弦弦长及位置信息
        S(s,t)=(C0+C1)*b(s,t)/2;      %翼段面积 
        if geo(s).wingtype==2  %垂尾的平均气动弦长计算可能有误，管他呢，反正一般也不用
            Cmac(s,t)=1/3*(C0^2 + C0*C1 + C1^2)*((LEy0 - TEy1)^2+(LEz0 - TEz1)^2)^.5;
        else
            Cmac(s,t)=-1/3*(C0^2 + C0*C1 + C1^2)*(LEy0 - TEy1);
        end
        mac_posX(s,t)=-1/6*(LEy0 - TEy1)*(C0*(2*LEx0+TEx1)+C1*(LEx0+2*TEx1));
        mac_posY(s,t)=-1/6*(LEy0 - TEy1)*(C0*(2*LEy0+TEy1)+C1*(LEy0+2*TEy1));
        mac_posZ(s,t)=-1/6*(LEy0 - TEy1)*(C0*(2*LEz0+TEz1)+C1*(LEz0+2*TEz1));
        Cmgc(s,t)=S(s,t)/b(s,t);

        if geo(s).symetric==1
            S(s,t)=S(s,t)*2; 
            Cmac(s,t)=Cmac(s,t)*2; 
            mac_posX(s,t)=mac_posX(s,t)*2; 
            mac_posY(s,t)=0; 
            mac_posZ(s,t)=mac_posZ(s,t)*2; 
        end
    end  %%for t=1:geo(s).nelem(s)+1
    ref.b_ref(s)=sum(b(s,:))*(geo(s).symetric+1);
end    

ref.S_ref=sum(S,2);
ref.R_asp=ref.b_ref.^2./ref.S_ref';  %展弦比
ref.C_mgc=sum(Cmgc.*S,2)./ref.S_ref;		%参考平均几何弦长
ref.C_mac=sum(Cmac,2)./ref.S_ref;     %参考平均气动弦长
ref.mac_pos=[sum(mac_posX,2)./ref.S_ref sum(mac_posY,2)./ref.S_ref sum(mac_posZ,2)./ref.S_ref];   %平均气动弦长位置

for i=1:nwing
    if geo(i).ismain==1
        ref.b_ref_M=ref.b_ref(i);
        ref.S_ref_M=ref.S_ref(i);
        ref.R_asp_M=ref.R_asp(i);       %展弦比
        ref.C_mgc_M=ref.C_mgc(i);		%参考平均几何弦长
        ref.C_mac_M=ref.C_mac(i);       %参考平均气动弦长
        ref.mac_pos_M=ref.mac_pos(i,:);   %平均气动弦长位置
        break
    end
end



end




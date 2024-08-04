function [ref]=pre_REFgeo(PROC)
%���ƽ�������ҳ�����λ�á��Լ�ƽ�������ҳ�����ֻ���һ���޸�Ϊ���л���
geo=PROC.geo;
ref=PROC.ref;

Node=PROC.NODE;


nwing=length(Node);
for s=1:nwing
    N=Node{s};  %��ȡ��ǰ�������������ڵ�
    [nSEC,~,~]=size(N);
    
    for t=1:nSEC-1
        %Chord loop, generating chords for wing sections.
        %And startingpoints for partition-quads
        %ǰԵ��
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
        
        C0=TEx0-LEx0;%��ǰ���ҳ�
        C1=TEx1-LEx1;%�¶��ҳ�
        if geo(s).wingtype==2  %�ж��Ǵ�βģʽ����һ��
            b(s,t)=((LEz1-LEz0)^2+(LEy1-LEy0)^2)^.5;
        else
            b(s,t)=LEy1-LEy0; %��ǰ��չ��
        end
        %������ʽ������ƽ���������ҳ���λ����Ϣ
        S(s,t)=(C0+C1)*b(s,t)/2;      %������ 
        if geo(s).wingtype==2  %��β��ƽ�������ҳ�����������󣬹����أ�����һ��Ҳ����
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
ref.R_asp=ref.b_ref.^2./ref.S_ref';  %չ�ұ�
ref.C_mgc=sum(Cmgc.*S,2)./ref.S_ref;		%�ο�ƽ�������ҳ�
ref.C_mac=sum(Cmac,2)./ref.S_ref;     %�ο�ƽ�������ҳ�
ref.mac_pos=[sum(mac_posX,2)./ref.S_ref sum(mac_posY,2)./ref.S_ref sum(mac_posZ,2)./ref.S_ref];   %ƽ�������ҳ�λ��

for i=1:nwing
    if geo(i).ismain==1
        ref.b_ref_M=ref.b_ref(i);
        ref.S_ref_M=ref.S_ref(i);
        ref.R_asp_M=ref.R_asp(i);       %չ�ұ�
        ref.C_mgc_M=ref.C_mgc(i);		%�ο�ƽ�������ҳ�
        ref.C_mac_M=ref.C_mac(i);       %�ο�ƽ�������ҳ�
        ref.mac_pos_M=ref.mac_pos(i,:);   %ƽ�������ҳ�λ��
        break
    end
end



end




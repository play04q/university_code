clear all
Meig(1,:,:)=[-6.0443 0.0691-0.1398i 0.0691+0.1398i -0.3256
-6.0980   -0.3411    0.0462    0.1611
 -6.1380   -0.2813    0.0110    0.1763
-6.1646            -0.0298-0.1214i  -0.0298+0.1214i  -0.0084
 -6.1781            -0.0293 - 0.3695i  -0.0293 + 0.3695i   0.0033          
 -6.1788            -0.0325 - 0.5590i  -0.0325 + 0.5590i   0.0094          
 -6.1669            -0.0426 - 0.7376i  -0.0426 + 0.7376i   0.0166          
 -6.1426            -0.0596 - 0.9127i  -0.0596 + 0.9127i   0.0246          
 -6.1059            -0.0831 - 1.0870i  -0.0831 + 1.0870i   0.0332          
 -6.0571            -0.1129 - 1.2618i  -0.1129 + 1.2618i   0.0420          
 -5.9962            -0.1491 - 1.4382i  -0.1491 + 1.4382i   0.0511          
 -5.9234            -0.1914 - 1.6168i  -0.1914 + 1.6168i   0.0603          
 -5.8388            -0.2397 - 1.7983i  -0.2397 + 1.7983i   0.0697          
 -5.7428            -0.2939 - 1.9834i  -0.2939 + 1.9834i   0.0790          
 -5.6358            -0.3537 - 2.1728i  -0.3537 + 2.1728i   0.0884          
 -5.5184            -0.4188 - 2.3672i  -0.4188 + 2.3672i   0.0977];
disp (squeeze(Meig))

i=1;
nA=16;    
% 从后往前，找到第一个标准的2个实根，2个虚根的状态
for j=nA:-1:1
    im=size(find(imag(Meig(i,j,:))~=0),1);
    re=size(find(imag(Meig(i,j,:))==0),1);
    if im==2 && re==2
        TMPT=j;
        break
    end
end

if TMPT>1
    for j=TMPT:-1:1
        im=size(find(imag(Meig(i,j,:))~=0),1);
        re=size(find(imag(Meig(i,j,:))==0),1);
        
        if im==2 && re==2   %当有两个实根、两个虚根时的排序
            %滚转收敛模态
            RSidx=[];
            DRidx=[];
            for k=1:4
                if imag(Meig(i,j,k))==0 
                    RSidx=[RSidx k];
                else
                    DRidx=[DRidx k];
                end
            end
            if abs(Meig(i,j,RSidx(1)))>abs(Meig(i,j,RSidx(2)))
                idx(1)=RSidx(1);
                idx(4)=RSidx(2);
            else
                idx(1)=RSidx(2);
                idx(4)=RSidx(1);
            end
            if imag(Meig(i,j,DRidx(1)))>0
                idx(2)=DRidx(1);
                idx(3)=DRidx(2);
            else
                idx(2)=DRidx(2);
                idx(3)=DRidx(1);
            end
            
            Meig(i,j,:)=Meig(i,j,idx);
        end
        
        if re==4
            C1=squeeze((Meig(i,j+1,1)+Meig(i,j+1,4))/2);%滚转收敛和螺旋模态
            C2=squeeze((Meig(i,j+1,2)+Meig(i,j+1,3))/2);%荷兰滚模态
            %先找到滚转收敛模态的根
            dis=squeeze(abs(Meig(i,j+1,1)-Meig(i,j,:)));
            [~,idx(1)]=min(dis);
            
            %找到螺旋模态的根
            dis=abs(C1-squeeze((Meig(i,j,1)+Meig(i,j,2:4))/2));
            [~,Tmp]=min(dis);
            idx(4)=Tmp+1;
            
            %剩下的是荷兰滚模态
            DRidx=[];
            for k=1:4
                if k~=idx(1) && k~=idx(4)
                    DRidx=[DRidx k];
                end
            end
            if Meig(i,j,DRidx(1))>Meig(i,j,DRidx(2))
                idx(2)=DRidx(1);
                idx(3)=DRidx(2);
            else
                idx(2)=DRidx(2);
                idx(3)=DRidx(1);
            end
            Meig(i,j,:)=Meig(i,j,idx);
        end
        [~,x]=size(unique(idx));
        
        if x~=4
            disp error
            keyboard
        end
        
    end
end


if TMPT<nA
    
    for j=TMPT+1:nA
        im=size(find(imag(Meig(i,j,:))~=0),1);
        re=size(find(imag(Meig(i,j,:))==0),1);
        
        if im==2 && re==2   %当有两个实根、两个虚根时的排序
            %滚转收敛模态
            RSidx=[];
            DRidx=[];
            for k=1:4
                if imag(Meig(i,j,k))==0 
                    RSidx=[RSidx k];
                else
                    DRidx=[DRidx k];
                end
            end
            if abs(Meig(i,j,RSidx(1)))>abs(Meig(i,j,RSidx(2)))
                idx(1)=RSidx(1);
                idx(4)=RSidx(2);
            else
                idx(1)=RSidx(2);
                idx(4)=RSidx(1);
            end
            if imag(Meig(i,j,DRidx(1)))>0
                idx(2)=DRidx(1);
                idx(3)=DRidx(2);
            else
                idx(2)=DRidx(2);
                idx(3)=DRidx(1);
            end
            
            Meig(i,j,:)=Meig(i,j,idx);
        end
        
        if re==4
            C1=squeeze((Meig(i,j-1,1)+Meig(i,j-1,4))/2);%滚转收敛和螺旋模态
            C2=squeeze((Meig(i,j-1,2)+Meig(i,j-1,3))/2);%荷兰滚模态
            %先找到滚转收敛模态的根
            dis=squeeze(abs(Meig(i,j-1,1)-Meig(i,j,:)));
            [~,idx(1)]=min(dis);
            
            %找到螺旋模态的根
            dis=abs(C1-squeeze((Meig(i,j,1)+Meig(i,j,2:4))/2));
            [~,Tmp]=min(dis);
            idx(4)=Tmp+1;
            
            %剩下的是荷兰滚模态
            DRidx=[];
            for k=1:4
                if k~=idx(1) && k~=idx(4)
                    DRidx=[DRidx k];
                end
            end
            if Meig(i,j,DRidx(1))>Meig(i,j,DRidx(2))
                idx(2)=DRidx(1);
                idx(3)=DRidx(2);
            else
                idx(2)=DRidx(2);
                idx(3)=DRidx(1);
            end
            Meig(i,j,:)=Meig(i,j,idx);
        end
        [~,x]=size(unique(idx));
        
        if x~=4
            disp error
            keyboard
        end
        
    end

end
    

disp(squeeze(Meig))
%{
for k1=1:4
        for k2=k1+1:4
            if real(Meig(i,j,k2)) < real(Meig(i,j,k1))
                T=eigvalue(k1);
                eigvalue(k1)=eigvalue(k2);
                eigvalue(k2)=T;
            end
                
                if real(eigvalue(k2)) == real(eigvalue(k1)) && imag(eigvalue(k2)) < imag(eigvalue(k1))
                    T=eigvalue(k1);
                    eigvalue(k1)=eigvalue(k2);
                    eigvalue(k2)=T;
                end
            end
    end
%}
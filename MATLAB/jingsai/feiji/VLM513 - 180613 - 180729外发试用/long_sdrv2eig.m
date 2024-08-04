function M_EIG=long_sdrv2eig(geo,state,ref,inertias,M_SDRV)
% MEig[�ٶ�ID,ӭ��ID,ģ̬ID]
nV=length(state.AS0);
nA=length(M_SDRV);
M_EIG=zeros(nV,nA,4);

for i=1:nV
    state.AS=state.AS0(i);
    [zeroliftdrag,~]=zeroliftdragpred(state,geo,ref);

    for j=1:nA
        state.alpha=M_SDRV(j).alpha;
        M_SDRV(j).CD=M_SDRV(j).CDi+zeroliftdrag.CD0;
        
        [eigvalue]=long_eig(M_SDRV(j),state,ref,inertias);
        M_EIG(i,j,:)=eigvalue;
    end
    
    %����������
    % �Ӻ���ǰ���ҵ���һ����׼�����Թ��������״̬
    TMPT=[];
    for j=nA:-1:1
        im=size(find(imag(M_EIG(i,j,:))~=0),1);
        if im==4 
            TMPT=j;
            break
        end
    end
    
    if isempty(TMPT)
        disp ('ע�⣺��������ģ̬�����У���û�г��ֱ�׼��<�����ڡ�������>ģ̬')
    else

        if TMPT>=1
            for j=TMPT:-1:1
                im=size(find(imag(M_EIG(i,j,:))~=0),1);
                if im==4   %�������Թ����ʱ������
                    for k1=1:4
                        for k2=k1:4
                            if abs(real(M_EIG(i,j,k2)))>abs(real(M_EIG(i,j,k1)))
                                tmp=M_EIG(i,j,k1);
                                M_EIG(i,j,k1)=M_EIG(i,j,k2);
                                M_EIG(i,j,k2)=tmp;
                            elseif real(M_EIG(i,j,k2))==real(M_EIG(i,j,k1))
                                if imag(M_EIG(i,j,k2))>0
                                    tmp=M_EIG(i,j,k1);
                                    M_EIG(i,j,k1)=M_EIG(i,j,k2);
                                    M_EIG(i,j,k2)=tmp;
                                end
                            end
                        end
                    end
                else
                    %���Ҷ�����ģ̬�ĸ�
                    dis1=squeeze(abs(M_EIG(i,j+1,1)-M_EIG(i,j,:)));
                    dis2=squeeze(abs(M_EIG(i,j+1,2)-M_EIG(i,j,:)));
                    [~,idx(1)]=min(dis1);
                    [~,idx(2)]=min(dis2);
                    if idx(1)==idx(2)
                        dis2(idx(1))=inf;
                        [~,idx(2)]=min(dis2);
                    end
                    if real(M_EIG(i,j,idx(2)))>real(M_EIG(i,j,idx(1)))
                        tmp=idx(1);
                        idx(1)=idx(2);
                        idx(2)=tmp;
                    elseif real(M_EIG(i,j,idx(2)))==real(M_EIG(i,j,idx(1)))
                        if imag(M_EIG(i,j,idx(2)))>imag(M_EIG(i,j,idx(1)))
                            tmp=idx(1);
                            idx(1)=idx(2);
                            idx(2)=tmp;
                        end
                    end
                    
                    %�ҳ���������ģ̬�ĸ�
                    dis1([idx(1) idx(2)])=inf;
                    [~,idx(3)]=min(dis1);
                    dis1([idx(3)])=inf;
                    [~,idx(4)]=min(dis1);
                    if real(M_EIG(i,j,idx(4)))>real(M_EIG(i,j,idx(3)))
                        tmp=idx(3);
                        idx(3)=idx(4);
                        idx(4)=tmp;
                    elseif real(M_EIG(i,j,idx(4)))==real(M_EIG(i,j,idx(3)))
                        if imag(M_EIG(i,j,idx(4)))>imag(M_EIG(i,j,idx(3)))
                            tmp=idx(3);
                            idx(3)=idx(4);
                            idx(4)=tmp;
                        end
                    end
                    M_EIG(i,j,:)=M_EIG(i,j,idx);
                end
            end
        end

        if TMPT<nA
            for j=TMPT+1:nA
                im=size(find(imag(M_EIG(i,j,:))~=0),1);
                if im==4   %�������Թ����ʱ������
                    for k1=1:4
                        for k2=k1:4
                            if abs(real(M_EIG(i,j,k2)))>abs(real(M_EIG(i,j,k1)))
                                tmp=M_EIG(i,j,k1);
                                M_EIG(i,j,k1)=M_EIG(i,j,k2);
                                M_EIG(i,j,k2)=tmp;
                            elseif real(M_EIG(i,j,k2))==real(M_EIG(i,j,k1))
                                if imag(M_EIG(i,j,k2))>0
                                    tmp=M_EIG(i,j,k1);
                                    M_EIG(i,j,k1)=M_EIG(i,j,k2);
                                    M_EIG(i,j,k2)=tmp;
                                end
                            end
                        end
                    end
                else
                    %���Ҷ�����ģ̬�ĸ�
                    dis1=squeeze(abs(M_EIG(i,j+1,1)-M_EIG(i,j,:)));
                    dis2=squeeze(abs(M_EIG(i,j+1,2)-M_EIG(i,j,:)));
                    [~,idx(1)]=min(dis1);
                    [~,idx(2)]=min(dis2);
                    if idx(1)==idx(2)
                        dis2(idx(1))=inf;
                        [~,idx(2)]=min(dis2);
                    end
                    if real(M_EIG(i,j,idx(2)))>real(M_EIG(i,j,idx(1)))
                        tmp=idx(1);
                        idx(1)=idx(2);
                        idx(2)=tmp;
                    elseif real(M_EIG(i,j,idx(2)))==real(M_EIG(i,j,idx(1)))
                        if imag(M_EIG(i,j,idx(2)))>imag(M_EIG(i,j,idx(1)))
                            tmp=idx(1);
                            idx(1)=idx(2);
                            idx(2)=tmp;
                        end
                    end
                    
                    %�ҳ���������ģ̬�ĸ�
                    dis1([idx(1) idx(2)])=inf;
                    [~,idx(3)]=min(dis1);
                    dis1([idx(3)])=inf;
                    [~,idx(4)]=min(dis1);
                    if real(M_EIG(i,j,idx(4)))>real(M_EIG(i,j,idx(3)))
                        tmp=idx(3);
                        idx(3)=idx(4);
                        idx(4)=tmp;
                    elseif real(M_EIG(i,j,idx(4)))==real(M_EIG(i,j,idx(3)))
                        if imag(M_EIG(i,j,idx(4)))>imag(M_EIG(i,j,idx(3)))
                            tmp=idx(3);
                            idx(3)=idx(4);
                            idx(4)=tmp;
                        end
                    end
                    M_EIG(i,j,:)=M_EIG(i,j,idx);
                end
            end
        end
    end
end
end
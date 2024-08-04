function[]=postproc(lattice,geo,ref);
settings=config('startup');
loop1=1;
while loop1==1;
    disp(' ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp('"                                                    ')
    disp('"  ���˵�                                            ')
    disp('"      |---->ͼ����ʾ������       ')
    disp('"                                                    ')
    disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""')
    disp(' ')
    disp(' [1].  �������ͼ������')
    disp(' ')
    disp(' [2].  ͼ����ʾ��ǰ�������ζ���')
    disp(' [3].  ������������������')   
    disp(' [4].  �غɷֲ�ͼ������������')
    disp(' ')
    disp(' [5].  ���������ߣ�ӭ�Ǳ仯���� ')
    disp(' [6].  Solution plot, Beta sweep')
    disp(' [7].  Solution plot, Delta sweep')
    disp(' [8].  Solution plot, Roll rate sweep')
    disp(' [9].  Solution plot, Pitch rate sweep')
    disp(' [10]. Solution plot, Yaw rate sweep')
    disp(' ')
    disp(' [11]. Perform a trefftz plane analysis, (experimental).') 
    disp(' [12]. ��������������������')
    disp(' [13]. Plot derivative definitions,')
    disp(' ')
    disp(' [14]. ������������������Ϊ�ı��ļ�.')
    disp(' [15]. ��ӭ�Ǳ仯����������Ϊ�ı��ļ�.')
    disp(' ')
    disp(' [0].  ����')
    disp(' ')

    quest=input('	��ѡ��ִ����Ŀ����: ');
    if isempty(quest)
        return
    end

    switch(quest)
        case 1
           close all

        case 2
            if geo.inst==0          %avoid crash if geometry is empty
                terror1(41)
            else
                geometryplot(lattice,geo,ref);
            end

        case 3
           resultplot(1);

        case 4
           resultplot(2);

        case 5
           resultplot(3);

        case 6
           resultplot(4);

        case 7
           resultplot(5);

        case 8
           resultplot(6);

        case 9
           resultplot(7);

        case 10
           resultplot(8);

        case 11
            resultplot(9)

        case 12
            resultplot(10)
        case 13
             definitions;

        case 14
            cd(settings.odir)
            dir
            cd(settings.hdir)
            disp(' ');
            
            JID=input('��ѡ����Ҫ�����ļ������浵�ļ�(JID): ','s');
            if isempty(JID)
                JID=('trial');            
                disp(' ')
                disp(' ��ȡĬ�ϼ������浵�ļ���"trial" ');
                disp(' ')
            end
            fname=input('������Ŀ���ı��ļ���: ','s');
            simpexport(JID,fname);
        
        case 15
            cd(settings.odir)
            dir
            cd(settings.hdir)
            disp(' ');
            
            quest=1;
            JID=input('��ѡ����Ҫ�����ļ������浵�ļ�(JID): ','s');
            if isempty(JID)
                JID=('trial');            
                disp(' ')
                disp(' ��ȡĬ�ϼ������浵�ļ���"trial" ');
                disp(' ')
            end
            fname=input('������Ŀ���ı��ļ���: ','s');
            swpexport(JID,fname,quest);

    case 0
        loop1=0;

    otherwise
        terror1(11)   
    end %% switch
end  %%while loop1=1
    
   



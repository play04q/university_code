function [DYN_LAT]=lat_chr(FILE,cmdline)
% cmdline����
% n-����Ҫ����߶ȡ��ٶȺ�ӭ����Ϣ
% i-ʹ�ò�ֵ��ʽ���
% r-ʹ�����¼��㷽ʽ���
% s-����ʾ8785�ο�����

if nargin<2
    cmdline='';
end

cmdline=lower(cmdline);
if ~contains(cmdline,'n')
    allstate=main_allstate('ash');
    
    disp ('--------------------------->')
    disp (['��ǰ���߶�Ϊ�� ' num2str(allstate.ALT) ' m'])
    disp (['    ����ٶ�Ϊ�� ' num2str(allstate.AS) ' m/s' ])
    disp (['    ���ӭ��Ϊ�� ' num2str(rad2deg(allstate.alpha)) 'Deg'])
    disp ('---------------------------------------------------------->')
    disp (' ')
else
    allstate=FILE.allstate;
end



%% �������м������Ƿ����Ŀ��ӭ��
%  ���ò���/����ĳһ������ӭ���µĵ�����Ϣ��ԭFILE���и�д
interp_need=1;   % 1-��Ҫ�ڲ�  0-��ֱ�Ӽ�����
if isfield(FILE,'M_SDRV')
    M_SDRV=FILE.M_SDRV;
    [nA,~]=size(M_SDRV.state);
    for i=1:nA
        if abs(allstate.alpha-M_SDRV.state(i,1).alpha)<deg2rad(0.01)
            interp_need=0;
            idx=i;
            break
        end
    end
end
if interp_need==0
    PROC.M_SDRV=M_SDRV.state(idx,1).DRVs;
    PROC.M_SDRV.CD=M_SDRV.state(idx,1).STC.CD;
else  %��Ҫ��ֵ�����������
    if contains(cmdline,'i') 
        tline='i';
    elseif contains(cmdline,'r')
        tline='r';
    else
        tline=input('�������������ļ���������ǰ����ӭ�ǣ���ȷ������������ȡ������[(I)nterpolation or (R)ecauculate <Ĭ��ΪI>]','s');
        if isempty(tline)
            tline='i';
        end
    end
    
    if strcmpi(tline(1),'i') 
        for i=1:4   %�����±�
            switch i
                case 1
                    T1='STC.';T2='';
                case 2
                    T1='DRVs.';T2='_beta';
                case 3
                    T1='DRVs.';T2='_P';
                case 4
                    T1='DRVs.';T2='_R';
            end

            for j=nA:-1:1
                if i==1 
                    XX(j)=M_SDRV.state(j,1).alpha; %#ok<NASGU>
                end

                eval(['CL(j)=M_SDRV.state(j,1).' T1 'CL' T2 ';'])
                eval(['CD(j)=M_SDRV.state(j,1).' T1 'CD' T2 ';'])
                eval(['CC(j)=M_SDRV.state(j,1).' T1 'CC' T2 ';'])
                eval(['Clm(j)=M_SDRV.state(j,1).' T1 'Clm' T2 ';'])
                eval(['Cmm(j)=M_SDRV.state(j,1).' T1 'Cmm' T2 ';'])
                eval(['Cnm(j)=M_SDRV.state(j,1).' T1 'Cnm' T2 ';'])
            end
            eval(['SDRV.CL' T2 '=interp1(XX,CL,allstate.alpha);'])    
            eval(['SDRV.CD' T2 '=interp1(XX,CD,allstate.alpha);'])    
            eval(['SDRV.CC' T2 '=interp1(XX,CC,allstate.alpha);'])    
            eval(['SDRV.Clm' T2 '=interp1(XX,Clm,allstate.alpha);'])    
            eval(['SDRV.Cmm' T2 '=interp1(XX,Cmm,allstate.alpha);'])    
            eval(['SDRV.Cnm' T2 '=interp1(XX,Cnm,allstate.alpha);'])    
        end
        
        SDRV.alpha=allstate.alpha;
        PROC.M_SDRV=SDRV;
    else  %strcmpi(tline(1),'i')
        FILE.state.alpha=allstate.alpha;
        FILE.state.alpha0=allstate.alpha;
        FILE.state.beta0=0;
        FILE.state.beta=0;
        
        [~,~,Results]=main_SDRV(FILE,'2n');
        CD0=FILE.M_SDRV.state(1,1).STC.CD-FILE.M_SDRV.state(1,1).STC.CDi;
        PROC.M_SDRV=Results.DRVs;
        PROC.M_SDRV.CD=Results.STC.CDi+CD0;
        
    end
end    

%% ���㴦��
PROC.state=allstate;
PROC.ref=FILE.ref;
PROC.inertias=FILE.inertias;
[eigvalue,DYN_LAT]=lat_sdrv2eig(PROC);

if ~contains(cmdline,'s')
    disp(squeeze(eigvalue));
end


if ~contains(cmdline,'s')
    disp ('                               ������ģ̬')
    fprintf('����� zeta_d %8.4f \t �˻� zeta_d*omega_nd %8.4f \t ����Ƶ�� omega_nd %8.4f \n',...
        DYN_LAT.DR.zeta_d,DYN_LAT.DR.zeta_d*DYN_LAT.DR.omega_nd,DYN_LAT.DR.omega_nd);
    disp ('                  ����ģ̬')
    fprintf('����ʱ�� %8.4f \n',DYN_LAT.SPR.T2DA);
    disp ('                 ��ת����ģ̬')
    fprintf('ʱ�䳣�� %8.4f \n',DYN_LAT.RM.TC);
end

%8785���ָо��ܼ��ߣ���ȥ��
%{
if isempty(strfind(cmdline,'s'))
    disp('                                 MIL8785C �ο�ֵ')
    disp('�ȼ�        ���н׶�         ����      ��С�����    ��С�˻�    ��С����Ƶ��')
    disp('          A(CI and GA)        IV          0.4           -            1.0')
    disp('               A             I,IV         0.19         0.35          1.0')
    disp('                            II,III        0.19         0.35          0.4**')
    disp('  1            B              All         0.08         0.15          0.4**')
    disp('               C           I,II-C,IV      0.08         0.15          1.0')
    disp('                           II-L,III       0.08         0.10          0.4**')
    disp --------------------------------------------------------------------------------
    disp('  2           All             All         0.02         0.05          0.4**')
    disp --------------------------------------------------------------------------------
    disp('  3           All             All          0            0            0.4**')
    disp ---------------------------------------------------------------------------------------------------------------
end

if isempty(strfind(cmdline,'s'))
    disp('        MIL8785C �ο���С����ʱ��')
    disp('���н׶�       1��      2��     3��')
    disp(' A&C           12        8       4 ')
    disp('  B            20        8       4 ')
    disp ---------------------------------------------------------------------------------------------------------------
end


if isempty(strfind(cmdline,'s'))
    disp('        MIL8785C �ο����ʱ�䳣��')
    disp('����       ����              ��    ��')
    disp('�׶�                  1��      2��    3��')
    disp(' A         I,IV       1.0      1.4       ')
    disp('          II,III      1.4      3.0       ')
    disp(' B          All       1.4      3.0     10 ')
    disp(' C       I,II-C,IV    1.0      1.4       ')
    disp('         II-L,III     1.4      3.0       ')
end
disp *************************************************
%}

if ~contains(cmdline,'n')
    disp -----------------------------------------------------
    tline=input('���в����������飿 [y or <n>]','s');
    if ~isempty(tline)
        lat_modtest2(PROC,DYN_LAT)
    end    
end

end

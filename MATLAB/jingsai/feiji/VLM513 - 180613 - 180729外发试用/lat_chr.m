function [DYN_LAT]=lat_chr(FILE,cmdline)
% cmdline参数
% n-不需要输入高度、速度和迎角信息
% i-使用插值方式求解
% r-使用重新计算方式求解
% s-不显示8785参考内容

if nargin<2
    cmdline='';
end

cmdline=lower(cmdline);
if ~contains(cmdline,'n')
    allstate=main_allstate('ash');
    
    disp ('--------------------------->')
    disp (['当前求解高度为： ' num2str(allstate.ALT) ' m'])
    disp (['    求解速度为： ' num2str(allstate.AS) ' m/s' ])
    disp (['    求解迎角为： ' num2str(rad2deg(allstate.alpha)) 'Deg'])
    disp ('---------------------------------------------------------->')
    disp (' ')
else
    allstate=FILE.allstate;
end



%% 查找现有计算结果是否包含目标迎角
%  利用查找/求解的某一个具体迎角下的导数信息对原FILE进行改写
interp_need=1;   % 1-需要内插  0-可直接计算结果
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
else  %需要插值求解气动导数
    if contains(cmdline,'i') 
        tline='i';
    elseif contains(cmdline,'r')
        tline='r';
    else
        tline=input('现有气动导数文件不包含当前输入迎角，请确认气动导数获取方法：[(I)nterpolation or (R)ecauculate <默认为I>]','s');
        if isempty(tline)
            tline='i';
        end
    end
    
    if strcmpi(tline(1),'i') 
        for i=1:4   %导数下标
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

%% 计算处理
PROC.state=allstate;
PROC.ref=FILE.ref;
PROC.inertias=FILE.inertias;
[eigvalue,DYN_LAT]=lat_sdrv2eig(PROC);

if ~contains(cmdline,'s')
    disp(squeeze(eigvalue));
end


if ~contains(cmdline,'s')
    disp ('                               荷兰滚模态')
    fprintf('阻尼比 zeta_d %8.4f \t 乘积 zeta_d*omega_nd %8.4f \t 固有频率 omega_nd %8.4f \n',...
        DYN_LAT.DR.zeta_d,DYN_LAT.DR.zeta_d*DYN_LAT.DR.omega_nd,DYN_LAT.DR.omega_nd);
    disp ('                  螺旋模态')
    fprintf('倍幅时间 %8.4f \n',DYN_LAT.SPR.T2DA);
    disp ('                 滚转收敛模态')
    fprintf('时间常数 %8.4f \n',DYN_LAT.RM.TC);
end

%8785部分感觉很鸡肋，先去掉
%{
if isempty(strfind(cmdline,'s'))
    disp('                                 MIL8785C 参考值')
    disp('等级        飞行阶段         类型      最小阻尼比    最小乘积    最小固有频率')
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
    disp('        MIL8785C 参考最小倍幅时间')
    disp('飞行阶段       1级      2级     3级')
    disp(' A&C           12        8       4 ')
    disp('  B            20        8       4 ')
    disp ---------------------------------------------------------------------------------------------------------------
end


if isempty(strfind(cmdline,'s'))
    disp('        MIL8785C 参考最大时间常数')
    disp('飞行       类型              等    级')
    disp('阶段                  1级      2级    3级')
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
    tline=input('进行参数调整试验？ [y or <n>]','s');
    if ~isempty(tline)
        lat_modtest2(PROC,DYN_LAT)
    end    
end

end

function [CASE]=load_DRVstability(inA)
%inA   [s]/m 单选/多选   
%M_SDRV与CASE类似 M_SDRV.Files(i)

settings=config('startup'); %setting directories 设置程序运行的目录环境

if nargin~=0
    cmdline=lower(inA);
    if contains(cmdline,'m')
        [CASE]=load_define([],'m');
    end
else
    [CASE]=load_define();
end
if isempty(CASE)
    return
end

nF=length(CASE.Files);

for i=1:nF
    file_SDRV=[settings.procdir 'sdrv_' CASE.Files(i).name '_A.mat'];
   
    if isempty( dir(file_SDRV) )
        T=0;
        for j=length(CASE.Files(i).name)-1:-1:1
            file_SDRV=[settings.procdir 'sdrv_' CASE.Files(i).name(1:j) '_A.mat'];
            if ~isempty(dir(file_SDRV) )
                disp ('********  警  告  **********')
                answ=input(['未找到准确对应气动导数文件，自动匹配文件  <' CASE.Files(i).name(1:j) '>  [Y/N 默认Y]'],'s');
                if isempty(answ) || strcmpi(answ,'y') 
                    T=1;
                    break
                end
            end
        end
        if T==0
            disp (['错误：对文件' CASE.Files(i).name '进行稳定性导数文件匹配时出现错误'])
            return
        end
    end
    
    disp (['Load Stability Derivative File  <' file_SDRV '>'])
    load (file_SDRV);
    
    
    if isfield(CASE.Files(i).scales,'s_geo')
        ref.b_ref_M=M_SDRV.ref.b_ref_M*CASE.Files(i).scales.s_geo;
        ref.S_ref_M=M_SDRV.ref.S_ref_M*CASE.Files(i).scales.s_geo^2;
        ref.S_ref=M_SDRV.ref.S_ref*CASE.Files(i).scales.s_geo^2;
        ref.C_mac_M=M_SDRV.ref.C_mac_M*CASE.Files(i).scales.s_geo;
        ref.ref_point=M_SDRV.ref.ref_point.*CASE.Files(i).scales.s_geo^2;
        CASE.Files(i).ref=ref;
    else
        CASE.Files(i).ref=M_SDRV.ref;
    end
    
    CASE.Files(i).M_SDRV=M_SDRV;
end


end
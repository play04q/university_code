function recent=main_recent(recent)
settings=config('startup'); %setting directories 设置程序运行的目录环境

if nargin<1  %读取默认值设置
    recent=[];
    if ~isempty(dir([settings.procdir 'recent.mat']))
        load ([settings.procdir 'recent.mat']);
    end
    recent=CheckField(recent,'res_path',settings.imdir);
    recent=CheckField(recent,'res_name','');
    recent=CheckField(recent,'res_mname','');
    recent=CheckField(recent,'AS0',20:10:40);
    recent=CheckField(recent,'AS',15);
    recent=CheckField(recent,'ALT',10);
    recent=CheckField(recent,'alpha',deg2rad(3));
    recent=CheckField(recent,'controlDrv','');
else
    save ([settings.procdir 'recent.mat'],'recent');
end

end

function VariableName=CheckField(VariableName,FieldName,DefaultValue)

if ~isfield(VariableName,FieldName)
    VariableName=setfield(VariableName,FieldName,DefaultValue);
end
end
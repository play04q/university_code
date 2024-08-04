function xlsoutput(quest,geo,state,ref,results,Mstate,Mresults)
settings=config('startup'); %setting directories 设置程序运行的目录环境
filename=[settings.exdir '\results.xls'];
switch quest
    case 0
        if ~isempty(dir(filename))
            delete(filename);
        end
        
        chaout(filename,geo,state,ref);
        
    case 1
        [nA nS ~]=size(Mstate);
        if strcmp(results.type,'swp1')
            A1=nS;
            B1=nA;
        else
            A1=nA;
            B1=nS;
        end
        
        for i=1:A1
            if strcmp(results.type,'swp1')
                sheetname=['AoS' num2str(rad2deg(Mstate(1,i,2)))];
                SS='Alpha';
            else
                sheetname=['AoA' num2str(rad2deg(Mstate(i,1,1)))];
                SS='Beta';
            end
            M(1,:)=[{SS},{'CL'},{'CD0'},{'CDi'},{'CD.total'},{'CMm'},{'CC'},{'CLm'},...
                {'CNm'},{'L'},{'D0'},{'Di'},{'D.total'}, {'Mm'},{'C'},...
                {'Lm'},{'Nm'},{'X'},{'Y'},{'Z'},{'xNP'}];
            
            for j=1:B1
                if strcmp(results.type,'swp1')
                    SS=Mstate(j,1,1);
                    A=j;
                    B=i;
                else
                    SS=Mstate(1,j,2);
                    A=i;
                    B=j;
                end
                
                M(1+j,:)=[{rad2deg(SS)},{Mresults(A,B).CL},{Mresults(A,B).CD0},{Mresults(A,B).CDi},...
                    {Mresults(A,B).CD},{Mresults(A,B).CMm},{Mresults(A,B).CC},{Mresults(A,B).CLm},...
                    {Mresults(A,B).CNm},{Mresults(A,B).L},{Mresults(A,B).D0},{Mresults(A,B).Di},...
                    {Mresults(A,B).D}, {Mresults(A,B).Mm},{Mresults(A,B).C},{Mresults(A,B).Lm},...
                    {Mresults(A,B).Nm},{Mresults(A,B).X},{Mresults(A,B).Y},{Mresults(A,B).Z},{Mresults(A,B).xNP}];
            end
            
            loop=1;
            while loop==1
                try
                    warning off
                    xlswrite(filename,M,sheetname,'A1')
                    loop=0;
                    warning on
                catch
                    beep
                    input('无法完成写Excel文件操作，可能目标文件已经打开');
                end
            end

            
        end
        
end
        
end

function chaout(filename,geo,state,ref)
M1=cell(1);
M1(1,1)={'%导入时图形显示几何定义方式[0 不显示][1 只显示轮廓线][2 显示网格划分和涡格面元法向定义]'};
M1(2,1)={geo.drawtype};

for s=1:geo.nwing;
    A=(s-1)*7+sum(geo.nelem(1:s-1));
    M1(A+3,1)={'%机翼编号'};
    M1(A+4,1)={['#' num2str(s)]};
    M1(A+5,1:4)=[{'%是否对称'},{'弦向网格数'},{'弦向网格生成方式'},{'是否为主机翼'}];
    M1(A+6,1:4)=[{geo.symetric(s)},{geo.nx(s)},{geo.meshtypex(s)},{geo.ismain(s)}];
    M1(A+7,1:6)=[{'%根弦前缘x坐标'},{'根弦前缘y坐标'},{'根弦前缘z坐标'},{'根弦长'},{'扭转角'},{'翼型'}];
    M1(A+8,1:6)=[{geo.startx(s)},{geo.starty(s)},{geo.startz(s)},{geo.c(s,1)},{rad2deg(geo.TW(s,1,1))},geo.foil(s,1)];
    M1(A+9,1:9)=[{'%翼段展长'},{'梢弦长'},{'前缘后掠角'},{'上反角'},{'梢部扭转角'},{'梢部翼型'},...
        {'展向网格数'},{'展向网格生成方式'},{'后缘操纵面铰链百分比'}];
    
    for t=1:geo.nelem(s)
        M1(A+9+t,1:9)=[{geo.b(s,t)},{geo.c(s,t+1)},{rad2deg(geo.SW(s,t))},{rad2deg(geo.dihed(s,t))},...
            {rad2deg(geo.TW(s,t+1))},geo.foil(s,t+1),{geo.ny(s,t)},{geo.meshtypey(s,t)},{geo.fc(s,t)}];
    end
            
end



M2=cell(1);
M2(1,1:2)=[{'%迎角(deg)'},{'侧滑角(deg)'}];
M2(2,1:2)=[{state.alpha},{state.beta}];	
M2(3,1:3)=[{'%滚转角速度(p) [deg/s]'},{'俯仰角速度(q) [deg/s]'},{'偏航角速度(r) [deg/s]'}];
M2(4,1:3)=[{state.P},{state.Q},{state.R}];
M2(5,1:2)=[{'%真实空速 [m/s]'},{'飞行高度 [m]'}];
M2(6,1:2)=[{state.AS},{state.ALT}];
M2(7,1)={'%使用普朗特-格劳厄脱(Prandtl-Glauert)法则修正 [0=否 1=是]'};
M2(8,1)={state.pgcorr};
M2(9,1)={'%涡线生成方式'};
M2(10,1)={state.waketype};


% M3=cell(1);
% M3(1,1)={'%坐标位置类型   [1]绝对坐标   [2]相对坐标'};
% M3(2,1)={ref.type};
% if ref.type==1
%     M3(3,1)={'%转动中心位置 x,y,z 坐标 [m]'};
%     M3(4,1:3)=[{ref.CR(1)},{ref.CR(3)},{ref.CR(3)}];
%     M3(5,1)={'%参考点位置 x,y,z 坐标 [m]'};
%     M3(6,1:3)=[{ref.ref_point(1)},{ref.ref_point(2)},{ref.ref_point(3)}];
% else
%     M3(3,1)={'%转动中心位置坐标 [% of MAC] '};
%     M3(4,1)={(ref.CR(1)-ref.mac_pos_M(1))/ref.C_mac_M*100};
%     M3(5,1)={'%参考点位置 x,y,z 坐标 [% of MAC]'};
%     M3(6,1)={(ref.point(1)-ref.mac_pos_M(1))/ref.C_mac_M*100};
% end

loop=1;
while loop==1
    try
        xlswrite(filename,M1,'sheet1','A1')
        xlswrite(filename,M2,'sheet2','A1')
%         xlswrite(filename,M3,'sheet3','A1')
        loop=0;
    catch
        beep
        input('无法完成写Excel文件操作，可能目标文件已经打开');
    end
end
end
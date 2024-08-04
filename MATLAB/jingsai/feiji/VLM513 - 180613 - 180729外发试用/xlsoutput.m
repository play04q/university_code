function xlsoutput(quest,geo,state,ref,results,Mstate,Mresults)
settings=config('startup'); %setting directories ���ó������е�Ŀ¼����
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
                    input('�޷����дExcel�ļ�����������Ŀ���ļ��Ѿ���');
                end
            end

            
        end
        
end
        
end

function chaout(filename,geo,state,ref)
M1=cell(1);
M1(1,1)={'%����ʱͼ����ʾ���ζ��巽ʽ[0 ����ʾ][1 ֻ��ʾ������][2 ��ʾ���񻮷ֺ��и���Ԫ������]'};
M1(2,1)={geo.drawtype};

for s=1:geo.nwing;
    A=(s-1)*7+sum(geo.nelem(1:s-1));
    M1(A+3,1)={'%������'};
    M1(A+4,1)={['#' num2str(s)]};
    M1(A+5,1:4)=[{'%�Ƿ�Գ�'},{'����������'},{'�����������ɷ�ʽ'},{'�Ƿ�Ϊ������'}];
    M1(A+6,1:4)=[{geo.symetric(s)},{geo.nx(s)},{geo.meshtypex(s)},{geo.ismain(s)}];
    M1(A+7,1:6)=[{'%����ǰԵx����'},{'����ǰԵy����'},{'����ǰԵz����'},{'���ҳ�'},{'Ťת��'},{'����'}];
    M1(A+8,1:6)=[{geo.startx(s)},{geo.starty(s)},{geo.startz(s)},{geo.c(s,1)},{rad2deg(geo.TW(s,1,1))},geo.foil(s,1)];
    M1(A+9,1:9)=[{'%���չ��'},{'���ҳ�'},{'ǰԵ���ӽ�'},{'�Ϸ���'},{'�Ҳ�Ťת��'},{'�Ҳ�����'},...
        {'չ��������'},{'չ���������ɷ�ʽ'},{'��Ե����������ٷֱ�'}];
    
    for t=1:geo.nelem(s)
        M1(A+9+t,1:9)=[{geo.b(s,t)},{geo.c(s,t+1)},{rad2deg(geo.SW(s,t))},{rad2deg(geo.dihed(s,t))},...
            {rad2deg(geo.TW(s,t+1))},geo.foil(s,t+1),{geo.ny(s,t)},{geo.meshtypey(s,t)},{geo.fc(s,t)}];
    end
            
end



M2=cell(1);
M2(1,1:2)=[{'%ӭ��(deg)'},{'�໬��(deg)'}];
M2(2,1:2)=[{state.alpha},{state.beta}];	
M2(3,1:3)=[{'%��ת���ٶ�(p) [deg/s]'},{'�������ٶ�(q) [deg/s]'},{'ƫ�����ٶ�(r) [deg/s]'}];
M2(4,1:3)=[{state.P},{state.Q},{state.R}];
M2(5,1:2)=[{'%��ʵ���� [m/s]'},{'���и߶� [m]'}];
M2(6,1:2)=[{state.AS},{state.ALT}];
M2(7,1)={'%ʹ��������-���Ͷ���(Prandtl-Glauert)�������� [0=�� 1=��]'};
M2(8,1)={state.pgcorr};
M2(9,1)={'%�������ɷ�ʽ'};
M2(10,1)={state.waketype};


% M3=cell(1);
% M3(1,1)={'%����λ������   [1]��������   [2]�������'};
% M3(2,1)={ref.type};
% if ref.type==1
%     M3(3,1)={'%ת������λ�� x,y,z ���� [m]'};
%     M3(4,1:3)=[{ref.CR(1)},{ref.CR(3)},{ref.CR(3)}];
%     M3(5,1)={'%�ο���λ�� x,y,z ���� [m]'};
%     M3(6,1:3)=[{ref.ref_point(1)},{ref.ref_point(2)},{ref.ref_point(3)}];
% else
%     M3(3,1)={'%ת������λ������ [% of MAC] '};
%     M3(4,1)={(ref.CR(1)-ref.mac_pos_M(1))/ref.C_mac_M*100};
%     M3(5,1)={'%�ο���λ�� x,y,z ���� [% of MAC]'};
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
        input('�޷����дExcel�ļ�����������Ŀ���ļ��Ѿ���');
    end
end
end
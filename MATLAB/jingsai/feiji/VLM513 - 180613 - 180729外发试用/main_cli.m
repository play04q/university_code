function main_cli()
MWT=[];
close all
settings=config('startup'); %setting directories 设置程序运行的目录环境

tline=input(['是否重新进行计算 [Y/N < 默认N >] '],'s');
if isempty(tline)
    tline='n';
end
if strcmpi(tline(1),'y')
    CASE=load_define([settings.calidir '029.in'],'n');
    nS=7;
    nA=8;

    for j=1:nS
        SID=['A-100' num2str(j) 'wb.dat'];
        res=fopen([settings.calidir SID]);

        for i=1:nA
            tline=readline(res);
            buf=sscanf(tline,'%f,%f,%f,%f,%f,%f,%f,%f');
            MWT(i,j).CL =buf(1);
            MWT(i,j).CD =buf(2);
            MWT(i,j).CMm =buf(3);
            MWT(i,j).CY  =buf(4);
            MWT(i,j).CNm =buf(5);
            MWT(i,j).CLm =buf(6);
            MWT(i,j).alpha =buf(7);
            MWT(i,j).beta  =buf(8);
        end
        fclose(res);
    end
    
    CASE.Files(1).state.alpha0=deg2rad([-5,0,5,10,15,20,25,30]);
    CASE.Files(1).state.beta0=deg2rad([-20,-10,5,0,5,10,20]);
    [~,~,results]=main_ADload(CASE,'n');
    
    nCOND=0;
    for i=1:nA
        for j=1:nS
            nCOND=nCOND+1;
            MVLM(i,j).CL  =results.Files(1).Condition(nCOND).ADload.PTL.CL;
            MVLM(i,j).CD  =results.Files(1).Condition(nCOND).ADload.Total.CD;
            MVLM(i,j).CMm =results.Files(1).Condition(nCOND).ADload.PTL.CMm;
            MVLM(i,j).CY  =results.Files(1).Condition(nCOND).ADload.PTL.CY;
            MVLM(i,j).CNm =results.Files(1).Condition(nCOND).ADload.PTL.CNm;
            MVLM(i,j).CLm =results.Files(1).Condition(nCOND).ADload.PTL.CLm;
            MVLM(i,j).alpha =rad2deg(results.Files(1).Condition(nCOND).state.alpha);
            MVLM(i,j).beta =rad2deg(results.Files(1).Condition(nCOND).state.beta);
        end
    end
    save([settings.calidir 'cali.mat'],'MWT','MVLM','nS','nA');
else
    load([settings.calidir 'cali.mat']);
end
    

figure (901)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.50,.50,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CL Calibration'])
view(3);

xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CL')
WT=zeros(nA,nS,3);
VLM=zeros(nA,nS,3);
for i=1:nA
    for j=1:nS
        WT(i,j,1) =MWT(i,j).alpha;
        WT(i,j,2) =MWT(i,j).beta;
        WT(i,j,3) =MWT(i,j).CL;
        VLM(i,j,1)=MVLM(i,j).alpha;
        VLM(i,j,2)=MVLM(i,j).beta;
        VLM(i,j,3)=MVLM(i,j).CL;
    end
end
plot3(WT(:,:,1),WT(:,:,2),WT(:,:,3),'x')
plot3(VLM(:,:,1),VLM(:,:,2),VLM(:,:,3))

figure (902)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.52,.48,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CD Calibration'])
view(3);

xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CD')

for i=1:nA
    for j=1:nS
        WT(i,j,3) =MWT(i,j).CD;
        VLM(i,j,3)=MVLM(i,j).CD;
    end
end
plot3(WT(:,:,1),WT(:,:,2),WT(:,:,3),'x')
plot3(VLM(:,:,1),VLM(:,:,2),VLM(:,:,3))


figure (903)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.54,.46,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CY Calibration'])
view(3);

xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CY')
for i=1:nA
    for j=1:nS
        WT(i,j,3) =MWT(i,j).CY;
        VLM(i,j,3)=MVLM(i,j).CY;
    end
end
plot3(WT(:,:,1)',WT(:,:,2)',WT(:,:,3)','x')
plot3(VLM(:,:,1)',VLM(:,:,2)',VLM(:,:,3)')

figure (911)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.1,.50,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CMm Calibration'])

view(3);
xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CMm')
for i=1:nA
    for j=1:nS
        WT(i,j,3) =MWT(i,j).CMm;
        VLM(i,j,3)=MVLM(i,j).CMm;
    end
end
plot3(WT(:,:,1),WT(:,:,2),WT(:,:,3),'x')
plot3(VLM(:,:,1),VLM(:,:,2),VLM(:,:,3))


figure (912)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.12,.48,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CLm Calibration'])

view(3);    
xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CLm')
for i=1:nA
    for j=1:nS
        WT(i,j,3) =MWT(i,j).CLm;
        VLM(i,j,3)=MVLM(i,j).CLm;
    end
end
plot3(WT(:,:,1)',WT(:,:,2)',WT(:,:,3)','x')
plot3(VLM(:,:,1)',VLM(:,:,2)',VLM(:,:,3)')


figure (913)
hold on
grid on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.14,.46,.35,.4])
set(gcf,'NumberTitle','off')
set(gcf,'Name',['CNm Calibration'])

view(3);    
xlabel('Alpha /DEG')
ylabel('Beta /DEG')
zlabel('CNm')
for i=1:nA
    for j=1:nS
        WT(i,j,3) =MWT(i,j).CNm;
        VLM(i,j,3)=MVLM(i,j).CNm;
    end
end
plot3(WT(:,:,1)',WT(:,:,2)',WT(:,:,3)','x')
plot3(VLM(:,:,1)',VLM(:,:,2)',VLM(:,:,3)')
legend('Wind Tunnel Test','Cauculation Results')

end
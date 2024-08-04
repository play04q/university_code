function foilmixer()
if nargin==0
    [foil_name,foil_path,~]=uigetfile({'*.dat;*.asc','翼型定义文件'},'选择原始翼型...','');
    foil_file=[foil_path foil_name];
    if isempty(foil_file) 
        return
    end
    
    
    if strcmpi(foil_file(end-3:end),'.dat')
        [x0,yc0,yu0,yl0]=readfoil2(foil0_file);
    end
    if strcmpi(foil_file(end-3:end),'.asc')
        [x0,yu0]=readasc(foil_file);
        [foil_name,foil_path,~]=uigetfile({'*.dat;*.asc','翼型定义文件'},'选择原始翼型...',foil_path);
        foil_file=[foil_path foil_name];
        [~,yl0]=readasc(foil_file);
        
        yc0=(yu0+yl0)/2;
        yt0=yu0-yl0;
    end
    
    [camber_name,camber_path,~]=uigetfile({'*.asc','弯度定义文件'},'选择优化后的弯度曲线...',foil_path);
    camber_file=[camber_path camber_name];
    [~,yc1]=readasc(camber_file);

    yu1=yc1+.5*yt0;
    yl1=yc1-.5*yt0;
   
    figure
    clf
    hold on

    plot(x0,yc0,':b')
    plot(x0,yc1,'r')
    legend('Origin','Optimized')
    
    plot(x0,yu0,':b')
    plot(x0,yl0,':b')

    plot(x0,yu1,'r')
    plot(x0,yl1,'r')
    
    figure
    clf
    hold on
    axis equal

    plot(x0,yc0,':b')
    plot(x0,yc1,'r')
    legend('Origin','Optimized')
    
    plot(x0,yu0,':b')
    plot(x0,yl0,':b')

    plot(x0,yu1,'r')
    plot(x0,yl1,'r')
    

    res=fopen([camber_file(1:end-4) 'U.asc'],'wt');
    [~,maxi]=size(x0);
    for i=1:maxi
        fprintf(res,'X %12.6f Y %12.6f Z %12.6f\n',x0(i)*1000,0,yu1(i)*1000);
    end
    fclose (res);
    res=fopen([camber_file(1:end-4) 'L.asc'],'wt');
    for i=1:maxi
        fprintf(res,'X %12.6f Y %12.6f Z %12.6f\n',x0(i)*1000,0,yl1(i)*1000);
    end
    fclose (res);

    
end






end
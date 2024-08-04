function [x,yc,yu,yl]=readfoil2(foil)
Isdraw=0;
yu=0;
yl=0;
xu=0;
xl=0;

if iscell(foil)
    foil=cell2mat(foil);
end

%str2double处理的变量中如含有字母，会返回NAN
if ~isnan(str2double(foil))
    TYPE=1;       %Naca xxxx profile, see case 1 
else
    if foil(1)~='*'
        TYPE=2;       %Airfoil from file, see case 2  
    else
        TYPE=3;       %读取弯度数据
    end
end

% First type
switch TYPE
    case 1    %The Airfoil camber can be described as a function, NACA 4 digits    
        foil=str2double(foil);
        x=0:0.01:1;
        
        if foil==0
            yc=zeros(1,101);
            yu=zeros(1,101);
            yl=zeros(1,101);
            return
        end
        
        m=fix(foil/1000);	%gives first NACA-4 number
        p=fix((foil-m*1000)/100);	%gives second NACA-4 number
        tk=((foil-m*1000)-p*100)/100;
   
        p=p/10;
        m=m/100;
        
        for i=1:101
            if x(i)<p
                yc(i)=(m/(p^2)*x(i)*(2*p-x(i)));  
            else
                yc(i)= m/((1-p)^2)* ((1-2*p)+2*p*x(i)-x(i)^2);
            end
        end
        
        
        for i=1:100
            xa(i)=1/2*(x(i)+x(i+1));
            theta(i)=atan( (yc(i+1)-yc(i)) / (x(i+1)-x(i)) );
            
            y=tk/0.2*(0.2969*sqrt(xa(i))-0.1260*xa(i)-0.3515*xa(i)^2+0.2843*xa(i)^3-0.1015*xa(i)^4);
            xu0(i)=xa(i)-y*sin(theta(i));
            xb0(i)=xa(i)+y*sin(theta(i));
            yu0(i)=(yc(i+1)+yc(i))/2+y*cos(theta(i));
            yb0(i)=(yc(i+1)+yc(i))/2-y*cos(theta(i));
            
        end
        
        yu = interp1(xu0,yu0,x,'PCHIP','extrap');
        yl = interp1(xb0,yb0,x,'PCHIP','extrap');

  
% Second Type        
    case 2        % Load the airfoil data points
        %settings=config('startup');
        %filename=[settings.afdir '\' foil '.dat'];
        filename=foil;
        if isempty(dir(filename))
            terror1(1);
            disp(['翼型数据库中没有找到此翼型文件: ' foil]);
            disp('以平板翼型代替当前翼型')
            x=0:0.01:1;
            yc=zeros(1,101);
            yu=zeros(1,101);
            yl=zeros(1,101);
            return
        end
        
        res=fopen(filename);
        fside=1;            %当前读取的是哪一面（上或下,0为结束）
        xu0=[];
        yu0=[];
        xb0=[];
        yb0=[];
        
        while feof(res)==0 %%依次读取文件的每一行
            tline=readline(res);
            buf=sscanf(tline,'%f %f');
            if ~isempty(buf) && length(buf)==2
                if fside==1
                    if ~isempty(xu0)
                        if buf(1)==xu0(end)
                            fside=2;
                            xu0=flipud(xu0);
                            yu0=flipud(yu0);
                        elseif buf(1)>xu0(end)
                            fside=2;
                            xb0=xu0(end);
                            yb0=yu0(end);
                            xu0=flipud(xu0);
                            yu0=flipud(yu0);
                        end
                    end
                    if fside==1
                        xu0=[xu0;buf(1)];
                        yu0=[yu0;buf(2)];
                    end
                end
                if fside==2
                    xb0=[xb0;buf(1)];
                    yb0=[yb0;buf(2)];
                    if buf(1)==1 
                        fside=0;
                    end
                end
            end   %if ~isempty
        end %while feof(res)==0 %%依次读取文件的每一行
        fclose(res);

        if fside~=0
            disp (['翼型文件' filename '中可能存在错误，请检查文件内容'])
        end
        
        %按给定的X点插值得到上下两个翼型曲线
        x=0:0.01:1;
        yu = interp1(xu0,yu0,x,'pchip','extrap');
        yl = interp1(xb0,yb0,x,'pchip','extrap');
        
        %计算中弧线坐标
        yc=1/2*(yu+yl);
        
    case 3             %读取弯度文件
        foil=foil(2:end);
        settings=config('startup');
        filename=[settings.cbdir '\' foil '.dat'];
        if isempty(dir(filename))
            terror1(1);
            disp(['中弧线数据库中没有找到此文件: ' foil]);
            disp('以平板代替当前弯度')
            x=0:0.01:1;
            yc=zeros(1,101);
            return
        end
        
        res=fopen(filename);
        x0=[];
        yc0=[];
        
        while feof(res)==0 %%依次读取文件的每一行
            tline=readline(res);
            buf=sscanf(tline,'%f %f');
            if ~isempty(buf)
                x0=[x0;buf(1)];
                yc0=[yc0;buf(2)];
            end
        end %while feof(res)==0 %%依次读取文件的每一行
        fclose(res);

        if x0(1)~=0 || x0(end)~=1
            disp (['弯度定义文件' filename '中可能存在错误，请检查文件内容'])
        end
        
        %按给定的X点插值得到上下两个翼型曲线
        x=0:0.01:1;

        
        %计算中弧线坐标
        yc=interp1(x0,yc0,x,'cubic','extrap');
        
        yu = yc;
        yl = yc;
        
end %switch type

if Isdraw==1
    figure (502)
    axis equal;
    hold on;
    try
    plot(x,yu,'-r');
    end
    try
    plot(xu0,yu0,'--b');
    end
    try
    plot(x,yl,'-r');
    end
    try
    plot(xb0,yb0,'--b');
    end
    plot(x,yc,'-g');
    
   keyboard
   close 502
end
           
        
end %function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


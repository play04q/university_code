function [windowxing,jieshu]=shiyan51(rs,wguo)
    %根据rs、过渡带wguo的大小选择窗形windowxing，确定阶数jieshu
    if rs>0
    N(1)=ceil(4*pi/wguo);as(1)=21;str(1).window=boxcar(N(1)+1);   N(2)=ceil(8*pi/wguo);as(2)=25;str(2).window=triang(N(2)+1);    N(3)=ceil(8*pi/wguo);as(3)=44;str(3).window=hanning(N(3)+1);   N(4)=ceil(8*pi/wguo);as(4)=53;str(4).window=hamming(N(4)+1);  N(5)=ceil(12*pi/wguo);as(5)=74;str(5).window=blackman(N(5)+1);    N(6)=ceil(10*pi/wguo);as(6)=80;str(6).window=kaiser(N(6)+1,7.865);
        i=0;
        while i<6
             i=i+1;
             if as(i)<rs
                 N(i)=1000000;
             end
         end
        [Nmin,m]=min(N);
        windowxing=str(m).window;
        jieshu=Nmin;
    else 
        error('rs > 0')
    end
end
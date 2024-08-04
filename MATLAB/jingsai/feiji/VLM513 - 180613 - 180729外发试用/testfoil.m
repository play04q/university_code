function testfoil
%[x1,yc1,~,~]=readfoil({'NACA2412-camber-1'});
%[x2,yc2]=paracamber(-0.0102,0.41,-3,-2);
C=[-0.041219959	0.034350347	-0.020008392];
XC=[0.774932479	0.741625086	0.289173724];
alphaLE=[13.78347448	-18.36606394	-2.914168002];
alphaTE=[-9.10093843	6.358587015	-2.953994049];
AA=1;

[x1,yc1,~,~]=readfoil({'NACA2412-camber-1'});
[x2,yc2]=paracamber(C(AA),XC(AA),alphaLE(AA),alphaTE(AA));

figure (999)
clf
plot(x1,yc1,x2,yc2)
legend('NACA2412-camber-1','paracamber')


idx=0;
for C=-0.05:0.01:0.05
    for XC=0.1:0.1:0.7
        for alphaLE=-20:5:20
            for alphaTE=-10:4:10
                %C=-0.05;
                %XC=0.4;
                %alphaLE=10;
                %alphaTE=10;
                idx=idx+1;
                [x2,yc2]=paracamber(C,XC,alphaLE,alphaTE);
                figure('visible','off');
                FG2=plot(x2,yc2);
                title([num2str(C) '/' num2str(XC) '/' num2str(alphaLE) '/' num2str(alphaTE)]);
                if abs(C)-max(abs(yc2)) < -1e-3
                    iserr='x';
                else
                    iserr=[];
                end
                saveas(FG2(1),[pwd '\PHD_Foil\' iserr num2str(idx)],'png');
                close(gcf)
                
            end
        end
    end
end

            
            
            
            %legend(num2str(m))
            

end
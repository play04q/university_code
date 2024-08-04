function test_deflect
%舵面偏转数值稳定性测试

resfile=[pwd '\import\Sample_CF_Deflect.in'];
[CASE]=load_define(resfile);
idx=1;
for i=0:1:20
    CASE.Files.geo(1).deflect(1,1)=deg2rad(i);
    CASE.Files.geo(1).deflect(1,2)=-deg2rad(i);
    [~,~,Results]=main_ADload(CASE,'n');
    Results=Results.Files.Condition.ADload.PTL;
    L(idx)=Results.L;
    D(idx)=Results.Di;
    C(idx)=Results.C;
    Lm(idx)=Results.Lm;
    Mm(idx)=Results.Mm;
    Nm(idx)=Results.Nm;
    Gamma(idx,:)=Results.Gamma;
    ANG(idx)=i;
    idx=idx+1;
end

figure (110)
clf
hold on
subplot(2,3,1)
plot(ANG,L,'-x')
title('L')
subplot(2,3,2)
plot(ANG,D,'-x')
title('D')
subplot(2,3,3)
plot(ANG,C,'-x')
title('C')
subplot(2,3,4)
plot(ANG,Lm,'-x')
title('Lm')
subplot(2,3,5)
plot(ANG,Mm,'-x')
title('Mm')
subplot(2,3,6)
plot(ANG,Nm,'-x')
title('Nm')

% figure(220)
% clf
% hold on
% for i=1:8
%     subplot(2,4,i)
%     YY=Gamma(:,i);
%     plot(ANG,YY)
% end

end
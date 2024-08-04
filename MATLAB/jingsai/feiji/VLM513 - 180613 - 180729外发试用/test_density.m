function test_density

%舵面偏转数值稳定性测试

resfile='E:\VLM513 - 141003\import\Sample_Mesh_Density.in';
[geo,state,ref,~]=autoread(resfile);
NX=geo(1).nx;
NY=geo(1).ny(1);


idx=1;
for i=1:17
    tic
    geo(1).nx=fix(NX);
    geo(1).ny(1)=fix(NY);
    fprintf('i = %d, nx = %d, ny = %d',i,geo(1).nx,geo(1).ny(1));
    [geo,state,ref,MESH,WAKE,Results]=solver_static(geo,state,ref,'n');
    A.L(idx)=Results.L;
    A.D(idx)=Results.D;
    A.C(idx)=Results.C;
    A.Lm(idx)=Results.Lm;
    A.Mm(idx)=Results.Mm;
    A.Nm(idx)=Results.Nm;
    ANG(idx)=i;
    NX=NX*1.1;
    NY=NY*1.1;
    idx=idx+1;
    elapsedTime=toc;
    fprintf('  消耗时间%f s\n',elapsedTime);
    if elapsedTime>120
        break
    end
end

figure (110)
clf
hold on
subplot(2,3,1)
hold on
plot(ANG,A.L)
title('L')
subplot(2,3,2)
hold on
plot(ANG,A.D)
title('D')
subplot(2,3,3)
hold on
plot(ANG,A.C)
title('C')
subplot(2,3,4)
hold on
plot(ANG,A.Lm)
title('Lm')
subplot(2,3,5)
hold on
plot(ANG,A.Mm)
title('Mm')
subplot(2,3,6)
hold on
plot(ANG,A.Nm)
title('Nm')

load ('1111.mat')
figure (110)
subplot(2,3,1)
plot(ANG,A.L,'r')
title('L')
subplot(2,3,2)
plot(ANG,A.D,'r')
title('D')
subplot(2,3,3)
plot(ANG,A.C,'r')
title('C')
subplot(2,3,4)
plot(ANG,A.Lm,'r')
title('Lm')
subplot(2,3,5)
plot(ANG,A.Mm,'r')
title('Mm')
subplot(2,3,6)
plot(ANG,A.Nm,'r')
title('Nm')

end
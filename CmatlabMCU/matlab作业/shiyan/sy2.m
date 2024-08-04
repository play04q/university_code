%%   2
%2，编程n分别求M脚本文件和M函数文件编程；
% %t 此函数功能是求阶乘
% function s=jiecheng(n)
%     i=1;s=1;
%     for i=1:n
%         s=s*i;
%     end
% end
%脚本文件：
n=input(' 请输入 n 值 ');
i=1;s=1;
for i=1:n
    s=s*i;
end
disp(s);

%%   3
% 统计十个数正负数个数
 a=0;b=0;
 for i=1:10
     f=input('请输入一个数值');
     if f>0
        a=a+1;
     elseif f<0
        b=b+1;
     else
        break;
     end
 end
disp(' 正数的个数 '),disp(a);
disp(' 负数的个数 '),disp(b); 

%%   4
% 依据奖金的不同，税率不同；如下：当奖金高于3000 时， r=0.15 ，
% 当奖金高于2000 时， r=0.1, 当奖金高于 1000 时， r=0.08, 
% 当奖金低于1000 时，r=0.05 ，运算扣税后的奖金
n=input('奖金');
if n>=3000
    r=0.15;
    s=n-n*r;
elseif n>2000
    r=0.1;
    s=n-n*r;
elseif n>1000
    r=0.08;
    s=n-n*r;
else
    r=0.05;
    s=n-n*r;
end
disp(s);

%%   5
% 编写程序，将某班同学某门课的成果为 60，75，85，96，52，36，86， 56，94，84，77，
% 用 switch结构统计各分段的人数，并将各人的成果变为优，良，中，及格和不及格表示
a=0;b=0;c=0;d=0;e=0;
x=[60,75,85,96,52,36,86,56,94,84,77];
x1=fix(x/10);
n=length(x1);
for i=1:n
    switch x1(i)
    case 9
        a=a+1;
    case 8
        b=b+1;
    case 7
        c=c+1;
    case 6
        d=d+1;
    otherwise
        e=e+1;
    end
end
you=['优秀',num2str(a),'人'];
liang=['良好',num2str(b),'人'];
zhong=['中等',num2str(c),'人'];
jige=['及格',num2str(d),'人'];
bujige=['不及格',num2str(e),'人'];
disp(you);
disp(liang);
disp(zhong);
disp(jige);
disp(bujige);

%%   6
%使用for语句 ：
% sum=0;
% for xh=1:10
%     sum=sum+xh.^3;
% end
% disp(sum);
%使用while循环语句 :
sum=0;xh=1;
while xh<=10
    sum=sum+xh.^3;
    xh=xh+1;
end
disp(sum);

%%   加的鬼东西
% n=input('输入正整数');
% if n==2
%     disp('yes');
% elseif n==1
%     disp('既不是质数，也不是素数');
% else
%     for i=1:n
%         x(i)=n/i;
%     end
%     x1=rem(x,1);
%     x2=x1(2:n-1);
%     x3=find(x2==0);
%     x4=find(x2==100);
%     if x3==true
%         disp('no');
% %     elseif x3==true
% %         disp('no');
%     else
%         disp('yes');
%     end
% %     for j=1:n-2
% %         a=0;
% %         if x2(a)==0
% %             disp('no');
% %             break;
% %         else
% %             disp('yes');
% %             break;
% %         end
% %         a=a+1;
% %     end
% end


x=input('请输入x的值 ：');
for i=2:x-1
    if 0==rem(x,i)
%         SushuJudge=0;
         fprintf('x不是素数\n');
        break;
    elseif i==x-1
%         SushuJudge=1;
        fprintf('x是素数\n');
    end
end

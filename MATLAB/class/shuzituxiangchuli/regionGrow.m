function J= regionGrow(I)
if isinteger(I)
    I=im2double(I);
end
figure;
imshow(I);title('原图');
[M,N]=size(I);
[y,x]=getpts;
%获得起始点
x1=round(x);
%横坐标获取
y1=round(y);
seed=I(x1,y1);
%将生长起始点灰度值存入种子中
J=zeros(M,N);  %图像输出矩阵
J(x1,y1)=1;  %J中取到的点设置白色
sum=seed; %存储符合种子点灰度值和
suit=1; %种子点个数
count=1;%记录新点数目
threshold=0.15;
while count>0
s=0;% 新点灰度值之和
count=0;
for i=1:M
    for j=1:N
        if J(i,j)==1
            if (i-1)>0 && (i+1)<(M+1)&&(j-1)>0 && (j+1)<(N+1) % 判断此点是否为边界
                for u= -1:1%判断邻域8是否符合阈值条件
                    for v= -1:1
                        if J(i+u,j+v)==0&&abs(I(i+u,j+v)-seed)<=threshold&&1/(1+1/15*abs(I(i+u,j+v)-seed))>0.8
                            J(i+u,j+v)=1; %判断是否有漏记，将符合条件点在J图像中设置白
                            count=count+1;
                            s=s+I(i+u,j+v);
                        end
                    end
                end
            end
        end
    end
end              
suit=suit+count;
sum=sum+s;
seed=sum/suit;
end
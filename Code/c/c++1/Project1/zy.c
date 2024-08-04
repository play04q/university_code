#include<stdio.h>
int main()
{
   int i,n,m,a=0,b=0;
   scanf("%d%d",&n,&m);
   int hole[n];
   for(i=0;i<n;i++)hole[i]=0;
   for(i=0;i<m;i++)
   {
       a=a%10;
       hole[a]=1;
       a+=i+2;
   }
   for(i=0;i<n;i++)
   {
       if(hole[i]==0)
   {
       b=i+1;
       printf("%d ",b);
   }
   }
    return 0;
}

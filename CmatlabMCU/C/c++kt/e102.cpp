#include<iostream>
#include<cstring>
using namespace std;
struct stu
{
    int num;
    char name [10];
    float score;
};
stu s[3]={{101,"zhang",60},{102,"zhang",99},{103,"meng",80}};
int main()
{
    stu t;
    for (int i=0;i<2;i++)
    for (int j=i;j<2;j++)
    {
        if(strcmp(s[i].name,s[j+1].name)>0)
        {
            t=s[i];
            s[i]=s[j+1];
            s[j+1]=t;
        }
    }
    stu *p;
    for (p=s;p<s+3;p++)
        cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
    return 0;
}

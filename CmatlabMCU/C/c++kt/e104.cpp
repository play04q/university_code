#include <iostream>
#include <cstring>
using namespace std;
struct stu
{
    int num;
    char name [10];
    float score;
};
stu s[100];
int main()
{
    stu t;
    int n;
    cin>>n;
    cout<<"num "<<"name "<<"score "<<endl;
    for (int i=0;i<n;i++)
        cin>>s[i].num>>s[i].name>>s[i].score;
    for (int i=0;i<n-1;i++)
        for (int j=i;j<n-1;j++)
        {
            if (s[i].score>s[j+1].score)
            {
                t=s[i];
                s[i]=s[j+1];
                s[j+1]=t;
            }
        }
    stu *p;
    for (p=s;p<s+n;p++)
        cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
    return 0;
}

#include<iostream>
#include<cstring>
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
    int n;
    cin>>n;
    cout<<"num "<<"name "<<"score "<<endl;
    for (int i=0;i<n;i++)
        cin>>s[i].num>>s [i].name>>s [i].score;
    stu *p;
    for (p=s;p<s+n;p++)
        cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
    return 0;
}

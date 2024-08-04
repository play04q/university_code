#include<iostream>
using namespace std;
struct student
{
int num;
char name[10];
char sex;
int age;
float score;
};
student stu[3]=
{
    {10101,"LiLin",'M',18,100},
    {10102,"ZhangFan",'M',17,98},
    {10103,"WangMin",'M',18,99}
};
int main()
{
    student *p;
    for (p=stu;p<stu+3;p++)
        cout<<p->num<<' '<<p->name<<' '<<p->sex<<' '<<p->age<<' '<<p->score<<endl;
    for(p=stu;p<stu+3;p++)
        cout<<(*p).num<<' '<<(*p).name<<' '<<(*p).sex;
        cout<<' '<<(*p).age<<' '<<(*p).score<<endl;
    return 0; 
}
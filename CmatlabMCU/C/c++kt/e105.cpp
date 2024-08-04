#include <iostream>
#include <string.h>
using namespace std;
int n=0;
struct student
{
    int num;
    char name [10];
    float score;
};
student s[100];
//信息显示子程序
void disp()
{
    student*p;
    cout<<endl<<endl;
    cout<<"num "<<"name "<<"score "<<endl;
    for(p=s;p<=s+n-1;p++)
        cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
    system("pause");
}
//人员添加子程序
void inse()
{
    int num0,bj=0;
    student*p;
    cout<<endl<<endl;
    cout<<endl<<"   请输入学号";
    cin>>num0;
    cout<<endl<<endl;
    for (p=s;p<=s+n-1;p++)
    {
        if((*p).num==num0)
        {
            bj=1;
            break;
        }
    }
    if(bj==1)
    {
        cout<<endl<<"  学号存在"<<endl<<endl;
        system("pause");
    }
    else
    {
        s[n].num=num0;
        cout<<"num"<<"name "<<"score "<<endl<<endl;
        cout<<s[n].num<<" ";
        cin>>s[n].name>>s[n].score;
        n++;
        disp();
    }
}
//人员信息查找子程序
void find()
{
    int num0,bj=0;
    student*p;
    cout<<endl<<endl;
    cout<<endl<<"请输入学生学号:";
    cin>>num0;
    cout<<endl<<endl;
    for(p=s;p<=s+n-1;p++)
    {
        if((*p).num==num0)
        {
            cout<<"num "<<"name "<<"score "<<endl;
            cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
            bj=1;
        }
    }
    if(bj==0)
        cout<<endl<<"无此学号学生！"<<endl<<endl;
    system("pause");
}
//人员信息删除子程序
void dele()
{
    int num0,bj=0;
    student*p;
    cout<<endl<<endl;
    cout<<endl<<"请输入学生学号:";
    cin>>num0;
    cout<<endl<<endl;
    for(p=s;p<=s+n-1;p++)
    {
        if((*p).num==num0)
        {
            for(;p<=s+n-1;p++)
            {
                (*p).num=(*(p+1)).num;
                strcpy((*p).name,(*(p+1)).name);
                (*p).score=(*(p+1)).score;
            }
            (*(p-1)).num=0;
            strcpy((*(p-1)).name," ");
            (*(p-1)).score=0;
            n--;
            bj=1;
            cout<<endl<<"  该学号学生删除完毕！";
        }
    }
    if(bj==0)
        cout<<endl<<" 无此学号学生！"<<endl<<endl;
    system("pause");
}
//人员信息修改子程序
void modi()
{
    int num0,bj=0;
    student*p;
    cout<<endl<<endl;
    cout<<endl<<"  请输入学生学号:";
    cin>>num0;
    cout<<endl<<endl;
    for(p=s;p<=s+n-1;p++)
    {
        if((*p).num=-num0)
        {
            cout<<"num "<<"name "<<"score "<<endl;
            cout<<(*p).num<<' '<<p->name<<' '<<p->score<<endl;
            bj=1;
            cout<<endl<<"修改如下"<<endl;
            cout<<(*p).num<<" ";
            cin>>p->name>>p->score;
        }
    }
    if(bj==0)
        cout<<endl<<"  无此学号学生！"<<endl<<endl;
    system("pause");
}
//排序子程序
void sort()
{
    student t;
    for(int i=0;i<n-1;i++)
    {
        for(int j=i;j<n-1;j++)
        {
            if(s[i].score>s[j+1].score)
            {
                t=s[i];
                s[i]=s[j+1];
                s[j+1]=t;
            }
        }
    }
    disp();
}
//主程序
int main()
{
    while(1)
    {
        system("cls");
        cout<<endl<<endl;
        cout<<"  学生管理系统"<<endl<<endl;
        for(int i=0;i<30;i++)
            cout<<"*";
        cout<<endl<<endl;
        cout<<"   1.添加一个学生"<<endl;
        cout<<"   2.查找一个学生"<<endl;
        cout<<"   3.删除一个学生"<<endl;
        cout<<"   4.修改一个学生"<<endl;
        cout<<"   5.学生成绩排序"<<endl;
        cout<<"   6.退出系统    "<<endl;
        for(int i=0;i<30;i++)
            cout<<"*";
        cout<<endl<<endl;
        char ch;
        cout<<"   请选择输入选项[1-6]:   ";
        cin>>ch;
        switch(ch)
        {
            case 'l':inse();break;
            case '2':find();break;
            case '3':dele();break;
            case '4':modi();break;
            case '5':sort();break;
            case '6':return 0;
            others:break;
        }
    }
}

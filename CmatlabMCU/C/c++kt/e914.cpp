#include<iostream>
using namespace std;
int main()
{
    int a=0,b=1;
    int c[]={0,1,2,3,4,5,6,7,8,9,10};
    int *p;
    p=&a;
    cout<<"p=&a "<<p<<endl;
    (*p)=3;
    cout<<"(*p)=3 "<<(*p)<<endl;
    (*p)=b;
    cout<<"(*p)=b "<<(*p)<<endl;
    //p=b;
    p=&b;
    cout<<"p=&b "<<p<<endl;
    p=c+6;
    cout<<"p=c+6 "<<p<<endl;
    cout<<"*p "<<*p<<endl;
    p++;
    cout<<"p++ "<<p<<endl;
    p=NULL;
    //cout<<*p;
    return 0;
}
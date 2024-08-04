#include <iostream>
#include <cmath>
using namespace std;
double p1,p2,p,k=819501.5915,v1,v2,h,h1,s,x,g=10.0;
int main()
{
    double sina,pi=3.14159,d,A;
    cout<<"设定（国际单位制）"<<endl;
    cout<<"水的密度"<<"  "<<"水管长度"<<"  "<<"水管的直径"<<"  "<<"两地的高差"<<endl;
    cin>>p>>s>>d>>h;
    A=(pi/4)*pow(d,2);
    if(h!=0)
        sina=s/h;
    cout<<endl;
    while (true)
    {
        cout<<"1"<<" "<<"流速"<<" "<<"水压"<<endl;
        cin>>v1>>p1;
        cout<<"2"<<" "<<"流速"<<" "<<"水压"<<endl;
        cin>>v2>>p2;
        h1=(p2+p1+2*p*k*(pow(A,3.5))*(pow(v1,2))+p*g*h)/(2*p*g+4*p*k*(pow(A,3.5))*g);
        x=h1/sina;
        cout<<x<<endl;
    }
    return 0;
}
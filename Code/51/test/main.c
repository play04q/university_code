#include <REGX52.H>			
//8051单片机呼吸灯程序 (简易版) 
 
sbit LED = P2^0;       //定义接LED的IO口 
 
void Delay(unsigned int t)    //一个非常快的延时函数，用于改变LED亮灭的时间 
{
		while(t--);
}
 
void main()
{
	while(1)
	{
  		unsigned int Time;			
  		
	for(Time=0;Time<600;Time++)	       //由暗到亮
    {
		  LED=1;				    //LED亮 ，使用开发板P2口LED这里改成=0
		  Delay(Time);				//经过fou循环，Time从0开始，每次亮的时间+1，直到 >=600 结束 
		  LED=0;				    //LED灭 ，使用开发板P2口LED这里改成=1
		  Delay(600-Time);			//总的时间 - 亮的时间 = 灭的时间 
	 }
	 
	 for(Time=600;Time>0;Time--)	  //由亮到暗 
    {
		  LED=1;					//LED亮 ，使用开发板P2口LED这里改成=0
		  Delay(Time);				//亮的时间从600开始减，一直到0结束 
		  LED=0;				    //LED灭 ，使用开发板P2口LED这里改成=1
		  Delay(600-Time);			//总的时间 - 亮的时间 = 灭的时间 
	 }
	 
	}
}
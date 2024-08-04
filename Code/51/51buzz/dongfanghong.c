#include <reg52.h>
sbit beep = P2^5;
unsigned char timer0H, timer0L, time;

//单片机晶振采用11.0592MHz
// 高八度     
code unsigned char FREQH[] = {
    0xF2, 0xF3, 0xF5, 0xF5, 0xF6, 0xF7, 0xF8,    //低音
    0xF9, 0xF9, 0xFA, 0xFA, 0xFB, 0xFB, 0xFC, 0xFC,//标准
    0xFC, 0xFD, 0xFD, 0xFD, 0xFD, 0xFE,            //高音 
    0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFF};   //超高音 
// 低八度
code unsigned char FREQL[] = {
    0x42, 0xC1, 0x17, 0xB6, 0xD0, 0xD1, 0xB6,    //低音
    0x21, 0xE1, 0x8C, 0xD8, 0x68, 0xE9, 0x5B, 0x8F, //标准
    0xEE, 0x44, 0x6B, 0xB4, 0xF4, 0x2D,             //高音
    0x47, 0x77, 0xA2, 0xB6, 0xDA, 0xFA, 0x16};   //超高音
code unsigned char song[] = {
5,2,2,  5,2,1,  6,2,1,  2,2,4,  1,2,2,  1,2,1,  6,1,1,  2,2,4,
5,2,2,  5,2,2,  6,2,1,  1,3,1,  6,2,1,  5,2,1,  1,2,2,  1,2,1,  6,1,1, 2,2,4,
5,2,2,  2,2,2,  1,2,1,  7,1,1,  6,1,1,  5,1,2,  5,2,2,  2,2,2,
3,2,1,  2,2,1,  1,2,2,  1,2,1,  6,1,1,
2,2,1,  3,2,1,  2,2,1,  1,2,1,  2,2,1,  1,2,1,  7,1,1,  6,1,1,  5,1,4,  5,1,4,
0,0,0,
};

void t0int() interrupt 1         //T0中断程序，控制发音的音调
{
    TR0 = 0;                     //先关闭T0
    beep = !beep;          //输出方波, 发音
    TH0 = timer0H;               //下次的中断时间, 这个时间, 控制音调高低
    TL0 = timer0L;
    TR0 = 1;                     //启动T0
}

void delay(unsigned char t)     //延时程序，控制发音的时间长度
{
    unsigned char t1;
    unsigned long t2;
    for(t1 = 0; t1 < t; t1++)    //双重循环, 共延时t个半拍
      for(t2 = 0; t2 < 10000; t2++); //延时期间, 可进入T0中断去发音
    TR0 = 0;                        //关闭T0, 停止发音
}

void sing()                      //演奏一个音符
{
    TH0 = timer0H;               //控制音调
    TL0 = timer0L;
    TR0 = 1;                     //启动T0, 由T0输出方波去发音
    delay(time);                 //控制时间长度
}

void main(void)
{
    unsigned char k, i;
    TMOD = 1;                    //置T0定时工作方式1
    ET0 = 1;                     //开T0中断
    EA = 1;                      //开总中断
    while(1) 
	{
      i = 0;
      time = 1; 
      while(time) 
	  {
        k = song[i] + 7 * song[i + 1] - 1;//第i个是音符, 第i+1个是第几个八度
        timer0H = FREQH[k];      //从数据表中读出频率数值
        timer0L = FREQL[k];      //时间长度
        time = song[i + 2];   //读出时间长度数值
        i += 3;
        sing();                  //发出一个音符
	  }  
    }  
}
#include <reg51.h>
#include <intrins.h>
#define  uchar unsigned char
#define  uint unsigned int
#define	BOOL bit 
sbit RS= P1^7;						//LCD指令数据选择
sbit RW= P1^6;						//LCD读/写操作选择
sbit EN= P1^5;						//LCD使能
sbit P3_5= P3^5;					//控制MAX487发送（1）和接收（0）
BOOL flag;							//与主机通信成功标记
uchar code tab0[] = {"Proteu 7.8"};	//LCD第1行显示
uchar code tab1[] = {"Count: "};	//LCD第2行显示
uchar code tab2[] = {"1234567890"};	//LCD通信次数1位显示
void delay(uint ms)					// 毫秒延时子程序
{
	uint i;
	while(ms--)
	{
		for(i = 0; i< 250; i++)
		{
			_nop_();
			_nop_();
			_nop_();
			_nop_();
		}
	}
}
BOOL lcd_bz()						// 测试LCD忙状态
{
	BOOL result;
	RS = 0;
	RW = 1;
	EN = 1;
	_nop_();
	_nop_();
	_nop_();
	_nop_();
	result = (BOOL)(P0&0x80);		//取BF值
	EN = 0;
	return result;	
}
void lcd_wcmd(uchar cmd)			// 写入指令数据到LCD
{
	while(lcd_bz());
	RS = 0;
	RW = 0;
	EN = 0;
	_nop_();
	_nop_();	
	P2= cmd;
	_nop_();
	_nop_();
	_nop_();
	//_nop_();
	EN = 1;
	_nop_();
	_nop_();
	_nop_();
	//_nop_();
	EN = 0;		
}
void lcd_pos(uchar pos)			//设定显示位置
{
	lcd_wcmd(pos | 0x80);		//最高位D7恒定为高电平1
}
void lcd_wdat(uchar dat)		//写入字符显示数据到LCD
{
	while(lcd_bz());
	RS = 1;
	RW = 0;
	EN= 0;
	P2= dat;
	_nop_();
	_nop_();
	_nop_();
	EN = 1;
	_nop_();
	_nop_();
	_nop_();
	EN= 0;	
}
void lcd_init()					//LCD初始化设定
{
	lcd_wcmd(0x38);				//功能设置：8位总线（DL=1）、双行显示（N=1）、
	delay(1);					//5×7点阵字符（F=0）
	lcd_wcmd(0x0c);				//显示开/关控制：开显示（D=1）、无光标（C=0）
	delay(1);					//不闪烁（B=0）
	lcd_wcmd(0x06);				//光标和显示模式设置：数据读写屏幕画面不动
	delay(1);					//AC自动加1
	lcd_wcmd(0x01);				//清显示：清除LCD的显示内容，AC置0
	delay(1);
}
void serial (void) interrupt 4 	//串行口中断子程序
{
	ES=0;						//关闭串口中断，准备处理数据
	RI=0;		
	if(SBUF==0x01)	 			//判断从主机接收的地址是否与本机一致
	{					
		P3_5=1;			   		//准备向主机发送数据
		SBUF=0x10;		  		//向主机发送数据，高4位供BCD数码管显示
		while(TI!=1);
		TI=0;
		flag=1;					//与主机通信成功标记置1
		SM2=0;					//准备接收主机TB8=0的数据
		//add your code here!
	}					
	ES=1;						//允许串口中断
	P3_5=0;						//准备从主机接收地址或数据
	SM2=1;						//准备从主机接收TB8=1的地址
}
void main(void)
{
	uint i,j;
	SCON=0xf0;					//串行口工作于方式3，SM2=1多机通信，
	   							//REN=1可接收数据（也可发送）
	TMOD=0x20;					//定时器1自动重装载,同主机程序
	TH1=0xfd;					//波特率设置,同主机程序
	TL1=0xfd;
	TR1=1;
	EA=1;
	ES=1;
	P3_5=0;						//准备接收主机发来的地址(TB8=1)或数据(TB8=0)
	lcd_init();					// 初始化LCD			
	delay(10);
	lcd_pos(1);					// 设置显示位置为第1行的第2个字符
	i = 0;
	while(tab0[i] != '\0')		// 显示字符" Proteus 7.8"
	{
		lcd_wdat(tab0[i]);
		i++;
	}
	lcd_pos(0x41);				// 设置显示位置为第2行第2个字符
	i = 0;
	while(tab1[i] != '\0')
	{
		lcd_wdat(tab1[i]);		// 显示字符" Count: "
		i++;
	}
	j=0;
	flag=0;	
  	while(1)
	{
		if(flag==1)
		{
			lcd_pos(0x49);		// 设置显示位置为第2行第2个字符
			lcd_wdat(tab2[j]);	// 显示对应字符"1234567890"
			j++;
			if(j==10)
			j=0;
			flag=0;
		}
	}
}

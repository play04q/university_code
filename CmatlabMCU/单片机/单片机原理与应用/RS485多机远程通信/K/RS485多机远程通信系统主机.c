#include<reg51.h>
#include<absacc.h>
#include<intrins.h>
unsigned char cort=0;
sbit P3_5=P3^5;				//����MAX487���ͣ�1���ͽ��գ�0��
void master(void)			//�����ӳ���
{
	if(cort==1)				//��1#�ӻ�ͨ��
	{	
		SBUF=0x01;		   	//����1#�ӻ���ַ
		while(TI!=1);
		TI=0;
		P3_5=0;		   		//׼������1#�ӻ�����������
		SM2=0;				//׼�����յ�9λTB8Ϊ0������
		while(RI!=1);
		RI=0;
		P2=SBUF;		 	//BCD�������ʾ1#�ӻ����������ݵĸ�4λ
		//add your code here!
	}		
	if(cort==2)	 			//��2#�ӻ�ͨ��
	{
		SBUF=0x02; 			//����2#�ӻ���ַ
		while(TI!=1);
		TI=0;
		P3_5=0;				//׼������2#�ӻ�����������
		SM2=0;				//׼�����յ�9λTB8Ϊ0������	
		while(RI!=1);
		RI=0;
		P2=SBUF;  			//BCD�������ʾ2#�ӻ����������ݵĸ�4λ
		//add your code here!		
	}							 
	if(cort==2)
	cort=0;
	SM2=1;				//׼�������дӻ������µĵ�ַ
	P3_5=1;			   	//׼������		
}
key_serial() interrupt 0 	//����ɨ���ӳ���
{	 
	 ++cort;				//��������
	 master(); 				//�����ӳ���
}
void main(void)
{
	
	P2=0xf0;	 			//BCD�������ʾF��P2�ڸ�4λ���ƣ�
	SCON=0xf8;				//���пڹ����ڷ�ʽ3��SM2=1���ͨ�ţ�
	   						//REN=1�ɽ������ݣ�TB8=1���͵�ַ			
	TMOD=0x20;				//T1�����ڷ�ʽ2���������ʷ�������
	TL1=0xfd;				//�����ʣ�fosc/32/12/��256-253��
	TH1=0xfd;
	TR1=1;	
	EA=1;
	EX0=1;
	IT0=1;
	P3_5=1;					//׼�����͵�ַ
	while(1)
	{
		_nop_();
	}
}

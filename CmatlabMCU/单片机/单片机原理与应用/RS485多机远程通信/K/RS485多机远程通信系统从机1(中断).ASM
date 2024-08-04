		ORG		0000H
		AJMP	MAIN
		ORG		0023H
		AJMP	INT
		ORG 	0100H
		RS 		BIT 	P1.7	;LCD液晶显示指令数据选择控制
	   	RW 		BIT 	P1.6	;LCD液晶显示读写选择控制
	   	EN 		BIT 	P1.5	;LCD液晶显示使能控制
	   	LCD 	EQU 	P2		;LCD液晶显示控制P2口
		P3_5	BIT		P3.5	;控制MAX487发送（1）和接收（0）
MAIN:   MOV 	SP,#60H
		MOV 	SCON,#0F0H		;串行口工作于方式3，SM2=1多机通信
	   							;REN=1可接收数据（也可发送）
		MOV 	TMOD,#20H		;定时器1自动重装载,同主机程序
	   	MOV 	TH1,#0FDH		;波特率设置,同主机程序
	   	MOV 	TL1,#0FDH
	   	SETB 	TR1
		SETB	ES
		SETB	EA
					 								  	
		ACALL 	INIT_LCD		;调用初始化子程序
	    MOV 	LCD,#81H		;定位第1行第2个位置
   	   	ACALL 	WR_COMM			;调用写指令子程序
	   	MOV 	DPTR,#TAB0		;送第1行文本首地址
	   	ACALL 	DISP_LCD		;调用查表显示子程序
	   	MOV 	P2,#0C1H		;定位第2行第2个位置
	   	ACALL 	WR_COMM
	   	MOV 	DPTR,#TAB1		;送第2行文本首地址
	   	ACALL 	DISP_LCD		;调用查表显示子程序
		MOV 	40H,#00H		; 存放与主机通信次数,用于对应显示
		CLR		P3_5
SERIAL:	NOP
		AJMP	SERIAL      
INT:	CLR		ES
		CLR		RI
		MOV 	A ,SBUF
		CJNE 	A,#01,SERIAL0	;接收数据非01,转SERIAL0
		SETB	P3_5			;准备向主机发送数据
		MOV		SBUF,#10H;		;向主机发送数据，高4位供BCD数码管显示
		JNB		TI,$
		CLR		TI
		CLR		SM2				;准备接收主机TB8=0的数据
		;add your code here!
	    ;显示次数
		MOV 	A,40H
		MOV 	P2,#0C9H		;每次均定位第2行第10个位置
		ACALL 	WR_COMM
		MOV 	DPTR ,#TAB2		;送第2显示次数对应数字表首地址	
 		MOV 	A,40H			;显示次数送A
		MOVC 	A,@A+DPTR		;表中找到显示次数字符对应地址
		MOV 	LCD,A			;显示该字符
		ACALL 	WR_DATA
		INC 	40H	
		MOV 	A,40H
		CJNE 	A,#10,SERIAL0	;未达到10次,转SERIAL0
		MOV 	40H,#00H		;达到10次,重新计数
SERIAL0:CLR		P3_5			;准备从主机接收
		SETB 	SM2				;准备从主机接收地址
		SETB	ES
		RETI
DISP_LCD:  						;查表显示子程序
		MOV 	A,#00H
		MOVC 	A,@A+DPTR
		CJNE 	A,#0FFH,SS		;是否是最后一个字符
		AJMP 	EXIT
SS: 	MOV 	LCD,A
		ACALL 	WR_DATA
		INC 	DPTR
		AJMP 	DISP_LCD
EXIT:	RET
INIT_LCD:						;初始化子程序
		MOV 	LCD,#01H		;清屏
		ACALL 	WR_COMM
		MOV 	LCD,#00000110B	;数据读写屏幕画面不动,AC自动加1
		ACALL 	WR_COMM
		MOV 	LCD,#00001100B	;开显示,无光标,不闪烁
		ACALL 	WR_COMM
		MOV 	LCD ,#38H		;功能设置：8位数据,双行显示,5×7点阵字符
		ACALL 	WR_COMM
		RET
WR_COMM:						;写命令子程序
		CLR		RS				;选择指令寄存器
		CLR		RW				;选择写模式
		CLR		EN				;禁止写LCD
		ACALL	DELAY			;调用延时或忙检测
		SETB	EN				;允许写LCD
		RET
WR_DATA:						;写数据子程序
		SETB 	RS
		CLR 	RW
		CLR 	EN
		ACALL 	DELAY			;调用延时或忙检测
		SETB 	EN
		RET	 	
DELAY:  						;忙检测
		MOV 	LCD,#0FFH	
		CLR 	RS
		SETB 	RW
		CLR  	EN
		NOP
		SETB 	EN
		JB 		LCD.7,DELAY		;忙位检测
		RET
TAB0:   DB 		"Proteus 7.1",0FFH ;显示字库	   
TAB1:   DB 		"Count:",0FFH
TAB2:   DB 		"1234567890"
		END

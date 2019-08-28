#include "led.h"
#include "beep.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "ILI93xx.h"
#include "usart.h"	 
#include "24cxx.h"
#include "flash.h"
#include "touch.h"
#include "sram.h"
#include "timer.h"
#include "sdio_sdcard.h"
#include "malloc.h"
#include "GUI.h"
#include "ff.h"
#include "exfuns.h"
#include "w25qxx.h"
#include "includes.h"
#include "FramewinDLG.h"
#include "WM.h"
#include "DIALOG.h"
#include "AD9854.h"
#include "stm32f10x.h"
//#include "adc.h"
#include "bsp_spi_ad7606.h"
/************************************************
 优先级0：中断服务服务管理任务 OS_IntQTask()
 优先级1：时钟节拍任务 OS_TickTask()
 优先级2：定时任务 OS_TmrTask()
 优先级OS_CFG_PRIO_MAX-2：统计任务 OS_StatTask()
 优先级OS_CFG_PRIO_MAX-1：空闲任务 OS_IdleTask()
************************************************/

#define source_res 2000//源内阻
#define load_res		2000//负载电阻，10k
#define signal_in	50//输入信号的幅度（50mv)
#define ADC_times 4//采样求平均次数

//任务优先级
#define START_TASK_PRIO				3
//任务堆栈大小	
#define START_STK_SIZE 				128
//任务控制块
OS_TCB StartTaskTCB;
//任务堆栈	
CPU_STK START_TASK_STK[START_STK_SIZE];
//任务函数
void start_task(void *p_arg);

//TOUCH任务
//设置任务优先级
#define TOUCH_TASK_PRIO				4
//任务堆栈大小
#define TOUCH_STK_SIZE				128
//任务控制块
OS_TCB TouchTaskTCB;
//任务堆栈
CPU_STK TOUCH_TASK_STK[TOUCH_STK_SIZE];
//touch任务
void touch_task(void *p_arg);

////LED0任务
////设置任务优先级
//#define LED0_TASK_PRIO 				5
////任务堆栈大小
//#define LED0_STK_SIZE				128
////任务控制块
//OS_TCB Led0TaskTCB;
////任务堆栈
//CPU_STK LED0_TASK_STK[LED0_STK_SIZE];
////led0任务
//void led0_task(void *p_arg);

//EMWINDEMO任务
//设置任务优先级
#define EMWINDEMO_TASK_PRIO			5
//任务堆栈大小
#define EMWINDEMO_STK_SIZE			1350
//任务控制块
OS_TCB EmwindemoTaskTCB;
//任务堆栈
CPU_STK EMWINDEMO_TASK_STK[EMWINDEMO_STK_SIZE];
//emwindemo_task任务
void emwindemo_task(void *p_arg);

//定时器
OS_TMR tmr1;
void tmr1_callback(void *p_tmr, void *p_arg);//定时器1的回调函数


void switch_Init(void);//继电器电平控制引脚初始化函数

extern int mod;
ulong Freq = 500;
u8 count_Freq = 0;
uint Amp_input = 500;//50*18(18为比例系数)
uint Amp_output = 270;
//16 ADC_value = 0;
int ADC_store_P[200];//存储采集到的ADC值正峰值，用于画图；
int ADC_store_N[200];//存储采集到的ADC负峰值，用于画图；
//int ADC_store_PP[200];//存储采集到的峰峰值
int ADC_Res_In_P[2];//测量输入电阻所用的ADC采样正值
int ADC_Res_In_N[2];//测量输入电阻所用的ADC采样负值
int ADC_Res_In_PP[2];//峰峰值
int ADC_Res_Out_P[2];//测量输出电阻所用的ADC采样正值
int ADC_Res_Out_N[2];//负值
int ADC_Res_Out_PP[2];//峰峰值

int ADC_Signal_out_P[1];//测量电路增益所用的ADC采样正值
int ADC_Signal_out_N[1];//测量电路增益所用的ADC采样负值
int ADC_Signal_out_PP[1];//峰峰值

//int Gain_graph[200];
int Gain_res[2];
//float Resistance_Input(void);//输入电阻计算函数
//float Resistance_Output(void);//输出电阻计算函数
//int Gain(void);//增益计算函数
//float Resis_In=0,Resis_Out=0;
int ADC_Input_P,ADC_Input_N;
int ADC_DC[5];


int main(void)
{	
	OS_ERR err;
	CPU_SR_ALLOC();
	
	delay_init();	    	//延时函数初始化	  
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 	//设置NVIC中断分组2:2位抢占优先级，2位响应优先级
	uart_init(115200);	 	//串口初始化为115200
 	LED_Init();			    //LED端口初始化
	TFTLCD_Init();			//LCD初始化	
	KEY_Init();	 			//按键初始化
//	BEEP_Init();			//初始化蜂鸣器
	FSMC_SRAM_Init();		//初始化SRAM
	my_mem_init(SRAMIN); 	//初始化内部内存池
	my_mem_init(SRAMEX);  	//初始化外部内存池
	
	exfuns_init();			//为fatfs文件系统分配内存
	f_mount(fs[0],"0:",1);	//挂载SD卡
	f_mount(fs[1],"1:",1);	//挂载FLASH
	TP_Init();				//触摸屏初始化
	AD9854_Init();//AD9854初始化
	//Adc_Init();//初始化ADC
	bsp_InitAD7606();//AD7606初始化
	AD_RANGE_10V();//将AD的采样范围设置为10V
	ad7606_StartRecord(20000);
	
	GPIO_ResetBits(GPIOB,GPIO_Pin_5);
	GPIO_ResetBits(GPIOE,GPIO_Pin_5);
	
	switch_Init();//端口初始化
	
	OSInit(&err);			//初始化UCOSIII
	OS_CRITICAL_ENTER();	//进入临界区
	//创建开始任务
	OSTaskCreate((OS_TCB 	* )&StartTaskTCB,		//任务控制块
				 (CPU_CHAR	* )"start task", 		//任务名字
                 (OS_TASK_PTR )start_task, 			//任务函数
                 (void		* )0,					//传递给任务函数的参数
                 (OS_PRIO	  )START_TASK_PRIO,     //任务优先级
                 (CPU_STK   * )&START_TASK_STK[0],	//任务堆栈基地址
                 (CPU_STK_SIZE)START_STK_SIZE/10,	//任务堆栈深度限位
                 (CPU_STK_SIZE)START_STK_SIZE,		//任务堆栈大小
                 (OS_MSG_QTY  )0,					//任务内部消息队列能够接收的最大消息数目,为0时禁止接收消息
                 (OS_TICK	  )0,					//当使能时间片轮转时的时间片长度，为0时为默认长度，
                 (void   	* )0,					//用户补充的存储区
                 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
                 (OS_ERR 	* )&err);				//存放该函数错误时的返回值
	OS_CRITICAL_EXIT();	//退出临界区	 
	OSStart(&err);  //开启UCOSIII
	while(1);
}

//开始任务函数
void start_task(void *p_arg)
{
	OS_ERR err;
	CPU_SR_ALLOC();
	p_arg = p_arg;

	CPU_Init();
#if OS_CFG_STAT_TASK_EN > 0u
   OSStatTaskCPUUsageInit(&err);  	//统计任务                
#endif
	
#ifdef CPU_CFG_INT_DIS_MEAS_EN		//如果使能了测量中断关闭时间
    CPU_IntDisMeasMaxCurReset();	
#endif

#if	OS_CFG_SCHED_ROUND_ROBIN_EN  //当使用时间片轮转的时候
	 //使能时间片轮转调度功能,时间片长度为1个系统时钟节拍，既1*5=5ms
	OSSchedRoundRobinCfg(DEF_ENABLED,1,&err);  
#endif		
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_CRC,ENABLE);//开启CRC时钟
	WM_SetCreateFlags(WM_CF_MEMDEV); 	//启动所有窗口的存储设备
	GUI_Init();  			//STemWin初始化
		//创建定时器1
	OSTmrCreate((OS_TMR		*)&tmr1,		//定时器1
                (CPU_CHAR	*)"tmr1",		//定时器名字
                (OS_TICK	 )20,			//20*10=200ms
                (OS_TICK	 )50,          //10*1=10ms，相当于200*10ms=2s完成一次扫频
                (OS_OPT		 )OS_OPT_TMR_PERIODIC, //周期模式
                (OS_TMR_CALLBACK_PTR)tmr1_callback,//定时器1回调函数
                (void	    *)0,			//参数为0
                (OS_ERR	    *)&err);		//返回的错误码

	OS_CRITICAL_ENTER();	//进入临界区
	//STemWin Demo任务	
	OSTaskCreate((OS_TCB*     )&EmwindemoTaskTCB,		
				 (CPU_CHAR*   )"Emwindemo task", 		
                 (OS_TASK_PTR )emwindemo_task, 			
                 (void*       )0,					
                 (OS_PRIO	  )EMWINDEMO_TASK_PRIO,     
                 (CPU_STK*    )&EMWINDEMO_TASK_STK[0],	
                 (CPU_STK_SIZE)EMWINDEMO_STK_SIZE/10,	
                 (CPU_STK_SIZE)EMWINDEMO_STK_SIZE,		
                 (OS_MSG_QTY  )0,					
                 (OS_TICK	  )0,  					
                 (void*       )0,					
                 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR,
                 (OS_ERR*     )&err);
	//触摸屏任务
	OSTaskCreate((OS_TCB*     )&TouchTaskTCB,		
				 (CPU_CHAR*   )"Touch task", 		
                 (OS_TASK_PTR )touch_task, 			
                 (void*       )0,					
                 (OS_PRIO	  )TOUCH_TASK_PRIO,     
                 (CPU_STK*    )&TOUCH_TASK_STK[0],	
                 (CPU_STK_SIZE)TOUCH_STK_SIZE/10,	
                 (CPU_STK_SIZE)TOUCH_STK_SIZE,		
                 (OS_MSG_QTY  )0,					
                 (OS_TICK	  )0,  					
                 (void*       )0,					
                 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR,
                 (OS_ERR*     )&err);			 
	OS_TaskSuspend((OS_TCB*)&StartTaskTCB,&err);		//挂起开始任务			 
	OS_CRITICAL_EXIT();	//退出临界区
}

//EMWINDEMO任务
void emwindemo_task(void *p_arg)
{
	//更换皮肤
	BUTTON_SetDefaultSkin(BUTTON_SKIN_FLEX); 
	CHECKBOX_SetDefaultSkin(CHECKBOX_SKIN_FLEX);
	DROPDOWN_SetDefaultSkin(DROPDOWN_SKIN_FLEX);
	FRAMEWIN_SetDefaultSkin(FRAMEWIN_SKIN_FLEX);
	HEADER_SetDefaultSkin(HEADER_SKIN_FLEX);
	MENU_SetDefaultSkin(MENU_SKIN_FLEX);
	MULTIPAGE_SetDefaultSkin(MULTIPAGE_SKIN_FLEX);
	PROGBAR_SetDefaultSkin(PROGBAR_SKIN_FLEX);
	RADIO_SetDefaultSkin(RADIO_SKIN_FLEX);
	SCROLLBAR_SetDefaultSkin(SCROLLBAR_SKIN_FLEX);
	SLIDER_SetDefaultSkin(SLIDER_SKIN_FLEX);
	SPINBOX_SetDefaultSkin(SPINBOX_SKIN_FLEX);
	CreateFramewin();
	while(1)
	{
		GUI_Delay(100); 
	}
}

//TOUCH任务
void touch_task(void *p_arg)
{
	OS_ERR err;
//	int i;
	while(1)
	{
		if(count_Freq==200)
		{
			OSTmrStop(&tmr1,OS_OPT_TMR_NONE,0,&err);//此时停止计数
			count_Freq = 0;//Freq=1000;//扫频结束后将DDS的输出频率设置为1kHz
			Freq=1000;
			AD9854_SetSine(Freq,Amp_output);
			ADC_Res_Out_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
			ADC_Res_Out_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
			g_tAD.usWrite = 0;
			//printf("Freq=%d\n",Freq);
			mod = 6;//跳转到default状态
			//ad7606_StopRecord();//停止采样
			//g_tAD.usWrite = 0;
		}//最初mod为4
		switch(mod)
		{
			case 0:{//0为初始状态，用于开启扫频计数器，设置初始状态，
							//当计数为0时，打开计数器
							OSTmrStart(&tmr1,&err);
							//ad7606_StartRecord(20000);
							GPIO_ResetBits(GPIOB,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_2);
				
							AD9854_SetSine(Freq,Amp_input);//扫频函数，设置为50mv
//							ADC_store_P[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
//							ADC_store_N[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							g_tAD.usWrite = 0;
							mod =1;
							}//此时为基础部分扫频的第一个状态
			case 1:{//采初始时刻的样值
//							ADC_store_P[count_Freq-1]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
//							ADC_store_N[count_Freq-1]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//							g_tAD.usWrite = 0;
							AD9854_SetSine(Freq,Amp_input);
							ADC_store_P[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
							ADC_store_N[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							g_tAD.usWrite = 0;
							break;
							}//基础部分扫频的第二个状态
			
			case 2:{
							AD9854_SetSine(Freq,Amp_input);
							GPIO_ResetBits(GPIOE,GPIO_Pin_5);
							GPIO_SetBits(GPIOB,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_2);
							//ad7606_StartRecord(20000);	
							ADC_Res_In_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
							ADC_Res_In_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							ADC_Res_In_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];//2k内阻时的
							
							printf("ADC1=%d\n",ADC_Res_In_P[1]);
							printf("ADC2=%d\n",ADC_Res_In_N[1]);
							g_tAD.usWrite = 0;//清楚残留数据
							break;  
							//ad7606_StopRecord();break;
					}//切换继电器挡位，测量源内阻为2k时的输出电压幅度
			case 3:{
							GPIO_ResetBits(GPIOB,GPIO_Pin_5);
							GPIO_SetBits(GPIOE,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_2);
							AD9854_SetSine(Freq,Amp_output);
							//ad7606_StartRecord(20000);	
							ADC_Res_Out_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
							ADC_Res_Out_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							ADC_Res_Out_PP[1]=ADC_Res_Out_P[1]-ADC_Res_Out_N[1];
							printf("ADC3=%d\n",ADC_Res_Out_P[1]);
							printf("ADC4=%d\n",ADC_Res_Out_N[1]);
							printf("ADC_PP=%d\n",ADC_Res_Out_PP[1]);
							g_tAD.usWrite = 0;//清楚残留数据
							
							//ad7606_StopRecord();//停止记录
							break;
			}//切换继电器挡位，测量负载为2k时的输出电压幅度
			case 4:{
								AD9854_SetSine(1000,40);
								GPIO_ResetBits(GPIOB,GPIO_Pin_5);
								GPIO_SetBits(GPIOE,GPIO_Pin_2);
								GPIO_ResetBits(GPIOE,GPIO_Pin_5);
								ADC_DC[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								ADC_DC[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								ADC_DC[2]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								g_tAD.usWrite = 0;//清楚残留数据
								//printf("adcdc=%d\n",ADC_DC[0]);
								break;
			}
			case 6:{
						Freq=1000;
						AD9854_SetSine(Freq,Amp_output);
						ADC_Res_Out_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
						ADC_Res_Out_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
						ADC_Res_Out_PP[0]=ADC_Res_Out_P[0]-ADC_Res_Out_N[0];
//						printf("ADCO1=%d",ADC_Res_Out_P[0]);
//						printf("ADCO2=%d",ADC_Res_Out_N[0]);
						g_tAD.usWrite = 0;
						break;
			}
			default:GPIO_ResetBits(GPIOE,GPIO_Pin_5);break;
			 
			}
		
//			if((mod == 0)&&(count_Freq==0))
//		{
//			OSTmrStart(&tmr1,&err);
//		}
				//选择几个点频
		GUI_TOUCH_Exec();	
		OSTimeDlyHMSM(0,0,0,5,OS_OPT_TIME_PERIODIC,&err);//延时5ms
	}
}
 


//定时器1的回调函数
void tmr1_callback(void *p_tmr, void *p_arg)
{
	static u8 tmr1_num=0;
	Freq = count_Freq*1000;
	count_Freq++;
	tmr1_num++;		//定时器1执行次数加1
}
//float Resistance_Input(void)//输入电阻计算函数
//{
//			float Res_In = 0;
////			delay_ms(1000);
////			ad7606_StartRecord(20000);//开始采样
////			g_tAD.usWrite = 0;
////			ADC_Res_In_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//取十次ADC的平均值；即平常状态下源内阻为0得到的值；
////			ADC_Res_In_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
////			g_tAD.usWrite = 0;
////			ad7606_StopRecord();
////			printf("ADC1=%d\n",ADC_Res_In_P[0]);
////			printf("ADC2=%d\n",ADC_Res_In_N[0]);
////			ADC_Res_In_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];
//			
//			GPIO_SetBits(GPIOB,GPIO_Pin_5);  //输入端继电器短路，使得电阻变为短路，源内阻变为0；LED0，对应引脚GPIOB.5拉高，亮  等同LED0=0;PB5
//			//delay_ms(6000);
//			ad7606_StartRecord(20000);
//			ADC_Res_In_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//取十次ADC的平均值；即平常状态下源内阻为0得到的值；
//			ADC_Res_In_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//			printf("ADC3=%d\n",ADC_Res_In_P[1]);
//			printf("ADC4=%d\n",ADC_Res_In_N[1]);
//			g_tAD.usWrite = 0;//清楚残留数据
//			ad7606_StopRecord();
//			ADC_Res_In_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];
//			
//			delay_ms(1000);
//			GPIO_ResetBits(GPIOB,GPIO_Pin_5);//再将引脚拉低，恢复初始状态
//			ad7606_StartRecord(20000);//开始采样
//			//g_tAD.usWrite = 0;
//			ADC_Res_In_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//取十次ADC的平均值；即平常状态下源内阻为0得到的值；
//			ADC_Res_In_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//			printf("ADC1=%d\n",ADC_Res_In_P[0]);
//			printf("ADC2=%d\n",ADC_Res_In_N[0]);
//			g_tAD.usWrite = 0;
//			ad7606_StopRecord();
//			ADC_Res_In_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];
//			delay_ms(1000);
//			Res_In=(ADC_Res_In_PP[0] - ADC_Res_In_PP[1])*source_res/ADC_Res_In_PP[1];//得到输出电阻值
//			return Res_In;
//}

//float Resistance_Output(void)//输出电阻计算函数
//{
//		float Res_Out= 2000;
//		delay_ms(6000);
//		ad7606_StartRecord(20000);
//		ADC_Res_Out_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//取十次ADC的平均值；即平常状态下源内阻为0得到的值；
//		ADC_Res_Out_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//		printf("ADC2_1=%d\n",ADC_Res_Out_P[0]);
//		printf("ADC2_2=%d\n",ADC_Res_Out_N[0]);
//		g_tAD.usWrite = 0;
//		ad7606_StopRecord();
//		ADC_Res_Out_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];//采10次电压得到平均值，即平常状态下负载开路的状况
//		GPIO_SetBits(GPIOE,GPIO_Pin_5);//拉高PE5的电平，使得PE5亮，使得射随器前的输入电阻接入。负载约为10KΩ
//		delay_ms(6000);
//		ad7606_StartRecord(20000);
//		ADC_Res_Out_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//取十次ADC的平均值；即平常状态下源内阻为0得到的值；
//		ADC_Res_Out_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//		printf("ADC2_3=%d\n",ADC_Res_Out_P[1]);
//		printf("ADC2_4=%d\n",ADC_Res_Out_N[1]);
//		g_tAD.usWrite = 0;
//		ADC_Res_Out_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];//采10次电压得到平均值，即平常状态下负载开路的状况
//		GPIO_ResetBits(GPIOE,GPIO_Pin_5);//再将引脚拉低恢复初始状态；
//		Res_Out=(ADC_Res_Out_PP[0]-ADC_Res_Out_PP[1])*load_res/ADC_Res_Out_PP[1];
//		ad7606_StopRecord();
//		return Res_Out;
//}

//int Gain(void)//增益计算函数
//{
//	int i;
//	ad7606_StartConv();
//	AD_CS_LOW();
//	for (i = 0; i < 2; i++)
//	{
//		Gain_res[i] = ad7606_ReadBytes();	
//	}		
//	
//	AD_CS_HIGH();
//	return Gain_res[0];
////	g_tAD.usWrite = 0;

//}

void switch_Init(void)
{
 
 GPIO_InitTypeDef  GPIO_InitStructure;
 	
 RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOE, ENABLE);	 //使能PE端口时钟
	
 GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;				 //LED0-->PE2 端口配置
 GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP; 		 //推挽输出
 GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;		 //IO口速度为50MHz
 GPIO_Init(GPIOE, &GPIO_InitStructure);					 //根据设定参数初始化GPIOE2
 GPIO_ResetBits(GPIOE,GPIO_Pin_2);						 //PE2 输出高

}
 


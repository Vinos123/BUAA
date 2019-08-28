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
 ���ȼ�0���жϷ������������� OS_IntQTask()
 ���ȼ�1��ʱ�ӽ������� OS_TickTask()
 ���ȼ�2����ʱ���� OS_TmrTask()
 ���ȼ�OS_CFG_PRIO_MAX-2��ͳ������ OS_StatTask()
 ���ȼ�OS_CFG_PRIO_MAX-1���������� OS_IdleTask()
************************************************/

#define source_res 2000//Դ����
#define load_res		2000//���ص��裬10k
#define signal_in	50//�����źŵķ��ȣ�50mv)
#define ADC_times 4//������ƽ������

//�������ȼ�
#define START_TASK_PRIO				3
//�����ջ��С	
#define START_STK_SIZE 				128
//������ƿ�
OS_TCB StartTaskTCB;
//�����ջ	
CPU_STK START_TASK_STK[START_STK_SIZE];
//������
void start_task(void *p_arg);

//TOUCH����
//�����������ȼ�
#define TOUCH_TASK_PRIO				4
//�����ջ��С
#define TOUCH_STK_SIZE				128
//������ƿ�
OS_TCB TouchTaskTCB;
//�����ջ
CPU_STK TOUCH_TASK_STK[TOUCH_STK_SIZE];
//touch����
void touch_task(void *p_arg);

////LED0����
////�����������ȼ�
//#define LED0_TASK_PRIO 				5
////�����ջ��С
//#define LED0_STK_SIZE				128
////������ƿ�
//OS_TCB Led0TaskTCB;
////�����ջ
//CPU_STK LED0_TASK_STK[LED0_STK_SIZE];
////led0����
//void led0_task(void *p_arg);

//EMWINDEMO����
//�����������ȼ�
#define EMWINDEMO_TASK_PRIO			5
//�����ջ��С
#define EMWINDEMO_STK_SIZE			1350
//������ƿ�
OS_TCB EmwindemoTaskTCB;
//�����ջ
CPU_STK EMWINDEMO_TASK_STK[EMWINDEMO_STK_SIZE];
//emwindemo_task����
void emwindemo_task(void *p_arg);

//��ʱ��
OS_TMR tmr1;
void tmr1_callback(void *p_tmr, void *p_arg);//��ʱ��1�Ļص�����


void switch_Init(void);//�̵�����ƽ�������ų�ʼ������

extern int mod;
ulong Freq = 500;
u8 count_Freq = 0;
uint Amp_input = 500;//50*18(18Ϊ����ϵ��)
uint Amp_output = 270;
//16 ADC_value = 0;
int ADC_store_P[200];//�洢�ɼ�����ADCֵ����ֵ�����ڻ�ͼ��
int ADC_store_N[200];//�洢�ɼ�����ADC����ֵ�����ڻ�ͼ��
//int ADC_store_PP[200];//�洢�ɼ����ķ��ֵ
int ADC_Res_In_P[2];//��������������õ�ADC������ֵ
int ADC_Res_In_N[2];//��������������õ�ADC������ֵ
int ADC_Res_In_PP[2];//���ֵ
int ADC_Res_Out_P[2];//��������������õ�ADC������ֵ
int ADC_Res_Out_N[2];//��ֵ
int ADC_Res_Out_PP[2];//���ֵ

int ADC_Signal_out_P[1];//������·�������õ�ADC������ֵ
int ADC_Signal_out_N[1];//������·�������õ�ADC������ֵ
int ADC_Signal_out_PP[1];//���ֵ

//int Gain_graph[200];
int Gain_res[2];
//float Resistance_Input(void);//���������㺯��
//float Resistance_Output(void);//���������㺯��
//int Gain(void);//������㺯��
//float Resis_In=0,Resis_Out=0;
int ADC_Input_P,ADC_Input_N;
int ADC_DC[5];


int main(void)
{	
	OS_ERR err;
	CPU_SR_ALLOC();
	
	delay_init();	    	//��ʱ������ʼ��	  
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 	//����NVIC�жϷ���2:2λ��ռ���ȼ���2λ��Ӧ���ȼ�
	uart_init(115200);	 	//���ڳ�ʼ��Ϊ115200
 	LED_Init();			    //LED�˿ڳ�ʼ��
	TFTLCD_Init();			//LCD��ʼ��	
	KEY_Init();	 			//������ʼ��
//	BEEP_Init();			//��ʼ��������
	FSMC_SRAM_Init();		//��ʼ��SRAM
	my_mem_init(SRAMIN); 	//��ʼ���ڲ��ڴ��
	my_mem_init(SRAMEX);  	//��ʼ���ⲿ�ڴ��
	
	exfuns_init();			//Ϊfatfs�ļ�ϵͳ�����ڴ�
	f_mount(fs[0],"0:",1);	//����SD��
	f_mount(fs[1],"1:",1);	//����FLASH
	TP_Init();				//��������ʼ��
	AD9854_Init();//AD9854��ʼ��
	//Adc_Init();//��ʼ��ADC
	bsp_InitAD7606();//AD7606��ʼ��
	AD_RANGE_10V();//��AD�Ĳ�����Χ����Ϊ10V
	ad7606_StartRecord(20000);
	
	GPIO_ResetBits(GPIOB,GPIO_Pin_5);
	GPIO_ResetBits(GPIOE,GPIO_Pin_5);
	
	switch_Init();//�˿ڳ�ʼ��
	
	OSInit(&err);			//��ʼ��UCOSIII
	OS_CRITICAL_ENTER();	//�����ٽ���
	//������ʼ����
	OSTaskCreate((OS_TCB 	* )&StartTaskTCB,		//������ƿ�
				 (CPU_CHAR	* )"start task", 		//��������
                 (OS_TASK_PTR )start_task, 			//������
                 (void		* )0,					//���ݸ��������Ĳ���
                 (OS_PRIO	  )START_TASK_PRIO,     //�������ȼ�
                 (CPU_STK   * )&START_TASK_STK[0],	//�����ջ����ַ
                 (CPU_STK_SIZE)START_STK_SIZE/10,	//�����ջ�����λ
                 (CPU_STK_SIZE)START_STK_SIZE,		//�����ջ��С
                 (OS_MSG_QTY  )0,					//�����ڲ���Ϣ�����ܹ����յ������Ϣ��Ŀ,Ϊ0ʱ��ֹ������Ϣ
                 (OS_TICK	  )0,					//��ʹ��ʱ��Ƭ��תʱ��ʱ��Ƭ���ȣ�Ϊ0ʱΪĬ�ϳ��ȣ�
                 (void   	* )0,					//�û�����Ĵ洢��
                 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //����ѡ��
                 (OS_ERR 	* )&err);				//��Ÿú�������ʱ�ķ���ֵ
	OS_CRITICAL_EXIT();	//�˳��ٽ���	 
	OSStart(&err);  //����UCOSIII
	while(1);
}

//��ʼ������
void start_task(void *p_arg)
{
	OS_ERR err;
	CPU_SR_ALLOC();
	p_arg = p_arg;

	CPU_Init();
#if OS_CFG_STAT_TASK_EN > 0u
   OSStatTaskCPUUsageInit(&err);  	//ͳ������                
#endif
	
#ifdef CPU_CFG_INT_DIS_MEAS_EN		//���ʹ���˲����жϹر�ʱ��
    CPU_IntDisMeasMaxCurReset();	
#endif

#if	OS_CFG_SCHED_ROUND_ROBIN_EN  //��ʹ��ʱ��Ƭ��ת��ʱ��
	 //ʹ��ʱ��Ƭ��ת���ȹ���,ʱ��Ƭ����Ϊ1��ϵͳʱ�ӽ��ģ���1*5=5ms
	OSSchedRoundRobinCfg(DEF_ENABLED,1,&err);  
#endif		
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_CRC,ENABLE);//����CRCʱ��
	WM_SetCreateFlags(WM_CF_MEMDEV); 	//�������д��ڵĴ洢�豸
	GUI_Init();  			//STemWin��ʼ��
		//������ʱ��1
	OSTmrCreate((OS_TMR		*)&tmr1,		//��ʱ��1
                (CPU_CHAR	*)"tmr1",		//��ʱ������
                (OS_TICK	 )20,			//20*10=200ms
                (OS_TICK	 )50,          //10*1=10ms���൱��200*10ms=2s���һ��ɨƵ
                (OS_OPT		 )OS_OPT_TMR_PERIODIC, //����ģʽ
                (OS_TMR_CALLBACK_PTR)tmr1_callback,//��ʱ��1�ص�����
                (void	    *)0,			//����Ϊ0
                (OS_ERR	    *)&err);		//���صĴ�����

	OS_CRITICAL_ENTER();	//�����ٽ���
	//STemWin Demo����	
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
	//����������
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
	OS_TaskSuspend((OS_TCB*)&StartTaskTCB,&err);		//����ʼ����			 
	OS_CRITICAL_EXIT();	//�˳��ٽ���
}

//EMWINDEMO����
void emwindemo_task(void *p_arg)
{
	//����Ƥ��
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

//TOUCH����
void touch_task(void *p_arg)
{
	OS_ERR err;
//	int i;
	while(1)
	{
		if(count_Freq==200)
		{
			OSTmrStop(&tmr1,OS_OPT_TMR_NONE,0,&err);//��ʱֹͣ����
			count_Freq = 0;//Freq=1000;//ɨƵ������DDS�����Ƶ������Ϊ1kHz
			Freq=1000;
			AD9854_SetSine(Freq,Amp_output);
			ADC_Res_Out_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
			ADC_Res_Out_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
			g_tAD.usWrite = 0;
			//printf("Freq=%d\n",Freq);
			mod = 6;//��ת��default״̬
			//ad7606_StopRecord();//ֹͣ����
			//g_tAD.usWrite = 0;
		}//���modΪ4
		switch(mod)
		{
			case 0:{//0Ϊ��ʼ״̬�����ڿ���ɨƵ�����������ó�ʼ״̬��
							//������Ϊ0ʱ���򿪼�����
							OSTmrStart(&tmr1,&err);
							//ad7606_StartRecord(20000);
							GPIO_ResetBits(GPIOB,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_2);
				
							AD9854_SetSine(Freq,Amp_input);//ɨƵ����������Ϊ50mv
//							ADC_store_P[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
//							ADC_store_N[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							g_tAD.usWrite = 0;
							mod =1;
							}//��ʱΪ��������ɨƵ�ĵ�һ��״̬
			case 1:{//�ɳ�ʼʱ�̵���ֵ
//							ADC_store_P[count_Freq-1]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
//							ADC_store_N[count_Freq-1]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//							g_tAD.usWrite = 0;
							AD9854_SetSine(Freq,Amp_input);
							ADC_store_P[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
							ADC_store_N[count_Freq]= ((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							g_tAD.usWrite = 0;
							break;
							}//��������ɨƵ�ĵڶ���״̬
			
			case 2:{
							AD9854_SetSine(Freq,Amp_input);
							GPIO_ResetBits(GPIOE,GPIO_Pin_5);
							GPIO_SetBits(GPIOB,GPIO_Pin_5);
							GPIO_ResetBits(GPIOE,GPIO_Pin_2);
							//ad7606_StartRecord(20000);	
							ADC_Res_In_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);
							ADC_Res_In_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
							ADC_Res_In_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];//2k����ʱ��
							
							printf("ADC1=%d\n",ADC_Res_In_P[1]);
							printf("ADC2=%d\n",ADC_Res_In_N[1]);
							g_tAD.usWrite = 0;//�����������
							break;  
							//ad7606_StopRecord();break;
					}//�л��̵�����λ������Դ����Ϊ2kʱ�������ѹ����
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
							g_tAD.usWrite = 0;//�����������
							
							//ad7606_StopRecord();//ֹͣ��¼
							break;
			}//�л��̵�����λ����������Ϊ2kʱ�������ѹ����
			case 4:{
								AD9854_SetSine(1000,40);
								GPIO_ResetBits(GPIOB,GPIO_Pin_5);
								GPIO_SetBits(GPIOE,GPIO_Pin_2);
								GPIO_ResetBits(GPIOE,GPIO_Pin_5);
								ADC_DC[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								ADC_DC[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								ADC_DC[2]=((int32_t)10000)*((float)((short)g_tAD.usBuf[2])/32768);
								g_tAD.usWrite = 0;//�����������
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
				//ѡ�񼸸���Ƶ
		GUI_TOUCH_Exec();	
		OSTimeDlyHMSM(0,0,0,5,OS_OPT_TIME_PERIODIC,&err);//��ʱ5ms
	}
}
 


//��ʱ��1�Ļص�����
void tmr1_callback(void *p_tmr, void *p_arg)
{
	static u8 tmr1_num=0;
	Freq = count_Freq*1000;
	count_Freq++;
	tmr1_num++;		//��ʱ��1ִ�д�����1
}
//float Resistance_Input(void)//���������㺯��
//{
//			float Res_In = 0;
////			delay_ms(1000);
////			ad7606_StartRecord(20000);//��ʼ����
////			g_tAD.usWrite = 0;
////			ADC_Res_In_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//ȡʮ��ADC��ƽ��ֵ����ƽ��״̬��Դ����Ϊ0�õ���ֵ��
////			ADC_Res_In_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
////			g_tAD.usWrite = 0;
////			ad7606_StopRecord();
////			printf("ADC1=%d\n",ADC_Res_In_P[0]);
////			printf("ADC2=%d\n",ADC_Res_In_N[0]);
////			ADC_Res_In_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];
//			
//			GPIO_SetBits(GPIOB,GPIO_Pin_5);  //����˼̵�����·��ʹ�õ����Ϊ��·��Դ�����Ϊ0��LED0����Ӧ����GPIOB.5���ߣ���  ��ͬLED0=0;PB5
//			//delay_ms(6000);
//			ad7606_StartRecord(20000);
//			ADC_Res_In_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//ȡʮ��ADC��ƽ��ֵ����ƽ��״̬��Դ����Ϊ0�õ���ֵ��
//			ADC_Res_In_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//			printf("ADC3=%d\n",ADC_Res_In_P[1]);
//			printf("ADC4=%d\n",ADC_Res_In_N[1]);
//			g_tAD.usWrite = 0;//�����������
//			ad7606_StopRecord();
//			ADC_Res_In_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];
//			
//			delay_ms(1000);
//			GPIO_ResetBits(GPIOB,GPIO_Pin_5);//�ٽ��������ͣ��ָ���ʼ״̬
//			ad7606_StartRecord(20000);//��ʼ����
//			//g_tAD.usWrite = 0;
//			ADC_Res_In_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//ȡʮ��ADC��ƽ��ֵ����ƽ��״̬��Դ����Ϊ0�õ���ֵ��
//			ADC_Res_In_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//			printf("ADC1=%d\n",ADC_Res_In_P[0]);
//			printf("ADC2=%d\n",ADC_Res_In_N[0]);
//			g_tAD.usWrite = 0;
//			ad7606_StopRecord();
//			ADC_Res_In_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];
//			delay_ms(1000);
//			Res_In=(ADC_Res_In_PP[0] - ADC_Res_In_PP[1])*source_res/ADC_Res_In_PP[1];//�õ��������ֵ
//			return Res_In;
//}

//float Resistance_Output(void)//���������㺯��
//{
//		float Res_Out= 2000;
//		delay_ms(6000);
//		ad7606_StartRecord(20000);
//		ADC_Res_Out_P[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//ȡʮ��ADC��ƽ��ֵ����ƽ��״̬��Դ����Ϊ0�õ���ֵ��
//		ADC_Res_Out_N[0]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//		printf("ADC2_1=%d\n",ADC_Res_Out_P[0]);
//		printf("ADC2_2=%d\n",ADC_Res_Out_N[0]);
//		g_tAD.usWrite = 0;
//		ad7606_StopRecord();
//		ADC_Res_Out_PP[0]=ADC_Res_In_P[0]-ADC_Res_In_N[0];//��10�ε�ѹ�õ�ƽ��ֵ����ƽ��״̬�¸��ؿ�·��״��
//		GPIO_SetBits(GPIOE,GPIO_Pin_5);//����PE5�ĵ�ƽ��ʹ��PE5����ʹ��������ǰ�����������롣����ԼΪ10K��
//		delay_ms(6000);
//		ad7606_StartRecord(20000);
//		ADC_Res_Out_P[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[0])/32768);//ȡʮ��ADC��ƽ��ֵ����ƽ��״̬��Դ����Ϊ0�õ���ֵ��
//		ADC_Res_Out_N[1]=((int32_t)10000)*((float)((short)g_tAD.usBuf[1])/32768);
//		printf("ADC2_3=%d\n",ADC_Res_Out_P[1]);
//		printf("ADC2_4=%d\n",ADC_Res_Out_N[1]);
//		g_tAD.usWrite = 0;
//		ADC_Res_Out_PP[1]=ADC_Res_In_P[1]-ADC_Res_In_N[1];//��10�ε�ѹ�õ�ƽ��ֵ����ƽ��״̬�¸��ؿ�·��״��
//		GPIO_ResetBits(GPIOE,GPIO_Pin_5);//�ٽ��������ͻָ���ʼ״̬��
//		Res_Out=(ADC_Res_Out_PP[0]-ADC_Res_Out_PP[1])*load_res/ADC_Res_Out_PP[1];
//		ad7606_StopRecord();
//		return Res_Out;
//}

//int Gain(void)//������㺯��
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
 	
 RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOE, ENABLE);	 //ʹ��PE�˿�ʱ��
	
 GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;				 //LED0-->PE2 �˿�����
 GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP; 		 //�������
 GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;		 //IO���ٶ�Ϊ50MHz
 GPIO_Init(GPIOE, &GPIO_InitStructure);					 //�����趨������ʼ��GPIOE2
 GPIO_ResetBits(GPIOE,GPIO_Pin_2);						 //PE2 �����

}
 


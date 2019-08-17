/*
*********************************************************************************************************
*	                                  
*	模块名称 : AD7606驱动模块
*	文件名称 : bsp_spi_ad7606.c
*	版    本 : V1.3
*	说    明 : 驱动AD7606 ADC转换器 SPI接口
*
*
*********************************************************************************************************
*/

#include "stm32f10x.h"
#include <stdio.h>
//#include "bsp.h"
#include "bsp_spi_ad7606.h"
//#include "bsp_timer.h"

FIFO_T	g_tAD;	/* 定义一个交换缓冲区，用于存储AD采集数据，并用于写入SD卡 */

void bsp_TIM4_Configuration(void);

/*
*********************************************************************************************************
*	函 数 名: bsp_InitAD7606
*	功能说明: 初始化AD7606 SPI口线
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void bsp_InitAD7606(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure;
	SPI_InitTypeDef   SPI_InitStructure;
	
	/* AD_SPI_CS_GPIO, AD_SPI_MOSI_GPIO, AD_SPI_MISO_GPIO, AD_SPI_DETECT_GPIO 
	   and AD_SPI_SCK_GPIO Periph clock enable */
	RCC_APB2PeriphClockCmd(AD_CS_GPIO_CLK | AD_SPI_MISO_GPIO_CLK | AD_SPI_SCK_GPIO_CLK
			, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = AD_SPI_SCK_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(AD_SPI_SCK_GPIO_PORT, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = AD_CS_PIN;
	GPIO_Init(AD_CS_GPIO_PORT, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = AD_SPI_MISO_PIN;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(AD_SPI_MISO_GPIO_PORT, &GPIO_InitStructure);
	/* 配置其它的GPIO */

	/* 使能GPIO时钟 */
	RCC_APB2PeriphClockCmd(AD_RESET_GPIO_CLK | AD_CONVST_GPIO_CLK | AD_RANGE_GPIO_CLK | AD_OS0_GPIO_CLK 
		| AD_OS1_GPIO_CLK | AD_OS2_GPIO_CLK, ENABLE);

	/* 配置RESET GPIO */
	GPIO_InitStructure.GPIO_Pin = AD_RESET_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(AD_RESET_GPIO_PORT, &GPIO_InitStructure);
	
	/* 配置CONVST GPIO */
	GPIO_InitStructure.GPIO_Pin = AD_CONVST_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(AD_CONVST_GPIO_PORT, &GPIO_InitStructure);

	/* 配置RANGE GPIO */
	GPIO_InitStructure.GPIO_Pin = AD_RANGE_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(AD_RANGE_GPIO_PORT, &GPIO_InitStructure);
	
	/* 配置OS0-2 GPIO */
	GPIO_InitStructure.GPIO_Pin = AD_OS0_PIN;
	GPIO_Init(AD_OS0_GPIO_PORT, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = AD_OS1_PIN;
	GPIO_Init(AD_OS1_GPIO_PORT, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = AD_OS2_PIN;
	GPIO_Init(AD_OS2_GPIO_PORT, &GPIO_InitStructure);

	/* 设置过采样模式 */
	ad7606_SetOS(0);

	/* 设置GPIO的初始状态 */
	ad7606_Reset();				/* 硬件复位复AD7606 */
	
	AD_CONVST_HIGH();			/* CONVST脚设置为高电平 */	

	bsp_TIM4_Configuration();	/* 配置TIM2定时中断 */		
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_Reset
*	功能说明: 硬件复位AD7606
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_Reset(void)
{
	/* AD7606是高电平复位，要求最小脉宽50ns */
	
	AD_RESET_LOW();
	
	AD_RESET_HIGH();
	AD_RESET_HIGH();
	AD_RESET_HIGH();
	AD_RESET_HIGH();
	
	AD_RESET_LOW();
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_SetOS
*	功能说明: 设置过采样模式（数字滤波，硬件求平均值)
*	形    参：_ucMode : 0-6  0表示无过采样，1表示2倍，2表示4倍，3表示8倍，4表示16倍
*				5表示32倍，6表示64倍
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_SetOS(uint8_t _ucMode)
{
	if (_ucMode == 1)
	{
		AD_OS2_0();
		AD_OS1_0();
		AD_OS0_1();
	}
	else if (_ucMode == 2)
	{
		AD_OS2_0();
		AD_OS1_1();
		AD_OS0_0();
	}
	else if (_ucMode == 3)
	{
		AD_OS2_0();
		AD_OS1_1();
		AD_OS0_1();
	}
	else if (_ucMode == 4)
	{
		AD_OS2_1();
		AD_OS1_0();
		AD_OS0_0();
	}
	else if (_ucMode == 5)
	{
		AD_OS2_1();
		AD_OS1_0();
		AD_OS0_1();
	}
	else if (_ucMode == 6)
	{
		AD_OS2_1();
		AD_OS1_1();
		AD_OS0_0();
	}
	else	/* 按0处理 */
	{
		AD_OS2_0();
		AD_OS1_0();
		AD_OS0_0();
	}
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_StartConv
*	功能说明: 启动AD7606的ADC转换
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_StartConv(void)
{
	/* 上升沿开始转换，低电平持续时间至少25ns  */
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	AD_CONVST_LOW();	/* 连续执行2次，低电平约50ns */
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	AD_CONVST_LOW();
	
	AD_CONVST_HIGH();
}

/*
*********************************************************************************************************
*	函 数 名: bsp_TIM4_Configuration
*	功能说明: 配置TIM4定时器
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void bsp_TIM4_Configuration(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	
	/* TIM2 clock enable */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM4, ENABLE);  

	/* Configure the NVIC Preemption Priority Bits[配置优先级组] */  
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);

	/* Enable the TIM2 gloabal Interrupt [允许TIM2全局中断]*/
	NVIC_InitStructure.NVIC_IRQChannel = TIM4_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;  
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
}
	
/*
*********************************************************************************************************
*	函 数 名: bsp_SET_TIM4_FREQ
*	功能说明: 设置TIM4定时器频率
*	形    参：_ulFreq : 采样频率，单位Hz，
*	返 回 值: 无
*********************************************************************************************************
*/
void bsp_SET_TIM4_FREQ(uint32_t _ulFreq)
{
	TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;
	uint16_t usPrescaler;
	uint16_t usPeriod;

	TIM_DeInit(TIM4);	/* 复位TIM2定时器 */

	/* TIM2 configuration 
		TIM2CLK = 36 MHz	
	*/
	if (_ulFreq == 0)
	{
		return;		/* 采样频率为0，停止采样 */
	}
	else if (_ulFreq <= 100)   /* 采样频率小于100Hz */
	{
		usPrescaler = 36000;		/* TM2CLK = 72 000 000/36000 = 2000 */
		usPeriod = 2000 / _ulFreq;			 	
	}
	else if (_ulFreq <= 200000)	/* 采样频率 ：100Hz - 200kHz */
	{
		usPrescaler = 36 - 1;		/* TM2CLK = 36 000 000/36 = 2 000 000 */
		usPeriod = 2000000 / _ulFreq;
	}	
	else	/* 采样频率大于 200kHz */
	{
		return;
	}
	
	TIM_TimeBaseStructure.TIM_Period = usPeriod - 1; 		/* 计数周期 */
	TIM_TimeBaseStructure.TIM_Prescaler = usPrescaler;	/* 分频系数 */
	TIM_TimeBaseStructure.TIM_ClockDivision = 0x0; 		/* */
	TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;  //计数方向向上计数
	TIM_TimeBaseInit(TIM4, &TIM_TimeBaseStructure);

	/* Clear TIM2 update pending flag[清除TIM2溢出中断标志] */
	TIM_ClearFlag(TIM4, TIM_FLAG_Update);

	TIM_SetCounter(TIM4, 0);

	/* Enable TIM2 Update interrupt [TIM2溢出中断允许]*/
	TIM_ITConfig(TIM4, TIM_IT_Update, ENABLE);  

	/* TIM2 enable counter [允许tim2计数]*/
	TIM_Cmd(TIM4, ENABLE);
}  

//SPI写数据
//向触摸屏IC写入1byte数据    
//num:要写入的数据
void SPI_SendData(u16 data)    
{  
	u8 count=0;   
	AD_SCK_LOW();	//下降沿有效
	for(count=0;count<16;count++)  
	{ 	  
		if(data&0x8000)
			AD_MISO_LOW();  
		else 
			AD_MISO_HIGH();   
		data<<=1;    
		AD_SCK_LOW(); 	 
		AD_CSK_HIGH();		//上升沿有效	        
	}		 			    
} 		 
//SPI读数据 
//从触摸屏IC读取adc值
//CMD:指令
//返回值:读到的数据	   
//u16 SPI_ReceiveData(void)	  
//{ 	 
//	u8 count=0; 	  
//	u16 Num=0; 
//	AD_SCK_LOW();		//先拉低时钟 	 	     	    
//	for(count=0;count<16;count++)//读出16位数据,只有高12位有效 
//	{ 				  
//		Num<<=1; 	 
//		AD_SCK_LOW();	//下降沿有效  	    	   
//		AD_CSK_HIGH();
//		
//		if(AD_MISO_IN)Num++;
//	}
//	return(Num);
//}
u16 SPI_ReceiveData(void)	  
{ 	 
	u8 count=0; 	  
	u16 Num=0; 
	AD_CSK_HIGH();	
	for(count=0;count<16;count++)//读出16位数据
	{
		Num<<=1;
		AD_SCK_LOW();	//下降沿有效
		if(AD_MISO_IN)Num++;
		AD_CSK_HIGH();
	}
	return(Num);
}
/*
*********************************************************************************************************
*	函 数 名: ad7606_ReadBytes
*	功能说明: 读取AD7606的采样结果
*	形    参：
*	返 回 值: 无
*********************************************************************************************************
*/
uint16_t ad7606_ReadBytes(void)
{
  uint16_t usData = 0;
  
////  /* Wait until the transmit buffer is empty */
////  while (SPI_I2S_GetFlagStatus(AD_SPI, SPI_I2S_FLAG_TXE) == RESET)
////  {
////  }
  
//  /* Send the byte */
//  SPI_I2S_SendData(AD_SPI, 0xFFFF);
////	SPI_SendData(0xFFFF);

////  /* Wait until a data is received */
////  while (SPI_I2S_GetFlagStatus(AD_SPI, SPI_I2S_FLAG_RXNE) == RESET)
////  {
////  }
  
  /* Get the received data */
////  usData = SPI_I2S_ReceiveData(AD_SPI);
	usData = SPI_ReceiveData();

  /* Return the shifted data */
  return usData;
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_IRQSrc
*	功能说明: 定时调用本函数，用于读取AD转换器数据
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_IRQSrc(void)
{
	uint8_t i;
	uint16_t usReadValue;

	TIM_ClearFlag(TIM4, TIM_FLAG_Update);

	/* 读取数据 
	示波器监测，CS低电平持续时间 35us 
	*/
	AD_CS_LOW();
	for (i = 0; i < CH_NUM; i++)
	{
		usReadValue = ad7606_ReadBytes();	
		if (g_tAD.usWrite < FIFO_SIZE)
		{
			g_tAD.usBuf[g_tAD.usWrite] = usReadValue;
			++g_tAD.usWrite;
		}
	}		
	
	AD_CS_HIGH();
//	g_tAD.usWrite = 0;
	ad7606_StartConv();
}

/*
*********************************************************************************************************
*	函 数 名: GetAdcFormFifo
*	功能说明: 从FIFO中读取一个ADC值
*	形    参：_usReadAdc : 存放ADC结果的变量指针
*	返 回 值: 1 表示OK，0表示暂无数据
*********************************************************************************************************
*/
uint8_t GetAdcFormFifo(uint16_t *_usReadAdc)
{
	uint16_t usWrite;
	
	DISABLE_INT();	
	usWrite = g_tAD.usWrite;
	ENABLE_INT();
	
	if (usWrite != g_tAD.usRead)
	{
		*_usReadAdc = g_tAD.usBuf[g_tAD.usRead];

		DISABLE_INT();
		if (++g_tAD.usRead >= FIFO_SIZE)
		{
			g_tAD.usRead = 0;
		}		
		ENABLE_INT();
		return 1;		
	}
	return 0;
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_StartRecord
*	功能说明: 开始采集
*	形    参：_ulFreq : 采样频率, 单位 HZ
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_StartRecord(uint32_t _ulFreq)
{
	//ad7606_Reset();	/* 复位硬件 */

	ad7606_StartConv();				/* 启动采样，避免第1组数据全0的问题 */

	g_tAD.usRead = 0;				/* 必须在开启TIM2之前清0 */
	g_tAD.usWrite = 0;

	bsp_TIM4_Configuration();		/* 配置TIM2定时中断 */		

	bsp_SET_TIM4_FREQ(_ulFreq);		/* 设置采样频率, 并使能TIM2定时采样中断 */
}

/*
*********************************************************************************************************
*	函 数 名: ad7606_StopRecord
*	功能说明: 停止采集
*	形    参：无
*	返 回 值: 无
*********************************************************************************************************
*/
void ad7606_StopRecord(void)
{
	/* TIM2 enable counter [允许tim2计数]*/
	TIM_Cmd(TIM4, DISABLE);
}

void TIM4_IRQHandler(void)
{
	ad7606_IRQSrc();
}


/*
*********************************************************************************************************
*	                                  
*	ģ������ : AD7606����ģ�� 
*	�ļ����� : bsp_ad7606.h
*	��    �� : V1.3
*	˵    �� : ͷ�ļ�
*********************************************************************************************************
*/

#include "stdint.h"
#include "sys.h"

#ifndef __BSP_AD7606_H
#define __BSP_AD7606_H

/* ����ȫ���жϵĺ� */
#define ENABLE_INT()	__set_PRIMASK(0)	/* ʹ��ȫ���ж� */
#define DISABLE_INT()	__set_PRIMASK(1)	/* ��ֹȫ���ж� */

/* ÿ������2�ֽڣ��ɼ�ͨ�� */
#define CH_NUM			3		/* �ɼ�2ͨ�� */
#define FIFO_SIZE		1*2*2		/* ��С��Ҫ����48K (CPU�ڲ�RAM ֻ��64K) */

/* ����AD7606��SPI GPIO */

#define AD_SPI_SCK_PIN                   GPIO_Pin_13//PB13
#define AD_SPI_SCK_GPIO_PORT             GPIOB
#define AD_SPI_SCK_GPIO_CLK              RCC_APB2Periph_GPIOB

#define AD_SPI_MISO_PIN                  GPIO_Pin_14//PB14
#define AD_SPI_MISO_GPIO_PORT            GPIOB
#define AD_SPI_MISO_GPIO_CLK             RCC_APB2Periph_GPIOB

#define AD_CS_PIN                        GPIO_Pin_11//PB11
#define AD_CS_GPIO_PORT                  GPIOB
#define AD_CS_GPIO_CLK                   RCC_APB2Periph_GPIOB

/*������AD7606������GPIO */
#define AD_RESET_PIN                     GPIO_Pin_0//PF0
#define AD_RESET_GPIO_PORT               GPIOF
#define AD_RESET_GPIO_CLK                RCC_APB2Periph_GPIOF

#define AD_CONVST_PIN                    GPIO_Pin_1//PF1
#define AD_CONVST_GPIO_PORT              GPIOF		
#define AD_CONVST_GPIO_CLK               RCC_APB2Periph_GPIOF

#define AD_RANGE_PIN                     GPIO_Pin_2
#define AD_RANGE_GPIO_PORT               GPIOF		
#define AD_RANGE_GPIO_CLK                RCC_APB2Periph_GPIOF

#define AD_OS0_PIN                     GPIO_Pin_3
#define AD_OS0_GPIO_PORT               GPIOF		
#define AD_OS0_GPIO_CLK                RCC_APB2Periph_GPIOF

#define AD_OS1_PIN                     GPIO_Pin_4
#define AD_OS1_GPIO_PORT               GPIOF		
#define AD_OS1_GPIO_CLK                RCC_APB2Periph_GPIOF

#define AD_OS2_PIN                     GPIO_Pin_5
#define AD_OS2_GPIO_PORT               GPIOF		
#define AD_OS2_GPIO_CLK                RCC_APB2Periph_GPIOF

#define AD_CS_LOW()     				AD_CS_GPIO_PORT->BRR = AD_CS_PIN
#define AD_CS_HIGH()     				AD_CS_GPIO_PORT->BSRR = AD_CS_PIN

#define AD_RESET_LOW()					AD_RESET_GPIO_PORT->BRR = AD_RESET_PIN
#define AD_RESET_HIGH()					AD_RESET_GPIO_PORT->BSRR = AD_RESET_PIN
	
#define AD_CONVST_LOW()					AD_CONVST_GPIO_PORT->BRR = AD_CONVST_PIN
#define AD_CONVST_HIGH()				AD_CONVST_GPIO_PORT->BSRR = AD_CONVST_PIN

#define AD_RANGE_5V()					AD_RANGE_GPIO_PORT->BRR = AD_RANGE_PIN
#define AD_RANGE_10V()					AD_RANGE_GPIO_PORT->BSRR = AD_RANGE_PIN

#define AD_OS0_0()						AD_OS0_GPIO_PORT->BRR = AD_OS0_PIN
#define AD_OS0_1()						AD_OS0_GPIO_PORT->BSRR = AD_OS0_PIN

#define AD_OS1_0()						AD_OS1_GPIO_PORT->BRR = AD_OS1_PIN
#define AD_OS1_1()						AD_OS1_GPIO_PORT->BSRR = AD_OS1_PIN

#define AD_OS2_0()						AD_OS2_GPIO_PORT->BRR = AD_OS2_PIN
#define AD_OS2_1()						AD_OS2_GPIO_PORT->BSRR = AD_OS2_PIN

#define AD_MISO_LOW()					AD_SPI_MISO_GPIO_PORT->BRR  = AD_SPI_MISO_PIN
#define AD_MISO_HIGH()				AD_SPI_MISO_GPIO_PORT->BSRR = AD_SPI_MISO_PIN

#define AD_SCK_LOW()					AD_SPI_SCK_GPIO_PORT->BRR  = AD_SPI_SCK_PIN
#define AD_CSK_HIGH()				AD_SPI_SCK_GPIO_PORT->BSRR = AD_SPI_SCK_PIN

#define AD_MISO_IN					PBin(14)

/* AD���ݲɼ������� */
typedef struct
{
	uint16_t usRead;
	uint16_t usWrite;
	uint16_t usCount;
	uint16_t usBuf[FIFO_SIZE];
}FIFO_T;

/* ���ⲿ���õĺ������� */
void ad7606_Reset(void);
void ad7606_SetOS(uint8_t _ucMode);
void bsp_SET_TIM2_FREQ(uint32_t _ulFreq);
void bsp_InitAD7606(void);
void ad7606_StartRecord(uint32_t _ulFreq);
void ad7606_StopRecord(void);
uint8_t GetAdcFormFifo(uint16_t *_usReadAdc);
void ad7606_StartConv(void);
uint16_t ad7606_ReadBytes(void);

extern FIFO_T  g_tAD;

#endif



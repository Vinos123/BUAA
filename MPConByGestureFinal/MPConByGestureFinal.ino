#include <gForceAdapter.h>
//#include <MusicPlayer.h>
//#include <SPI.h>
//#include <SD.h>
//#include "Pins_config.h"
//#include "vs10xx.h"
//#include  <avr/pgmspace.h>

#define 	CON_VD 3
#define		CON_BK 6
#define		CON_PS 5
#define 	CON_NT 4
#define		CON_VU 7

GForceAdapter gforce = GForceAdapter(&Serial2);
//MusicPlayer player;
//VS10XX VS;
int state=1;
void setup()
{
  Serial2.begin(115200);
  Serial.begin(115200);
  //player.begin();
  
//  delay(500);
  //set pin mode to output
  pinMode(CON_VD, OUTPUT);
  pinMode(CON_BK, OUTPUT);
  pinMode(CON_PS, OUTPUT);
  pinMode(CON_NT, OUTPUT);
  pinMode(CON_VU, OUTPUT);

  // default set output low
  digitalWrite(CON_VD, HIGH);
  digitalWrite(CON_BK, HIGH);
  digitalWrite(CON_PS, HIGH);
  digitalWrite(CON_NT, HIGH);
  digitalWrite(CON_VU, HIGH);
  gforce.Init();
}

void loop()
{
  GF_Data gForceData;
  GF_Euler* euler;
  GF_Quaternion quat;
  float w_1,x_1,y_1,z_1;//四元数
  euler=(GF_Euler*)(malloc)(sizeof(GF_Euler));
  w_1=gForceData.value.quaternion.w;
  x_1=gForceData.value.quaternion.x;
  y_1=gForceData.value.quaternion.y;
  z_1=gForceData.value.quaternion.z;

  if (OK == gforce.GetGForceData(&gForceData))    //有效手势
  {
  quat = gForceData.value.quaternion;
    if(OK == gforce.QuaternionToEuler(&quat,euler) )  //空间方位角
  {
    Serial.println("start2*****************************************");
    }
    GF_Gesture gesture;
    switch (gForceData.type)
    {
      case GF_Data::QUATERNION :
      //Serial.println("break");
        break;
      case GF_Data::GESTURE :
        gesture = gForceData.value.gesture;
        Serial.println("gesture%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        if (gesture == GF_FIST)
        {
          if(state==1)
          {
            Serial.println("GF_FIST");
            digitalWrite(CON_PS,LOW);
            delay(500);
            digitalWrite(CON_PS,HIGH);
            Serial.println("PS");
            state=0;
          }
        }
        else if (gesture == GF_SPREAD)
        {
          //播放
          if(state==0)
          {
            Serial.println("GF_SPREAD");
            digitalWrite(CON_PS,LOW);
            delay(500);
            digitalWrite(CON_PS,HIGH);
            Serial.println("PS");
            state=1;
          }
        }
        else if (gesture == GF_WAVEOUT)//
        {
          //切到下一首歌
          Serial.println("GF_WAVEOUT");
          digitalWrite(CON_NT,LOW);
          delay(500);
          digitalWrite(CON_NT,HIGH);
          Serial.println("NT");
        }
        else if (gesture == GF_WAVEIN)
        {
          //切到上一首歌
          Serial.println("GF_WAVEIN");
          digitalWrite(CON_BK,LOW);
          delay(500);
          digitalWrite(CON_BK,HIGH);
          Serial.println("BK");
        }
        //不需要手势识别时防止误操作
      else if (gesture == GF_PINCH)
        {
          //停止手势识别操作
          Serial.println("GF_PINCH");
          digitalWrite(CON_VU,LOW);
          delay(500);
          digitalWrite(CON_VU,HIGH);
          Serial.println("VU");
       }
        else if (gesture == GF_SHOOT)
        {
          //开始手势识别操作
          Serial.println("GF_SHOOT");
          digitalWrite(CON_VD,LOW);
          delay(500);
          digitalWrite(CON_VD,HIGH);
          Serial.println("VD");
        }
        else if (gesture == GF_RELEASE)
        {
          Serial.println("GF_RELEASE");
         
        }
        else if (gesture == GF_UNKNOWN)
        {
          Serial.println("GF_UNKNOWN");
   
        }
        else
        Serial.println("nothing");
        break;
      default:
      Serial.println("default");
        break;
    }
  }
//  Serial.println("start2");
//  //用于显示
////  Serial.print(w_1);
////  Serial.print(x_1);
////  Serial.print(y_1);
////  Serial.print(z_1);
////  Serial.println(euler->yaw);
//  int roll ;
//  roll=(int)(euler->roll);//Roll角控制音量；
//  Serial.println(roll);

}

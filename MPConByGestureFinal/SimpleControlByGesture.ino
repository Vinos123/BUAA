
#include<UF_uArm.h>
#include <gForceAdapter.h>

UF_uArm uarm;

#define 	GFORCE_FIST_PIN		2
#define		GFORCE_SPREAD_PIN	3
#define		GFORCE_WAVEIN_PIN	4
#define 	GFORCE_WAVEOUT_PIN	5
#define		GFORCE_PINCH_PIN	6
#define		GFORCE_SHOOT_PIN	7

GForceAdapter gforce = GForceAdapter(&Serial);

void setup()
{
  uarm.init();          // initialize the uArm position
  uarm.setServoSpeed(SERVO_R, 50);  // 0=full speed, 1-255 slower to faster
  uarm.setServoSpeed(SERVO_L, 50);  // 0=full speed, 1-255 slower to faster
  uarm.setServoSpeed(SERVO_ROT, 50); // 0=full speed, 1-255 slower to faster
  delay(500);
  //set pin mode to output
  pinMode(GFORCE_FIST_PIN, OUTPUT);
  pinMode(GFORCE_SPREAD_PIN, OUTPUT);
  pinMode(GFORCE_WAVEIN_PIN, OUTPUT);
  pinMode(GFORCE_WAVEOUT_PIN, OUTPUT);
  pinMode(GFORCE_PINCH_PIN, OUTPUT);
  pinMode(GFORCE_SHOOT_PIN, OUTPUT);

  // default set output low
  digitalWrite(GFORCE_FIST_PIN, LOW);
  digitalWrite(GFORCE_SPREAD_PIN, LOW);
  digitalWrite(GFORCE_WAVEIN_PIN, LOW);
  digitalWrite(GFORCE_WAVEOUT_PIN, LOW);
  digitalWrite(GFORCE_PINCH_PIN, LOW);
  digitalWrite(GFORCE_SHOOT_PIN, LOW);
  gforce.Init();
}

void loop()
{
  GF_Data gForceData;
  GF_Euler* euler;
  GF_Quaternion quat;
  float w_1,x_1,y_1,z_1;
  euler=(GF_Euler*)(malloc)(sizeof(GF_Euler));
  w_1=gForceData.value.quaternion.w;
  x_1=gForceData.value.quaternion.x;
  y_1=gForceData.value.quaternion.y;
  z_1=gForceData.value.quaternion.z;
  

  if (OK == gforce.GetGForceData(&gForceData))
  {

 
  quat = gForceData.value.quaternion;
    if(OK == gforce.QuaternionToEuler(&quat,euler) )
  {
    Serial.println(1.5);
    }
   
  
    GF_Gesture gesture;
    switch (gForceData.type)
    {
      case GF_Data::QUATERNION :
      
        break;
      case GF_Data::GESTURE :
        gesture = gForceData.value.gesture;
        if (gesture == GF_FIST)
        {
          digitalWrite(GFORCE_FIST_PIN, HIGH);
          uarm.gripperCatch();
        }
        else if (gesture == GF_SPREAD)
        {
          digitalWrite(GFORCE_SPREAD_PIN, HIGH);
          uarm.gripperRelease();
        }
        else if (gesture == GF_WAVEIN)
        {
          digitalWrite(GFORCE_WAVEIN_PIN, HIGH);
        }
        else if (gesture == GF_WAVEOUT)
        {
          digitalWrite(GFORCE_WAVEOUT_PIN, HIGH);
        }
        else if (gesture == GF_PINCH)
        {
          digitalWrite(GFORCE_PINCH_PIN, HIGH);
        }
        else if (gesture == GF_SHOOT)
        {
          digitalWrite(GFORCE_SHOOT_PIN, HIGH);
          uarm.gripperCatch();
        }
        else if (gesture == GF_RELEASE)
        {
          digitalWrite(GFORCE_FIST_PIN, LOW);
          digitalWrite(GFORCE_SPREAD_PIN, LOW);
          digitalWrite(GFORCE_WAVEIN_PIN, LOW);
          digitalWrite(GFORCE_WAVEOUT_PIN, LOW);
          digitalWrite(GFORCE_PINCH_PIN, LOW);
          digitalWrite(GFORCE_SHOOT_PIN, LOW);
          uarm.gripperRelease();
        }
        else if (gesture == GF_UNKNOWN)
        {
          digitalWrite(GFORCE_FIST_PIN, HIGH);
          digitalWrite(GFORCE_SPREAD_PIN, HIGH);
          digitalWrite(GFORCE_WAVEIN_PIN, HIGH);
          digitalWrite(GFORCE_WAVEOUT_PIN, HIGH);
          digitalWrite(GFORCE_PINCH_PIN, HIGH);
          digitalWrite(GFORCE_SHOOT_PIN, HIGH);
          uarm.gripperRelease();
        }
        break;
      default:
        break;
    }
  }
  Serial.print(w_1);
  Serial.print(x_1);
  Serial.print(y_1);
  Serial.print(z_1);
  Serial.println(euler->yaw);
  int yaw;
  yaw = (int)(180*euler->yaw);
  int roll ;
  roll=(int)(-90*euler->roll);
 // int pitch;
  //pitch=(int)(
  uarm.setPosition(roll+20,20,yaw+50,0);
 /* Serial.print(euler->roll);*/
  //Serial.print(euler->roll);
  //Serial.print(euler->pitch);
}

/*
Arduino controller for 5 channel pressure system
establishes Serial communication with PC (first waits for "i" and then sends out "initialized...")
After that Arduino expects commands for reading 5 analog inputs that are connected to pressure sensors
The commands for reading pressure values are: a,b,c,d,e
The commands to set pressures are: 1,2,3,4,5 followed by a two byte value
We are using a 12-bit DAC MCP4725 (one channel) and MCP4728 (four channel) to set the pressure values

These are the connections for the Arduino Duemilanove:
MCP 4725 connections are: Vcc to 5V, SDA Arduino pin 4, SCL Arduino pin 5, GND - 0V
http://blog.geekcowboy.net/2008/09/sparkfun-dac-breakout-board-tutorial_8918.html
For Arduino mega:
SDA (Pin 20), SCL (Pin 21)

*/
#include <Wire.h>
#include "mcp4728.h"

mcp4728 dac = mcp4728(0); // instantiate mcp4728 object, Device ID = 0

byte Program = 64;
byte Device = 96;

int setP;    // integer to set 

int iAnVal;  /* Variable to store the Voltage given by the pressure sensor.
              2 byte value. (10-bit ADC). This means that it will map input voltages 
              between 0 and 5 volts into integer values between 0 and 1023. */
              
int pressure1,pressure2,pressure3,pressure4; // variables to hold the value for each pressure controller
              
byte firstByte,secondByte,hb,lb;
             
void setup() {
  pinMode(7,OUTPUT); // this is connected to LDAC  of MCP4728 two
  pinMode(8,OUTPUT); // this is connected to LDAC of MCP4728 one
  pinMode(22, OUTPUT); // valve 1
  pinMode(24, OUTPUT); // valve 2 
  pinMode(26, OUTPUT); // valve 3
  pinMode(28, OUTPUT); // valve 4    
  pinMode(30, OUTPUT); // valve 5    
  pinMode(32, OUTPUT); // valve 6   
  pinMode(34, OUTPUT); // valve 7
  pinMode(36, OUTPUT); // valve 8
  digitalWrite(22, LOW);    // turn valve off
  digitalWrite(24, LOW);    // turn valve off
  digitalWrite(26, LOW);    // turn valve off
  digitalWrite(28, LOW);    // turn valve off
  digitalWrite(30, LOW);    // turn valve off
  digitalWrite(32, LOW);    // turn valve off
  digitalWrite(34, LOW);    // turn valve off
  digitalWrite(36, LOW);    // turn valve off
  digitalWrite(7,LOW); //LDAC 2 ground
  digitalWrite(8,LOW); //LDAC 1 ground
  
  Serial.begin(9600);
  establishContact(); // send waiting... until respone comes
//  Serial.println("before dac.begin");
  dac.begin();
  dac.vdd(5000); // set VDD(mV) of MCP4728 for correct conversion between LSB and Vout
  dac.setVref(0,0,0,0); // set to use internal voltage reference (Vref=VDD=5V)
  dac.analogWrite(0,0,0,0); // set all pressures to zero
  pressure1=0;
  pressure2=0;
  pressure3=0;
  pressure4=0;

//  Serial.println("after dac.begin");
  delay(100);
}

//get a Byte ###########################
int getByte(){
	int res=0;
	while(1){
		if(Serial.available() > 0){
			res=Serial.read();
			return res;
		}
	}
}

void loop() {
if (Serial.available()>0) {
  // get incoming byte
  int gByte=getByte();
  switch (gByte) {
    case 'a':
      iAnVal = analogRead(0);   // read a value from the pressure sensor
      Serial.println(iAnVal);
      break;
    case 'b':    
      iAnVal = analogRead(1);   // read a value from the pressure sensor
      Serial.println(iAnVal);
      break;
    case 'c':    
      iAnVal = analogRead(2);   // read a value from the pressure sensor
      Serial.println(iAnVal);
      break;
    case 'd':    
      iAnVal = analogRead(3);   // read a value from the pressure sensor
      Serial.println(iAnVal);
      break;
    case 'e':    
      iAnVal = analogRead(4);   // read a value from the pressure sensor
      Serial.println(iAnVal);
      break;
    case '1':
      firstByte=getByte();
      secondByte=getByte();
      setP=(firstByte-1)*64+secondByte-1;
      pressure1=setP;
      dac.analogWrite(0,setP); // write to input register of a DAC. Channel 0-3, Value 0-4095
      Serial.print(int(firstByte));
      Serial.print(" ");
      Serial.print(int(secondByte));
      Serial.print(" ");
      Serial.println(setP);
      break;
    case '2':
      firstByte=getByte();
      secondByte=getByte();
      setP=(firstByte-1)*64+secondByte-1;
      pressure2=setP;
      dac.analogWrite(1,setP); // write to input register of a DAC. Channel 0-3, Value 0-4095
      Serial.print(int(firstByte));
      Serial.print(" ");
      Serial.print(int(secondByte));
      Serial.print(" ");
      Serial.println(setP);
      break;
    case '3':
      firstByte=getByte();
      secondByte=getByte();
      setP=(firstByte-1)*64+secondByte-1;
      pressure3=setP;
      dac.analogWrite(2,setP); // write to input register of a DAC. Channel 0-3, Value 0-4095
      Serial.print(int(firstByte));
      Serial.print(" ");
      Serial.print(int(secondByte));
      Serial.print(" ");
      Serial.println(setP);
      break;
    case '4':
      firstByte=getByte();
      secondByte=getByte();
      setP=(firstByte-1)*64+secondByte-1;
      pressure4=setP;
      dac.analogWrite(3,setP); // write to input register of a DAC. Channel 0-3, Value 0-4095
      Serial.print(int(firstByte));
      Serial.print(" ");
      Serial.print(int(secondByte));
      Serial.print(" ");
      Serial.println(setP);
      break;
    case 'A':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(22, LOW);      // turn valve off
          Serial.println("22 low");
          }
      else {
          digitalWrite(22, HIGH);     // turn valve on
          Serial.println("22 high");
           }
      break;
    case 'B':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(24, LOW);      // turn valve off
          Serial.println("24 low");
          }
      else {
          digitalWrite(24, HIGH);     // turn valve on
          Serial.println("24 high");
           }
      break;
    case 'C':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(26, LOW);      // turn valve off
          Serial.println("26 low");
          }
      else {
          digitalWrite(26, HIGH);     // turn valve on
          Serial.println("26 high");
           }
      break;
    case 'D':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(28, LOW);      // turn valve off
          Serial.println("28 low");
          }
      else {
          digitalWrite(28, HIGH);     // turn valve on
          Serial.println("28 high");
           }
      break;
    case 'E':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(30, LOW);      // turn valve off
          Serial.println("30 low");
          }
      else {
          digitalWrite(30, HIGH);     // turn valve on
          Serial.println("30 high");
           }
    case 'F':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(32, LOW);      // turn valve off
          Serial.println("32 low");
          }
      else {
          digitalWrite(32, HIGH);     // turn valve on
          Serial.println("32 high");
           }
      break;
    case 'G':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(34, LOW);      // turn valve off
          Serial.println("34 low");
          }
      else {
          digitalWrite(34, HIGH);     // turn valve on
          Serial.println("34 high");
           }
      break;
      case 'H':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(36, LOW);      // turn valve off
          Serial.println("36 low");
          }
      else {
          digitalWrite(36, HIGH);     // turn valve on
          Serial.println("36 high");
           }
      break;

    case 'R':
    // reset all pressures
      dac.analogWrite(0,0); // write 0
      dac.analogWrite(1,0); // write 0
      dac.analogWrite(2,0); // write 0
      dac.analogWrite(3,0); // write 0
      pressure1=0;
      pressure2=0;
      pressure3=0;
      pressure4=0;
      Serial.println("ok");
      break;
      
    case 'P':
    // pause with remembering pressures
      dac.analogWrite(0,0); // write 0
      dac.analogWrite(1,0); // write 0
      dac.analogWrite(2,0); // write 0
      dac.analogWrite(3,0); // write 0
      Serial.println("ok");
      break;
      
    case 'Q':
    // resume after pause with previous pressures
      dac.analogWrite(pressure1,pressure2,pressure3,pressure4);
      Serial.println("ok");
      break;
      
    case 'V':
    // close all valves
      digitalWrite(22, LOW);    // turn valve off
      digitalWrite(24, LOW);    // turn valve off
      digitalWrite(26, LOW);    // turn valve off
      digitalWrite(28, LOW);    // turn valve off
      digitalWrite(30, LOW);    // turn valve off
      digitalWrite(32, LOW);    // turn valve off
      digitalWrite(34, LOW);    // turn valve off
      digitalWrite(36, LOW);    // turn valve off
      Serial.println("ok");
      break;
    case 'O':
    // open all valves
      digitalWrite(22, HIGH);    // turn valve off
      digitalWrite(24, HIGH);    // turn valve off
      digitalWrite(26, HIGH);    // turn valve off
      digitalWrite(28, HIGH);    // turn valve off
      digitalWrite(30, HIGH);    // turn valve off
      digitalWrite(32, HIGH);    // turn valve off
      digitalWrite(34, HIGH);    // turn valve off
      digitalWrite(36, HIGH);    // turn valve off
      Serial.println("ok");
      break;
    
    default:
      break;
      // turn all the LEDs off:
      }
 }
}

void establishContact() {
  while(1) {
    int inByte=0;
    inByte=getByte();
    if (inByte=='i') {
      Serial.println("initialized...");
      return; }
  }
}


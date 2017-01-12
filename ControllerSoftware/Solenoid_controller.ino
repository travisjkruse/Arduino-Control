/*
Arduino controller for Solenoid controller

*/

byte firstByte,secondByte;
                       
void setup() {
  pinMode(3, OUTPUT); // valve 1
  pinMode(5, OUTPUT); // valve 2 
  pinMode(6, OUTPUT); // valve 3
  pinMode(9, OUTPUT); // valve 4    
  pinMode(10, OUTPUT); // valve 5    
  pinMode(11, OUTPUT); // valve 6    
  
  digitalWrite(3, LOW);    // turn valve off
  digitalWrite(5, LOW);    // turn valve off
  digitalWrite(6, LOW);    // turn valve off
  digitalWrite(9, LOW);    // turn valve off
  digitalWrite(10, LOW);    // turn valve off
  digitalWrite(11, LOW);    // turn valve off
  
  Serial.begin(115200);
  establishContact(); // send waiting... until respone comes
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
    case 'A':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(3, LOW);      // turn valve off
          Serial.println("3 low");
          }
      else {
          digitalWrite(3, HIGH);     // turn valve on
          Serial.println("3 high");
           }
      break;
    case 'B':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(5, LOW);      // turn valve off
          Serial.println("5 low");
          }
      else {
          digitalWrite(5, HIGH);     // turn valve on
          Serial.println("5 high");
           }
      break;
    case 'C':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(6, LOW);      // turn valve off
          Serial.println("6 low");
          }
      else {
          digitalWrite(6, HIGH);     // turn valve on
          Serial.println("6 high");
           }
      break;
    case 'D':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(9, LOW);      // turn valve off
          Serial.println("9 low");
          }
      else {
          digitalWrite(9, HIGH);     // turn valve on
          Serial.println("9 high");
           }
      break;
    case 'E':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(10, LOW);      // turn valve off
          Serial.println("10 low");
          }
      else {
          digitalWrite(10, HIGH);     // turn valve on
          Serial.println("10 high");
           }
      break;
    case 'F':
      firstByte=getByte();
      if (firstByte=='0') {
          digitalWrite(11, LOW);      // turn valve off
          Serial.println("11 low");
          }
      else {
          digitalWrite(11, HIGH);     // turn valve on
          Serial.println("11 high");
           }
      break;
    case 'V':
    // close all valves
      digitalWrite(3, LOW);    // turn valve off
      digitalWrite(5, LOW);    // turn valve off
      digitalWrite(6, LOW);    // turn valve off
      digitalWrite(9, LOW);    // turn valve off
      digitalWrite(10, LOW);    // turn valve off
      digitalWrite(11, LOW);    // turn valve off
      Serial.println("ok");
      break;
    case 'O':
    // open all valves
      digitalWrite(3, HIGH);    // turn valve off
      digitalWrite(5, HIGH);    // turn valve off
      digitalWrite(6, HIGH);    // turn valve off
      digitalWrite(9, HIGH);    // turn valve off
      digitalWrite(10, HIGH);    // turn valve off
      digitalWrite(11, HIGH);    // turn valve off
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


// arduino sketch to control a camera trigger and LED exposure
// the timing is controlled by 4 intervals given by 16-bit integers timerval[4]
// except for waiting time (prescaler 256) the prescaler is 8
// 0 - waiting time
// 1 - camera trigger (100 microseconds)
// 2 - delay
// 3 - LED on
//
// commands
// A#### set waiting time
// B#### set delay between trigger and LED on
// C#### set LED on

#define ledPin 12
#define cameraPin 11
#define buttonPin 0

int counter,digit,i;
int timerval[4] = {2000,40,50,50};
int setTimer;    // integer to set
int onFlag;
char buffer[100];
int led,camera;

byte firstByte,secondByte,hb,lb;

void setup()
{
  pinMode(ledPin, OUTPUT);
  pinMode(cameraPin, OUTPUT);
  pinMode(buttonPin,INPUT);
  digitalWrite(ledPin,LOW);
  digitalWrite(cameraPin,LOW);
  onFlag=0;
  counter=0;
  led=0;
  camera=0;
  
  // initialize timer1 
  noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;

  OCR1A = timerval[0];            // compare match register 16MHz/256/2Hz
  TCCR1B |= (1 << WGM12);   // CTC mode
  TCCR1B |= (1 << CS12);    // 256 prescaler 
  TIMSK1 |= (1 << OCIE1A);  // enable timer compare interrupt
  interrupts();             // enable all interrupts
  
  Serial.begin(9600);

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

ISR(TIMER1_COMPA_vect)          // timer compare interrupt service routine
{
  noInterrupts();
  counter = (counter+1) % 4;
  if (!counter) {
    TCCR1B |= (1 << CS12);    // 256 prescaler
    TCCR1B &= ~(1 << CS11);   // clear 8 prescaler
  } else if (counter==1) {
    TCCR1B |= (1 << CS11);    // 8 prescaler
    TCCR1B &= ~(1 << CS12);   // clear 256 prescaler
  }
  if (counter==1 || counter==2) {
      camera=!camera;
      digitalWrite(cameraPin, camera);   // toggle camera pin
  } else {
      led=!led;
      digitalWrite(ledPin, led);   // toggle LED pin
  }
  OCR1A = timerval[counter];
  interrupts();
}

void loop()
{
  if (Serial.available()>0) {
  // get incoming byte
  int gByte=getByte();
  switch (gByte) {
    case 'A':
     i=0;
     delay(10);
     if(Serial.available()){
       delay(10);
       while( Serial.available() && i< 99) {
             buffer[i++] = Serial.read();
       }
       buffer[i++]='\0';
      }
      setTimer=atoi(buffer);
      timerval[0]=setTimer;
      Serial.print("value: ");Serial.println(setTimer);
      break;
      
    case 'B':
     i=0;
     delay(10);
     if(Serial.available()){
       delay(10);
       while( Serial.available() && i< 99) {
             buffer[i++] = Serial.read();
       }
       buffer[i++]='\0';
      }
      setTimer=atoi(buffer);
      timerval[2]=setTimer;
      Serial.print("value: ");Serial.println(setTimer);
      break;
      
    case 'C':
     i=0;
     delay(10);
     if(Serial.available()){
       delay(10);
       while( Serial.available() && i< 99) {
             buffer[i++] = Serial.read();
       }
       buffer[i++]='\0';
      }
      setTimer=atoi(buffer);
      timerval[3]=setTimer;
      Serial.print("value: ");Serial.println(setTimer);
      break;
            
    default:
      break;
    }
  }
}


